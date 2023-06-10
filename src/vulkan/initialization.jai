create_sampler :: (device: VkDevice) -> VkSampler {
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

    result : VkSampler = ---;
    Vk_Check(vkCreateSampler(device, *create_info, null, *result));
    return result;
}

create_renderpass :: (device: VkDevice, format: VkFormat) -> VkRenderPass {
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

create_shader_module :: (device: VkDevice, path: string) -> VkShaderModule {
    result : VkShaderModule = VK_NULL_HANDLE;

    file, success := read_entire_file(path);
    assert(success, "Unable to read %!", path);
    if !success then return result;

    create_info := VkShaderModuleCreateInfo.{
        codeSize = xx file.count,
        pCode = xx file.data,
    };
    Vk_Check(vkCreateShaderModule(device, *create_info, null, *result));
    return result;
}

create_or_update_swapchain :: () {
    using global_renderer;
    Vk_Check(vkDeviceWaitIdle(device));

    present_modes := fill_array(VkPresentModeKHR, vkGetPhysicalDeviceSurfacePresentModesKHR, physical_device, surface);
    present_mode : VkPresentModeKHR = .FIFO_KHR;
    for present_modes {
        if it == .MAILBOX_KHR then present_mode = .MAILBOX_KHR;
        break;
    }
    image_count := ifx present_mode == .MAILBOX_KHR then 3 else 2;

    surface_capabilities: VkSurfaceCapabilitiesKHR;
    vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physical_device, surface, *surface_capabilities);

    swapchain_extent = surface_capabilities.currentExtent;
    if swapchain_extent.width == U32_MAX {
        w : s32 = ---;
        h : s32 = ---;
        SDL_GetWindowSize(window, *w, *h);
        swapchain_extent.width  = clamp(cast(u32) w, surface_capabilities.minImageExtent.width, surface_capabilities.maxImageExtent.width);
        swapchain_extent.height = clamp(cast(u32) h, surface_capabilities.minImageExtent.height, surface_capabilities.maxImageExtent.height);
    }
    old_swapchain := swapchain;

    create_info := VkSwapchainCreateInfoKHR.{
        surface = surface,
        minImageCount = xx image_count,
        imageFormat = surface_format.format,
        imageColorSpace = surface_format.colorSpace,
        imageExtent = swapchain_extent,
        imageArrayLayers = 1,
        imageUsage = VkImageUsageFlagBits.COLOR_ATTACHMENT_BIT | .TRANSFER_DST_BIT,
        imageSharingMode = .EXCLUSIVE,
        preTransform = surface_capabilities.currentTransform,
        compositeAlpha = .OPAQUE_BIT_KHR,
        presentMode = present_mode,
        clipped = VK_TRUE,
        oldSwapchain = old_swapchain
    };
    Vk_Check(vkCreateSwapchainKHR(device, *create_info, null, *swapchain));

    if old_swapchain != VK_NULL_HANDLE {
        for swapchain_image_views {
            vkDestroyImageView(device, it, null);
        }
        swapchain_image_views.count = 0;

        vkDestroySwapchainKHR(device, old_swapchain, null);
        swapchain_images.count = 0;
    }

    swapchain_images = fill_array(VkImage, vkGetSwapchainImagesKHR, device, swapchain, allocator = context.allocator);

    for swapchain_images{
        image_view := make_image_view(it, surface_format.format);
        array_add(*swapchain_image_views, image_view);
    }
    log("Swapchain created:");
    log("\tFormat: %", surface_format.format);
    log("\tPresent mode: %", present_mode);
    log("\tImage count: %", image_count);
    log("\tExtent: %", swapchain_extent);
}

pipeline_create_info :: (vertex_shader: VkShaderModule, fragment_shader: VkShaderModule, layout: VkPipelineLayout) -> VkGraphicsPipelineCreateInfo #expand {
    `stages : [2]VkPipelineShaderStageCreateInfo;
    stages[0] = .{stage = .VERTEX_BIT,   module = vertex_shader, pName = "main"};
    stages[1] = .{stage = .FRAGMENT_BIT, module = fragment_shader, pName = "main"};
            /* Non constant array litterals pls
        stages := VkPipelineShaderStageCreateInfo.[
            .{stage = .VERTEX_BIT,   module = vertex_shader, pName = "main"},
            .{stage = .FRAGMENT_BIT, module = vertex_shader, pName = "main"},
        ]; */     

    `dynamic_state := VkDynamicState.[.VIEWPORT, .SCISSOR];

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
        layout = layout,
    };
    return create_info;
}