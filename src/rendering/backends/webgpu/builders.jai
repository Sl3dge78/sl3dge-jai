Pipeline_Builder :: struct {
    vertex := wgpu.VertexState.{
        module =       null,  // add_vertex_shader
        entryPoint =   "",    // add_vertex_shader
        constantCount = 0,
        constants     = null,
        bufferCount   = 0,    // add_vertex_shader
        buffers       = null, // add_vertex_shader
    };
    // vertex_buffer_layouts: []wgpu.VertexBufferLayout; // add_vertex_shader

    primitive := wgpu.PrimitiveState.{
        topology =         .TriangleList,
        stripIndexFormat = .Undefined,
        frontFace =        .CCW,
        cullMode =         .None,
    };

    depth_stencil : wgpu.DepthStencilState;
    has_depth : bool;

    multisample := wgpu.MultisampleState.{
        count = 1,
        mask = ~(cast(u32)0),
        alphaToCoverageEnabled = false,
    };

    fragment := wgpu.FragmentState.{
        module =         null, // add_fragment_shader
        entryPoint =     "",   // add_fragment_shader
        constantCount =  0,
        constants =      null,
        targetCount =    0,    // build 
        targets =        null, // build
    };

    color_targets : [..]wgpu.ColorTargetState;
}

add_vertex_shader :: (builder: *Pipeline_Builder, module: wgpu.ShaderModule, entry_point: string, $vertex_types: ..Type) {
    builder.vertex.module = module;
    builder.vertex.entryPoint = temp_c_string(entry_point);
    arr := NewArray(vertex_types.count, wgpu.VertexBufferLayout,, allocator = temp);
    offset := 0;
    for vertex_types { 
        arr[it_index] = get_vertex_layout(it, offset);
        offset += xx arr[it_index].attributeCount;
    }
    builder.vertex.bufferCount = xx arr.count;
    builder.vertex.buffers = arr.data;
}

get_vertex_layout :: (type: Type, shader_location_offset := 0) -> wgpu.VertexBufferLayout {
    info := cast(*Type_Info_Struct)type;
    attributes := NewArray(info.members.count, wgpu.VertexAttribute,, allocator = temp);

    for info.members {
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
                if elem_type_info.runtime_size == {
                    case 1; format = .Uint8x4;
                    case; assert(false, "runtime size unhandled!");
                }
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

add_fragment_shader :: (using builder: *Pipeline_Builder, module: wgpu.ShaderModule, entry_point: string) {
    fragment.module = module;
    fragment.entryPoint = temp_c_string(entry_point);
}

primitive_state :: (using builder: *Pipeline_Builder, topology : wgpu.PrimitiveTopology, front_face: wgpu.FrontFace = .CCW, cull_mode: wgpu.CullMode = .None) {
        primitive = wgpu.PrimitiveState.{
        topology =         topology,
        stripIndexFormat = .Undefined,
        frontFace =        front_face,
        cullMode =         cull_mode,
    };
}

depth_stencil_state :: (using builder: *Pipeline_Builder, format: wgpu.TextureFormat) {
    builder.depth_stencil = wgpu.DepthStencilState.{
        format = format, 
        depthWriteEnabled = true, 
        depthCompare = .Less,
        stencilFront = .{},
        stencilBack = .{},
        stencilReadMask = 0xFFFFFFFF,
        stencilWriteMask = 0xFFFFFFFF,
        depthBias = 0,
        depthBiasSlopeScale = 0,
        depthBiasClamp = 0,
    };
    builder.has_depth = true;
}

add_color_target :: (using builder: *Pipeline_Builder, format: wgpu.TextureFormat) {
    color_targets.allocator = temp;
    tgt := wgpu.ColorTargetState.{
        format = format, 
        blend = null, // Will be set in build
        writeMask = xx wgpu.ColorWriteMask.All,
    };
    array_add(*color_targets, tgt);
}

pipeline_builder_build :: (using builder: *Pipeline_Builder, device: wgpu.Device, layout: wgpu.PipelineLayout, label := "") -> wgpu.RenderPipeline {
    assert(vertex.module != null, "No vertex shader specified when building pipeline");
    
    desc := wgpu.RenderPipelineDescriptor.{
        label = temp_c_string(label),
        layout = layout,
        vertex = vertex,
        primitive = primitive,
        depthStencil = null,       // Set below
        multisample = multisample,
        fragment = null,           // Set below
    };

    // Fragment
    blend := wgpu.BlendState.{
        color = .{
            operation = .Add, 
            srcFactor = .SrcAlpha,
            dstFactor = .OneMinusSrcAlpha,
        },
        alpha = .{
            operation = .Add,
            srcFactor = .SrcAlpha,
            dstFactor = .OneMinusSrcAlpha,
        },
    };
    for *color_targets {
        it.blend = *blend;
    }
    fragment.targetCount = xx color_targets.count;
    fragment.targets = color_targets.data;
    desc.fragment = ifx fragment.module == null then null else *fragment;

    // Depth
    if has_depth {
        desc.depthStencil = *depth_stencil;
    }

    pipeline := WGPU_Check(wgpu.DeviceCreateRenderPipeline(device, *desc));
    return pipeline;
}


Pipeline_Layout_Builder :: struct {
    push_constant_range : wgpu.PushConstantRange;
    bind_groups : [..] wgpu.BindGroupLayout;
}

set_push_constants :: (using builder: *Pipeline_Layout_Builder, size: u32, stages: wgpu.ShaderStageFlags = .Vertex, start : u32 = 0) {
    push_constant_range.stages = stages;
    push_constant_range.start = start;
    push_constant_range.end = size;
}

add_bind_groups :: (using builder: *Pipeline_Layout_Builder, bind_group_layouts: ..wgpu.BindGroupLayout) {
    bind_groups.allocator = temp;
    array_add(*bind_groups, ..bind_group_layouts);
}

pipeline_layout_builder_build :: (using builder: *Pipeline_Layout_Builder, device: wgpu.Device) -> wgpu.PipelineLayout {
    layout_desc := wgpu.PipelineLayoutDescriptor.{
        bindGroupLayoutCount = xx bind_groups.count,
        bindGroupLayouts     = bind_groups.data,
    };

    extras := wgpu.PipelineLayoutExtras.{
        chain = .{ sType = xx wgpu.NativeSType.SType_PipelineLayoutExtras },
        pushConstantRangeCount = 1,
        pushConstantRanges = *builder.push_constant_range
    };

    if push_constant_range.end != 0 { 
        layout_desc.nextInChain = *extras.chain;
    }

    pipeline_layout := WGPU_Check(wgpu.DeviceCreatePipelineLayout(device, *layout_desc));
    return pipeline_layout;
}


Bindings_Builder :: struct {
    entries: [..] wgpu.BindGroupLayoutEntry;
}

add_entry :: (using builder: *Bindings_Builder, entry: $T, binding: u32, visibility: wgpu.ShaderStageFlags) {
    
    group_entry := wgpu.BindGroupLayoutEntry.{
        binding = binding,
        visibility = visibility
    };
    #if T == wgpu.BufferBindingLayout {
        group_entry.buffer = entry;
    } else #if T == wgpu.SamplerBindingLayout {
        group_entry.sampler = entry;
    } else #if wgpu.TextureBindingLayout {
        group_entry.texture = entry;
    } else #if wgpu.StorageTextureBindingLayout {
        group_entry.storageTexture = entry;
    } else { #assert(false); }

    array_add(*entries, group_entry);
}

bindings_builder_build :: (using builder: *Bindings_Builder) -> wgpu.BindGroupLayout {
    
    desc := wgpu.BindGroupLayoutDescriptor.{
        entryCount = xx entries.count,
        entries = entries.data,
    };
    group_layout := WGPU_Check(wgpu.DeviceCreateBindGroupLayout(global_renderer.device, *desc));
    
    array_reset(*entries);
    return group_layout;
}

shader_module_create :: (code: string, device: wgpu.Device) -> wgpu.ShaderModule {
    wgsl_desc := wgpu.ShaderModuleWGSLDescriptor.{
        chain = .{ sType = .ShaderModuleWGSLDescriptor },
        code = code.data,
    };

    shader_desc := wgpu.ShaderModuleDescriptor.{
        nextInChain = *wgsl_desc.chain
    };

    return WGPU_Check(wgpu.DeviceCreateShaderModule(device, *shader_desc));
}