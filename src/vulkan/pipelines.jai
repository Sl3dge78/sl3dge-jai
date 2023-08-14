Pipeline :: struct {
    pipeline_layout: VkPipelineLayout;
    pipeline: VkPipeline;
}

// --------
// 2d/ui pipeline

create_ui_pipeline :: (device: VkDevice, render_pass: VkRenderPass) -> Pipeline {
    pipeline : Pipeline;

    // Pipeline
    vtx := create_shader_module(device, "shaders/ui.vert.spv");
    defer vkDestroyShaderModule(device, vtx, null);

    frag := create_shader_module(device, "shaders/ui.frag.spv");
    defer vkDestroyShaderModule(device, frag, null);

    

    layouts := VkDescriptorSetLayout.[
        global_renderer.single_texture_layout,
    ];

    push_constant_ci := VkPushConstantRange.{
        stageFlags = .VERTEX_BIT,
        offset = 0,
        size = 4 * size_of(float),
    };

    layout_ci := VkPipelineLayoutCreateInfo.{ 
        pushConstantRangeCount = 1,
        pPushConstantRanges = *push_constant_ci,
        setLayoutCount = xx layouts.count,
        pSetLayouts = layouts.data,
    };
    Vk_Check(vkCreatePipelineLayout(device, *layout_ci, null, *pipeline.pipeline_layout));

    builder: Pipeline_Builder;
    Pipeline_Builder.add_vertex_input(*builder, Vertex);
    Pipeline_Builder.add_shader(*builder, .VERTEX_BIT, vtx, "main");
    Pipeline_Builder.add_shader(*builder, .FRAGMENT_BIT, frag, "main");
    Pipeline_Builder.add_dynamic_state(*builder, VkDynamicState.VIEWPORT, VkDynamicState.SCISSOR);
    builder.color_blend = true;
    pipeline.pipeline = Pipeline_Builder.build(*builder, device, pipeline.pipeline_layout, render_pass);
    log("UI Pipeline created.");

    return pipeline;
}

bind_ui_pipeline :: (command_buffer: VkCommandBuffer) {
    pipeline := global_renderer.ui_pipeline;

    // Bind pipeline, dynamic state, global descriptors and a default push constant
    vkCmdBindPipeline(command_buffer, .GRAPHICS, pipeline.pipeline);
    vkCmdSetViewport(command_buffer, 0, 1, *VkViewport.{0, 0, xx global_renderer.swapchain_extent.width,  (cast(float)global_renderer.swapchain_extent.height), 0, 1});
    vkCmdSetScissor(command_buffer, 0, 1, *VkRect2D.{.{0, 0}, global_renderer.swapchain_extent});
    vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.pipeline_layout, 0, 1, *global_engine.default_font.descriptor, 0, null); 
    
}

Material :: struct {
    shadowmap: Pipeline;
    color: Pipeline;
    #place shadowmap; pipelines: [2]Pipeline;

    destroy :: (device: VkDevice, material: *Material) {
        for material.pipelines {
            vkDestroyPipelineLayout(device, it.pipeline_layout, null);
            vkDestroyPipeline(device, it.pipeline, null);
        }
    }
}

create_static_mesh_material :: (device : VkDevice, shadowmap_rp: VkRenderPass, color_rp: VkRenderPass) -> Material {
    result: Material;

    vtx := create_shader_module(device, "shaders/static.vert.spv");
    defer vkDestroyShaderModule(device, vtx, null);

    frag := create_shader_module(device, "shaders/color.frag.spv");
    defer vkDestroyShaderModule(device, frag, null);

    {   // Shadowmap   

        // Layout
        push_constant_ci := VkPushConstantRange.{
            stageFlags = .VERTEX_BIT,
            offset = 0,
            size = size_of(PushConstantData),
        };

        layouts := VkDescriptorSetLayout.[
            global_renderer.camera_set_layout,
        ];

        layout_ci := VkPipelineLayoutCreateInfo.{ 
            pushConstantRangeCount = 1,
            pPushConstantRanges = *push_constant_ci,
            setLayoutCount = xx layouts.count,
            pSetLayouts = layouts.data,
        };
        Vk_Check(vkCreatePipelineLayout(device, *layout_ci, null, *result.pipelines[Pipeline_Kind.SHADOWMAP].pipeline_layout));

        // Pipeline
        builder: Pipeline_Builder;
        Pipeline_Builder.add_vertex_input(*builder, Vertex);
        Pipeline_Builder.add_shader(*builder, .VERTEX_BIT, vtx, "main");
        Pipeline_Builder.rasterization_state_depth_bias(*builder, 1.25, 0, 1.75);
        Pipeline_Builder.viewport_state(*builder, Renderer.SHADOWMAP_SIZE, Renderer.SHADOWMAP_SIZE);
        result.pipelines[Pipeline_Kind.SHADOWMAP].pipeline = Pipeline_Builder.build(*builder, device, result.pipelines[Pipeline_Kind.SHADOWMAP].pipeline_layout, shadowmap_rp);
        log("Shadowmap pipeline created.");
    }

    {   // Color   

        // Layout
        push_constant_ci := VkPushConstantRange.{
            stageFlags = .VERTEX_BIT,
            offset = 0,
            size = size_of(PushConstantData),
        };

        layouts := VkDescriptorSetLayout.[
            global_renderer.camera_set_layout,
            global_renderer.shadowmap_layout,
            global_renderer.single_texture_layout,
        ];

        layout_ci := VkPipelineLayoutCreateInfo.{ 
            pushConstantRangeCount = 1,
            pPushConstantRanges = *push_constant_ci,
            setLayoutCount = xx layouts.count,
            pSetLayouts = layouts.data,
        };
        Vk_Check(vkCreatePipelineLayout(device, *layout_ci, null, *result.pipelines[Pipeline_Kind.COLOR].pipeline_layout));

        // Pipeline
        builder: Pipeline_Builder;
        Pipeline_Builder.add_vertex_input(*builder, Vertex);
        Pipeline_Builder.add_shader(*builder, .VERTEX_BIT, vtx, "main");
        Pipeline_Builder.add_shader(*builder, .FRAGMENT_BIT, frag, "main");
        Pipeline_Builder.add_dynamic_state(*builder, VkDynamicState.VIEWPORT, VkDynamicState.SCISSOR);
        result.pipelines[Pipeline_Kind.COLOR].pipeline = Pipeline_Builder.build(*builder, device, result.pipelines[Pipeline_Kind.COLOR].pipeline_layout, color_rp);
        log("Color pipeline created.");
    }
    return result;
}

create_skinned_mesh_material :: (device : VkDevice, shadowmap_rp: VkRenderPass, color_rp: VkRenderPass) -> Material {
    result: Material;

    vtx := create_shader_module(device, "shaders/skinned.vert.spv");
    defer vkDestroyShaderModule(device, vtx, null);

    frag := create_shader_module(device, "shaders/color.frag.spv");
    defer vkDestroyShaderModule(device, frag, null);

    {   // Shadowmap   

        // Layout
        push_constant_ci := VkPushConstantRange.{
            stageFlags = .VERTEX_BIT,
            offset = 0,
            size = size_of(PushConstantData),
        };

        layouts := VkDescriptorSetLayout.[
            global_renderer.camera_set_layout,
            global_renderer.empty_set_layout,
            global_renderer.empty_set_layout,
            global_renderer.skinned_mesh_layout,
        ];

        layout_ci := VkPipelineLayoutCreateInfo.{ 
            pushConstantRangeCount = 1,
            pPushConstantRanges = *push_constant_ci,
            setLayoutCount = xx layouts.count,
            pSetLayouts = layouts.data,
        };
        layout := *result.pipelines[Pipeline_Kind.SHADOWMAP].pipeline_layout;
        Vk_Check(vkCreatePipelineLayout(device, *layout_ci, null, layout));

        builder: Pipeline_Builder;
        Pipeline_Builder.add_vertex_input(*builder, Vertex);
        Pipeline_Builder.add_vertex_input(*builder, Skinned_Vertex);
        Pipeline_Builder.add_shader(*builder, .VERTEX_BIT, vtx, "main");
        Pipeline_Builder.rasterization_state_depth_bias(*builder, 1.25, 0, 1.75);
        Pipeline_Builder.viewport_state(*builder, Renderer.SHADOWMAP_SIZE, Renderer.SHADOWMAP_SIZE);
        result.pipelines[Pipeline_Kind.SHADOWMAP].pipeline = Pipeline_Builder.build(*builder, device, result.pipelines[Pipeline_Kind.SHADOWMAP].pipeline_layout, shadowmap_rp);
        
        log("Shadowmap pipeline created.");
    }

    {   // Color   

        // Layout
        push_constant_ci := VkPushConstantRange.{
            stageFlags = .VERTEX_BIT,
            offset = 0,
            size = size_of(PushConstantData),
        };

        layouts := VkDescriptorSetLayout.[
            global_renderer.camera_set_layout,
            global_renderer.shadowmap_layout,
            global_renderer.single_texture_layout,
            global_renderer.skinned_mesh_layout,
        ];

        layout_ci := VkPipelineLayoutCreateInfo.{ 
            pushConstantRangeCount = 1,
            pPushConstantRanges = *push_constant_ci,
            setLayoutCount = xx layouts.count,
            pSetLayouts = layouts.data,
        };
        Vk_Check(vkCreatePipelineLayout(device, *layout_ci, null, *result.pipelines[Pipeline_Kind.COLOR].pipeline_layout));
        
        builder: Pipeline_Builder;
        Pipeline_Builder.add_vertex_input(*builder, Vertex);
        Pipeline_Builder.add_vertex_input(*builder, Skinned_Vertex);
        Pipeline_Builder.add_shader(*builder, .VERTEX_BIT, vtx, "main");
        Pipeline_Builder.add_shader(*builder, .FRAGMENT_BIT, frag, "main");
        Pipeline_Builder.add_dynamic_state(*builder, VkDynamicState.VIEWPORT, VkDynamicState.SCISSOR);
        result.pipelines[Pipeline_Kind.COLOR].pipeline = Pipeline_Builder.build(*builder, device, result.pipelines[Pipeline_Kind.COLOR].pipeline_layout, color_rp);
        
        log("Color pipeline created.");
    }
    return result;
}

Pipeline_Kind :: enum {
    SHADOWMAP :: 0;
    COLOR :: 1;
}

bind_material :: (command_buffer: VkCommandBuffer, material: Material, $kind: Pipeline_Kind) {
    #if kind == .SHADOWMAP {
        pipeline := material.shadowmap;
        vkCmdBindPipeline(command_buffer, .GRAPHICS, pipeline.pipeline);
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.pipeline_layout, Renderer.FRAME_CAMERADATA_SET, 1, *context.vk.shadowmap_camera_descriptor, 0, null);
    } else #if kind == .COLOR {
        pipeline := material.color;
        vkCmdBindPipeline(command_buffer, .GRAPHICS, pipeline.pipeline);
        vkCmdSetViewport(command_buffer, 0, 1, *VkViewport.{0, xx global_renderer.swapchain_extent.height, xx global_renderer.swapchain_extent.width, -(cast(float)global_renderer.swapchain_extent.height), 0, 1});
        vkCmdSetScissor(command_buffer, 0, 1, *VkRect2D.{.{0, 0}, global_renderer.swapchain_extent});
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.pipeline_layout, Renderer.FRAME_CAMERADATA_SET, 1, *context.vk.camera_descriptor, 0, null);
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.pipeline_layout, Renderer.FRAME_SHADOWMAP_SET, 1, *global_renderer.shadowmap_descriptor_set, 0, null);
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.pipeline_layout, Renderer.MATERIAL_SET, 1, *global_renderer.default_texture_descriptor, 0, null);
    } else {
        #assert false;
    }
}