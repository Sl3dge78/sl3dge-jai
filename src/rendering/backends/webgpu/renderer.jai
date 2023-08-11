WGPU_Check :: (item: *$T) -> *T #expand {
    assert(item != null, "Unable to create %!", T);
    return item;
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
    width : u32;
    height: u32;

    sampler   : wgpu.Sampler;

    single_texture_bind_group   : wgpu.BindGroupLayout;
    global_matrices_bind_group  : wgpu.BindGroupLayout;
    shadowmap_texture_bind_group: wgpu.BindGroupLayout;

    ui_pipeline          : wgpu.RenderPipeline;

    depth_texture : Texture;
    static_mesh_pipelines : [2] wgpu.RenderPipeline; // 0 = shadowmap, 1 = color

    global_matrices_buffer: Buffer;
    global_matrices_binding: wgpu.BindGroup;

    shadowmap_matrices_buffer: Buffer;
    shadowmap_matrices_binding: wgpu.BindGroup;
    shadowmap_framebuffer: Texture;
    shadowmap_texture_binding : wgpu.BindGroup;

    projection := Matrix4_Identity;
    view := Matrix4_Identity;
    light_dir : Vector3;

    create :: (window: *SDL_Window) -> Renderer {
        renderer := *global_renderer;

        wgpu.SetLogCallback(wgpu_log_callback, null);
        wgpu.SetLogLevel(.Warn);

        {   // Instance
            desc: wgpu.InstanceDescriptor;
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
            } else {
                // @TODO
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

        {   // Color Uniforms
            renderer.global_matrices_buffer = Buffer.create(size_of(Global_Matrices), .Uniform | .CopyDst);
            
            desc := wgpu.BindGroupDescriptor.{
                layout = renderer.global_matrices_bind_group,
                entryCount = 1,
                entries = *wgpu.BindGroupEntry.{
                    binding = 0, buffer = renderer.global_matrices_buffer.handle, offset = 0, size = renderer.global_matrices_buffer.size
                },
            };
            renderer.global_matrices_binding = WGPU_Check(wgpu.DeviceCreateBindGroup(renderer.device, *desc));

            renderer.projection = make_projection_matrix(radians(45), cast(float)renderer.width/cast(float)renderer.height, 0.1, 1000);
            renderer.view = Matrix4_Identity;
            renderer.light_dir = unit_vector(.{1, -2, -1});
        }

        {   // Shadowmap Uniforms
            renderer.shadowmap_framebuffer = Texture.create(2048, 2048, .TextureBinding | .RenderAttachment, .Depth24Plus);
            
            entries := wgpu.BindGroupEntry.[
                .{binding = 0, sampler = global_renderer.sampler },
                .{binding = 1, textureView = renderer.shadowmap_framebuffer.view },
            ];
            desc1 := wgpu.BindGroupDescriptor.{
                layout = global_renderer.shadowmap_texture_bind_group,
                entryCount = entries.count,
                entries = entries.data,
            };
            renderer.shadowmap_texture_binding = wgpu.DeviceCreateBindGroup(renderer.device, *desc1);

            renderer.shadowmap_matrices_buffer = Buffer.create(size_of(Global_Matrices), .Uniform | .CopyDst);
            desc2 := wgpu.BindGroupDescriptor.{
                layout = renderer.global_matrices_bind_group,
                entryCount = 1,
                entries = *wgpu.BindGroupEntry.{
                    binding = 0, buffer = renderer.shadowmap_matrices_buffer.handle, offset = 0, size = renderer.shadowmap_matrices_buffer.size
                },
            };
            renderer.shadowmap_matrices_binding = WGPU_Check(wgpu.DeviceCreateBindGroup(renderer.device, *desc2));
        }

        return renderer;
    }

    destroy :: (using renderer: *Renderer) {
        Draw_Data.destroy(*context.immediate._2d_draw_data);
        Draw_Data.destroy(*context.immediate._3d_draw_data);

        wgpu.RenderPipelineRelease(ui_pipeline);
        wgpu.RenderPipelineRelease(static_mesh_pipelines[0]);
        wgpu.RenderPipelineRelease(static_mesh_pipelines[1]);

        wgpu.BindGroupRelease(global_matrices_binding);
        Buffer.destroy(*global_matrices_buffer);

        Buffer.destroy(*shadowmap_matrices_buffer);
        Texture.destroy(*shadowmap_framebuffer);
        wgpu.BindGroupRelease(shadowmap_matrices_binding);
        wgpu.BindGroupRelease(shadowmap_texture_binding);
        
        Texture.destroy(*depth_texture);

        wgpu.BindGroupLayoutRelease(single_texture_bind_group);
        wgpu.BindGroupLayoutRelease(global_matrices_bind_group);
        wgpu.BindGroupLayoutRelease(shadowmap_texture_bind_group);

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
        found |= hub_report(report.vulkan, *builder);
        if report.backendType == {
            case .Vulkan; found |= hub_report(report.vulkan, *builder);
            case .OpenGL; found |= hub_report(report.gl, *builder);
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
            maxBindGroups                             = 2,
            maxBindingsPerBindGroup                   = 2,
            maxDynamicUniformBuffersPerPipelineLayout = 0,
            maxDynamicStorageBuffersPerPipelineLayout = 0,
            maxSampledTexturesPerShaderStage          = 1,
            maxSamplersPerShaderStage                 = 1,
            maxStorageBuffersPerShaderStage           = 0,
            maxStorageTexturesPerShaderStage          = 0,
            maxUniformBuffersPerShaderStage           = 1,
            maxUniformBufferBindingSize               = 256,
            maxStorageBufferBindingSize               = 0,
            minUniformBufferOffsetAlignment           = supported_limits.limits.minUniformBufferOffsetAlignment,
            minStorageBufferOffsetAlignment           = supported_limits.limits.minStorageBufferOffsetAlignment,
            maxVertexBuffers                          = 1,
            maxBufferSize                             = 16 * 1024 * 1024,
            maxVertexAttributes                       = 4,
            maxVertexBufferArrayStride                = size_of(Vertex),
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

    // This needs to be a macro otherwise the generated array gets optimized out
    get_vertex_layout :: ($type: Type) -> wgpu.VertexBufferLayout {
        info := type_info(type);
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
            }
            attributes[it_index] = .{format = format, offset = xx it.offset_in_bytes, shaderLocation = xx it_index };
        }

        return wgpu.VertexBufferLayout.{
            arrayStride = xx size_of(type),
            stepMode = .Vertex,
            attributeCount = xx attributes.count,
            attributes = attributes.data
        };
    }

    create_binding_groups :: (using renderer: *Renderer) {
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

    shadowmap_render_pass :: (using renderer: *Renderer, command_encoder: wgpu.CommandEncoder, framebuffer: wgpu.TextureView) {
        
        render_pass_desc := wgpu.RenderPassDescriptor.{
            label = "Shadow Map",
            depthStencilAttachment = *wgpu.RenderPassDepthStencilAttachment.{
                view = framebuffer,
                depthLoadOp = .Clear,
                depthStoreOp = .Store,
                depthClearValue = 1,
                stencilLoadOp = .Clear,
                stencilStoreOp = .Discard,
                stencilClearValue = 0,
                stencilReadOnly = true,
            }
        };
        render_pass := WGPU_Check(wgpu.CommandEncoderBeginRenderPass(command_encoder, *render_pass_desc));
        wgpu.RenderPassEncoderSetPipeline(render_pass, static_mesh_pipelines[0]);
        wgpu.RenderPassEncoderSetBindGroup(render_pass, 0, shadowmap_matrices_binding, 0, null);
        draw_immediate_meshes(renderer, render_pass);
        wgpu.RenderPassEncoderEnd(render_pass);
    }

    main_render_pass :: (using renderer: *Renderer, command_encoder: wgpu.CommandEncoder, framebuffer: wgpu.TextureView) {
        render_pass_desc := wgpu.RenderPassDescriptor.{
            label = "Main Pass",
            colorAttachmentCount = 1,
            colorAttachments = *wgpu.RenderPassColorAttachment.{
                view = framebuffer,
                resolveTarget = null,
                loadOp = .Clear,
                storeOp = .Store,
                clearValue = .{0.529, 0.808, 0.922, 1.0}
            },
            depthStencilAttachment = *wgpu.RenderPassDepthStencilAttachment.{
                view = renderer.depth_texture.view,
                depthLoadOp = .Clear,
                depthStoreOp = .Store,
                depthClearValue = 1,
                stencilLoadOp = .Clear,
                stencilStoreOp = .Discard,
                stencilClearValue = 0,
                stencilReadOnly = true,
            },
        };
        render_pass := WGPU_Check(wgpu.CommandEncoderBeginRenderPass(command_encoder, *render_pass_desc));
        wgpu.RenderPassEncoderSetPipeline(render_pass, static_mesh_pipelines[1]);
        wgpu.RenderPassEncoderSetBindGroup(render_pass, 0, global_matrices_binding, 0, null);
        wgpu.RenderPassEncoderSetBindGroup(render_pass, 1, shadowmap_texture_binding, 0, null);
        draw_immediate_meshes(renderer, render_pass);

        wgpu.RenderPassEncoderEnd(render_pass);
    }

    ui_render_pass :: (using renderer: *Renderer, command_encoder: wgpu.CommandEncoder, framebuffer: wgpu.TextureView) {
        render_pass_desc := wgpu.RenderPassDescriptor.{
            label = "UI Pass",
            colorAttachmentCount = 1,
            colorAttachments = *wgpu.RenderPassColorAttachment.{
                view = framebuffer,
                resolveTarget = null,
                loadOp = .Load,
                storeOp = .Store,
            },
            depthStencilAttachment = null,
        };
        render_pass := WGPU_Check(wgpu.CommandEncoderBeginRenderPass(command_encoder, *render_pass_desc));

        {   // Immediate 2d data
            using context.immediate._2d_draw_data;
            wgpu.RenderPassEncoderSetPipeline(render_pass, ui_pipeline);
            wgpu.RenderPassEncoderSetBindGroup(render_pass, 0, global_engine.default_font.binding, 0, null);
            wgpu.RenderPassEncoderSetVertexBuffer(render_pass, 0, vertex_buffer.handle, 0, vertex_buffer.size);
            pc := float.[2.0 / cast(float)global_renderer.width, -2.0 / cast(float)global_renderer.height, -1, 1];
            wgpu.RenderPassEncoderSetPushConstants(render_pass, .Vertex, 0, size_of(type_of(pc)), *pc);
            for context.immediate._2d_draw_data.draw_cmds {
                wgpu.RenderPassEncoderDraw(render_pass, it.count, 1, it.id, 0);
            }
            
        }

        wgpu.RenderPassEncoderEnd(render_pass);
    }

    draw_immediate_meshes :: (using renderer: *Renderer, render_pass: wgpu.RenderPassEncoder) {
        using context.immediate._3d_draw_data;
        
        wgpu.RenderPassEncoderSetVertexBuffer(render_pass, 0, vertex_buffer.handle, 0, vertex_buffer.size);
        for draw_cmds {
            pc := Standard_Push_Constants.{transpose(it.xform), transpose(inverse(it.xform))};
            wgpu.RenderPassEncoderSetPushConstants(render_pass, .Vertex, 0, size_of(type_of(pc)), *pc);
            wgpu.RenderPassEncoderDraw(render_pass, it.count, 1, it.id, 0);
        }
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
        Buffer.write_data(global_matrices_buffer, *matrices, size_of(type_of(matrices)));

        shadowmap_matrices := Global_Matrices.{
            projection = transpose(light_proj),
            view = transpose(light_view),
            light = matrices.light,
            light_dir = matrices.light_dir
        };
        Buffer.write_data(shadowmap_matrices_buffer, *shadowmap_matrices, size_of(type_of(shadowmap_matrices)));

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
}

global_renderer : Renderer;

c_print :: (format: string, args: ..Any, to_standard_error := false) #expand {
    new_ctx: Context;
    push_context new_ctx {
        print(format, ..args, to_standard_error);
    }
} @PrintLike

wgpu_log_callback :: (level: wgpu.LogLevel, message: *u8, data: *void) #c_call {
    c_print("WGPU - % : %\n", level, to_string(message));
}

wgpu_device_lost_callback :: (reason: wgpu.DeviceLostReason, message: *u8, userdata: *void) -> void #c_call {
    c_print("WGPU DEVICE LOST - % : %\n", reason, to_string(message));
    debug_break();
}

wgpu_error_callback :: (type: wgpu.ErrorType, message: *u8, userdata: *void) -> void #c_call {
    c_print("WGPU ERROR - % : %\n", type, to_string(message));
    debug_break();
}

wgpu_on_queue_work_done :: (status: wgpu.QueueWorkDoneStatus, userdata: *void) -> void #c_call {
    c_print("WGPU QUEUE - %\n", status);
}