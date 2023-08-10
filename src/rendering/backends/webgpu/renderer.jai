

Renderer :: struct {
    // Main State
    instance  : wgpu.Instance;
    surface   : wgpu.Surface;
    adapter   : wgpu.Adapter;
    device    : wgpu.Device;
    queue     : wgpu.Queue;
    swapchain : wgpu.SwapChain;
    swapchain_format : wgpu.TextureFormat;
    width : u32;
    height: u32;

    sampler   : wgpu.Sampler;

    single_texture_bind_group : wgpu.BindGroupLayout;

    ui_pipeline  : wgpu.RenderPipeline;

    create :: (window: *SDL_Window) -> Renderer {
        renderer := *global_renderer;

        wgpu.SetLogCallback(wgpu_log_callback, null);
        wgpu.SetLogLevel(.Trace);

        {   // Instance
            desc: wgpu.InstanceDescriptor;
            renderer.instance = wgpu.CreateInstance(*desc);
            assert(renderer.instance != null, "Unable to create Instance");
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

            renderer.surface = wgpu.InstanceCreateSurface(renderer.instance, *desc);
            assert(renderer.surface != null, "Unable to create Surface");
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
                maxPushConstantSize = 2 * size_of(Vector2),
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
            log("Activated limits: %", limits);
        }

        {   // Queue 
            renderer.queue = wgpu.DeviceGetQueue(renderer.device);    
            assert(renderer.queue != null, "Unable to create Queue");

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
            renderer.swapchain = wgpu.DeviceCreateSwapChain(renderer.device, renderer.surface, *desc);
            assert(renderer.swapchain != null, "Unable to create SwapChain");
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

            renderer.sampler = wgpu.DeviceCreateSampler(renderer.device, *desc);
            assert(renderer.sampler != null, "Unable to create Sampler");
        }

        {   // Bindings
            builder : Bindings_Builder;
            Bindings_Builder.add_entry(*builder, wgpu.SamplerBindingLayout.{type = .Filtering}, binding = 0, .Fragment);
            Bindings_Builder.add_entry(*builder, wgpu.TextureBindingLayout.{sampleType = .Float, viewDimension = ._2D, multisampled = false}, binding = 1, .Fragment);
            renderer.single_texture_bind_group = Bindings_Builder.build(*builder);
        }

        {   // Pipelines
            renderer.ui_pipeline = create_ui_pipeline(renderer);
        }

        return renderer;
    }

    destroy :: (using renderer: *Renderer) {
        Draw_Data.destroy(*context.immediate._2d_draw_data);

        wgpu.RenderPipelineRelease(ui_pipeline);
        wgpu.SwapChainRelease(swapchain);
        wgpu.QueueRelease(queue);
        wgpu.DeviceRelease(device);
        wgpu.AdapterRelease(adapter);
        wgpu.SurfaceRelease(surface);
        wgpu.InstanceRelease(instance);
    }

    get_required_limits :: (adapter: wgpu.Adapter) -> wgpu.Limits {
        supported_limits : wgpu.SupportedLimits;
        wgpu.AdapterGetLimits(adapter, *supported_limits);
        // log("Limits: %", supported_limits);

        return .{
            maxTextureDimension1D                     = 1,
            maxTextureDimension2D                     = 2048,
            maxTextureDimension3D                     = 1,
            maxTextureArrayLayers                     = 1,
            maxBindGroups                             = 1,
            maxBindingsPerBindGroup                   = 2,
            maxDynamicUniformBuffersPerPipelineLayout = 0,
            maxDynamicStorageBuffersPerPipelineLayout = 0,
            maxSampledTexturesPerShaderStage          = 1,
            maxSamplersPerShaderStage                 = 1,
            maxStorageBuffersPerShaderStage           = 0,
            maxStorageTexturesPerShaderStage          = 0,
            maxUniformBuffersPerShaderStage           = 0,
            maxUniformBufferBindingSize               = 0,
            maxStorageBufferBindingSize               = 0,
            minUniformBufferOffsetAlignment           = supported_limits.limits.minUniformBufferOffsetAlignment,
            minStorageBufferOffsetAlignment           = supported_limits.limits.minStorageBufferOffsetAlignment,
            maxVertexBuffers                          = 1,
            maxBufferSize                             = 4096,
            maxVertexAttributes                       = 4,
            maxVertexBufferArrayStride                = size_of(Vertex),
            maxInterStageShaderComponents             = 6,
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

    create_ui_pipeline :: (renderer: *Renderer) -> wgpu.RenderPipeline {
        // Shader
        wgsl_desc := wgpu.ShaderModuleWGSLDescriptor.{
            code = UI_SHADER,
        };

        shader_desc := wgpu.ShaderModuleDescriptor.{
            nextInChain = *wgsl_desc.chain
        };

        shader_module := wgpu.DeviceCreateShaderModule(renderer.device, *shader_desc);
        assert(shader_module != null, "Unable to create shader module");

        layout_builder: Pipeline_Layout_Builder;
        Pipeline_Layout_Builder.push_constants(*layout_builder, size_of(Vector2) * 2, stages = .Vertex);
        Pipeline_Layout_Builder.add_bind_groups(*layout_builder, renderer.single_texture_bind_group);
        pipeline_layout := Pipeline_Layout_Builder.build(*layout_builder, renderer.device);

        builder: Pipeline_Builder;
        Pipeline_Builder.add_vertex_shader(*builder, shader_module, "vs_main", Vertex);
        Pipeline_Builder.add_fragment_shader(*builder, shader_module, "fs_main");
        return Pipeline_Builder.build(*builder, renderer.device, pipeline_layout, "UI Pipeline");
    }
    
    // create_static_mesh_pipeline :: (using renderer: *Renderer) -> wgpu.RenderPipeline {

    // }

    end_frame :: () {
        using global_renderer;


        current_texture := wgpu.SwapChainGetCurrentTextureView(swapchain);
        defer wgpu.TextureViewRelease(current_texture);

        Draw_Data.upload(*context.immediate._2d_draw_data);

        encoder_desc := wgpu.CommandEncoderDescriptor.{ label = "Main Command Encoder" };
        command_encoder := wgpu.DeviceCreateCommandEncoder(device, *encoder_desc);
        defer wgpu.CommandEncoderRelease(command_encoder);

        render_pass_desc := wgpu.RenderPassDescriptor.{
            label = "UI Pass",
            colorAttachmentCount = 1,
            colorAttachments = *wgpu.RenderPassColorAttachment.{
                view = current_texture,
                resolveTarget = null,
                loadOp = .Clear,
                storeOp = .Store,
                clearValue = .{0.9, 0.1, 0.2, 1.0}
            },
            depthStencilAttachment = null,
        };
        render_pass := wgpu.CommandEncoderBeginRenderPass(command_encoder, *render_pass_desc);

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
            Draw_Data.reset(*context.immediate._2d_draw_data);
        }

        wgpu.RenderPassEncoderEnd(render_pass);
        command_buffer_desc := wgpu.CommandBufferDescriptor.{ label = "Main Command Buffer" };
        command_buffer := wgpu.CommandEncoderFinish(command_encoder, *command_buffer_desc);
        defer wgpu.CommandBufferRelease(command_buffer);
        wgpu.QueueSubmit(queue, 1, *command_buffer);
        wgpu.SwapChainPresent(swapchain);
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