Pipeline :: struct {
    pipeline_layout: VkPipelineLayout;
    pipeline: VkPipeline;
}

destroy_pipeline :: (using pass: *Pipeline, device: VkDevice) {
    vkDestroyPipelineLayout(device, pipeline_layout, null);
    vkDestroyPipeline(device, pipeline, null);
}

// --------
// Color pipeline

create_color_pipeline :: (device: VkDevice, render_pass: VkRenderPass) -> Pipeline {
    pipeline : Pipeline;

    // Pipeline
    vtx := create_shader_module(device, "shaders/color.vert.spv");
    defer vkDestroyShaderModule(device, vtx, null);

    frag := create_shader_module(device, "shaders/color.frag.spv");
    defer vkDestroyShaderModule(device, frag, null);

    stages := VkPipelineShaderStageCreateInfo.[
        .{stage = .VERTEX_BIT,   module = vtx, pName = "main"},
        .{stage = .FRAGMENT_BIT, module = frag, pName = "main"}
    ];

    push_constant_ci := VkPushConstantRange.{
        stageFlags = .VERTEX_BIT,
        offset = 0,
        size = size_of(PushConstantData),
    };

    layouts := VkDescriptorSetLayout.[
        global_renderer.global_set_layout,
        global_renderer.shadowmap_layout,
        global_renderer.single_texture_layout,
    ];

    layout_ci := VkPipelineLayoutCreateInfo.{ 
        pushConstantRangeCount = 1,
        pPushConstantRanges = *push_constant_ci,
        setLayoutCount = xx layouts.count,
        pSetLayouts = layouts.data,
    };
    Vk_Check(vkCreatePipelineLayout(device, *layout_ci, null, *pipeline.pipeline_layout));

    create_info := pipeline_create_info(pipeline.pipeline_layout, render_pass);
    vkCreateGraphicsPipelines(device, null, 1, *create_info, null, *pipeline.pipeline);
    log("Standard pipeline created.");

    return pipeline;
}

draw_color_pipeline :: (scene: *Scene, command_buffer: VkCommandBuffer) {
    image_index := context.vk.image_index;
    pipeline := *global_renderer.color_pipeline;

    if scene.color_draw_data.vertices.count == 0 && scene.static_models.count == 0 return;

    {   // Bind pipeline, dynamic state, global descriptors and a default push constant
        vkCmdBindPipeline(command_buffer, .GRAPHICS, pipeline.pipeline);
        vkCmdSetViewport(command_buffer, 0, 1, *VkViewport.{0, xx global_renderer.swapchain_extent.height, xx global_renderer.swapchain_extent.width, -(cast(float)global_renderer.swapchain_extent.height), 0, 1});
        vkCmdSetScissor(command_buffer, 0, 1, *VkRect2D.{.{0, 0}, global_renderer.swapchain_extent});
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.pipeline_layout, 1, 1, *global_renderer.shadowmap_descriptor_set, 0, null);
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.pipeline_layout, 2, 1, *global_renderer.default_texture_descriptor, 0, null);
        
    }

    offset : u64 = 0;
    vkCmdBindVertexBuffers(command_buffer, 0, 1, *scene.color_draw_data.vertex_buffer.buffer, *offset);

    // Issue draw calls & end command buffer
    for scene.color_draw_data.draw_cmds {
        pc := PushConstantData.{transpose(it.xform), transpose(inverse(it.xform))};
        vkCmdPushConstants(command_buffer, pipeline.pipeline_layout, .VERTEX_BIT, 0, size_of(PushConstantData), *pc);
        vkCmdDraw(command_buffer, it.count, 1, it.id, 0);
    }

    for scene.static_models {
        vkCmdBindVertexBuffers(command_buffer, 0, 1, *it.mesh.vertex_buffer.buffer, *it.mesh.vertex_offset);
        vkCmdBindIndexBuffer(command_buffer, it.mesh.index_buffer.buffer, it.mesh.index_offset, .UINT32);
        pc := PushConstantData.{transpose(it.transform), transpose(inverse(it.transform))};
        vkCmdPushConstants(command_buffer, pipeline.pipeline_layout, .VERTEX_BIT, 0, size_of(PushConstantData), *pc);
        vkCmdDrawIndexed(command_buffer, xx it.mesh.index_count, 1, 0, 0, 0);
    }
}

create_skinned_pipeline :: (device: VkDevice, render_pass: VkRenderPass) -> Pipeline {
    pipeline : Pipeline;

    // Pipeline
    
    vtx := create_shader_module(device, "shaders/skinned.vert.spv");
    defer vkDestroyShaderModule(device, vtx, null);

    frag := create_shader_module(device, "shaders/color.frag.spv");
    defer vkDestroyShaderModule(device, frag, null);

    stages := VkPipelineShaderStageCreateInfo.[
        .{stage = .VERTEX_BIT,   module = vtx, pName = "main"},
        .{stage = .FRAGMENT_BIT, module = frag, pName = "main"}
    ];

    layouts := VkDescriptorSetLayout.[
        global_renderer.global_set_layout,
        global_renderer.shadowmap_layout,
        global_renderer.single_texture_layout,
    ];

    push_constant_ci := VkPushConstantRange.{
        stageFlags = .VERTEX_BIT,
        offset = 0,
        size = size_of(PushConstantData),
    };

    layout_ci := VkPipelineLayoutCreateInfo.{ 
        pushConstantRangeCount = 1,
        pPushConstantRanges = *push_constant_ci,
        setLayoutCount = xx layouts.count,
        pSetLayouts = layouts.data,
    };
    Vk_Check(vkCreatePipelineLayout(device, *layout_ci, null, *pipeline.pipeline_layout));

    create_info := pipeline_create_info(pipeline.pipeline_layout, render_pass);
    vertex_input := vertex_input_state_ci(.[.{0, size_of(Vertex), .VERTEX}, .{1, size_of(Skinned_Vertex), .VERTEX}], skinned_vertex_input_attribute);
    create_info.pVertexInputState = *vertex_input;

    vkCreateGraphicsPipelines(device, null, 1, *create_info, null, *pipeline.pipeline);
    log("Skinned pipeline created.");
    
    return pipeline;
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

    stages := VkPipelineShaderStageCreateInfo.[
        .{stage = .VERTEX_BIT,   module = vtx, pName = "main"},
        .{stage = .FRAGMENT_BIT, module = frag, pName = "main"}
    ];

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

    create_info := pipeline_create_info(pipeline.pipeline_layout, render_pass);
    create_info.pColorBlendState.pAttachments = *VkPipelineColorBlendAttachmentState.{
        blendEnable = VK_TRUE,
        srcColorBlendFactor = .SRC_ALPHA,
        dstColorBlendFactor = .ONE_MINUS_SRC_ALPHA,
        colorBlendOp = .ADD,
        srcAlphaBlendFactor = .SRC_ALPHA,
        dstAlphaBlendFactor = .ONE_MINUS_SRC_ALPHA,
        alphaBlendOp = .ADD,
        colorWriteMask = .R_BIT | .G_BIT | .B_BIT | .A_BIT,
    };
    vkCreateGraphicsPipelines(device, null, 1, *create_info, null, *pipeline.pipeline);
    log("Pipeline created.");

    return pipeline;
}

draw_ui_pipeline :: (dd: *Draw_Data, command_buffer: VkCommandBuffer) {

    using global_renderer;
    image_index := context.vk.image_index;
    pipeline := ui_pipeline;

    if dd.vertices.count == 0 return;

    {   // Bind pipeline, dynamic state, global descriptors and a default push constant
        vkCmdBindPipeline(command_buffer, .GRAPHICS, pipeline.pipeline);
        vkCmdSetViewport(command_buffer, 0, 1, *VkViewport.{0, 0, xx swapchain_extent.width,  (cast(float)swapchain_extent.height), 0, 1});
        vkCmdSetScissor(command_buffer, 0, 1, *VkRect2D.{.{0, 0}, swapchain_extent});
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.pipeline_layout, 0, 1, *global_engine.default_font.descriptor, 0, null);
    }

    pc := float.[2.0 / cast(float)global_renderer.swapchain_extent.width, 2.0 / cast(float)global_renderer.swapchain_extent.height, -1, -1];
    vkCmdPushConstants(command_buffer, pipeline.pipeline_layout, .VERTEX_BIT, 0, size_of(type_of(pc)), *pc);

    offset : u64 = 0;
    vkCmdBindVertexBuffers(command_buffer, 0, 1, *dd.vertex_buffer.buffer, *offset);

    // Issue draw calls & end command buffer
    for dd.draw_cmds {
        vkCmdDraw(command_buffer, it.count, 1, it.id, 0);
    }
}

// --------
// Shadowmap Pipeline

create_shadowmap_pipeline :: (device: VkDevice, render_pass: VkRenderPass, size: u32) -> Pipeline {
    pipeline : Pipeline;

    // Pipeline 
    
    vtx := create_shader_module(device, "shaders/shadowmap.vert.spv");
    defer vkDestroyShaderModule(device, vtx, null);

    stages := VkPipelineShaderStageCreateInfo.[
        .{stage = .VERTEX_BIT, module = vtx, pName = "main"}
    ];

    push_constant_ci := VkPushConstantRange.{
        stageFlags = .VERTEX_BIT,
        offset = 0,
        size = size_of(PushConstantData),
    };

    layouts := VkDescriptorSetLayout.[
        global_renderer.global_set_layout,
    ];

    layout_ci := VkPipelineLayoutCreateInfo.{ 
        pushConstantRangeCount = 1,
        pPushConstantRanges = *push_constant_ci,
        setLayoutCount = xx layouts.count,
        pSetLayouts = layouts.data,
    };
    Vk_Check(vkCreatePipelineLayout(device, *layout_ci, null, *pipeline.pipeline_layout));

    rasterization_state := rasterization_state_ci();
    rasterization_state.depthBiasEnable = VK_TRUE;
    rasterization_state.depthBiasConstantFactor = 1.25;
    rasterization_state.depthBiasClamp = 0;
    rasterization_state.depthBiasSlopeFactor = 1.75;

    viewport_state := viewport_state_ci(size, size);

    create_info := pipeline_create_info(pipeline.pipeline_layout, render_pass);
    create_info.pDynamicState = null;
    create_info.pRasterizationState = *rasterization_state;
    create_info.pViewportState = *viewport_state;
    vkCreateGraphicsPipelines(device, null, 1, *create_info, null, *pipeline.pipeline);
    log("Shadowmap pipeline created.");
    
    return pipeline;
}

draw_shadowmap_pipeline :: (scene: *Scene, command_buffer: VkCommandBuffer) {
    image_index := context.vk.image_index;
    pipeline := *global_renderer.shadowmap_pipeline;

    if scene.color_draw_data.vertices.count == 0 && scene.static_models.count == 0 return;

    {   // Bind pipeline, dynamic state, global descriptors and a default push constant
        vkCmdBindPipeline(command_buffer, .GRAPHICS, pipeline.pipeline);
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.pipeline_layout, 0, 1, *global_renderer.global_descriptor[image_index], 0, null);
    }

    offset : u64 = 0;
    vkCmdBindVertexBuffers(command_buffer, 0, 1, *scene.color_draw_data.vertex_buffer.buffer, *offset);

    // Issue draw calls & end command buffer
    for scene.color_draw_data.draw_cmds {
        // pc := PushConstantData.{transpose(it.xform), transpose(inverse(it.xform))};
        pc := PushConstantData.{transpose(it.xform), transpose(inverse(it.xform))};
        vkCmdPushConstants(command_buffer, pipeline.pipeline_layout, .VERTEX_BIT, 0, size_of(PushConstantData), *pc);
        vkCmdDraw(command_buffer, it.count, 1, it.id, 0);
    }

    for scene.static_models {
        vkCmdBindVertexBuffers(command_buffer, 0, 1, *it.mesh.vertex_buffer.buffer, *it.mesh.vertex_offset);
        vkCmdBindIndexBuffer(command_buffer, it.mesh.index_buffer.buffer, it.mesh.index_offset, .UINT32);
        pc := PushConstantData.{transpose(it.transform), transpose(inverse(it.transform))};
        vkCmdPushConstants(command_buffer, pipeline.pipeline_layout, .VERTEX_BIT, 0, size_of(PushConstantData), *pc);
        vkCmdDrawIndexed(command_buffer, xx it.mesh.index_count, 1, 0, 0, 0);
    }
}

