Render_Pass :: struct {
    render_pass: VkRenderPass;
    descriptor_pool: VkDescriptorPool;
    descriptor_set_layout: VkDescriptorSetLayout;
    pipeline_layout: VkPipelineLayout;
    pipeline: VkPipeline;

    uniform_data: [Renderer.FRAME_COUNT] Buffer;
    descriptor_sets: [Renderer.FRAME_COUNT] VkDescriptorSet;
    sampler: VkSampler;
}

create_renderpass :: (device: VkDevice, format: VkFormat) -> VkRenderPass{
    create_info := VkRenderPassCreateInfo.{
        attachmentCount = 1,
        pAttachments = *VkAttachmentDescription.{
            format = format,
            samples = ._1_BIT,
            loadOp = .CLEAR,
            storeOp = .STORE,
            stencilLoadOp = .DONT_CARE,
            stencilStoreOp = .DONT_CARE,
            initialLayout = .UNDEFINED,
            finalLayout = .PRESENT_SRC_KHR,
        },
        subpassCount = 1,
        pSubpasses = *VkSubpassDescription.{
            pipelineBindPoint = .GRAPHICS,
            colorAttachmentCount = 1,
            pColorAttachments = *VkAttachmentReference.{
                attachment = 0,
                layout = .COLOR_ATTACHMENT_OPTIMAL,
            },
        },
        dependencyCount = 1,
        pDependencies = *VkSubpassDependency.{
            srcSubpass = VK_SUBPASS_EXTERNAL,
            dstSubpass = 0,
            srcStageMask = .COLOR_ATTACHMENT_OUTPUT_BIT,
            dstStageMask = .COLOR_ATTACHMENT_OUTPUT_BIT,
            srcAccessMask = 0,
            dstAccessMask = VkAccessFlagBits.COLOR_ATTACHMENT_READ_BIT | .COLOR_ATTACHMENT_WRITE_BIT,
            dependencyFlags = 0,
        },
    };
    render_pass: VkRenderPass = ---;
    Vk_Check(vkCreateRenderPass(device, *create_info, null, *render_pass));
    return render_pass;
}


init_color_pass :: (device: VkDevice) -> Render_Pass {
    color_pass : Render_Pass;

    // Render pass
    color_pass.render_pass = create_renderpass(device, global_renderer.surface_format.format);

    // Pipeline
    {
        vtx := create_shader_module(device, "shaders/shader.vert.spv");
        defer vkDestroyShaderModule(device, vtx, null);

        frag := create_shader_module(device, "shaders/shader.frag.spv");
        defer vkDestroyShaderModule(device, frag, null);

        bindings : [2]VkDescriptorSetLayoutBinding;
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

        layout_info := VkDescriptorSetLayoutCreateInfo.{
            bindingCount = bindings.count,
            pBindings = bindings.data,
        };        
        
        Vk_Check(vkCreateDescriptorSetLayout(device, *layout_info, null, *color_pass.descriptor_set_layout));

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
            setLayoutCount = 1,
            pSetLayouts = *color_pass.descriptor_set_layout,
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
            renderPass = color_pass.render_pass,
        };
        vkCreateGraphicsPipelines(device, null, 1, *create_info, null, *color_pass.pipeline);
        log("Pipeline created.");
    }

    // Sampler 
    {
        create_info := VkSamplerCreateInfo.{
            magFilter = .NEAREST,
            minFilter = .NEAREST,
            addressModeU = .REPEAT,
            addressModeV = .REPEAT,
            addressModeW = .REPEAT,
            anisotropyEnable = VK_TRUE,
            maxAnisotropy = global_renderer.physical_device_properties.limits.maxSamplerAnisotropy,
            borderColor = .INT_OPAQUE_BLACK,
            unnormalizedCoordinates = VK_FALSE,
            compareEnable = VK_FALSE,
            compareOp = .ALWAYS,
            mipmapMode = .LINEAR,
            mipLodBias = 0,
            minLod = 0,
            maxLod = 0,
        };
        Vk_Check(vkCreateSampler(device, *create_info, null, *color_pass.sampler));
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
            descriptorCount = Renderer.FRAME_COUNT,
        };

        pool_info := VkDescriptorPoolCreateInfo.{
            poolSizeCount = pool_sizes.count,
            pPoolSizes = pool_sizes.data,
            maxSets = Renderer.FRAME_COUNT,
        };
        Vk_Check(vkCreateDescriptorPool(device, *pool_info, null, *color_pass.descriptor_pool));

        alloc_info := VkDescriptorSetAllocateInfo.{
            descriptorPool = color_pass.descriptor_pool,
            descriptorSetCount = 1,
            pSetLayouts = *color_pass.descriptor_set_layout,
        };

        for *color_pass.descriptor_sets {
            Vk_Check(vkAllocateDescriptorSets(device, *alloc_info, it));
            
        }
    }


    return color_pass;

}

destroy_color_pass :: (using color_pass: *Render_Pass, device: VkDevice) {
    vkDestroySampler(device, sampler, null);
    vkDestroyDescriptorSetLayout(device, descriptor_set_layout, null);
    vkDestroyPipelineLayout(device, pipeline_layout, null);
    vkDestroyPipeline(device, pipeline, null);
    vkDestroyRenderPass(device, render_pass, null);
    for uniform_data {
        destroy_buffer(it);
    }
}

begin_pass :: (pass: Render_Pass, clear_color: Vector4) {
    using global_renderer;
    using context.vk_frame_data;
    vkCmdBeginRenderPass(command_buffer, *VkRenderPassBeginInfo.{
        renderPass = pass.render_pass,
        framebuffer = framebuffers[image_index],
        clearValueCount = 1,
        pClearValues = *VkClearValue.{color = .{_float32 = clear_color.component }},
        renderArea = .{
            offset = .{0, 0},
            extent = swapchain_extent,
        },
    }, .INLINE);
    vkCmdBindPipeline(command_buffer, .GRAPHICS, pass.pipeline);
    set_transform_matrix(Matrix4_Identity);
    vkCmdSetViewport(command_buffer, 0, 1, *VkViewport.{0, 0, xx swapchain_extent.width, xx swapchain_extent.height, 0, 1});
    vkCmdSetScissor(command_buffer, 0, 1, *VkRect2D.{.{0, 0}, swapchain_extent});
    update_descriptors(pass, image_index, resources.block_texture);
    vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pass.pipeline_layout, 0, 1, *pass.descriptor_sets[image_index], 0, null);
}

update_descriptors :: (pass: Render_Pass, id : u32, texture: Texture) {
    descriptor_writes : [2]VkWriteDescriptorSet;
    buffer_info := VkDescriptorBufferInfo .{
        buffer = pass.uniform_data[id].buffer,
        offset = 0,
        range = size_of(CameraData),
    };
    descriptor_writes[0] = .{
        dstSet = pass.descriptor_sets[id],
        dstBinding = 0,
        dstArrayElement = 0,
        descriptorType = .UNIFORM_BUFFER,
        descriptorCount = 1,
        pBufferInfo = *buffer_info,
    };

    image_info := VkDescriptorImageInfo.{
        sampler = pass.sampler,
        imageView = texture.view,
        imageLayout = .SHADER_READ_ONLY_OPTIMAL,
    };
    descriptor_writes[1] = .{
        dstSet = pass.descriptor_sets[id],
        dstBinding = 1,
        dstArrayElement = 0,
        descriptorType = .COMBINED_IMAGE_SAMPLER,
        descriptorCount = 1,
        pImageInfo = *image_info,
    };
    vkUpdateDescriptorSets(global_renderer.device, descriptor_writes.count, descriptor_writes.data, 0, null);
    
}