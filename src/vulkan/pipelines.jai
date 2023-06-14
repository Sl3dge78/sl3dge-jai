Pipeline :: struct (nb_sets: u32){
    descriptor_set_layouts: [nb_sets]VkDescriptorSetLayout;
    pipeline_layout: VkPipelineLayout;
    pipeline: VkPipeline;
    descriptor_sets: [Renderer.FRAME_COUNT][nb_sets] VkDescriptorSet;
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

create_color_pipeline :: (device: VkDevice, render_pass: VkRenderPass) -> Pipeline(2) {
    pipeline : Pipeline(2);

    // Pipeline
    {
        vtx := create_shader_module(device, "shaders/color.vert.spv");
        defer vkDestroyShaderModule(device, vtx, null);

        frag := create_shader_module(device, "shaders/color.frag.spv");
        defer vkDestroyShaderModule(device, frag, null);

        stages : [2]VkPipelineShaderStageCreateInfo;
        stages[0] = .{stage = .VERTEX_BIT,   module = vtx, pName = "main"};
        stages[1] = .{stage = .FRAGMENT_BIT, module = frag, pName = "main"};

        bindings : [3]VkDescriptorSetLayoutBinding;
        bindings[0] = .{
            binding = 0,
            descriptorType = .UNIFORM_BUFFER,
            descriptorCount = 1,
            stageFlags = .VERTEX_BIT,
            pImmutableSamplers = null,
        };
        bindings[1] = .{
            binding = 1,
            descriptorType = .COMBINED_IMAGE_SAMPLER,
            descriptorCount = 1,
            stageFlags = .FRAGMENT_BIT,
            pImmutableSamplers = null,
        };
        bindings[2] = .{
            binding = 2,
            descriptorType = .UNIFORM_BUFFER,
            descriptorCount = 1,
            stageFlags = .FRAGMENT_BIT,
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

        create_info := pipeline_create_info(pipeline.pipeline_layout, render_pass);
        vkCreateGraphicsPipelines(device, null, 1, *create_info, null, *pipeline.pipeline);
        log("Standard pipeline created.");
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

            // @Hardcoded: Create a Material struct, that allocates a descriptor set on a specific pipline and gets bound when needed
            // @Todo: Only write the frame constant data here
            descriptor_writes : [2]VkWriteDescriptorSet;
            buffer_info := VkDescriptorBufferInfo .{
                buffer = pipeline.uniform_data[it_index].buffer,
                offset = 0,
                range = size_of(CameraData) - size_of(Vector3),
            };
            descriptor_writes[0] = .{
                dstSet = it.*[0],
                dstBinding = 0,
                dstArrayElement = 0,
                descriptorType = .UNIFORM_BUFFER,
                descriptorCount = 1,
                pBufferInfo = *buffer_info,
            };
           
            buffer_info2 := VkDescriptorBufferInfo .{
                buffer = pipeline.uniform_data[it_index].buffer,
                offset = size_of(CameraData) - size_of(Vector3),
                range = size_of(Vector3),
            };
            descriptor_writes[1] = .{
                dstSet = it.*[0],
                dstBinding = 2,
                dstArrayElement = 0,
                descriptorType = .UNIFORM_BUFFER,
                descriptorCount = 1,
                pBufferInfo = *buffer_info2,
            };

            vkUpdateDescriptorSets(global_renderer.device, descriptor_writes.count, descriptor_writes.data, 0, null);
        }
    }

    return pipeline;
}

draw_color_pipeline :: (dd: *Draw_Data, command_buffer: VkCommandBuffer) {
    using global_renderer;
    image_index := context.vk.image_index;
    pipeline := *color_pipeline;

    if dd.vertices.count == 0 return;

    {   // Update uniform data        
        camera_data := CameraData.{
            proj = transpose(projection),
            view = transpose(view),
            view_proj = transpose(projection * view),
            light = transpose(light),
            light_dir = global_renderer.light_dir,
        };
        memcpy(pipeline.uniform_data[context.vk.image_index].mapped, *camera_data, size_of(type_of(camera_data)));

        // @Hardcoded: Create a Material struct, that allocates a descriptor set on a specific pipline and gets bound when needed
        // @Todo: Only write the frame constant data here
        descriptor_writes : [2]VkWriteDescriptorSet;
        // Diffuse
        image_info := VkDescriptorImageInfo.{
            sampler = global_renderer.sampler, // @Hardcoded
            imageView = resources.block_texture.view, // @Hardcoded
            imageLayout = .SHADER_READ_ONLY_OPTIMAL,
        };
        descriptor_writes[0] = .{
            dstSet = pipeline.descriptor_sets[context.vk.image_index][1],
            dstBinding = 0,
            dstArrayElement = 0,
            descriptorType = .COMBINED_IMAGE_SAMPLER,
            descriptorCount = 1,
            pImageInfo = *image_info,
        };

        // Shadowmap
        image_info2 := VkDescriptorImageInfo.{
            sampler = global_renderer.sampler, // @Hardcoded
            imageView = global_renderer.shadowmap_texture.view, // @Hardcoded
            imageLayout = .DEPTH_STENCIL_READ_ONLY_OPTIMAL,
        };
        descriptor_writes[1] = .{
            dstSet = pipeline.descriptor_sets[context.vk.image_index][0],
            dstBinding = 1,
            dstArrayElement = 0,
            descriptorType = .COMBINED_IMAGE_SAMPLER,
            descriptorCount = 1,
            pImageInfo = *image_info2,
        };

        vkUpdateDescriptorSets(global_renderer.device, descriptor_writes.count, descriptor_writes.data, 0, null);
    }

    {   // Bind pipeline, dynamic state, global descriptors and a default push constant
        vkCmdBindPipeline(command_buffer, .GRAPHICS, pipeline.pipeline);
        vkCmdSetViewport(command_buffer, 0, 1, *VkViewport.{0, xx swapchain_extent.height, xx swapchain_extent.width, -(cast(float)swapchain_extent.height), 0, 1});
        vkCmdSetScissor(command_buffer, 0, 1, *VkRect2D.{.{0, 0}, swapchain_extent});
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.pipeline_layout, 0, 1, *pipeline.descriptor_sets[image_index][0], 0, null);
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.pipeline_layout, 1, 1, *pipeline.descriptor_sets[image_index][1], 0, null);
    }

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

create_ui_pipeline :: (device: VkDevice, render_pass: VkRenderPass) -> Pipeline(2) {
    pipeline : Pipeline(2);

    // Pipeline
    {
        vtx := create_shader_module(device, "shaders/ui.vert.spv");
        defer vkDestroyShaderModule(device, vtx, null);

        frag := create_shader_module(device, "shaders/ui.frag.spv");
        defer vkDestroyShaderModule(device, frag, null);

        stages : [2]VkPipelineShaderStageCreateInfo;
        stages[0] = .{stage = .VERTEX_BIT,   module = vtx, pName = "main"};
        stages[1] = .{stage = .FRAGMENT_BIT, module = frag, pName = "main"};

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

        create_info := pipeline_create_info(pipeline.pipeline_layout, render_pass);
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

            descriptor_writes : [1]VkWriteDescriptorSet;
            buffer_info := VkDescriptorBufferInfo .{
                buffer = pipeline.uniform_data[it_index].buffer,
                offset = 0,
                range = size_of(CameraData),
            };
            descriptor_writes[0] = .{
                dstSet = it.*[0],
                dstBinding = 0,
                dstArrayElement = 0,
                descriptorType = .UNIFORM_BUFFER,
                descriptorCount = 1,
                pBufferInfo = *buffer_info,
            };
            vkUpdateDescriptorSets(global_renderer.device, descriptor_writes.count, descriptor_writes.data, 0, null);
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
        camera_data := CameraData.{
            proj = transpose(proj),
            view = Matrix4_Identity,
            view_proj = transpose(proj),
            // light = transpose(light),
        };
        memcpy(pipeline.uniform_data[image_index].mapped, *camera_data, size_of(type_of(camera_data)));

        // @Hardcoded: Create a Material struct, that allocates a descriptor set on a specific pipline and gets bound when needed
        // @Todo: Only write the frame constant data here
        descriptor_writes : [1]VkWriteDescriptorSet;

        image_info := VkDescriptorImageInfo.{
            sampler = sampler, // @Hardcoded
            imageView = global_engine.default_font.texture.view, // @Hardcoded
            imageLayout = .SHADER_READ_ONLY_OPTIMAL,
        };
        descriptor_writes[0] = .{
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
        vkCmdSetViewport(command_buffer, 0, 1, *VkViewport.{0, 0, xx swapchain_extent.width,  (cast(float)swapchain_extent.height), 0, 1});
        vkCmdSetScissor(command_buffer, 0, 1, *VkRect2D.{.{0, 0}, swapchain_extent});
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.pipeline_layout, 0, 1, *pipeline.descriptor_sets[image_index][0], 0, null);
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.pipeline_layout, 1, 1, *pipeline.descriptor_sets[image_index][1], 0, null);
    }

    offset : u64 = 0;
    vkCmdBindVertexBuffers(command_buffer, 0, 1, *dd.vertex_buffer.buffer, *offset);

    // Issue draw calls & end command buffer
    for dd.draw_cmds {
        vkCmdDraw(command_buffer, it.count, 1, it.id, 0);
    }
}

// --------
// Shadowmap Pipeline

create_shadowmap_pipeline :: (device: VkDevice, render_pass: VkRenderPass, size: u32) -> Pipeline(1) {
    pipeline : Pipeline(1);

    // Pipeline 
    {
        vtx := create_shader_module(device, "shaders/shadowmap.vert.spv");
        defer vkDestroyShaderModule(device, vtx, null);

        stages : [1]VkPipelineShaderStageCreateInfo;
        stages[0] = .{stage = .VERTEX_BIT, module = vtx, pName = "main"};

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
        log("Standard pipeline created.");
    }

    alloc_info := VkDescriptorSetAllocateInfo.{
        descriptorPool = global_renderer.descriptor_pool,
        descriptorSetCount = pipeline.descriptor_set_layouts.count,
        pSetLayouts = pipeline.descriptor_set_layouts.data,
    };

    for *pipeline.descriptor_sets {
        Vk_Check(vkAllocateDescriptorSets(device, *alloc_info, it.data));
        descriptor_writes : [1]VkWriteDescriptorSet;
        buffer_info := VkDescriptorBufferInfo .{
            buffer = pipeline.uniform_data[it_index].buffer,
            offset = 0,
            range = size_of(CameraData),
        };
        descriptor_writes[0] = .{
            dstSet = it.*[0],
            dstBinding = 0,
            dstArrayElement = 0,
            descriptorType = .UNIFORM_BUFFER,
            descriptorCount = 1,
            pBufferInfo = *buffer_info,
        };
        vkUpdateDescriptorSets(global_renderer.device, descriptor_writes.count, descriptor_writes.data, 0, null);
    }

    return pipeline;
}

draw_shadowmap_pipeline :: (dd: *Draw_Data, command_buffer: VkCommandBuffer) {
    using global_renderer;
    image_index := context.vk.image_index;
    pipeline := *shadowmap_pipeline;

    { // Update uniform data
        camera_data := CameraData.{
            light = transpose(global_renderer.light),
        };
        memcpy(global_renderer.shadowmap_pipeline.uniform_data[context.vk.image_index].mapped, *camera_data, size_of(type_of(camera_data)));
       
    }

    if dd.vertices.count == 0 return;

    {   // Bind pipeline, dynamic state, global descriptors and a default push constant
        vkCmdBindPipeline(command_buffer, .GRAPHICS, pipeline.pipeline);
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.pipeline_layout, 0, 1, *pipeline.descriptor_sets[image_index][0], 0, null);
    }

    offset : u64 = 0;
    vkCmdBindVertexBuffers(command_buffer, 0, 1, *dd.vertex_buffer.buffer, *offset);

    // Issue draw calls & end command buffer
    for dd.draw_cmds {
        vkCmdPushConstants(command_buffer, pipeline.pipeline_layout, .VERTEX_BIT, 0, size_of(PushConstantData), *PushConstantData.{transpose(it.xform)});
        vkCmdDraw(command_buffer, it.count, 1, it.id, 0);
    }
}

