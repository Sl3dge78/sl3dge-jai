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

Compute_Metadata :: struct { 
    samplers: u32;
    readOnlyStorageTextures: u32;
    readOnlyStorageBuffers: u32;
    readWriteStorageTextures: u32;
    readWriteStorageBuffers: u32;
    uniformBuffers: u32;
    threadCountX: u32 = 1;
    threadCountY: u32 = 1;
    threadCountZ: u32 = 1;
}

Pipeline_Info :: struct {
    vertex_shader: string;
    vertex_info: Shader_Metadata;
    fragment_shader: string;
    fragment_info: Shader_Metadata;
    vertex_type: string;
    color_target : struct {
        format: string;
        blend: bool;
    };
    depth_target: bool;
}

Compute_Info :: struct {
    shader: string;
    metadata: Compute_Metadata;
}

// Using metadata file, so we don't need to ship dependencies
// @TODO integrate this in the executable somehow?
add_shader :: (using b: *Pipeline_Builder, device: *SDL_GPUDevice, path: string)  {
    metadata_path := tprint("%.json", path_strip_extension(path));
    success, metadata := json_parse_file(metadata_path, Shader_Metadata,, temp);
    assert(success);
    add_shader(b, device, path, metadata);
}

add_shader :: (using b: *Pipeline_Builder, device: *SDL_GPUDevice, path: string, info: Shader_Metadata) {
    stage: SDL_GPUShaderStage = ---;

    stage_str := path_extension(path);
    if stage_str == "vert" then stage = .VERTEX;
    else if stage_str == "frag" then stage = .FRAGMENT;
    else assert(false, "Unexpected shader extension: %", stage_str);
    file := read_entire_file(tprint("res/%.spv", path),, temp);
    create_info := SDL_GPUShaderCreateInfo.{
        code_size = xx file.count,
        code = file.data,
        entrypoint = "main",
        format = SDL_GPU_SHADERFORMAT_SPIRV,
        stage = stage,
        num_samplers = info.samplers,
        num_storage_textures = info.storageTextures,
        num_storage_buffers = info.storageBuffers,
        num_uniform_buffers = info.uniformBuffers,
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
    depth_stencil_state.compare_op = .LESS;

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
            sample_mask = 0x0,
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

from_info :: (builder: *Pipeline_Builder, info: Pipeline_Info) {
    add_shader(builder, global_renderer.device, info.vertex_shader, info.vertex_info);
    add_shader(builder, global_renderer.device, info.fragment_shader, info.fragment_info);
    if info.vertex_type == {
        case "Standard_Vertex"; add_vertex_type(builder, Standard_Vertex);
        case "UI_Vertex"; add_vertex_type(builder, UI_Vertex);
        case; assert(false);
    }
    format: SDL_GPUTextureFormat;
    if info.color_target.format == {
        case "swapchain"; format = global_renderer.swapchain_format;
        case; {
            format=, result := enum_name_to_value(SDL_GPUTextureFormat, info.color_target.format);
            assert(result);
        }
    };
    add_color_target(builder, format, info.color_target.blend);
    if info.depth_target {
        add_depth_stencil_target(builder, global_renderer.depth_stencil_format);
    }
}

build_compute_pipeline :: (path : string) -> *SDL_GPUComputePipeline {
    compute_shader, success := read_entire_file(path,, temp);
    assert(success, tprint("Unable to read %", path));
    metadata_path := tprint("%.json", path_strip_extension(path));
    success=, metadata := json_parse_file(metadata_path, Compute_Metadata,, temp);
    assert(success);
    ci := SDL_GPUComputePipelineCreateInfo.{
        code_size = xx compute_shader.count,
        code = compute_shader.data,
        entrypoint = "main",
        format =  SDL_GPU_SHADERFORMAT_SPIRV,
        num_samplers = metadata.samplers,
        num_readonly_storage_textures  = metadata.readOnlyStorageTextures,
        num_readonly_storage_buffers   = metadata.readOnlyStorageBuffers,
        num_readwrite_storage_textures = metadata.readWriteStorageTextures,
        num_readwrite_storage_buffers  = metadata.readWriteStorageBuffers,
        num_uniform_buffers            = metadata.uniformBuffers,
        threadcount_x = metadata.threadCountX,
        threadcount_y = metadata.threadCountY,
        threadcount_z = metadata.threadCountZ,
    };
    return SDL_NullCheck(SDL_CreateGPUComputePipeline(global_renderer.device, *ci));
}

build_compute_pipeline :: (info: Compute_Info) -> *SDL_GPUComputePipeline {
    compute_shader, success := read_entire_file(tprint("res/%.spv", info.shader),, temp);
    assert(success, tprint("Unable to read %", info.shader));
    metadata := info.metadata;
    ci := SDL_GPUComputePipelineCreateInfo.{
        code_size = xx compute_shader.count,
        code = compute_shader.data,
        entrypoint = "main",
        format =  SDL_GPU_SHADERFORMAT_SPIRV,
        num_samplers = metadata.samplers,
        num_readonly_storage_textures  = metadata.readOnlyStorageTextures,
        num_readonly_storage_buffers   = metadata.readOnlyStorageBuffers,
        num_readwrite_storage_textures = metadata.readWriteStorageTextures,
        num_readwrite_storage_buffers  = metadata.readWriteStorageBuffers,
        num_uniform_buffers            = metadata.uniformBuffers,
        threadcount_x = metadata.threadCountX,
        threadcount_y = metadata.threadCountY,
        threadcount_z = metadata.threadCountZ,
    };
    return SDL_NullCheck(SDL_CreateGPUComputePipeline(global_renderer.device, *ci));
}

#import "Process";

compile_shader :: (path: string) {
    output_file := tprint("res/%.spv", path);
    metadata_file := tprint("res/%.json", path);
    
    if false {
        run_command("glslang", "-gVS", "-V", path, "-o", output_file, working_directory = "bin", capture_and_return_output = true, arg_quoting = .QUOTE_IF_NEEDED);
    } else {
        result, stdout, stderr := run_command("glslang", "-V", path, "-o", output_file, working_directory = "bin", capture_and_return_output = true);
        if result.exit_code != 0 {
            print_color("========\n", color = .RED);
            print_color("%\n%", stdout, stderr, color = .RED);
            print_color("========\n", color = .RED);
            return;
        }
    }
    result, stout, stderr := run_command("shadercross", output_file, "-o", metadata_file, working_directory = "bin", capture_and_return_output = true,, logger = (msg: string, data: *void, info: Log_Info) {});
    if result.exit_code != 0 {
        // Shadercross not installed, maybe log it
    }
    print_color("%\n", path, color = .GREEN);
}

export_material :: (name: string, info: Pipeline_Info) {
    compile_shader(info.vertex_shader);
    compile_shader(info.fragment_shader);
    builder: String_Builder;
    json_write_native(*builder, *info, type_info(type_of(info)));

    write_entire_file(tprint("bin/res/%.mat", name), *builder);
}

export_pipeline :: (name: string, info: Pipeline_Info) {
    compile_shader(info.vertex_shader);
    compile_shader(info.fragment_shader);
    builder: String_Builder;
    json_write_native(*builder, *info, type_info(type_of(info)));
    s := builder_to_string(*builder);

    write_entire_file(tprint("bin/res/%.pipeline", name), s);
}

export_compute_pipeline :: (name: string, info: Compute_Info) {
    compile_shader(info.shader);
    builder: String_Builder;
    json_write_native(*builder, *info, type_info(type_of(info)));
    s := builder_to_string(*builder);
    write_entire_file(tprint("bin/res/%.compute", name), s);
}
