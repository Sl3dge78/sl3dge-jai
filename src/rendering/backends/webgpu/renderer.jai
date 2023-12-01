#if OS == .MACOS {
    SDL_MetalView :: struct{}
    SDL_Metal_CreateView :: (window: *SDL_Window) -> *SDL_MetalView #foreign SDL2;
    SDL_Metal_GetLayer :: (metal_view: *SDL_MetalView) -> *void #foreign SDL2;
}

Renderer :: struct {
    // Main State
    instance  : wgpu.Instance;
    surface   : wgpu.Surface;
    adapter   : wgpu.Adapter;
    device    : wgpu.Device;
    queue     : wgpu.Queue;

    surface_format : wgpu.TextureFormat;
    surface_texture: wgpu.SurfaceTexture;
    surface_view   : wgpu.TextureView;

    depth_format :: wgpu.TextureFormat.Depth24Plus;
    command_buffers: [..]wgpu.CommandBuffer;

    limits: wgpu.Limits;
    uniform_buffer_alignement: u64;
    width : u32;
    height: u32;

    sampler   : wgpu.Sampler;

    empty_bgl : wgpu.BindGroupLayout;
    single_texture_bgl   : wgpu.BindGroupLayout;
    global_matrices_bgl  : wgpu.BindGroupLayout;
    shadowmap_texture_bgl: wgpu.BindGroupLayout;
    instance_data_bgl : wgpu.BindGroupLayout;

    debug_pipeline       : wgpu.RenderPipeline;
    ui_pipeline          : wgpu.RenderPipeline;

    depth_texture : Texture;
    static_mesh_pipelines : [2] wgpu.RenderPipeline; // 0 = directionnal shadowmap, 1 = color
    skinned_mesh_pipelines : [2] wgpu.RenderPipeline; // 0 = directionnal shadowmap, 1 = color

    empty_uniform: wgpu.BindGroup;

    global_matrices_uniform: Uniform;
    empty_texture: Texture;
    empty_texture_uniform: Texture_Uniform;

    shadowmap_matrices_uniform: Uniform;
    shadowmap_framebuffer: Texture;
    shadowmap_texture_uniform : Texture_Uniform;

    projection := Matrix4_Identity;
    view := Matrix4_Identity;
    light_vec : Vector3;            // Direction or Position if point light

    current_scene: *Scene;
    mesh_buffer_pool: Buffer_Pool = .{
        kind =  .Vertex | .Index | .CopyDst
    };

    uniform_pool: Buffer_Pool = .{
        kind =  .Uniform | .CopyDst
    };

    immediate_pool: Buffer_Pool = .{
        kind =  .Vertex | .CopyDst
    };

    show_debug := false;
}

global_renderer : Renderer;

adapter_cb :: (status: wgpu.RequestAdapterStatus, adapter: wgpu.Adapter, message: *u8, userdata: *void) -> void #c_call {
    if status != .Success {
        c_print("%\n", message);
        return;
    }
    (cast(*wgpu.Adapter) userdata).* = adapter;
}

device_cb :: (status: wgpu.RequestDeviceStatus, device: wgpu.Device, message: *u8, userdata: *void) #c_call {
    if status != .Success {
        c_print("%\n", message);
        return;
    }
    (cast(*wgpu.Device) userdata).* = device;
}

renderer_create :: (window: *SDL_Window) -> Renderer {
    renderer := *global_renderer;

    wgpu.SetLogCallback(wgpu_log_callback, null);
    wgpu.SetLogLevel(.Warn);

    {   // Instance

        instance_extras := wgpu.InstanceExtras.{
            backends = .Vulkan | .GL,
        };

        desc := wgpu.InstanceDescriptor.{
            nextInChain = cast(*wgpu.ChainedStruct)(*instance_extras),
        };
        renderer.instance = WGPU_Check(wgpu.CreateInstance(*desc));
    }

    {   // Surface
        desc := wgpu.SurfaceDescriptor.{
            label = "Main Surface"
        };

        sdl_info: SDL_SysWMinfo;
        SDL_VERSION(*sdl_info.version);
        if !SDL_GetWindowWMInfo(window, *sdl_info) {
            log("%", to_string(SDL_GetError()));
        }

        #if OS == .LINUX {
            surface_desc_x11 := wgpu.SurfaceDescriptorFromXlibWindow.{
                display = sdl_info.info.x11.display,
                window = xx sdl_info.info.x11.window,
            };
            desc.nextInChain = xx *surface_desc_x11;
        } else #if OS == .MACOS {
            metal_view := SDL_Metal_CreateView(window);
            metal_layer := SDL_Metal_GetLayer(metal_view);

            surface_desc_from_metal_layer := wgpu.SurfaceDescriptorFromMetalLayer.{
                layer = metal_layer,
            };
            desc.nextInChain = xx *surface_desc_from_metal_layer;
        } else #if OS == .WINDOWS {
            surface_desc := wgpu.SurfaceDescriptorFromWindowsHWND.{
                hinstance = xx sdl_info.info.win.hinstance,
                hwnd = xx sdl_info.info.win.window,
            };
            desc.nextInChain = xx *surface_desc;
        } else {
            #assert(false);
        }

        renderer.surface = WGPU_Check(wgpu.InstanceCreateSurface(renderer.instance, *desc));
       
    }
    
    {   // Adapter
        options := wgpu.RequestAdapterOptions.{
            compatibleSurface = renderer.surface,
            powerPreference = .HighPerformance,
        };
        wgpu.InstanceRequestAdapter(renderer.instance, *options, adapter_cb, *renderer.adapter);
        assert(renderer.adapter != null, "Unable to create Adapter");

        nb := wgpu.AdapterEnumerateFeatures(renderer.adapter, null);
        features := NewArray(xx nb, wgpu.FeatureName, allocator = temp);

        wgpu.AdapterEnumerateFeatures(renderer.adapter, features.data);
        log("Features: ");
        for features {
            log("\t%", it);
        }
    }

    {   // Device
        limits := get_required_limits(renderer.adapter);

        extras := wgpu.RequiredLimitsExtras.{
            limits = .{
                maxPushConstantSize = size_of(Standard_Push_Constants),
            }
        };

        required_limits := wgpu.RequiredLimits.{
            nextInChain = *extras.chain,
            limits = limits,
        };

        required_features := wgpu.FeatureName.[
            xx wgpu.NativeFeature.PushConstants
        ];

        desc := wgpu.DeviceDescriptor.{
            label = "Main Device",
            requiredFeatureCount = required_features.count,
            requiredFeatures =      required_features.data,
            requiredLimits = *required_limits,
            defaultQueue = . {
                label = "Default Queue",
            },
            deviceLostCallback = wgpu_device_lost_callback,
        };
        wgpu.AdapterRequestDevice(renderer.adapter, *desc, device_cb, *renderer.device);
        assert(renderer.device != null, "Unable to create Device");

        wgpu.DeviceSetUncapturedErrorCallback(renderer.device, wgpu_error_callback, null);

        activated_limits : wgpu.SupportedLimits;
        wgpu.DeviceGetLimits(renderer.device, *activated_limits);
        renderer.limits = activated_limits.limits;
        renderer.uniform_buffer_alignement = renderer.limits.minUniformBufferOffsetAlignment;
        log("Activated limits: %", renderer.limits);
    }

    {   // Queue 
        renderer.queue = WGPU_Check(wgpu.DeviceGetQueue(renderer.device));
        wgpu.QueueOnSubmittedWorkDone(renderer.queue, wgpu_on_queue_work_done, null);
    }
    
    {   // SwapChain
        renderer.surface_format = wgpu.SurfaceGetPreferredFormat(renderer.surface, renderer.adapter);
         config := wgpu.SurfaceConfiguration.{
            device = renderer.device,
            format = renderer.surface_format,
            usage = .RenderAttachment,
            viewFormatCount = 1,
            viewFormats = *renderer.surface_format,
            alphaMode = .Auto,
            width = 1280,
            height = 720,
            presentMode = .Fifo,

        };
        wgpu.SurfaceConfigure(renderer.surface, *config);
        // desc := wgpu.SwapChainDescriptor.{
        //     label = "Main SwapChain",
        //     format = renderer.surface_format,
        //     usage = xx wgpu.TextureUsage.RenderAttachment,
        //     width = 1280,
        //     height = 720,
        //     presentMode = .Fifo,
        // };
        renderer.width = 1280;
        renderer.height = 720;
        // renderer.swapchain = WGPU_Check(wgpu.DeviceCreateSwapChain(renderer.device, renderer.surface, *desc));
    }

    {   // Sampler

        desc := wgpu.SamplerDescriptor.{
            label =         "Main Sampler",
            addressModeU =  .ClampToEdge,
            addressModeV =  .ClampToEdge,
            addressModeW =  .ClampToEdge,
            magFilter =     .Linear,
            minFilter =     .Linear,
            mipmapFilter =  .Linear,
            lodMinClamp =   0,
            lodMaxClamp =   1,
            compare =       .Undefined,
            maxAnisotropy = 1,
        };

        renderer.sampler = WGPU_Check(wgpu.DeviceCreateSampler(renderer.device, *desc));
    }

    create_bind_group_layouts(renderer);

    renderer.debug_pipeline = create_debug_pipeline(renderer);
    renderer.ui_pipeline = create_ui_pipeline(renderer, UI_SHADER);
    renderer.static_mesh_pipelines = create_static_mesh_pipeline(renderer);
    renderer.skinned_mesh_pipelines = create_skinned_mesh_pipeline(renderer);

    {   // Empty Uniform
        desc := wgpu.BindGroupDescriptor.{
            layout = renderer.empty_bgl, 
            entryCount = 0,
            entries = null,
        };
        renderer.empty_uniform = WGPU_Check(wgpu.DeviceCreateBindGroup(renderer.device, *desc));

        data := u8.[255, 255, 255, 255];
        renderer.empty_texture = texture_from_data(data.data, 1, 1, 4, u8);
        texture_set_label(*renderer.empty_texture, "Empty Texture");
        renderer.empty_texture_uniform = texture_uniform_create(renderer.sampler, renderer.empty_texture.view, global_renderer.single_texture_bgl);
    }   

    {   // Color Uniforms
        renderer.global_matrices_uniform = uniform_create(renderer.device, *renderer.uniform_pool, size_of(Global_Matrices), renderer.global_matrices_bgl);

        renderer.projection = make_projection_matrix(radians(45), cast(float)renderer.width/cast(float)renderer.height, 0.1, 1000);
        renderer.view = Matrix4_Identity;
        renderer.light_vec = unit_vector(.{1, -2, -1});
    }

    {   // Shadowmap Uniforms
        renderer.shadowmap_framebuffer = texture_create(2048, 2048, .TextureBinding | .RenderAttachment, .Depth24Plus);

        renderer.shadowmap_texture_uniform = texture_uniform_create(renderer.sampler, renderer.shadowmap_framebuffer.view, global_renderer.shadowmap_texture_bgl);
        renderer.shadowmap_matrices_uniform = uniform_create(renderer.device, *renderer.uniform_pool, size_of(Global_Matrices), renderer.global_matrices_bgl);
        
    }

    update_framebuffer(renderer);
    return renderer;
}

renderer_destroy :: (using renderer: *Renderer) {
    buffer_pool_reset(*mesh_buffer_pool);
    buffer_pool_reset(*uniform_pool);
    buffer_pool_reset(*immediate_pool);

    wgpu.RenderPipelineRelease(debug_pipeline);
    wgpu.RenderPipelineRelease(ui_pipeline);
    wgpu.RenderPipelineRelease(static_mesh_pipelines[0]);
    wgpu.RenderPipelineRelease(static_mesh_pipelines[1]);

    destroy(*global_matrices_uniform);
    destroy(*shadowmap_matrices_uniform);

    destroy(*shadowmap_framebuffer);
    destroy(*shadowmap_texture_uniform);
    
    destroy(*depth_texture);

    wgpu.BindGroupLayoutRelease(empty_bgl);
    wgpu.BindGroupLayoutRelease(single_texture_bgl);
    wgpu.BindGroupLayoutRelease(global_matrices_bgl);
    wgpu.BindGroupLayoutRelease(shadowmap_texture_bgl);
    wgpu.BindGroupLayoutRelease(instance_data_bgl);

    wgpu.SamplerRelease(sampler);

    wgpu.QueueRelease(queue);
    wgpu.DeviceRelease(device);
    wgpu.AdapterRelease(adapter);
    wgpu.SurfaceRelease(surface);

    report_gpu_leaks(instance);

    wgpu.InstanceRelease(instance);
}

renderer_push_command_encoder :: (encoder: *wgpu.CommandEncoder, label := "") {
    command_buffer := WGPU_Check(wgpu.CommandEncoderFinish(encoder.*, *wgpu.CommandBufferDescriptor.{ label = temp_c_string(label)}));
    array_add(*global_renderer.command_buffers, command_buffer);
    encoder.* = null;
}

end_frame :: () {
    using renderer := *global_renderer;

    // Upload data
    // upload(*context.immediate._2d_draw_data);
    // upload(*context.immediate._3d_draw_data);
    // if show_debug {
    //     upload(*context.immediate.debug_draw_data);
    // }    
    
    size:: 20;
    light_proj := orthographic_projection_matrix(size, -size, -size, size, -size, size, true);
    light_view := make_look_at_matrix(.{0, 0, 0}, light_vec, .{0, 1, 0}, false);
    matrices := Global_Matrices.{
        projection = transpose(projection),
        view = transpose(view),
        light = transpose(light_proj * light_view),
        light_vec = light_vec
    };
    uniform_write(global_matrices_uniform, *matrices);

    shadowmap_matrices := Global_Matrices.{
        projection = transpose(light_proj),
        view = transpose(light_view),
        light = matrices.light,
        light_vec = matrices.light_vec
    };
    uniform_write(shadowmap_matrices_uniform, *shadowmap_matrices);

    encoder_desc := wgpu.CommandEncoderDescriptor.{ label = "Main Command Encoder" };
    command_encoder := WGPU_Check(wgpu.DeviceCreateCommandEncoder(device, *encoder_desc));
    defer wgpu.CommandEncoderRelease(command_encoder);
    shadowmap_render_pass(renderer, command_encoder, shadowmap_framebuffer.view);
    main_render_pass(renderer, command_encoder, global_renderer.surface_view);
    if show_debug {
        debug_render_pass(renderer, command_encoder, global_renderer.surface_view);
    }
    ui_render_pass(renderer, command_encoder, global_renderer.surface_view);
    
    command_buffer := WGPU_Check(wgpu.CommandEncoderFinish(command_encoder, *wgpu.CommandBufferDescriptor.{ label = "Main Command Buffer" }));
    array_add(*renderer.command_buffers, command_buffer);

    wgpu.QueueSubmit(queue, xx renderer.command_buffers.count, renderer.command_buffers.data);

    // Before present to have the real time
    frame_end := SDL_GetPerformanceCounter();
    global_engine.frame_time = cast(float)(frame_end - global_engine.frame_start) / cast(float)SDL_GetPerformanceFrequency();
    wgpu.SurfacePresent(surface);
    global_engine.frame_start = SDL_GetPerformanceCounter();

    wgpu.TextureViewRelease(renderer.surface_view);
    
    for renderer.command_buffers {
        defer wgpu.CommandBufferRelease(it);
    }
    renderer.command_buffers.count = 0;

    buffer_pool_reset_keeping_memory(*global_renderer.immediate_pool);
    update_framebuffer(*global_renderer);
}

change_light_vector :: (vec: Vector3) {
    global_renderer.light_vec = vec;
}

set_projection_matrix :: (fov: float) {
    global_renderer.projection = make_projection_matrix(radians(45), cast(float)global_renderer.width/cast(float)global_renderer.height, 0.1, 1000);
}

set_view_matrix :: (view: Matrix4) {
    global_renderer.view = view;
}

set_scene :: (scene: *Scene) {
    global_renderer.current_scene = scene;
}

report_gpu_leaks :: (instance: wgpu.Instance) {
    storage_report :: (s: wgpu.StorageReport, name: string, builder: *String_Builder) -> bool {
        if s.numOccupied == 0 then return false;
        print_to_builder(builder, "%: %\n", name, s.numOccupied);
        return true;
    }

    hub_report :: (h: wgpu.HubReport, builder: *String_Builder) -> bool {
        found := false;
        arr : [15]wgpu.StorageReport = xx *h;
        ti := type_info(wgpu.HubReport);
        
        // Skip the first 2 members (adapters & devices)
        for 2..ti.members.count - 1 {
            found |= storage_report(arr[it], ti.members[it].name, builder);
        }
        return found;
    }

    report : wgpu.GlobalReport;
    wgpu.GenerateReport(instance, *report);
    
    builder: String_Builder;
    found:= false;

    found |= storage_report(report.surfaces, "Surfaces", *builder);
    if report.backendType == {
        case .Vulkan; found |= hub_report(report.vulkan, *builder);
        case .OpenGL; found |= hub_report(report.gl, *builder);
        case .Metal; found |= hub_report(report.metal, *builder);
        case; assert(false, "Memory check unimplemented for backend : %", report.backendType);
    }
    
    if found {
        log("=== GPU Leaks found ===");
        str := builder_to_string(*builder);
        defer free(str);
        log("%", str);
    }

}

get_required_limits :: (adapter: wgpu.Adapter) -> wgpu.Limits {
    supported_limits : wgpu.SupportedLimits;
    wgpu.AdapterGetLimits(adapter, *supported_limits);

    return .{
        maxTextureDimension1D                     = 1,
        maxTextureDimension2D                     = 2048,
        maxTextureDimension3D                     = 1,
        maxTextureArrayLayers                     = 1,
        maxBindGroups                             = 4,
        maxBindingsPerBindGroup                   = 2,
        maxDynamicUniformBuffersPerPipelineLayout = 0,
        maxDynamicStorageBuffersPerPipelineLayout = 0,
        maxSampledTexturesPerShaderStage          = 1,
        maxSamplersPerShaderStage                 = 1,
        maxStorageBuffersPerShaderStage           = 0,
        maxStorageTexturesPerShaderStage          = 0,
        maxUniformBuffersPerShaderStage           = 2,
        maxUniformBufferBindingSize               = 8192,
        maxStorageBufferBindingSize               = 0,
        minUniformBufferOffsetAlignment           = supported_limits.limits.minUniformBufferOffsetAlignment,
        minStorageBufferOffsetAlignment           = supported_limits.limits.minStorageBufferOffsetAlignment,
        maxVertexBuffers                          = 2,
        maxBufferSize                             = 32 * 1024 * 1024,
        maxVertexAttributes                       = 6,
        maxVertexBufferArrayStride                = size_of(Standard_Vertex) + size_of(Skinned_Vertex),
        maxInterStageShaderComponents             = 16,
        maxInterStageShaderVariables              = 0,
        maxColorAttachments                       = 0,
        maxColorAttachmentBytesPerSample          = 0,
        maxComputeWorkgroupStorageSize            = 0,
        maxComputeInvocationsPerWorkgroup         = 0,
        maxComputeWorkgroupSizeX                  = 0,
        maxComputeWorkgroupSizeY                  = 0,
        maxComputeWorkgroupSizeZ                  = 0,
        maxComputeWorkgroupsPerDimension          = 0,
    };
}

create_bind_group_layouts :: (using renderer: *Renderer) {
    {   // Empty 
        desc := wgpu.BindGroupLayoutDescriptor.{
            label = "Empty",
            entryCount = 0,
            entries = null
        };
        renderer.empty_bgl = WGPU_Check(wgpu.DeviceCreateBindGroupLayout(renderer.device, *desc));

    }

    {   // Single texture
        builder : Bindings_Builder;
        add_entry(*builder, wgpu.SamplerBindingLayout.{type = .Filtering}, binding = 0, .Fragment);
        add_entry(*builder, wgpu.TextureBindingLayout.{sampleType = .Float, viewDimension = ._2D, multisampled = false}, binding = 1, .Fragment);
        renderer.single_texture_bgl = bindings_builder_build(*builder);
    }

    {   // Shadowmap
        builder : Bindings_Builder;
        add_entry(*builder, wgpu.SamplerBindingLayout.{type = .Filtering}, binding = 0, .Fragment);
        add_entry(*builder, wgpu.TextureBindingLayout.{sampleType = .Depth, viewDimension = ._2D, multisampled = false}, binding = 1, .Fragment);
        renderer.shadowmap_texture_bgl = bindings_builder_build(*builder);
    }

    {   // Global Data
        builder : Bindings_Builder;
        add_entry(*builder, wgpu.BufferBindingLayout.{ type = .Uniform, hasDynamicOffset = false, minBindingSize = xx size_of(Global_Matrices) }, binding = 0, .Vertex | .Fragment);
        renderer.global_matrices_bgl = bindings_builder_build(*builder);
    }

    {   // Instance Data
        builder : Bindings_Builder;
        add_entry(*builder, wgpu.BufferBindingLayout.{type = .Uniform, hasDynamicOffset = false, minBindingSize = xx size_of(Instance_Data) }, binding = 0, .Vertex);
        add_entry(*builder, wgpu.SamplerBindingLayout.{type = .Filtering}, binding = 1, .Fragment);
        add_entry(*builder, wgpu.TextureBindingLayout.{sampleType = .Float, viewDimension = ._2D, multisampled = false}, binding = 2, .Fragment);
        renderer.instance_data_bgl = bindings_builder_build(*builder);
    }
}

create_ui_pipeline :: (using renderer: *Renderer, shader: string) -> wgpu.RenderPipeline {
    shader_module := shader_module_create(shader, device);
    defer wgpu.ShaderModuleRelease(shader_module);

    layout_builder: Pipeline_Layout_Builder;
    set_push_constants(*layout_builder, size_of(UI_Push_Constants), stages = .Vertex);
    add_bind_groups(*layout_builder, single_texture_bgl);
    pipeline_layout := pipeline_layout_builder_build(*layout_builder, device);
    defer wgpu.PipelineLayoutRelease(pipeline_layout);

    builder: Pipeline_Builder;
    add_vertex_shader(*builder, shader_module, "vs_main", UI_Vertex);
    add_fragment_shader(*builder, shader_module, "fs_main");
    return pipeline_builder_build(*builder, device, pipeline_layout, "UI Pipeline");
}

create_static_mesh_pipeline :: (using renderer: *Renderer) -> [2]wgpu.RenderPipeline {
    pipelines : [2]wgpu.RenderPipeline;
    
    shader_module := shader_module_create(STANDARD_SHADER, device);
    defer wgpu.ShaderModuleRelease(shader_module);

    {   // Shadowmap            
        layout_builder: Pipeline_Layout_Builder;
        set_push_constants(*layout_builder, size_of(Standard_Push_Constants), stages = .Vertex);
        add_bind_groups(*layout_builder, renderer.global_matrices_bgl);
        pipeline_layout := pipeline_layout_builder_build(*layout_builder, renderer.device);
        defer wgpu.PipelineLayoutRelease(pipeline_layout);

        builder: Pipeline_Builder;
        add_vertex_shader(*builder, shader_module, "static_vs", Standard_Vertex);
        depth_stencil_state(*builder, renderer.depth_format);
        primitive_state(*builder, .TriangleList, cull_mode = .Front);
        pipelines[0] = pipeline_builder_build(*builder, renderer.device, pipeline_layout, "Static Mesh Color Pipeline");
    }

    {   // Color
        depth_texture = texture_create(width, height, .RenderAttachment, depth_format);

        layout_builder: Pipeline_Layout_Builder;
        set_push_constants(*layout_builder, size_of(Standard_Push_Constants), stages = .Vertex);
        add_bind_groups(*layout_builder, renderer.global_matrices_bgl);
        add_bind_groups(*layout_builder, renderer.shadowmap_texture_bgl);
        add_bind_groups(*layout_builder, renderer.empty_bgl);
        add_bind_groups(*layout_builder, renderer.single_texture_bgl);
        pipeline_layout := pipeline_layout_builder_build(*layout_builder, renderer.device);
        defer wgpu.PipelineLayoutRelease(pipeline_layout);

        builder: Pipeline_Builder;
        add_vertex_shader(*builder, shader_module, "static_vs", Standard_Vertex);
        add_fragment_shader(*builder, shader_module, "fs_main");
        depth_stencil_state(*builder, renderer.depth_format);
        pipelines[1] = pipeline_builder_build(*builder, renderer.device, pipeline_layout, "Static Mesh Color Pipeline");
    }
    return pipelines;
}

create_skinned_mesh_pipeline :: (using renderer: *Renderer) -> [2]wgpu.RenderPipeline {
    pipelines : [2]wgpu.RenderPipeline;
    
    shader_module := shader_module_create(STANDARD_SHADER, device);
    defer wgpu.ShaderModuleRelease(shader_module);

    {   // Shadowmap            
        layout_builder: Pipeline_Layout_Builder;
        set_push_constants(*layout_builder, size_of(Standard_Push_Constants), stages = .Vertex);
        add_bind_groups(*layout_builder, 
            renderer.global_matrices_bgl, 
            empty_bgl,
            instance_data_bgl
        );
        pipeline_layout := pipeline_layout_builder_build(*layout_builder, renderer.device);
        defer wgpu.PipelineLayoutRelease(pipeline_layout);

        builder: Pipeline_Builder;
        add_vertex_shader(*builder, shader_module, "skinned_vs", Standard_Vertex, Skinned_Vertex);
        depth_stencil_state(*builder, renderer.depth_format);
        pipelines[0] = pipeline_builder_build(*builder, renderer.device, pipeline_layout, "Skinned Mesh Color Pipeline");
    }

    {   // Color
        depth_texture = texture_create(width, height, .RenderAttachment, depth_format);

        layout_builder: Pipeline_Layout_Builder;
        set_push_constants(*layout_builder, size_of(Standard_Push_Constants), stages = .Vertex);
        add_bind_groups(*layout_builder, renderer.global_matrices_bgl);
        add_bind_groups(*layout_builder, renderer.shadowmap_texture_bgl);
        add_bind_groups(*layout_builder, renderer.instance_data_bgl);
        add_bind_groups(*layout_builder, renderer.single_texture_bgl);
        pipeline_layout := pipeline_layout_builder_build(*layout_builder, renderer.device);
        defer wgpu.PipelineLayoutRelease(pipeline_layout);

        builder: Pipeline_Builder;
        add_vertex_shader(*builder, shader_module, "skinned_vs", Standard_Vertex, Skinned_Vertex);
        add_fragment_shader(*builder, shader_module, "fs_main");
        depth_stencil_state(*builder, renderer.depth_format);
        pipelines[1] = pipeline_builder_build(*builder, renderer.device, pipeline_layout, "Skinned Mesh Color Pipeline");
    }
    return pipelines;
}

create_debug_pipeline :: (using renderer: *Renderer) -> wgpu.RenderPipeline {
    shader_module := shader_module_create(DEBUG_SHADER, device);
    defer wgpu.ShaderModuleRelease(shader_module);

    layout_builder: Pipeline_Layout_Builder;
    set_push_constants(*layout_builder, size_of(Standard_Push_Constants), stages = .Vertex);
    add_bind_groups(*layout_builder, renderer.global_matrices_bgl);
    pipeline_layout := pipeline_layout_builder_build(*layout_builder, renderer.device);
    defer wgpu.PipelineLayoutRelease(pipeline_layout);

    builder: Pipeline_Builder;
    add_vertex_shader(*builder, shader_module, "vs_main", Debug_Vertex);
    add_fragment_shader(*builder, shader_module, "fs_main");
    primitive_state(*builder, .LineList);
    pipeline := pipeline_builder_build(*builder, renderer.device, pipeline_layout, "Debug Pipeline");
    return pipeline;

}

shadowmap_render_pass :: (using renderer: *Renderer, command_encoder: wgpu.CommandEncoder, framebuffer: wgpu.TextureView) {
    
    attachment := wgpu.RenderPassDepthStencilAttachment.{
        view = framebuffer,
        depthLoadOp = .Clear,
        depthStoreOp = .Store,
        depthClearValue = 1,
        stencilLoadOp = .Clear,
        stencilStoreOp = .Discard,
        stencilClearValue = 0,
        stencilReadOnly = true,
    };
    render_pass_desc := wgpu.RenderPassDescriptor.{
        label = "Shadow Map",
        depthStencilAttachment = *attachment
    };
    render_pass := WGPU_Check(wgpu.CommandEncoderBeginRenderPass(command_encoder, *render_pass_desc));

    wgpu.RenderPassEncoderSetPipeline(render_pass, static_mesh_pipelines[0]);
    wgpu.RenderPassEncoderSetBindGroup(render_pass, 0, shadowmap_matrices_uniform.bind_group, 0, null);
    // immediate_draw_3d(render_pass);
    if current_scene {
        draw_static_meshes(current_scene, render_pass);
    

        wgpu.RenderPassEncoderSetPipeline(render_pass, skinned_mesh_pipelines[0]);
        wgpu.RenderPassEncoderSetBindGroup(render_pass, 1, empty_uniform, 0, null);
        draw_skinned_meshes(current_scene, render_pass);
    }

    wgpu.RenderPassEncoderEnd(render_pass);
}

main_render_pass :: (using renderer: *Renderer, command_encoder: wgpu.CommandEncoder, framebuffer: wgpu.TextureView) {
    color_attachment := wgpu.RenderPassColorAttachment.{
        view = framebuffer,
        resolveTarget = null,
        loadOp = .Load,
        storeOp = .Store,
        // clearValue = .{0.529, 0.808, 0.922, 1.0}
    };
    depth_attachment := wgpu.RenderPassDepthStencilAttachment.{
        view = renderer.depth_texture.view,
        depthLoadOp = .Clear,
        depthStoreOp = .Store,
        depthClearValue = 1,
        stencilLoadOp = .Clear,
        stencilStoreOp = .Discard,
        stencilClearValue = 0,
        stencilReadOnly = true,
    };
    render_pass_desc := wgpu.RenderPassDescriptor.{
        label = "Main Pass",
        colorAttachmentCount = 1,
        colorAttachments = *color_attachment,
        depthStencilAttachment = *depth_attachment,
    };
    render_pass := WGPU_Check(wgpu.CommandEncoderBeginRenderPass(command_encoder, *render_pass_desc));

    wgpu.RenderPassEncoderSetPipeline(render_pass, static_mesh_pipelines[1]);
    wgpu.RenderPassEncoderSetBindGroup(render_pass, 0, global_matrices_uniform.bind_group, 0, null);
    wgpu.RenderPassEncoderSetBindGroup(render_pass, 1, shadowmap_texture_uniform.bind_group, 0, null);
    // immediate_draw_3d(render_pass);
    if current_scene {
        draw_static_meshes(current_scene, render_pass);
    
        wgpu.RenderPassEncoderSetPipeline(render_pass, skinned_mesh_pipelines[1]);
        draw_skinned_meshes(current_scene, render_pass);
    }
    
    wgpu.RenderPassEncoderEnd(render_pass);
}

ui_render_pass :: (using renderer: *Renderer, command_encoder: wgpu.CommandEncoder, framebuffer: wgpu.TextureView) {
    attachment := wgpu.RenderPassColorAttachment.{
        view = framebuffer,
        resolveTarget = null,
        loadOp = .Load,
        storeOp = .Store,
    };
    render_pass_desc := wgpu.RenderPassDescriptor.{
        label = "UI Pass",
        colorAttachmentCount = 1,
        colorAttachments = *attachment,
        depthStencilAttachment = null,
    };
    render_pass := WGPU_Check(wgpu.CommandEncoderBeginRenderPass(command_encoder, *render_pass_desc));

    // immediate_draw_2d(render_pass);

    wgpu.RenderPassEncoderEnd(render_pass);
}

debug_render_pass :: (using renderer: *Renderer, command_encoder: wgpu.CommandEncoder, framebuffer: wgpu.TextureView) {
    attachment := wgpu.RenderPassColorAttachment.{
        view = framebuffer,
        resolveTarget = null,
        loadOp = .Load,
        storeOp = .Store,
    };
    render_pass_desc := wgpu.RenderPassDescriptor.{
        label = "Debug Pass",
        colorAttachmentCount = 1,
        colorAttachments = *attachment,
        depthStencilAttachment = null,
    };
    render_pass := WGPU_Check(wgpu.CommandEncoderBeginRenderPass(command_encoder, *render_pass_desc));

    // immediate_draw_debug(render_pass);

    wgpu.RenderPassEncoderEnd(render_pass);
}

update_framebuffer :: (using renderer: *Renderer) {
    wgpu.SurfaceGetCurrentTexture(renderer.surface, *renderer.surface_texture);
    desc := wgpu.TextureViewDescriptor.{
        format = renderer.surface_format,
        dimension =       ._2D,
        baseMipLevel= 0,
        mipLevelCount = 1,
        baseArrayLayer = 0,
        arrayLayerCount = 1,
        aspect = .All
    };
    renderer.surface_view = wgpu.TextureCreateView(renderer.surface_texture.texture, *desc);

}
