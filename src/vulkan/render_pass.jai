Pipeline :: struct { // @TODO : Change this name
    descriptor_set_layouts: [2]VkDescriptorSetLayout;
    pipeline_layout: VkPipelineLayout;
    pipeline: VkPipeline;
    descriptor_sets: [Renderer.FRAME_COUNT][2] VkDescriptorSet;
    uniform_data: [Renderer.FRAME_COUNT] Buffer;
}

destroy_pipeline :: (using pass: *Pipeline, device: VkDevice) {
    for descriptor_set_layouts {
        vkDestroyDescriptorSetLayout(device, it, null);
    }
    vkDestroyPipelineLayout(device, pipeline_layout, null);
    vkDestroyPipeline(device, pipeline, null);
    for *uniform_data {
        destroy_buffer(it);
    }
}

// -------
// Color pipeline

create_color_pipeline :: (device: VkDevice, render_pass: VkRenderPass) -> Pipeline {
    pipeline : Pipeline;

    // Pipeline
    {
        vtx := create_shader_module(device, "shaders/color.vert.spv");
        defer vkDestroyShaderModule(device, vtx, null);

        frag := create_shader_module(device, "shaders/color.frag.spv");
        defer vkDestroyShaderModule(device, frag, null);

        bindings : [1]VkDescriptorSetLayoutBinding;
        bindings[0] = .{
            binding = 0,
            descriptorType = .UNIFORM_BUFFER,
            descriptorCount = 1,
            stageFlags = .VERTEX_BIT,
            pImmutableSamplers = null,
        };
        layout_info := VkDescriptorSetLayoutCreateInfo.{
            bindingCount = bindings.count,
            pBindings = bindings.data,
        };        
        
        Vk_Check(vkCreateDescriptorSetLayout(device, *layout_info, null, *pipeline.descriptor_set_layouts[0]));

        bindings[0] = .{
            binding = 0,
            descriptorType = .COMBINED_IMAGE_SAMPLER,
            descriptorCount = 1,
            stageFlags = .FRAGMENT_BIT,
            pImmutableSamplers = null,
        };
        Vk_Check(vkCreateDescriptorSetLayout(device, *layout_info, null, *pipeline.descriptor_set_layouts[1]));

        for *pipeline.uniform_data {
            it.* = create_buffer(size_of(CameraData), .UNIFORM_BUFFER_BIT, .UPLOAD, map = true);
        }

        push_constant_ci := VkPushConstantRange.{
            stageFlags = .VERTEX_BIT,
            offset = 0,
            size = size_of(PushConstantData),
        };

        layout_ci := VkPipelineLayoutCreateInfo.{ 
            pushConstantRangeCount = 1,
            pPushConstantRanges = *push_constant_ci,
            setLayoutCount = pipeline.descriptor_set_layouts.count,
            pSetLayouts = pipeline.descriptor_set_layouts.data,
        };
        Vk_Check(vkCreatePipelineLayout(device, *layout_ci, null, *pipeline.pipeline_layout));

        create_info := pipeline_create_info(vtx, frag, pipeline.pipeline_layout);
        create_info.renderPass = render_pass;
        vkCreateGraphicsPipelines(device, null, 1, *create_info, null, *pipeline.pipeline);
        log("Pipeline created.");
    }

    // DescriptorSet
    {
        
        alloc_info := VkDescriptorSetAllocateInfo.{
            descriptorPool = global_renderer.descriptor_pool,
            descriptorSetCount = pipeline.descriptor_set_layouts.count,
            pSetLayouts = pipeline.descriptor_set_layouts.data,
        };

        for *pipeline.descriptor_sets {
            Vk_Check(vkAllocateDescriptorSets(device, *alloc_info, it.data));   
        }
    }

    return pipeline;
}

draw_color_pipeline :: (dd: *Draw_Data, command_buffer: VkCommandBuffer) {
    using global_renderer;
    image_index := context.vk.image_index;
    pipeline := *color_pipeline;

    if dd.vertices.count == 0 return;

    {   // Bind pipeline, dynamic state, global descriptors and a default push constant
        vkCmdBindPipeline(command_buffer, .GRAPHICS, pipeline.pipeline);
        vkCmdSetViewport(command_buffer, 0, 1, *VkViewport.{0, 0, xx swapchain_extent.width, xx swapchain_extent.height, 0, 1});
        vkCmdSetScissor(command_buffer, 0, 1, *VkRect2D.{.{0, 0}, swapchain_extent});
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.pipeline_layout, 0, 1, *pipeline.descriptor_sets[image_index][0], 0, null);
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.pipeline_layout, 1, 1, *pipeline.descriptor_sets[image_index][1], 0, null);
    }

    clear_color := Vector4.{0, 0, 0, 1};

    size : u64 = xx (dd.vertices.count * size_of(Vertex));
    create_or_update_buffer(*dd.vertex_buffer, size, VkBufferUsageFlagBits.VERTEX_BUFFER_BIT | .INDEX_BUFFER_BIT | .UNIFORM_BUFFER_BIT | .STORAGE_BUFFER_BIT | .TRANSFER_SRC_BIT, .UPLOAD);
    copy_data(dd.vertex_buffer, dd.vertices.data, size);
    offset : u64 = 0;
    vkCmdBindVertexBuffers(command_buffer, 0, 1, *dd.vertex_buffer.buffer, *offset);

    // Issue draw calls & end command buffer
    for dd.draw_cmds {
        vkCmdPushConstants(command_buffer, pipeline.pipeline_layout, .VERTEX_BIT, 0, size_of(PushConstantData), *PushConstantData.{transpose(it.xform)});
        vkCmdDraw(command_buffer, it.count, 1, it.id, 0);
    }
}

// --------
// 2d/ui pipeline

create_ui_pipeline :: (device: VkDevice, render_pass: VkRenderPass) -> Pipeline {
    pipeline : Pipeline;

    // Pipeline
    {
        vtx := create_shader_module(device, "shaders/ui.vert.spv");
        defer vkDestroyShaderModule(device, vtx, null);

        frag := create_shader_module(device, "shaders/ui.frag.spv");
        defer vkDestroyShaderModule(device, frag, null);

        bindings : [1]VkDescriptorSetLayoutBinding;
        bindings[0] = .{
            binding = 0,
            descriptorType = .UNIFORM_BUFFER,
            descriptorCount = 1,
            stageFlags = .VERTEX_BIT,
            pImmutableSamplers = null,
        };
        layout_info := VkDescriptorSetLayoutCreateInfo.{
            bindingCount = bindings.count,
            pBindings = bindings.data,
        };        
        
        Vk_Check(vkCreateDescriptorSetLayout(device, *layout_info, null, *pipeline.descriptor_set_layouts[0]));

        bindings[0] = .{
            binding = 0,
            descriptorType = .COMBINED_IMAGE_SAMPLER,
            descriptorCount = 1,
            stageFlags = .FRAGMENT_BIT,
            pImmutableSamplers = null,
        };
        Vk_Check(vkCreateDescriptorSetLayout(device, *layout_info, null, *pipeline.descriptor_set_layouts[1]));

        for *pipeline.uniform_data {
            it.* = create_buffer(size_of(CameraData), .UNIFORM_BUFFER_BIT, .UPLOAD, map = true);
        }

        layout_ci := VkPipelineLayoutCreateInfo.{ 
            setLayoutCount = pipeline.descriptor_set_layouts.count,
            pSetLayouts = pipeline.descriptor_set_layouts.data,
        };
        Vk_Check(vkCreatePipelineLayout(device, *layout_ci, null, *pipeline.pipeline_layout));

        create_info := pipeline_create_info(vtx, frag, pipeline.pipeline_layout);
        create_info.renderPass = render_pass;
        create_info.pColorBlendState.pAttachments = *VkPipelineColorBlendAttachmentState.{
            blendEnable = VK_TRUE,
            srcColorBlendFactor = .SRC_ALPHA,
            dstColorBlendFactor = .ONE_MINUS_SRC_ALPHA,
            colorBlendOp = .ADD,
            srcAlphaBlendFactor = .SRC_ALPHA,
            dstAlphaBlendFactor = .ONE_MINUS_SRC_ALPHA,
            alphaBlendOp = .ADD,
            colorWriteMask = VkColorComponentFlagBits.R_BIT | .G_BIT | .B_BIT | .A_BIT,
        };
        vkCreateGraphicsPipelines(device, null, 1, *create_info, null, *pipeline.pipeline);
        log("Pipeline created.");
    }

    // DescriptorSet
    {
        // @TODO: Move that in a Material struct
        alloc_info := VkDescriptorSetAllocateInfo.{
            descriptorPool = global_renderer.descriptor_pool,
            descriptorSetCount = pipeline.descriptor_set_layouts.count,
            pSetLayouts = pipeline.descriptor_set_layouts.data,
        };

        for *pipeline.descriptor_sets {
            Vk_Check(vkAllocateDescriptorSets(device, *alloc_info, it.data));
        }
    }

    return pipeline;
}

draw_ui_pipeline :: (dd: *Draw_Data, command_buffer: VkCommandBuffer) {

    using global_renderer;
    image_index := context.vk.image_index;
    pipeline := ui_pipeline;

    {   // Update uniform data 
        proj := orthographic_projection_matrix(0, xx global_renderer.swapchain_extent.width, 0, xx global_renderer.swapchain_extent.height, -1, 1);
        // proj._22 *= -1;
        camera_data := CameraData.{
            proj = transpose(proj),
            view = Matrix4_Identity,
            view_proj = transpose(proj),
        };
        memcpy(pipeline.uniform_data[image_index].mapped, *camera_data, size_of(type_of(camera_data)));

        // @Hardcoded: Create a Material struct, that allocates a descriptor set on a specific pipline and gets bound when needed
        // @Todo: Only write the frame constant data here
        descriptor_writes : [2]VkWriteDescriptorSet;
        buffer_info := VkDescriptorBufferInfo .{
            buffer = pipeline.uniform_data[image_index].buffer,
            offset = 0,
            range = size_of(CameraData),
        };
        descriptor_writes[0] = .{
            dstSet = pipeline.descriptor_sets[image_index][0],
            dstBinding = 0,
            dstArrayElement = 0,
            descriptorType = .UNIFORM_BUFFER,
            descriptorCount = 1,
            pBufferInfo = *buffer_info,
        };

        image_info := VkDescriptorImageInfo.{
            sampler = sampler, // @Hardcoded
            imageView = global_engine.default_font.texture.view, // @Hardcoded
            imageLayout = .SHADER_READ_ONLY_OPTIMAL,
        };
        descriptor_writes[1] = .{
            dstSet = pipeline.descriptor_sets[image_index][1],
            dstBinding = 0,
            dstArrayElement = 0,
            descriptorType = .COMBINED_IMAGE_SAMPLER,
            descriptorCount = 1,
            pImageInfo = *image_info,
        };
        vkUpdateDescriptorSets(global_renderer.device, descriptor_writes.count, descriptor_writes.data, 0, null);
    }

    if dd.vertices.count == 0 return;

    {   // Bind pipeline, dynamic state, global descriptors and a default push constant
        vkCmdBindPipeline(command_buffer, .GRAPHICS, pipeline.pipeline);
        vkCmdSetViewport(command_buffer, 0, 1, *VkViewport.{0, 0, xx swapchain_extent.width, xx swapchain_extent.height, 0, 1});
        vkCmdSetScissor(command_buffer, 0, 1, *VkRect2D.{.{0, 0}, swapchain_extent});
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.pipeline_layout, 0, 1, *pipeline.descriptor_sets[image_index][0], 0, null);
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.pipeline_layout, 1, 1, *pipeline.descriptor_sets[image_index][1], 0, null);
    }

    clear_color := Vector4.{0, 0, 0, 1};

    

    size : u64 = xx (dd.vertices.count * size_of(Vertex));
    create_or_update_buffer(*dd.vertex_buffer, size, VkBufferUsageFlagBits.VERTEX_BUFFER_BIT | .INDEX_BUFFER_BIT | .UNIFORM_BUFFER_BIT | .STORAGE_BUFFER_BIT | .TRANSFER_SRC_BIT, .UPLOAD);
    copy_data(dd.vertex_buffer, dd.vertices.data, size);
    offset : u64 = 0;
    vkCmdBindVertexBuffers(command_buffer, 0, 1, *dd.vertex_buffer.buffer, *offset);

    // Issue draw calls & end command buffer
    for dd.draw_cmds {
        vkCmdDraw(command_buffer, it.count, 1, it.id, 0);
    }

}

