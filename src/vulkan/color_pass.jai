Render_Pass :: struct {
    descriptor_set_layouts: [2]VkDescriptorSetLayout;
    pipeline_layout: VkPipelineLayout;
    pipeline: VkPipeline;

    descriptor_sets: [Renderer.FRAME_COUNT][2] VkDescriptorSet;

    uniform_data: [Renderer.FRAME_COUNT] Buffer;
}

create_color_pass :: (device: VkDevice) -> Render_Pass {
    color_pass : Render_Pass;

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

        create_info := pipeline_create_info(vtx, frag, color_pass.pipeline_layout);
        vkCreateGraphicsPipelines(device, null, 1, *create_info, null, *color_pass.pipeline);
        log("Pipeline created.");
    }

    // DescriptorSet
    {
        
        alloc_info := VkDescriptorSetAllocateInfo.{
            descriptorPool = global_renderer.descriptor_pool,
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
    for descriptor_set_layouts {
        vkDestroyDescriptorSetLayout(device, it, null);
    }
    vkDestroyPipelineLayout(device, pipeline_layout, null);
    vkDestroyPipeline(device, pipeline, null);
    for *uniform_data {
        destroy_buffer(it);
    }
    
}

draw_color_pass :: (dd: *Draw_Data) {
    using global_renderer;
    using context.vk;

    {   // Prepare frame buffer
        vkBeginCommandBuffer(command_buffer, *VkCommandBufferBeginInfo.{flags = .ONE_TIME_SUBMIT_BIT});
        transition_image_layout(swapchain_images[image_index], .UNDEFINED, .COLOR_ATTACHMENT_OPTIMAL, command_buffer);
    }

    if dd.vertices.count > 0 {

        {   // Bind pipeline, dynamic state, global descriptors and a default push constant
            vkCmdBindPipeline(command_buffer, .GRAPHICS, color_pass.pipeline);
            vkCmdSetViewport(command_buffer, 0, 1, *VkViewport.{0, 0, xx swapchain_extent.width, xx swapchain_extent.height, 0, 1});
            vkCmdSetScissor(command_buffer, 0, 1, *VkRect2D.{.{0, 0}, swapchain_extent});
            vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, color_pass.pipeline_layout, 0, 1, *color_pass.descriptor_sets[image_index][0], 0, null);
            vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, color_pass.pipeline_layout, 1, 1, *color_pass.descriptor_sets[image_index][1], 0, null);
        }

        clear_color := Vector4.{0, 0, 0, 1};
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

    
        size : u64 = xx (dd.vertices.count * size_of(Vertex));
        create_or_update_buffer(*dd.vertex_buffer, size, VkBufferUsageFlagBits.VERTEX_BUFFER_BIT | .INDEX_BUFFER_BIT | .UNIFORM_BUFFER_BIT | .STORAGE_BUFFER_BIT | .TRANSFER_SRC_BIT, .UPLOAD);
        copy_data(dd.vertex_buffer, dd.vertices.data, size);
        offset : u64 = 0;
        vkCmdBindVertexBuffers(command_buffer, 0, 1, *dd.vertex_buffer.buffer, *offset);

        // Issue draw calls & end command buffer
        for dd.draw_cmds {
            vkCmdPushConstants(command_buffer, color_pass.pipeline_layout, .VERTEX_BIT, 0, size_of(PushConstantData), *PushConstantData.{transpose(it.xform)});
            vkCmdDraw(command_buffer, it.count, 1, it.id, 0);
        }

        vkCmdEndRendering(command_buffer);
    }

    {   // Transition image for present & end command buffer
        transition_image_layout(swapchain_images[image_index], .COLOR_ATTACHMENT_OPTIMAL, .PRESENT_SRC_KHR, command_buffer);
        Vk_Check(vkEndCommandBuffer(command_buffer));
    }
   
}
