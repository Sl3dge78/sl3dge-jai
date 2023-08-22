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

    add_vertex_shader :: (builder: *Pipeline_Builder, module: wgpu.ShaderModule, entry_point: string, $vertex_types: ..Type) {
        builder.vertex.module = module;
        builder.vertex.entryPoint = temp_c_string(entry_point);
        arr := NewArray(vertex_types.count, wgpu.VertexBufferLayout, allocator = temp);
        for vertex_types { 
            arr[it_index] = Renderer.get_vertex_layout(it);
        }
        builder.vertex.bufferCount = xx arr.count;
        builder.vertex.buffers = arr.data;
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

    build :: (using builder: *Pipeline_Builder, device: wgpu.Device, layout: wgpu.PipelineLayout, label := "") -> wgpu.RenderPipeline {
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
        if fragment.module != null {
            color_target := wgpu.ColorTargetState.{
                format = global_renderer.swapchain_format, // @Hardcoded
                blend = *wgpu.BlendState.{
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
                },
                writeMask = xx wgpu.ColorWriteMask.All,
            };
            fragment.targetCount = 1;
            fragment.targets = *color_target;
        }
        desc.fragment = ifx fragment.module == null then null else *fragment;

        // Depth
        if has_depth {
            desc.depthStencil = *depth_stencil;
        }

        pipeline := WGPU_Check(wgpu.DeviceCreateRenderPipeline(device, *desc));
        return pipeline;
    }
}

Pipeline_Layout_Builder :: struct {
    push_constant_range := wgpu.PushConstantRange.{
        stages = .Vertex,
        start = 0,
        end = size_of(Vector2) * 2,
    };
    bind_groups : [..] wgpu.BindGroupLayout;

    push_constants :: (using builder: *Pipeline_Layout_Builder, size: u32, stages: wgpu.ShaderStageFlags = .Vertex, start : u32 = 0) {
        push_constant_range.stages = stages;
        push_constant_range.start = start;
        push_constant_range.end = size;
    }

    add_bind_groups :: (using builder: *Pipeline_Layout_Builder, bind_group_layouts: ..wgpu.BindGroupLayout) {
        bind_groups.allocator = temp;
        array_add(*bind_groups, ..bind_group_layouts);
    }

    build :: (using builder: *Pipeline_Layout_Builder, device: wgpu.Device) -> wgpu.PipelineLayout {
        extras := wgpu.PipelineLayoutExtras.{
            pushConstantRangeCount = 1,
            pushConstantRanges = *push_constant_range
        };

        layout_desc := wgpu.PipelineLayoutDescriptor.{
            nextInChain = *extras.chain,
            bindGroupLayoutCount = xx bind_groups.count,
            bindGroupLayouts     = bind_groups.data,
        };

        pipeline_layout := WGPU_Check(wgpu.DeviceCreatePipelineLayout(device, *layout_desc));
        return pipeline_layout;
    }
}

Bindings_Builder :: struct {

    entries: [..] wgpu.BindGroupLayoutEntry;

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

    build :: (using builder: *Bindings_Builder) -> wgpu.BindGroupLayout {
        
        desc := wgpu.BindGroupLayoutDescriptor.{
            entryCount = xx entries.count,
            entries = entries.data,
        };
        group_layout := WGPU_Check(wgpu.DeviceCreateBindGroupLayout(global_renderer.device, *desc));
        
        array_reset(*entries);
        return group_layout;
    }
}

create_shader_module :: (code: string, device: wgpu.Device) -> wgpu.ShaderModule {
    wgsl_desc := wgpu.ShaderModuleWGSLDescriptor.{
        code = code.data,
    };

    shader_desc := wgpu.ShaderModuleDescriptor.{
        nextInChain = *wgsl_desc.chain
    };

    return WGPU_Check(wgpu.DeviceCreateShaderModule(device, *shader_desc));
}