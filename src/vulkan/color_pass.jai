Render_Pass :: struct {
    // render_pass: VkRenderPass;
    descriptor_pool: VkDescriptorPool;
    descriptor_set_layouts: [2]VkDescriptorSetLayout;
    pipeline_layout: VkPipelineLayout;
    pipeline: VkPipeline;

    descriptor_sets: [Renderer.FRAME_COUNT][2] VkDescriptorSet;

    uniform_data: [Renderer.FRAME_COUNT] Buffer;
    
    sampler: VkSampler;

    // @TODO: Might be moved elsewhere because some passes might use the same vtx data
    vertex_buffer: Buffer;
    vertices: [..]Vertex;
    draw_cmds : [..]Draw_Cmd;
    transform: Matrix4;
}

Draw_Cmd :: struct {
    id: u32;
    count: u32;
    xform: Matrix4;
}

create_color_pass :: (device: VkDevice) -> Render_Pass {
    color_pass : Render_Pass;

    // Pipeline
    {
        vtx := create_shader_module(device, "shaders/shader.vert.spv");
        defer vkDestroyShaderModule(device, vtx, null);

        frag := create_shader_module(device, "shaders/shader.frag.spv");
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
        
        Vk_Check(vkCreateDescriptorSetLayout(device, *layout_info, null, *color_pass.descriptor_set_layouts[0]));

        bindings[0] = .{
            binding = 0,
            descriptorType = .COMBINED_IMAGE_SAMPLER,
            descriptorCount = 1,
            stageFlags = .FRAGMENT_BIT,
            pImmutableSamplers = null,
        };
        Vk_Check(vkCreateDescriptorSetLayout(device, *layout_info, null, *color_pass.descriptor_set_layouts[1]));

        for *color_pass.uniform_data {
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
            setLayoutCount = color_pass.descriptor_set_layouts.count,
            pSetLayouts = color_pass.descriptor_set_layouts.data,
        };
        Vk_Check(vkCreatePipelineLayout(device, *layout_ci, null, *color_pass.pipeline_layout));

        stages : [2]VkPipelineShaderStageCreateInfo;
        stages[0] = .{stage = .VERTEX_BIT,   module = vtx, pName = "main"};
        stages[1] = .{stage = .FRAGMENT_BIT, module = frag, pName = "main"};
        /* Non constant array litterals pls
        stages := VkPipelineShaderStageCreateInfo.[
            .{stage = .VERTEX_BIT,   module = vtx, pName = "main"},
            .{stage = .FRAGMENT_BIT, module = frag, pName = "main"},
        ]; */       

        dynamic_state := VkDynamicState.[.VIEWPORT, .SCISSOR];

        create_info := VkGraphicsPipelineCreateInfo.{
            stageCount = stages.count,
            pStages = stages.data,
            pVertexInputState = *VkPipelineVertexInputStateCreateInfo.{
                vertexBindingDescriptionCount = 1,
                pVertexBindingDescriptions = *VkVertexInputBindingDescription.{
                    binding = 0, stride = size_of(Vertex), inputRate = .VERTEX
                },
                vertexAttributeDescriptionCount = vertex_input_attribute.count,
                pVertexAttributeDescriptions = vertex_input_attribute.data,
            },
            pInputAssemblyState = *VkPipelineInputAssemblyStateCreateInfo.{
                topology = .TRIANGLE_LIST,
                primitiveRestartEnable = VK_FALSE,
            },
            pViewportState = *VkPipelineViewportStateCreateInfo.{
                viewportCount = 1,
                pViewports = VK_NULL_HANDLE,
                scissorCount = 1,
                pScissors = VK_NULL_HANDLE,
            },
            pRasterizationState = *VkPipelineRasterizationStateCreateInfo.{
                depthClampEnable = VK_FALSE,
                rasterizerDiscardEnable = VK_FALSE,
                polygonMode = .FILL,
                cullMode = .NONE,
                frontFace = .CLOCKWISE,
                depthBiasEnable = VK_FALSE,
                depthBiasConstantFactor = 0,
                depthBiasClamp = 0,
                depthBiasSlopeFactor = 0,
                lineWidth = 1,
            },
            pMultisampleState = *VkPipelineMultisampleStateCreateInfo.{
                rasterizationSamples = ._1_BIT,
                sampleShadingEnable = VK_FALSE,
                minSampleShading = 1,
                pSampleMask = VK_NULL_HANDLE,
                alphaToCoverageEnable = VK_FALSE,
                alphaToOneEnable = VK_FALSE,
            },
            pColorBlendState = *VkPipelineColorBlendStateCreateInfo.{
                logicOpEnable = VK_FALSE,
                attachmentCount = 1,
                pAttachments = *VkPipelineColorBlendAttachmentState.{
                    blendEnable = VK_FALSE,
                    srcColorBlendFactor = .ONE,
                    dstColorBlendFactor = .ZERO,
                    colorBlendOp = .ADD,
                    srcAlphaBlendFactor = .ONE,
                    dstAlphaBlendFactor = .ZERO,
                    alphaBlendOp = .ADD,
                    colorWriteMask = VkColorComponentFlagBits.R_BIT | .G_BIT | .B_BIT | .A_BIT,
                },
            },
            pDynamicState = *VkPipelineDynamicStateCreateInfo.{
                dynamicStateCount = dynamic_state.count,
                pDynamicStates = dynamic_state.data,
            },
            layout = color_pass.pipeline_layout,
        };
        vkCreateGraphicsPipelines(device, null, 1, *create_info, null, *color_pass.pipeline);
        log("Pipeline created.");
    }

    // DescriptorPool & DescriptorSet
    {
        pool_sizes : [2]VkDescriptorPoolSize;
        pool_sizes[0] = VkDescriptorPoolSize.{
            type = .UNIFORM_BUFFER,
            descriptorCount = Renderer.FRAME_COUNT,
        };
        pool_sizes[1] = VkDescriptorPoolSize.{
            type = .COMBINED_IMAGE_SAMPLER,
            descriptorCount = Renderer.FRAME_COUNT, //@TODO: 32?
        };

        pool_info := VkDescriptorPoolCreateInfo.{
            poolSizeCount = pool_sizes.count,
            pPoolSizes = pool_sizes.data,
            maxSets = Renderer.FRAME_COUNT * 2,
        };
        Vk_Check(vkCreateDescriptorPool(device, *pool_info, null, *color_pass.descriptor_pool));

        alloc_info := VkDescriptorSetAllocateInfo.{
            descriptorPool = color_pass.descriptor_pool,
            descriptorSetCount = color_pass.descriptor_set_layouts.count,
            pSetLayouts = color_pass.descriptor_set_layouts.data,
        };

        for *color_pass.descriptor_sets {
            Vk_Check(vkAllocateDescriptorSets(device, *alloc_info, it.data));
            
        }
    }

    return color_pass;
}

destroy_color_pass :: (using color_pass: *Render_Pass, device: VkDevice) {
    vkDestroyDescriptorPool(device, descriptor_pool, null);
    vkDestroySampler(device, sampler, null);
    for descriptor_set_layouts {
        vkDestroyDescriptorSetLayout(device, it, null);
    }
    vkDestroyPipelineLayout(device, pipeline_layout, null);
    vkDestroyPipeline(device, pipeline, null);
    for *uniform_data {
        destroy_buffer(it);
    }
    destroy_buffer(*vertex_buffer);
}

begin_color_pass :: (view: Matrix4, clear_color: Vector4 = .{0, 0, 0, 1} ) {
    using global_renderer;
    using context.vk;

    current_pass = *global_renderer.color_pass;

    {   // Update uniform data 
        proj := make_projection_matrix(radians(45), cast(float)global_renderer.swapchain_extent.width/cast(float)global_renderer.swapchain_extent.height, 0.1, 1000);
        proj._22 *= -1;
        camera_data := CameraData.{
            proj = transpose(proj),
            view = transpose(view),
            view_proj = transpose(view * proj),
        };
        memcpy(color_pass.uniform_data[image_index].mapped, *camera_data, size_of(type_of(camera_data)));

        // @Hardcoded: Create a Material struct, that allocates a descriptor set on a specific pipline and gets bound when needed
        // @Todo: Only write the frame constant data here
        descriptor_writes : [2]VkWriteDescriptorSet;
        buffer_info := VkDescriptorBufferInfo .{
            buffer = color_pass.uniform_data[image_index].buffer,
            offset = 0,
            range = size_of(CameraData),
        };
        descriptor_writes[0] = .{
            dstSet = color_pass.descriptor_sets[image_index][0],
            dstBinding = 0,
            dstArrayElement = 0,
            descriptorType = .UNIFORM_BUFFER,
            descriptorCount = 1,
            pBufferInfo = *buffer_info,
        };

        image_info := VkDescriptorImageInfo.{
            sampler = sampler, // @Hardcoded
            imageView = resources.block_texture.view, // @Hardcoded
            imageLayout = .SHADER_READ_ONLY_OPTIMAL,
        };
        descriptor_writes[1] = .{
            dstSet = color_pass.descriptor_sets[image_index][1],
            dstBinding = 0,
            dstArrayElement = 0,
            descriptorType = .COMBINED_IMAGE_SAMPLER,
            descriptorCount = 1,
            pImageInfo = *image_info,
        };
        vkUpdateDescriptorSets(global_renderer.device, descriptor_writes.count, descriptor_writes.data, 0, null);
        /*
        buffer_info := VkDescriptorBufferInfo .{
            buffer = color_pass.uniform_data[image_index].buffer,
            offset = 0,
            range = size_of(CameraData),
        };
        descriptor_write := VkWriteDescriptorSet.{
            dstSet = color_pass.descriptor_sets[image_index][0],
            dstBinding = 0,
            dstArrayElement = 0,
            descriptorType = .UNIFORM_BUFFER,
            descriptorCount = 1,
            pBufferInfo = *buffer_info,
        };
        vkUpdateDescriptorSets(global_renderer.device, 1, *descriptor_write, 0, null);
        */
    }

    {   // Prepare frame buffer
        vkBeginCommandBuffer(command_buffer, *VkCommandBufferBeginInfo.{flags = .ONE_TIME_SUBMIT_BIT});
        transition_image_layout(swapchain_images[image_index], .UNDEFINED, .COLOR_ATTACHMENT_OPTIMAL, command_buffer);
    }

    {   // Bind pipeline, dynamic state, global descriptors and a default push constant
        vkCmdBindPipeline(command_buffer, .GRAPHICS, color_pass.pipeline);
        vkCmdSetViewport(command_buffer, 0, 1, *VkViewport.{0, 0, xx swapchain_extent.width, xx swapchain_extent.height, 0, 1});
        vkCmdSetScissor(command_buffer, 0, 1, *VkRect2D.{.{0, 0}, swapchain_extent});
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, color_pass.pipeline_layout, 0, 1, *color_pass.descriptor_sets[image_index][0], 0, null);
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, color_pass.pipeline_layout, 1, 1, *color_pass.descriptor_sets[image_index][1], 0, null);
    }

    {   // Reset vertex buffer
        color_pass.vertices.count = 0;
        color_pass.draw_cmds.count = 0;
        color_pass.transform = Matrix4_Identity;
    }

    {   // Begin rendering
        render_info := VkRenderingInfoKHR.{
            renderArea = .{
                offset = .{0, 0},
                extent = swapchain_extent,
            },
            layerCount = 1,
            colorAttachmentCount = 1,
            pColorAttachments = *VkRenderingAttachmentInfoKHR.{
                imageView = swapchain_image_views[image_index],
                imageLayout = .ATTACHMENT_OPTIMAL,
                loadOp = .CLEAR,
                storeOp = .STORE,
                clearValue = VkClearValue.{color = .{_float32 = clear_color.component }},
            },
        };
        vkCmdBeginRendering(command_buffer, *render_info);
    }
}

end_color_pass :: () {
    using global_renderer;
    using context.vk;

    if color_pass.vertices.count > 0 {
        size : u64 = xx (color_pass.vertices.count * size_of(Vertex));
        create_or_update_buffer(*color_pass.vertex_buffer, size, VkBufferUsageFlagBits.VERTEX_BUFFER_BIT | .INDEX_BUFFER_BIT | .UNIFORM_BUFFER_BIT | .STORAGE_BUFFER_BIT | .TRANSFER_SRC_BIT, .UPLOAD);
        copy_data(color_pass.vertex_buffer, color_pass.vertices.data, size);
        offset : u64 = 0;
        vkCmdBindVertexBuffers(command_buffer, 0, 1, *color_pass.vertex_buffer.buffer, *offset);

        // Issue draw calls & end command buffer
        for color_pass.draw_cmds {
            vkCmdPushConstants(command_buffer, color_pass.pipeline_layout, .VERTEX_BIT, 0, size_of(PushConstantData), *PushConstantData.{transpose(it.xform)});
            vkCmdDraw(command_buffer, it.count, 1, it.id, 0);
        }
    }

    vkCmdEndRendering(command_buffer);

    {   // Transition image for present & end command buffer
        transition_image_layout(swapchain_images[image_index], .COLOR_ATTACHMENT_OPTIMAL, .PRESENT_SRC_KHR, command_buffer);
        Vk_Check(vkEndCommandBuffer(command_buffer));
    }
   
}
