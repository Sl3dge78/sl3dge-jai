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
    swapchain : wgpu.SwapChain;
    swapchain_format : wgpu.TextureFormat;

    depth_format :: wgpu.TextureFormat.Depth24Plus;

    limits: wgpu.Limits;
    uniform_buffer_alignement: u64;
    width : u32;
    height: u32;

    sampler   : wgpu.Sampler;

    empty_bind_group : wgpu.BindGroupLayout;
    single_texture_bind_group   : wgpu.BindGroupLayout;
    global_matrices_bind_group  : wgpu.BindGroupLayout;
    shadowmap_texture_bind_group: wgpu.BindGroupLayout;
    instance_data_bind_group : wgpu.BindGroupLayout;

    ui_pipeline          : wgpu.RenderPipeline;

    depth_texture : Texture;
    static_mesh_pipelines : [2] wgpu.RenderPipeline; // 0 = shadowmap, 1 = color
    skinned_mesh_pipelines : [2] wgpu.RenderPipeline; // 0 = shadowmap, 1 = color

    empty_uniform: wgpu.BindGroup;

    global_matrices_uniform: Uniform;

    shadowmap_matrices_uniform: Uniform;
    shadowmap_framebuffer: Texture;
    shadowmap_texture_uniform : Texture_Uniform;

    projection := Matrix4_Identity;
    view := Matrix4_Identity;
    light_dir : Vector3;

    current_scene: *Scene;
    mesh_buffer_pool: Buffer_Pool = .{
        kind =  .Vertex | .Index | .CopyDst
    };

    uniform_pool: Buffer_Pool = .{
        kind =  .Uniform | .CopyDst
    };

    create :: (window: *SDL_Window) -> Renderer {
        renderer := *global_renderer;

        wgpu.SetLogCallback(wgpu_log_callback, null);
        wgpu.SetLogLevel(.Warn);

        {   // Instance
            desc: wgpu.InstanceDescriptor;
            renderer.instance = WGPU_Check(wgpu.CreateInstance(*desc));
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
            } else {
                #assert(false);
            }

            renderer.surface = WGPU_Check(wgpu.InstanceCreateSurface(renderer.instance, *desc));
        }
        
        {   // Adapter
            adapter_cb :: (status: wgpu.RequestAdapterStatus, adapter: wgpu.Adapter, message: *u8, userdata: *void) -> void #c_call {
                if status != .Success {
                    c_print("%\n", message);
                    return;
                }
                (cast(*wgpu.Adapter) userdata).* = adapter;
            }

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
            device_cb :: (status: wgpu.RequestDeviceStatus, device: wgpu.Device, message: *u8, userdata: *void) #c_call {
                if status != .Success {
                    c_print("%\n", message);
                    return;
                }
                (cast(*wgpu.Device) userdata).* = device;
            }

            limits := get_required_limits(renderer.adapter);

            extras := wgpu.RequiredLimitsExtras.{
                maxPushConstantSize = size_of(Standard_Push_Constants),
            };

            required_limits := wgpu.RequiredLimits.{
                nextInChain = *extras.chain,
                limits = limits,
            };

            required_features := wgpu.FeatureName.[
                .PushConstants
            ];

            desc := wgpu.DeviceDescriptor.{
                label = "Main Device",
                requiredFeaturesCount = required_features.count,
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
            renderer.swapchain_format = wgpu.SurfaceGetPreferredFormat(renderer.surface, renderer.adapter);
            desc := wgpu.SwapChainDescriptor.{
                label = "Main SwapChain",
                format = renderer.swapchain_format,
                usage = xx wgpu.TextureUsage.RenderAttachment,
                width = 1280,
                height = 720,
                presentMode = .Fifo,
            };
            renderer.width = desc.width;
            renderer.height = desc.height;
            renderer.swapchain = WGPU_Check(wgpu.DeviceCreateSwapChain(renderer.device, renderer.surface, *desc));
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

        create_binding_groups(renderer);
      
        renderer.ui_pipeline = create_ui_pipeline(renderer);
        renderer.static_mesh_pipelines = create_static_mesh_pipeline(renderer);
        renderer.skinned_mesh_pipelines = create_skinned_mesh_pipeline(renderer);

        {   // Empty Uniform
            desc := wgpu.BindGroupDescriptor.{
                layout = renderer.empty_bind_group, 
                entryCount = 0,
                entries = null,
            };
            renderer.empty_uniform = WGPU_Check(wgpu.DeviceCreateBindGroup(renderer.device, *desc));
        }   

        {   // Color Uniforms
            renderer.global_matrices_uniform = Uniform.create(renderer.device, *renderer.uniform_pool, size_of(Global_Matrices), renderer.global_matrices_bind_group);

            renderer.projection = make_projection_matrix(radians(45), cast(float)renderer.width/cast(float)renderer.height, 0.1, 1000);
            renderer.view = Matrix4_Identity;
            renderer.light_dir = unit_vector(.{1, -2, -1});
        }

        {   // Shadowmap Uniforms
            renderer.shadowmap_framebuffer = Texture.create(2048, 2048, .TextureBinding | .RenderAttachment, .Depth24Plus);

            renderer.shadowmap_texture_uniform = Texture_Uniform.create(renderer.sampler, renderer.shadowmap_framebuffer.view, global_renderer.shadowmap_texture_bind_group);
            renderer.shadowmap_matrices_uniform = Uniform.create(renderer.device, *renderer.uniform_pool, size_of(Global_Matrices), renderer.global_matrices_bind_group);
            
        }

        return renderer;
    }

    destroy :: (using renderer: *Renderer) {
        Buffer_Pool.reset(*mesh_buffer_pool);
        Buffer_Pool.reset(*uniform_pool);

        Draw_Data.destroy(*context.immediate._2d_draw_data);
        Draw_Data.destroy(*context.immediate._3d_draw_data);

        wgpu.RenderPipelineRelease(ui_pipeline);
        wgpu.RenderPipelineRelease(static_mesh_pipelines[0]);
        wgpu.RenderPipelineRelease(static_mesh_pipelines[1]);

        Uniform.destroy(*global_matrices_uniform);
        Uniform.destroy(*shadowmap_matrices_uniform);

        Texture.destroy(*shadowmap_framebuffer);
        Texture_Uniform.destroy(*shadowmap_texture_uniform);
        
        Texture.destroy(*depth_texture);

        wgpu.BindGroupLayoutRelease(empty_bind_group);
        wgpu.BindGroupLayoutRelease(single_texture_bind_group);
        wgpu.BindGroupLayoutRelease(global_matrices_bind_group);
        wgpu.BindGroupLayoutRelease(shadowmap_texture_bind_group);
        wgpu.BindGroupLayoutRelease(instance_data_bind_group);

        wgpu.SamplerRelease(sampler);

        wgpu.SwapChainRelease(swapchain);
        wgpu.QueueRelease(queue);
        wgpu.DeviceRelease(device);
        wgpu.AdapterRelease(adapter);
        wgpu.SurfaceRelease(surface);

        report_gpu_leaks(instance);

        wgpu.InstanceRelease(instance);
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
            maxBindGroups                             = 3,
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
            maxVertexBufferArrayStride                = size_of(Vertex) + size_of(Skinned_Vertex),
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

    get_vertex_layout :: (type: Type, shader_location_offset := 0) -> wgpu.VertexBufferLayout {
        info := cast(*Type_Info_Struct)type;
        attributes := NewArray(info.members.count, wgpu.VertexAttribute, allocator = temp);

        for info.members {
            // .{ format = .Float32x2, offset = 0, shaderLocation = 0 },
            format: wgpu.VertexFormat;

            if it.type.type == {
                case .BOOL; {
                    format = .Sint32;
                }
                case .INTEGER; {
                    int_type_info := cast(*Type_Info_Integer) it.type;

                    if int_type_info.signed {
                        format = .Sint32;
                    } else {
                        format = .Uint32;
                    }
                }
                case .FLOAT; {
                    assert(it.type.runtime_size <= 4, "Only float32 is supported in Vertex Attribute Data.");
                    format = .Float32;
                }
                case .STRUCT; {
                    struct_type_info := cast(*Type_Info_Struct) it.type;

                    if struct_type_info.name == {
                        case "Vector4"; format = .Float32x4;
                        case "Vector3"; format = .Float32x3;
                        case "Vector2"; format = .Float32x2;
                        case; assert(false, "Unsupported struct type. Only Vector2, Vector3, Vector4 are supported");
                    }
                }
                case .ARRAY; {
                    array_type_info := cast(*Type_Info_Array) it.type;
                    assert(array_type_info.array_count == 4, "Unhandled!");
                    elem_type_info := array_type_info.element_type;
                    assert(elem_type_info.type == .INTEGER, "Unhandled!");
                    format = .Uint32x4;
                }
            }
            attributes[it_index] = .{format = format, offset = xx it.offset_in_bytes, shaderLocation = xx (it_index + shader_location_offset) };
        }

        return wgpu.VertexBufferLayout.{
            arrayStride = xx info.runtime_size,
            stepMode = .Vertex,
            attributeCount = xx attributes.count,
            attributes = attributes.data
        };
    }

    create_binding_groups :: (using renderer: *Renderer) {
        {   // Empty 
            desc := wgpu.BindGroupLayoutDescriptor.{
                label = "Empty",
                entryCount = 0,
                entries = null
            };
            renderer.empty_bind_group = WGPU_Check(wgpu.DeviceCreateBindGroupLayout(renderer.device, *desc));

        }

        {   // Single texture
            builder : Bindings_Builder;
            Bindings_Builder.add_entry(*builder, wgpu.SamplerBindingLayout.{type = .Filtering}, binding = 0, .Fragment);
            Bindings_Builder.add_entry(*builder, wgpu.TextureBindingLayout.{sampleType = .Float, viewDimension = ._2D, multisampled = false}, binding = 1, .Fragment);
            renderer.single_texture_bind_group = Bindings_Builder.build(*builder);
        }

        {   // Shadowmap
            builder : Bindings_Builder;
            Bindings_Builder.add_entry(*builder, wgpu.SamplerBindingLayout.{type = .Filtering}, binding = 0, .Fragment);
            Bindings_Builder.add_entry(*builder, wgpu.TextureBindingLayout.{sampleType = .Depth, viewDimension = ._2D, multisampled = false}, binding = 1, .Fragment);
            renderer.shadowmap_texture_bind_group = Bindings_Builder.build(*builder);
        }

        {   // Global Data
            builder : Bindings_Builder;
            Bindings_Builder.add_entry(*builder, wgpu.BufferBindingLayout.{ type = .Uniform, hasDynamicOffset = false, minBindingSize = xx size_of(Global_Matrices) }, binding = 0, .Vertex | .Fragment);
            renderer.global_matrices_bind_group = Bindings_Builder.build(*builder);
        }

        {   // Instance Data
            builder : Bindings_Builder;
            Bindings_Builder.add_entry(*builder, wgpu.BufferBindingLayout.{type = .Uniform, hasDynamicOffset = false, minBindingSize = xx size_of(Instance_Data) }, binding = 0, .Vertex);
            renderer.instance_data_bind_group = Bindings_Builder.build(*builder);
        }
    }

    create_ui_pipeline :: (using renderer: *Renderer) -> wgpu.RenderPipeline {
        
        shader_module := create_shader_module(UI_SHADER, device);
        defer wgpu.ShaderModuleRelease(shader_module);

        layout_builder: Pipeline_Layout_Builder;
        Pipeline_Layout_Builder.push_constants(*layout_builder, size_of(UI_Push_Constants), stages = .Vertex);
        Pipeline_Layout_Builder.add_bind_groups(*layout_builder, single_texture_bind_group);
        pipeline_layout := Pipeline_Layout_Builder.build(*layout_builder, device);
        defer wgpu.PipelineLayoutRelease(pipeline_layout);

        builder: Pipeline_Builder;
        Pipeline_Builder.add_vertex_shader(*builder, shader_module, "vs_main", Vertex);
        Pipeline_Builder.add_fragment_shader(*builder, shader_module, "fs_main");
        return Pipeline_Builder.build(*builder, device, pipeline_layout, "UI Pipeline");
    }
    
    create_static_mesh_pipeline :: (using renderer: *Renderer) -> [2]wgpu.RenderPipeline {
        pipelines : [2]wgpu.RenderPipeline;
        
        shader_module := create_shader_module(STANDARD_SHADER, device);
        defer wgpu.ShaderModuleRelease(shader_module);

        {   // Shadowmap            
            layout_builder: Pipeline_Layout_Builder;
            Pipeline_Layout_Builder.push_constants(*layout_builder, size_of(Standard_Push_Constants), stages = .Vertex);
            Pipeline_Layout_Builder.add_bind_groups(*layout_builder, renderer.global_matrices_bind_group);
            pipeline_layout := Pipeline_Layout_Builder.build(*layout_builder, renderer.device);
            defer wgpu.PipelineLayoutRelease(pipeline_layout);

            builder: Pipeline_Builder;
            Pipeline_Builder.add_vertex_shader(*builder, shader_module, "static_vs", Vertex);
            Pipeline_Builder.depth_stencil_state(*builder, renderer.depth_format);
            pipelines[0] = Pipeline_Builder.build(*builder, renderer.device, pipeline_layout, "Static Mesh Color Pipeline");
        }

        {   // Color
            depth_texture = Texture.create(width, height, .RenderAttachment, depth_format);

            layout_builder: Pipeline_Layout_Builder;
            Pipeline_Layout_Builder.push_constants(*layout_builder, size_of(Standard_Push_Constants), stages = .Vertex);
            Pipeline_Layout_Builder.add_bind_groups(*layout_builder, renderer.global_matrices_bind_group);
            Pipeline_Layout_Builder.add_bind_groups(*layout_builder, renderer.shadowmap_texture_bind_group);
            pipeline_layout := Pipeline_Layout_Builder.build(*layout_builder, renderer.device);
            defer wgpu.PipelineLayoutRelease(pipeline_layout);

            builder: Pipeline_Builder;
            Pipeline_Builder.add_vertex_shader(*builder, shader_module, "static_vs", Vertex);
            Pipeline_Builder.add_fragment_shader(*builder, shader_module, "fs_main");
            Pipeline_Builder.depth_stencil_state(*builder, renderer.depth_format);
            pipelines[1] = Pipeline_Builder.build(*builder, renderer.device, pipeline_layout, "Static Mesh Color Pipeline");
        }
        return pipelines;
    }

    create_skinned_mesh_pipeline :: (using renderer: *Renderer) -> [2]wgpu.RenderPipeline {
        pipelines : [2]wgpu.RenderPipeline;
        
        shader_module := create_shader_module(STANDARD_SHADER, device);
        defer wgpu.ShaderModuleRelease(shader_module);

        {   // Shadowmap            
            layout_builder: Pipeline_Layout_Builder;
            Pipeline_Layout_Builder.push_constants(*layout_builder, size_of(Standard_Push_Constants), stages = .Vertex);
            Pipeline_Layout_Builder.add_bind_groups(*layout_builder, 
                renderer.global_matrices_bind_group, 
                empty_bind_group,
                instance_data_bind_group
            );
            pipeline_layout := Pipeline_Layout_Builder.build(*layout_builder, renderer.device);
            defer wgpu.PipelineLayoutRelease(pipeline_layout);

            builder: Pipeline_Builder;
            Pipeline_Builder.add_vertex_shader(*builder, shader_module, "skinned_vs", Vertex, Skinned_Vertex);
            Pipeline_Builder.depth_stencil_state(*builder, renderer.depth_format);
            pipelines[0] = Pipeline_Builder.build(*builder, renderer.device, pipeline_layout, "Skinned Mesh Color Pipeline");
        }

        {   // Color
            depth_texture = Texture.create(width, height, .RenderAttachment, depth_format);

            layout_builder: Pipeline_Layout_Builder;
            Pipeline_Layout_Builder.push_constants(*layout_builder, size_of(Standard_Push_Constants), stages = .Vertex);
            Pipeline_Layout_Builder.add_bind_groups(*layout_builder, renderer.global_matrices_bind_group);
            Pipeline_Layout_Builder.add_bind_groups(*layout_builder, renderer.shadowmap_texture_bind_group);
            Pipeline_Layout_Builder.add_bind_groups(*layout_builder, renderer.instance_data_bind_group);
            pipeline_layout := Pipeline_Layout_Builder.build(*layout_builder, renderer.device);
            defer wgpu.PipelineLayoutRelease(pipeline_layout);

            builder: Pipeline_Builder;
            Pipeline_Builder.add_vertex_shader(*builder, shader_module, "skinned_vs", Vertex, Skinned_Vertex);
            Pipeline_Builder.add_fragment_shader(*builder, shader_module, "fs_main");
            Pipeline_Builder.depth_stencil_state(*builder, renderer.depth_format);
            pipelines[1] = Pipeline_Builder.build(*builder, renderer.device, pipeline_layout, "Skinned Mesh Color Pipeline");
        }
        return pipelines;
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
        Immediate.draw_3d(render_pass);
        Scene.draw_static_meshes(current_scene, render_pass);
        wgpu.RenderPassEncoderSetPipeline(render_pass, skinned_mesh_pipelines[0]);
        wgpu.RenderPassEncoderSetBindGroup(render_pass, 1, empty_uniform, 0, null);
        Scene.draw_skinned_meshes(current_scene, render_pass);
        wgpu.RenderPassEncoderEnd(render_pass);
    }

    main_render_pass :: (using renderer: *Renderer, command_encoder: wgpu.CommandEncoder, framebuffer: wgpu.TextureView) {
        color_attachment := wgpu.RenderPassColorAttachment.{
            view = framebuffer,
            resolveTarget = null,
            loadOp = .Clear,
            storeOp = .Store,
            clearValue = .{0.529, 0.808, 0.922, 1.0}
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
        Immediate.draw_3d(render_pass);
        Scene.draw_static_meshes(current_scene, render_pass);

        wgpu.RenderPassEncoderSetPipeline(render_pass, skinned_mesh_pipelines[1]);
        Scene.draw_skinned_meshes(current_scene, render_pass);
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

        Immediate.draw_2d(render_pass);

        wgpu.RenderPassEncoderEnd(render_pass);
    }

    end_frame :: () {
        using renderer := *global_renderer;

        current_texture := WGPU_Check(wgpu.SwapChainGetCurrentTextureView(swapchain));
        defer wgpu.TextureViewRelease(current_texture);

        // Upload data
        Draw_Data.upload(*context.immediate._2d_draw_data);
        defer Draw_Data.reset(*context.immediate._2d_draw_data);
        Draw_Data.upload(*context.immediate._3d_draw_data);
        defer Draw_Data.reset(*context.immediate._3d_draw_data);

        size:: 20;
        light_proj := orthographic_projection_matrix(size, -size, -size, size, -size, size, true);
        light_view := make_look_at_matrix(.{0, 0, 0}, light_dir, .{0, 1, 0}, false);
        matrices := Global_Matrices.{
            projection = transpose(projection),
            view = transpose(view),
            light = transpose(light_proj * light_view),
            light_dir = light_dir
        };
        Uniform.write(global_matrices_uniform, *matrices);

        shadowmap_matrices := Global_Matrices.{
            projection = transpose(light_proj),
            view = transpose(light_view),
            light = matrices.light,
            light_dir = matrices.light_dir
        };
        Uniform.write(shadowmap_matrices_uniform, *shadowmap_matrices);

        encoder_desc := wgpu.CommandEncoderDescriptor.{ label = "Main Command Encoder" };
        command_encoder := WGPU_Check(wgpu.DeviceCreateCommandEncoder(device, *encoder_desc));
        defer wgpu.CommandEncoderRelease(command_encoder);
        shadowmap_render_pass(renderer, command_encoder, shadowmap_framebuffer.view);
        main_render_pass(renderer, command_encoder, current_texture);
        ui_render_pass(renderer, command_encoder, current_texture);
        
        command_buffer_desc := wgpu.CommandBufferDescriptor.{ label = "Main Command Buffer" };
        command_buffer := WGPU_Check(wgpu.CommandEncoderFinish(command_encoder, *command_buffer_desc));
        defer wgpu.CommandBufferRelease(command_buffer);
        wgpu.QueueSubmit(queue, 1, *command_buffer);
        wgpu.SwapChainPresent(swapchain);
    }

    change_light_direction :: (dir: Vector3) {
        global_renderer.light_dir = dir;
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
}

global_renderer : Renderer;