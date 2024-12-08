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
    render_format : wgpu.TextureFormat = .BGRA8Unorm;

    depth_format :: wgpu.TextureFormat.Depth24Plus;

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

    blit_pipeline        : wgpu.RenderPipeline;
    debug_pipeline       : wgpu.RenderPipeline;
    ui_pipeline          : wgpu.RenderPipeline;

    depth_texture : Texture;
    static_mesh_pipelines : [2] wgpu.RenderPipeline; // 0 = directionnal shadowmap, 1 = color
    skinned_mesh_pipelines : [2] wgpu.RenderPipeline; // 0 = directionnal shadowmap, 1 = color

    empty_uniform: wgpu.BindGroup;

    global_matrices_uniform: Uniform;
    empty_texture: Texture;
    empty_texture_uniform: wgpu.BindGroup;

    shadowmap_matrices_uniform: Uniform;
    shadowmap_framebuffer: Texture;
    shadowmap_texture_uniform : wgpu.BindGroup;

    projection := Matrix4_Identity;
    view := Matrix4_Identity;
    light_vec : Vector3;            // Direction or Position if point light

    // current_scene: *Scene;
    vertex_pool: Buffer_Pool = .{
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

renderer_create :: (window: *SDL_Window) -> *Renderer {
    renderer := *global_renderer;

    wgpu.SetLogCallback(wgpu_log_callback, null);
    wgpu.SetLogLevel(.Warn);

    {   // Instance

        desc := wgpu.InstanceDescriptor.{
        };
        renderer.instance = WGPU_Check(wgpu.CreateInstance(*desc));
    }

    {   // Surface
        desc := wgpu.SurfaceDescriptor.{
            label = "Main Surface"
        };


        #if OS == .LINUX {
            handle := SDL_GetPointerProperty(SDL_GetWindowProperties(window), SDL_PROP_WINDOW_X11_WINDOW_NUMBER, null);
            display := SDL_GetPointerProperty(SDL_GetWindowProperties(window), SDL_PROP_WINDOW_X11_DISPLAY_POINTER, null);
            surface_desc_x11 := wgpu.SurfaceDescriptorFromXlibWindow.{
                chain = .{ sType = .SurfaceDescriptorFromXlibWindow },
                display = display,
                window = xx window, 
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
            hinstance := SDL_GetPointerProperty(SDL_GetWindowProperties(window), SDL_PROP_WINDOW_WIN32_INSTANCE_POINTER, null);
            hwnd := SDL_GetPointerProperty(SDL_GetWindowProperties(window), SDL_PROP_WINDOW_WIN32_HWND_POINTER, null);
            surface_desc := wgpu.SurfaceDescriptorFromWindowsHWND.{
                chain = .{ sType = .SurfaceDescriptorFromWindowsHWND },
                hinstance = xx hinstance,
                hwnd = xx hwnd,
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
        };
        wgpu.InstanceRequestAdapter(renderer.instance, *options, adapter_cb, *renderer.adapter);
        assert(renderer.adapter != null, "Unable to create Adapter");

        props : wgpu.AdapterProperties = ---;
        wgpu.AdapterGetProperties(renderer.adapter, *props);

        log("Adapter : %", props.adapterType);
        log("Backend : %", props.backendType);
        nb := wgpu.AdapterEnumerateFeatures(renderer.adapter, null);
        features := NewArray(xx nb, wgpu.FeatureName,, allocator = temp);

        wgpu.AdapterEnumerateFeatures(renderer.adapter, features.data);
        log("Features: ");
        for features {
            log("\t%", it);
        }
    }

    {   // Device
        limits := get_required_limits(renderer.adapter);

        extras := wgpu.RequiredLimitsExtras.{
            chain = .{sType = xx wgpu.NativeSType.SType_RequiredLimitsExtras },
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

        queue_desc := wgpu.QueueDescriptor.{
            label = "Default Queue",
        };

        desc := wgpu.DeviceDescriptor.{
            label = "Main Device",
            requiredFeatureCount = required_features.count,
            requiredFeatures =      required_features.data,
            requiredLimits = *required_limits,
            defaultQueue = queue_desc,
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
        {
            caps : wgpu.SurfaceCapabilities = ---;
            wgpu.SurfaceGetCapabilities(renderer.surface, renderer.adapter, *caps);
            log("Surface caps: %", caps);
            log("Present modes: ");
            p_modes : []wgpu.PresentMode;
            p_modes.data = caps.presentModes;
            p_modes.count = xx caps.presentModeCount;
            for p_modes {
                log("\t%", it);
            }

            log("Formats: ");
            p_formats: []wgpu.TextureFormat;
            p_formats.count = xx caps.formatCount;
            p_formats.data = caps.formats;
            for p_formats {
                log("\t%", it);
            }

        }

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
        renderer.width = 1280;
        renderer.height = 720;
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

    renderer.depth_texture = texture_create(renderer.width, renderer.height, .RenderAttachment, renderer.depth_format);

    create_bind_group_layouts(renderer);

    renderer.blit_pipeline = create_blit_pipeline(renderer);
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
        renderer.empty_texture = texture_from_data(data.data, 1, 1, 4, u8, "Empty Texture");
        renderer.empty_texture_uniform = create_bind_group_from_texture(*renderer.empty_texture);
    }   

    {   // Color Uniforms
        renderer.global_matrices_uniform = uniform_create(renderer.device, *renderer.uniform_pool, size_of(Global_Matrices), renderer.global_matrices_bgl);

        renderer.projection = make_projection_matrix(radians(45), cast(float)renderer.width/cast(float)renderer.height, 0.1, 1000);
        renderer.view = Matrix4_Identity;
        renderer.light_vec = unit_vector(.{1, -2, -1});
    }

    {   // Shadowmap Uniforms
        renderer.shadowmap_framebuffer = texture_create(2048, 2048, .TextureBinding | .RenderAttachment, .Depth24Plus);

        renderer.shadowmap_texture_uniform = create_bind_group_from_texture(*renderer.shadowmap_framebuffer, renderer.shadowmap_texture_bgl);
        renderer.shadowmap_matrices_uniform = uniform_create(renderer.device, *renderer.uniform_pool, size_of(Global_Matrices), renderer.global_matrices_bgl);
        
    }

    // update_framebuffer(renderer);
    return renderer;
}

destroy :: (using renderer: *Renderer) {
    buffer_pool_reset(*vertex_pool);
    buffer_pool_reset(*uniform_pool);
    buffer_pool_reset(*immediate_pool);

    wgpu.RenderPipelineRelease(debug_pipeline);
    wgpu.RenderPipelineRelease(blit_pipeline);
    wgpu.RenderPipelineRelease(ui_pipeline);
    wgpu.RenderPipelineRelease(static_mesh_pipelines[0]);
    wgpu.RenderPipelineRelease(static_mesh_pipelines[1]);
    wgpu.RenderPipelineRelease(skinned_mesh_pipelines[0]);
    wgpu.RenderPipelineRelease(skinned_mesh_pipelines[1]);

    wgpu.BindGroupRelease(empty_uniform);

    destroy(*global_matrices_uniform);
    destroy(*shadowmap_matrices_uniform);

    destroy(*shadowmap_framebuffer);
    destroy(*shadowmap_texture_uniform);
    
    destroy(*depth_texture);

    destroy(*empty_texture);
    destroy(*empty_texture_uniform);

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

change_light_vector :: (vec: Vector3) {
    global_renderer.light_vec = vec;
}

set_projection_matrix :: (fov: float) {
    global_renderer.projection = make_projection_matrix(radians(45), cast(float)global_renderer.width/cast(float)global_renderer.height, 0.1, 1000);
}

set_view_matrix :: (view: Matrix4) {
    global_renderer.view = view;
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

create_ui_pipeline :: (renderer: *Renderer, shader: string) -> wgpu.RenderPipeline {
    shader_module := shader_module_create(shader, renderer.device);
    defer wgpu.ShaderModuleRelease(shader_module);

    layout_builder: Pipeline_Layout_Builder;
    set_push_constants(*layout_builder, size_of(UI_Push_Constants), stages = .Vertex);
    add_bind_groups(*layout_builder, renderer.single_texture_bgl);
    pipeline_layout := pipeline_layout_builder_build(*layout_builder, renderer.device);
    defer wgpu.PipelineLayoutRelease(pipeline_layout);

    builder: Pipeline_Builder;
    add_vertex_shader(*builder, shader_module, "vs_main", UI_Vertex);
    add_fragment_shader(*builder, shader_module, "fs_main");
    add_color_target(*builder, renderer.render_format);
    return pipeline_builder_build(*builder, renderer.device, pipeline_layout, "UI Pipeline");
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
        pipelines[0] = pipeline_builder_build(*builder, renderer.device, pipeline_layout, "Static Mesh Shadow Pipeline");
    }

    {   // Color
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
        add_color_target(*builder, renderer.render_format);
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
        add_color_target(*builder, renderer.render_format);
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
    add_vertex_shader(*builder, shader_module, "debug_vs_main", Debug_Vertex);
    add_fragment_shader(*builder, shader_module, "debug_fs_main");
    add_color_target(*builder, renderer.render_format);
    primitive_state(*builder, .LineList);
    pipeline := pipeline_builder_build(*builder, renderer.device, pipeline_layout, "Debug Pipeline");
    return pipeline;

}

create_blit_pipeline :: (using renderer: *Renderer) -> wgpu.RenderPipeline {
    shader_module := shader_module_create(BLIT_SHADER, renderer.device);
    defer wgpu.ShaderModuleRelease(shader_module);

    layout_builder: Pipeline_Layout_Builder;
    add_bind_groups(*layout_builder, renderer.single_texture_bgl);
    pipeline_layout := pipeline_layout_builder_build(*layout_builder, renderer.device);
    defer wgpu.PipelineLayoutRelease(pipeline_layout);

    builder: Pipeline_Builder;
    add_vertex_shader(*builder, shader_module, "blit_vs_main");
    add_fragment_shader(*builder, shader_module, "blit_fs_main");
    add_color_target(*builder, renderer.surface_format);
    return pipeline_builder_build(*builder, renderer.device, pipeline_layout, "Blit Pipeline");
}

create_command_encoder :: (label := "") -> wgpu.CommandEncoder {
    desc := wgpu.CommandEncoderDescriptor.{ label = temp_c_string(label) };
    return WGPU_Check(wgpu.DeviceCreateCommandEncoder(global_renderer.device, *desc));
}
