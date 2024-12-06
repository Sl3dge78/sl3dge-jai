Pipeline_Builder :: struct {
    vertex_shader : *SDL_GPUShader;
    fragment_shader : *SDL_GPUShader;
    vertex_descriptions : [..]SDL_GPUVertexBufferDescription;
    vertex_attributes : [..]SDL_GPUVertexAttribute;
    depth_stencil_state : SDL_GPUDepthStencilState; 
    depth_stencil_format : SDL_GPUTextureFormat = .INVALID; // If invalid, no depth target
    rasterizer_state : SDL_GPURasterizerState = .{
        fill_mode = .FILL,
        cull_mode = .BACK,
        front_face = .COUNTER_CLOCKWISE,
        depth_bias_constant_factor = 0,
        depth_bias_clamp = 0,
        depth_bias_slope_factor = 0,
        enable_depth_bias = false,
        enable_depth_clip = false,
    };
    targets : [..]SDL_GPUColorTargetDescription;
}

Shader_Metadata :: struct {
    samplers : u32;
    storageTextures: u32;
    storageBuffers: u32;
    uniformBuffers: u32;
}

// Using metadata file, so we don't need to ship dependencies
// @TODO integrate this in the executable somehow?
add_shader :: (using b: *Pipeline_Builder, device: *SDL_GPUDevice, path: string)  {
    stage_str := path_extension(path_strip_extension(path));

    stage: SDL_GPUShaderStage = ---;
    if stage_str == "vert" then stage = .VERTEX;
    else if stage_str == "frag" then stage = .FRAGMENT;
    else assert(false, "Unexpected shader extension: %", stage_str);

    file := read_entire_file(path,, temp);
    metadata_path := tprint("%.json", path_strip_extension(path));
    success, metadata := json_parse_file(metadata_path, Shader_Metadata,, temp);
    assert(success);
    create_info := SDL_GPUShaderCreateInfo.{
        code_size = xx file.count,
        code = file.data,
        entrypoint = "main",
        format = SDL_GPU_SHADERFORMAT_SPIRV,
        stage = stage,
        num_samplers = metadata.samplers,
        num_storage_textures = metadata.storageTextures,
        num_storage_buffers = metadata.storageBuffers,
        num_uniform_buffers = metadata.uniformBuffers,
    };
    shader := SDL_NullCheck(SDL_CreateGPUShader(device, *create_info));
    if stage == .VERTEX {
        vertex_shader = shader;
    } else if stage == .FRAGMENT {
        fragment_shader = shader;
    } else {
        assert(false, "Unknown shader type");
    }
}

/* Using shadercross
add_shader :: (using b: *Pipeline_Builder, device: *SDL_GPUDevice, path: string, stage: SDL_GPUShaderStage) {
    file := read_entire_file(path,, temp);
    info : SDL_ShaderCross_GraphicsShaderInfo = ---;
    SDL_Check(SDL_ShaderCross_ReflectGraphicsSPIRV(file.data, xx file.count, *info));
    shader := SDL_NullCheck(SDL_ShaderCross_CompileGraphicsShaderFromSPIRV(device, file.data, xx file.count, "main", stage, *info));

    if stage == .VERTEX {
        vertex_shader = shader;
    } else if stage == .FRAGMENT {
        fragment_shader = shader;
    } else {
        assert(false, "Unknown shader type");
    }
}
*/

// Manual 
add_shader_manual :: (using b: *Pipeline_Builder, device: *SDL_GPUDevice, path: string, stage: SDL_GPUShaderStage, num_samplers : u32, num_storage_textures : u32, num_storage_buffers : u32, num_uniform_buffers : u32)  {
    file := read_entire_file(path,, temp);
    log("%", path);
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
    shader := SDL_NullCheck(SDL_CreateGPUShader(device, *create_info));
    if stage == .VERTEX {
        vertex_shader = shader;
    } else if stage == .FRAGMENT {
        fragment_shader = shader;
    } else {
        assert(false, "Unknown shader type");
    }
}

add_vertex_type :: (using b: *Pipeline_Builder, $vertex_type: Type) {
    vertex_attributes.allocator = temp;

    info := type_info(vertex_type);
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
        array_add(*vertex_attributes, SDL_GPUVertexAttribute.{
            location = xx it_index,
            buffer_slot = xx vertex_descriptions.count,
            format = format,
            offset = xx it.offset_in_bytes
        });
    }

    vertex_descriptions.allocator = temp;
    array_add(*vertex_descriptions, .{
        slot = 0,
        pitch = size_of(vertex_type),
        input_rate = .VERTEX
    });
}

add_color_target :: (using b: *Pipeline_Builder, format: SDL_GPUTextureFormat, blend := true) {
    targets.allocator = temp;
    target := SDL_GPUColorTargetDescription.{
        format = format,
    };
    if blend {
        target.blend_state = .{
            src_color_blendfactor = .SRC_ALPHA,
            dst_color_blendfactor = .ONE_MINUS_SRC_ALPHA,
            color_blend_op = .ADD,
            src_alpha_blendfactor = .SRC_ALPHA,
            dst_alpha_blendfactor = .ONE_MINUS_SRC_ALPHA,
            alpha_blend_op = .ADD,
            // color_write_mask = .R | .G | .B | .A,
            enable_blend = true,
            enable_color_write_mask = false,
        };
    }
    array_add(*targets, target); 
}

add_depth_stencil_target :: (using b: *Pipeline_Builder, format: SDL_GPUTextureFormat) {
    depth_stencil_format = format;

    depth_stencil_state.enable_depth_test = true;
    depth_stencil_state.enable_depth_write = true;
    depth_stencil_state.compare_op = .GREATER;

    // depth_stencil_state.enable_stencil_test = false;
    // depth_stencil_state.back_stencil_state = .{};
    // depth_stencil_state.front_stencil_state = .{};
    // depth_stencil_state.compare_mask = 0;
    // depth_stencil_state.write_mask = 0;
}

set_depth_bias :: (using b: *Pipeline_Builder, constant_factor: float, clamp: float, slope_factor: float) {
    b.rasterizer_state.enable_depth_bias = true;
    b.rasterizer_state.depth_bias_constant_factor = constant_factor;
    b.rasterizer_state.depth_bias_clamp = clamp;
    b.rasterizer_state.depth_bias_slope_factor = slope_factor;
}

build_pipeline :: (using b: *Pipeline_Builder, device: *SDL_GPUDevice) -> *SDL_GPUGraphicsPipeline {
    ci := SDL_GPUGraphicsPipelineCreateInfo.{
        vertex_shader = vertex_shader,
        fragment_shader = fragment_shader,
        vertex_input_state = .{
            vertex_buffer_descriptions = vertex_descriptions.data,
            num_vertex_buffers = xx vertex_descriptions.count,
            vertex_attributes = vertex_attributes.data,
            num_vertex_attributes = xx vertex_attributes.count,
        },
        primitive_type = .TRIANGLELIST,
        rasterizer_state = rasterizer_state,
        multisample_state = .{
            sample_count = ._1,
            sample_mask = 0xFFFFFFFF,
            enable_mask = false,
        },
        depth_stencil_state = depth_stencil_state, 
        target_info = .{
            color_target_descriptions = targets.data,
            num_color_targets = xx targets.count,
            depth_stencil_format = depth_stencil_format,
            has_depth_stencil_target = depth_stencil_format != .INVALID,
        },

        props = 0,
    };
    result := SDL_NullCheck(SDL_CreateGPUGraphicsPipeline(device, *ci));
    SDL_ReleaseGPUShader(device, vertex_shader);
    if fragment_shader != null { 
        SDL_ReleaseGPUShader(device, fragment_shader);
    }
    return result;
}
