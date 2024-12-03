
Renderer :: struct {
    device: *SDL_GPUDevice;
    ui_pipeline: *SDL_GPUGraphicsPipeline;

    sampler : *SDL_GPUSampler;
    empty_texture: *SDL_GPUTexture;

    immediate_buffer_pool: Buffer_Pool = .{
        kind = .VERTEX,
    };
}

global_renderer : Renderer;

renderer_create :: (window: *SDL_Window) -> *Renderer {
    using renderer := *global_renderer;

    shader_formats := SDL_GPU_SHADERFORMAT_SPIRV;
    assert(SDL_GPUSupportsShaderFormats(xx shader_formats, null), "Shader aren't supported on this device!");
    device = SDL_NullCheck(SDL_CreateGPUDevice(xx shader_formats, true, null));
    SDL_Check(SDL_ClaimWindowForGPUDevice(device, window));

    present_mode : SDL_GPUPresentMode = .VSYNC;
    if SDL_WindowSupportsGPUPresentMode(device, window, .MAILBOX) {
        present_mode = .MAILBOX;
    }
    SDL_Log("Present mode: %", present_mode);
    SDL_Check(SDL_SetGPUSwapchainParameters(device, window, .SDR, present_mode));

    {   // UI Pipeline
        targets := SDL_GPUColorTargetDescription.[.{
            format = SDL_GetGPUSwapchainTextureFormat(device, window),
            blend_state = .{
                src_color_blendfactor = .SRC_ALPHA,
                dst_color_blendfactor = .ONE_MINUS_SRC_ALPHA,
                color_blend_op = .ADD,
                src_alpha_blendfactor = .SRC_ALPHA,
                dst_alpha_blendfactor = .ONE_MINUS_SRC_ALPHA,
                alpha_blend_op = .ADD,
                // color_write_mask = .R | .G | .B | .A,
                enable_blend = true,
                enable_color_write_mask = false,
            },
        }];
        desc : []SDL_GPUVertexBufferDescription = .[.{
            slot = 0,
            pitch = size_of(UI_Vertex),
            input_rate = .VERTEX
        }];
        attr := get_vertex_type_attr(UI_Vertex, 0); 
        vtx := create_shader(device, "shaders/ui.vert.spv", .VERTEX, num_uniform_buffers = 1);
        defer SDL_ReleaseGPUShader(device, vtx);
        frag := create_shader(device, "shaders/ui.frag.spv", .FRAGMENT, num_samplers = 1);
        defer SDL_ReleaseGPUShader(device, frag);

        ci := SDL_GPUGraphicsPipelineCreateInfo.{
            vertex_shader = vtx,
            fragment_shader = frag,
            vertex_input_state = .{
                vertex_buffer_descriptions = desc.data,
                num_vertex_buffers = xx desc.count,
                vertex_attributes = attr.data,
                num_vertex_attributes = xx attr.count,
            },
            primitive_type = .TRIANGLELIST,
            rasterizer_state = .{
                fill_mode = .FILL,
                cull_mode = .NONE,
                front_face = .COUNTER_CLOCKWISE,
                depth_bias_constant_factor = 0,
                depth_bias_clamp = 0,
                depth_bias_slope_factor = 0,
                enable_depth_bias = false,
                enable_depth_clip = false,
            },
            multisample_state = .{
                sample_count = ._1,
                sample_mask = 0xFFFFFFFF,
                enable_mask = false,
            },
            depth_stencil_state = .{
                compare_op = .LESS,
                back_stencil_state = .{},
                front_stencil_state = .{},
                compare_mask = 0,
                write_mask = 0,
                enable_depth_test = false,
                enable_depth_write = false,
                enable_stencil_test = false,
            },
            target_info = .{
                color_target_descriptions = targets.data,
                num_color_targets = xx targets.count,
                depth_stencil_format = .D24_UNORM,
                has_depth_stencil_target = false,
            },

            props = 0,
        };
        ui_pipeline = SDL_NullCheck(SDL_CreateGPUGraphicsPipeline(device, *ci));
    }

    sampler_ci := SDL_GPUSamplerCreateInfo.{
        min_filter = .LINEAR,
        mag_filter = .LINEAR,
        mipmap_mode = .LINEAR,
        address_mode_u = .REPEAT,
        address_mode_v = .REPEAT,
        address_mode_w = .REPEAT,
        mip_lod_bias = 0,
        // max_anisotropy = 16,
        compare_op = .ALWAYS,
        min_lod = 0,
        max_lod = 0,
        enable_anisotropy = false,
        enable_compare = false,
    };
    sampler = SDL_NullCheck(SDL_CreateGPUSampler(device, *sampler_ci));

    data := u8.[255, 255, 255, 255];
    empty_texture = texture_from_data(data.data, 1, 1, 4, u8, "empty_texture");

    return renderer;
}

destroy :: (using self: *Renderer) {
    destroy(empty_texture);
    buffer_pool_reset(*immediate_buffer_pool);
    SDL_ReleaseGPUSampler(device, sampler);
    SDL_ReleaseGPUGraphicsPipeline(device, ui_pipeline);
    SDL_DestroyGPUDevice(device);
}

Texture :: *SDL_GPUTexture;  

texture_from_data :: (buffer: *u8, w: u32, h: u32, channels: u32, $type: Type, name: string) -> Texture {
    size := w * h * channels * size_of(type);
    tbuf_ci := SDL_GPUTransferBufferCreateInfo.{
        usage = .UPLOAD,
        size = size,
        props = 0,
    };
    tbuf := SDL_CreateGPUTransferBuffer(global_renderer.device, *tbuf_ci);
    defer SDL_ReleaseGPUTransferBuffer(global_renderer.device, tbuf);

    format : SDL_GPUTextureFormat;
    if channels == {
        case 1; format = .R8_UNORM;
        case 4; format = .R8G8B8A8_UNORM_SRGB;
        case; assert(false, "Unhandled channel count of %.", channels);
    }

    texture_ci := SDL_GPUTextureCreateInfo.{
        type = ._2D,
        format = format,
        usage = SDL_GPU_TEXTUREUSAGE_SAMPLER,
        width = w,
        height = h,
        layer_count_or_depth = 1,
        num_levels = 1,
        sample_count = ._1,

        props = 0,
    };
    texture := SDL_CreateGPUTexture(global_renderer.device, *texture_ci);

    data := SDL_MapGPUTransferBuffer(global_renderer.device, tbuf, false);
    SDL_memcpy(data, buffer, size);
    SDL_UnmapGPUTransferBuffer(global_renderer.device, tbuf);

    cmd := SDL_AcquireGPUCommandBuffer(global_renderer.device);
    defer SDL_SubmitGPUCommandBuffer(cmd);

    copy_pass := SDL_BeginGPUCopyPass(cmd);
    defer SDL_EndGPUCopyPass(copy_pass);
    src := SDL_GPUTextureTransferInfo.{ tbuf, 0, w, h };

    dst := SDL_GPUTextureRegion.{
        texture,
        0, 0,
        0, 0, 0,
        w, h, 1,
    };
    SDL_UploadToGPUTexture(copy_pass, *src, *dst, false);
    SDL_SetGPUTextureName(global_renderer.device, texture, name.data);
    return texture;
}

destroy :: (self: Texture) {
    assert(self != null);
    SDL_ReleaseGPUTexture(global_renderer.device, self);
}

get_vertex_type_attr :: ($type: Type, slot: u32) -> []SDL_GPUVertexAttribute {
    result : [..]SDL_GPUVertexAttribute;
    result.allocator = temp;
    info := type_info(type);
    
    for info.members {
        format: SDL_GPUVertexElementFormat;

        if it.type.type == {
            case .FLOAT; {
                assert(it.type.runtime_size <= 4, "Only float32 is supported in Vertex Attribute Data.");
                format = .FLOAT;
            }
            case .STRUCT; {
                struct_type_info := cast(*Type_Info_Struct) it.type;

                if struct_type_info.name == {
                    case "Vector4"; format = .FLOAT4;
                    case "Vector3"; format = .FLOAT3;
                    case "Vector2"; format = .FLOAT2;
                    case; assert(false, "Unsupported struct type. Only Vector2, Vector3, Vector4 are supported");
                }
            }
            case .ARRAY; {
                array_type_info := cast(*Type_Info_Array) it.type;
                if array_type_info.element_type.type == .INTEGER && array_type_info.element_type.runtime_size == 1 && array_type_info.array_count == 4 {
                    format = .BYTE4;
                } else {
                    assert(false, "Unhandled array type: % in vertex input.", array_type_info.element_type);
                }
            }
            case; {
                assert(false, "Unhandled type % in vertex input", it.type.type);
            }
        }
        array_add(*result, .{
            location = xx result.count,
            buffer_slot = slot,
            format = format,
            offset = xx it.offset_in_bytes
        });
    }
    return result;
}

create_shader :: (device: *SDL_GPUDevice, path: string, stage: SDL_GPUShaderStage, num_samplers : u32 = 0, num_storage_textures : u32 = 0, num_storage_buffers : u32 = 0, num_uniform_buffers : u32 = 0) -> *SDL_GPUShader {
    file := read_entire_file(path,, temp);
    create_info := SDL_GPUShaderCreateInfo.{
        code_size = xx file.count,
        code = file.data,
        entrypoint = "main",
        format = SDL_GPU_SHADERFORMAT_SPIRV,
        stage = stage,
        num_samplers = num_samplers,
        num_storage_textures = num_storage_textures,
        num_storage_buffers = num_storage_buffers,
        num_uniform_buffers = num_uniform_buffers,
    };
    return SDL_NullCheck(SDL_CreateGPUShader(device, *create_info));
}

Frame_Data :: struct {
    cmd: *SDL_GPUCommandBuffer;
    target: *SDL_GPUTexture;
    width: u32;
    height: u32;
}

begin_frame :: () -> bool, Frame_Data {
    fd : Frame_Data;
    fd.cmd = SDL_NullCheck(SDL_AcquireGPUCommandBuffer(global_renderer.device));
    SDL_Check(SDL_AcquireGPUSwapchainTexture(fd.cmd, global_engine.window, *fd.target, *fd.width, *fd.height));
    if fd.target == null {
        SDL_Check(SDL_CancelGPUCommandBuffer(fd.cmd));
        return false, .{};
    }
    return true, fd;
}

end_frame :: (frame_data: Frame_Data) {
    SDL_Check(SDL_SubmitGPUCommandBuffer(frame_data.cmd));
}

Buffer :: struct {
    #as handle: *SDL_GPUBuffer;
    size: u32;
}

buffer_create :: (size: u32, flags: SDL_GPUBufferUsageFlags) -> Buffer {
    ci := SDL_GPUBufferCreateInfo.{
        usage = flags,
        size = xx size,
        props = 0,
    };
    return .{
        SDL_NullCheck(SDL_CreateGPUBuffer(global_renderer.device, *ci)),
        size,
    };
}

destroy :: (buf: Buffer) {
    SDL_ReleaseGPUBuffer(global_renderer.device, buf.handle);
}