Swapchain :: struct {
    handle: VkSwapchainKHR = VK_NULL_HANDLE;
    format: VkSurfaceFormatKHR;
    extent: VkExtent2D;
    images: [..]VkImage;
    image_views: [..]VkImageView;
    framebuffers: [FRAMES_IN_FLIGHT]VkFramebuffer;
    depth_texture: Texture;

    FRAMES_IN_FLIGHT :: 2;
}

swapchain_create_or_update :: (self: *Swapchain, device: VkDevice, physical_device: VkPhysicalDevice, surface: VkSurfaceKHR, window: *SDL_Window) {
    vkDeviceWaitIdle(device);

    present_modes := fill_array(VkPresentModeKHR, vkGetPhysicalDeviceSurfacePresentModesKHR, physical_device, surface);
    present_mode : VkPresentModeKHR = .FIFO_KHR;
    log("Present modes:"); 
    for present_modes {
        log("\t%", it);
        if it == .MAILBOX_KHR {
            present_mode = .MAILBOX_KHR;
            break;
        }
    }
    image_count := ifx present_mode == .MAILBOX_KHR then 3 else 2;

    surface_capabilities: VkSurfaceCapabilitiesKHR;
    vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physical_device, surface, *surface_capabilities);

    self.extent = surface_capabilities.currentExtent;
    if self.extent.width == U32_MAX {
        w : s32 = ---;
        h : s32 = ---;
        SDL_GetWindowSize(window, *w, *h);
        self.extent.width  = clamp(cast(u32) w, surface_capabilities.minImageExtent.width, surface_capabilities.maxImageExtent.width);
        self.extent.height = clamp(cast(u32) h, surface_capabilities.minImageExtent.height, surface_capabilities.maxImageExtent.height);
    }
    old_swapchain := self.handle;

    create_info := VkSwapchainCreateInfoKHR.{
        surface = surface,
        minImageCount = xx image_count,
        imageFormat = self.format.format,
        imageColorSpace = self.format.colorSpace,
        imageExtent = self.extent,
        imageArrayLayers = 1,
        imageUsage = .COLOR_ATTACHMENT_BIT | .TRANSFER_DST_BIT,
        imageSharingMode = .EXCLUSIVE,
        preTransform = surface_capabilities.currentTransform,
        compositeAlpha = .OPAQUE_BIT_KHR,
        presentMode = present_mode,
        clipped = VK_TRUE,
        oldSwapchain = old_swapchain
    };
    new_swapchain: VkSwapchainKHR = ---;
    Vk_Check(vkCreateSwapchainKHR(device, *create_info, null, *new_swapchain));

    if old_swapchain != VK_NULL_HANDLE {
        destroy(self, device, true);
    }

    self.handle = new_swapchain;

    self.images = fill_array(VkImage, vkGetSwapchainImagesKHR, device, self.handle, allocator = context.allocator);

    for self.images {
        image_view := make_image_view(it, self.format.format);
        debug_name_object(image_view, "Swapchain image view");
        debug_name_object(it, "Swapchain image");
        array_add(*self.image_views, image_view);
    }

    {   // Depth image
        self.depth_texture = texture_create(self.extent.width, self.extent.height, Renderer.DEPTH_FORMAT, .DEPTH_STENCIL_ATTACHMENT_BIT, .DEPTH_BIT | .STENCIL_BIT, "Swapchain Depth Texture");
        transition_texture_layout(*self.depth_texture, .DEPTH_STENCIL_ATTACHMENT_OPTIMAL);
    }

    attachments := VkImageView.[
        self.image_views[0],
        self.depth_texture.view
    ];

    // @Cleanup: Dynamic Rendering
    // framebuffer_ci := VkFramebufferCreateInfo.{
    //     renderPass = global_renderer.standard_render_pass, // @Hardcoded
    //     attachmentCount = attachments.count,
    //     pAttachments = attachments.data,
    //     width = self.extent.width,
    //     height = self.extent.height,
    //     layers = 1,
    // };
    // Vk_Check(vkCreateFramebuffer(device, *framebuffer_ci, null, *self.framebuffers[0]));
    // attachments[0] = self.image_views[1];
    // Vk_Check(vkCreateFramebuffer(device, *framebuffer_ci, null, *self.framebuffers[1]));

    log("Swapchain created:");
    log("\tFormat: %", self.format.format);
    log("\tPresent mode: %", present_mode);
    log("\tImage count: %", image_count);
    log("\tExtent: %", self.extent);
}

destroy :: (using self: *Swapchain, device: VkDevice, $soft := false) {
    for framebuffers {
        vkDestroyFramebuffer(device, it, null);
    }

    for image_views {
        vkDestroyImageView(device, it, null);
    }
    #if soft {
        image_views.count = 0;
        images.count = 0;
    } else {
        array_reset(*image_views);
        array_reset(*images);
    }
    destroy(*depth_texture);

    vkDestroySwapchainKHR(device, handle, null);
}

swapchain_pick_format :: (physical_device: VkPhysicalDevice, surface: VkSurfaceKHR) -> VkSurfaceFormatKHR {
    result: VkSurfaceFormatKHR;
    surface_formats := fill_array(VkSurfaceFormatKHR, vkGetPhysicalDeviceSurfaceFormatsKHR, physical_device, surface);
    result = surface_formats[0];
    if result.format == .UNDEFINED then result.format = .B8G8R8A8_UNORM;
    return result;
}