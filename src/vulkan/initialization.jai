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