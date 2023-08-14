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

create_standard_renderpass :: (device: VkDevice) -> VkRenderPass {
    format := global_renderer.surface_format.format;
    depth_format := global_renderer.depth_format;

    attachments := VkAttachmentDescription.[
    .{
        format = format,
        samples = ._1_BIT,
        loadOp = .CLEAR,
        storeOp = .STORE,
        stencilLoadOp = .DONT_CARE,
        stencilStoreOp = .DONT_CARE,
        initialLayout = .UNDEFINED,
        finalLayout = .PRESENT_SRC_KHR,
    },
    .{
        format = depth_format,
        samples = ._1_BIT,
        loadOp = .CLEAR,
        storeOp = .STORE,
        stencilLoadOp = .DONT_CARE,
        stencilStoreOp = .DONT_CARE,
        initialLayout = .UNDEFINED,
        finalLayout = .DEPTH_STENCIL_ATTACHMENT_OPTIMAL,
    }];

    create_info := VkRenderPassCreateInfo.{
        attachmentCount = attachments.count,
        pAttachments = attachments.data,
        subpassCount = 1,
        pSubpasses = *VkSubpassDescription.{
            pipelineBindPoint = .GRAPHICS,
            colorAttachmentCount = 1,
            pColorAttachments = *VkAttachmentReference.{
                attachment = 0,
                layout = .COLOR_ATTACHMENT_OPTIMAL,
            },
            pDepthStencilAttachment = *VkAttachmentReference.{
                attachment = 1,
                layout = .DEPTH_STENCIL_ATTACHMENT_OPTIMAL
            },
        },
        dependencyCount = 1,
        pDependencies = *VkSubpassDependency.{
            srcSubpass = VK_SUBPASS_EXTERNAL,
            dstSubpass = 0,
            srcStageMask = .COLOR_ATTACHMENT_OUTPUT_BIT | .EARLY_FRAGMENT_TESTS_BIT,
            dstStageMask = .COLOR_ATTACHMENT_OUTPUT_BIT | .EARLY_FRAGMENT_TESTS_BIT,
            srcAccessMask = 0,
            dstAccessMask = .COLOR_ATTACHMENT_WRITE_BIT | .DEPTH_STENCIL_ATTACHMENT_WRITE_BIT,
            dependencyFlags = 0,
        },
    };
    render_pass: VkRenderPass = ---;
    Vk_Check(vkCreateRenderPass(device, *create_info, null, *render_pass));
    return render_pass;
}

create_shadowmap_renderpass :: (device: VkDevice) -> VkRenderPass {
    format := global_renderer.surface_format.format;
    depth_format := global_renderer.depth_format;

    attachments := VkAttachmentDescription.[
    .{
        format = depth_format,
        samples = ._1_BIT,
        loadOp = .CLEAR,
        storeOp = .STORE,
        stencilLoadOp = .DONT_CARE,
        stencilStoreOp = .DONT_CARE,
        initialLayout = .UNDEFINED,
        finalLayout = .DEPTH_STENCIL_READ_ONLY_OPTIMAL,
    }];

    dependencies := VkSubpassDependency.[
    .{
        srcSubpass = VK_SUBPASS_EXTERNAL,
        dstSubpass = 0,
        srcStageMask = .FRAGMENT_SHADER_BIT, 
        dstStageMask = .EARLY_FRAGMENT_TESTS_BIT,
        srcAccessMask = .SHADER_READ_BIT,
        dstAccessMask = .DEPTH_STENCIL_ATTACHMENT_WRITE_BIT,
        dependencyFlags = .BY_REGION_BIT,
    },
    .{
        srcSubpass = 0,
        dstSubpass = VK_SUBPASS_EXTERNAL,
        srcStageMask = .LATE_FRAGMENT_TESTS_BIT, 
        dstStageMask = .FRAGMENT_SHADER_BIT,
        srcAccessMask = .DEPTH_STENCIL_ATTACHMENT_WRITE_BIT,
        dstAccessMask = .SHADER_READ_BIT,
        dependencyFlags = .BY_REGION_BIT,
    }];

    create_info := VkRenderPassCreateInfo.{
        attachmentCount = attachments.count,
        pAttachments = attachments.data,
        subpassCount = 1,
        pSubpasses = *VkSubpassDescription.{
            pipelineBindPoint = .GRAPHICS,
            colorAttachmentCount = 0,
            pDepthStencilAttachment = *VkAttachmentReference.{
                attachment = 0,
                layout = .DEPTH_STENCIL_ATTACHMENT_OPTIMAL
            },
        },
        dependencyCount = dependencies.count,
        pDependencies = dependencies.data
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
    defer free(file);

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
        imageUsage = .COLOR_ATTACHMENT_BIT | .TRANSFER_DST_BIT,
        imageSharingMode = .EXCLUSIVE,
        preTransform = surface_capabilities.currentTransform,
        compositeAlpha = .OPAQUE_BIT_KHR,
        presentMode = present_mode,
        clipped = VK_TRUE,
        oldSwapchain = old_swapchain
    };
    Vk_Check(vkCreateSwapchainKHR(device, *create_info, null, *swapchain));

    if old_swapchain != VK_NULL_HANDLE {
        for framebuffers {
            vkDestroyFramebuffer(device, it, null);
        }

        for swapchain_image_views {
            vkDestroyImageView(device, it, null);
        }
        swapchain_image_views.count = 0;

        vkDestroySwapchainKHR(device, old_swapchain, null);
        swapchain_images.count = 0;

        Texture.destroy(*depth_texture);
    }

    swapchain_images = fill_array(VkImage, vkGetSwapchainImagesKHR, device, swapchain, allocator = context.allocator);

    for swapchain_images {
        image_view := make_image_view(it, surface_format.format);
        array_add(*swapchain_image_views, image_view);

    }

    {   // Depth image
        depth_texture = Texture.create(swapchain_extent.width, swapchain_extent.height, depth_format, .DEPTH_STENCIL_ATTACHMENT_BIT, .DEPTH_BIT | .STENCIL_BIT);
        transition_image_layout(depth_texture.image, .UNDEFINED, .DEPTH_STENCIL_ATTACHMENT_OPTIMAL);
    }

    create_framebuffers();

    log("Swapchain created:");
    log("\tFormat: %", surface_format.format);
    log("\tPresent mode: %", present_mode);
    log("\tImage count: %", image_count);
    log("\tExtent: %", swapchain_extent);
}

create_descriptor_set_layout :: (device: VkDevice, bindings: []VkDescriptorSetLayoutBinding) -> VkDescriptorSetLayout {
    result : VkDescriptorSetLayout;
    layout_info := VkDescriptorSetLayoutCreateInfo.{
        bindingCount = xx bindings.count,
        pBindings = bindings.data,
    };
    Vk_Check(vkCreateDescriptorSetLayout(device, *layout_info, null, *result));
    return result;
}