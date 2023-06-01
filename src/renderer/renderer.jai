
Renderer :: struct {
    instance: VkInstance;
    debug_messenger: VkDebugUtilsMessengerEXT;
    surface: VkSurfaceKHR;
    physical_device: VkPhysicalDevice;

    window: *SDL_Window;
    device: VkDevice;
    queue_family_index: u32;
    graphics_queue: VkQueue;

    swapchain: VkSwapchainKHR;
    swapchain_extent: VkExtent2D;
    swapchain_images: [..]VkImage;
    surface_format: VkSurfaceFormatKHR;
    swapchain_image_views: [..]VkImageView;
    framebuffers: [..]VkFramebuffer;
    
    FRAME_COUNT :: 2;
    frame_index := 0;
    
    command_pool : VkCommandPool;
    frame_data: [FRAME_COUNT]Frame_Data;

    render_pass: VkRenderPass;
    pipeline_layout: VkPipelineLayout;
    descriptor_set_layout: VkDescriptorSetLayout;
    pipeline: VkPipeline;

    sampler: VkSampler;

    // Mem
    REGION_SIZE :: 64 * 1024;
    BUFFER_SIZE :: FRAME_COUNT * REGION_SIZE;

    memory_properties: VkPhysicalDeviceMemoryProperties;
    MemoryType :: enum {
        READBACK :: 0; // HOST_VISIBLE_BIT | .HOST_CACHED_BIT
        UPLOAD;        // HOST_VISIBLE_BIT | .HOST_COHERENT_BIT
        LOCAL;         // DEVICE_LOCAL_BIT
        COUNT;
    }
    compatible_mem_types: [MemoryType.COUNT]u32;

    // Buf
    upload_buffer: Buffer;
    buffer: *void;

    // Immediate
    MAX_VERTICES :: REGION_SIZE / size_of(Vertex);
    nb_vertices: u32;
}

Frame_Data :: struct {
    command_buffer: VkCommandBuffer;
    frame_fence: VkFence;
    image_available_semaphore: VkSemaphore;
    render_finished_semaphore: VkSemaphore;
    uniform: Buffer;
    image_index: u32;
}

global_renderer: Renderer;

PushConstantData :: struct {
    transform: Matrix4;
}

panic :: () {
    write_string("Panic");
    breakpoint();
    abort();
}

debug_callback :: (severity: VkDebugUtilsMessageSeverityFlagsEXT, type: VkDebugUtilsMessageTypeFlagsEXT, callback_data: *VkDebugUtilsMessengerCallbackDataEXT,  data: *void) -> VkBool32 #c_call {
    ctx := << cast(*Context) data;
    push_context ctx {
        msg := to_string(callback_data.pMessage);
        log("%: %", severity, msg);
    }
    return VK_TRUE;
}

renderer_init :: (window: *SDL_Window) -> Renderer {
    renderer := *global_renderer;

    // Create instance
    {
        layers: [..]*u8; 
        layers.allocator = temp;
        array_add(*layers, temp_c_string("VK_LAYER_KHRONOS_validation"));

        extensions: [..]*u8;
        extensions.allocator = temp;
        
        nb : u32;
        SDL_Vulkan_GetInstanceExtensions(window, *nb, null);
        array_reserve(*extensions, nb);
        SDL_Vulkan_GetInstanceExtensions(window, *nb, extensions.data);
        extensions.count += nb;

        array_add(*extensions, temp_c_string("VK_EXT_debug_utils"));
        log("Extensions:");
        for ext : extensions {
            log("\t%", to_string(ext));
        }

        create_info := VkInstanceCreateInfo.{
            enabledLayerCount = xx layers.count,
            ppEnabledLayerNames = layers.data,
            enabledExtensionCount = xx extensions.count,
            ppEnabledExtensionNames = extensions.data,
        };
        Vk_Check(vkCreateInstance(*create_info, null, *renderer.instance));
        log("Instance created.");
    }

    load_function_pointers(renderer.instance);
    SDL_Vulkan_CreateSurface(window, renderer.instance, *renderer.surface);

    renderer.window = window;
    
    // Create debug msger
    {
        create_info := VkDebugUtilsMessengerCreateInfoEXT.{
            messageSeverity = VkDebugUtilsMessageSeverityFlagBitsEXT.WARNING_BIT_EXT | .ERROR_BIT_EXT,
            messageType = VkDebugUtilsMessageTypeFlagBitsEXT.GENERAL_BIT_EXT | .VALIDATION_BIT_EXT | .PERFORMANCE_BIT_EXT,
            pfnUserCallback = debug_callback,
            pUserData = *context,
        };
        Vk_Check(vkCreateDebugUtilsMessengerEXT(renderer.instance, *create_info, null, *renderer.debug_messenger));
        log("Debug messenger created.");
    }

    physical_device_properties: VkPhysicalDeviceProperties = ---;
    // Pick device 
    {
        physical_devices := fill_array(VkPhysicalDevice, vkEnumeratePhysicalDevices, renderer.instance);
        if(physical_devices.count <= 0) {
            log_error("No physical device found!");
            panic();
        }

        for device : physical_devices {
            // @Robustness: Better picking:
            // - Check extensions
            // - Pick depending on queues
            vkGetPhysicalDeviceProperties(device, *physical_device_properties);
            if (physical_device_properties.deviceType == .DISCRETE_GPU) {
                renderer.physical_device = device;
                log("Physical device: %", to_string(physical_device_properties.deviceName));
                break;
            }
        }
        if (!renderer.physical_device) {
            renderer.physical_device = physical_devices[0];
            vkGetPhysicalDeviceProperties(renderer.physical_device, *physical_device_properties);
        }
        
    }

    // Queue Families
    {
        // @Robustness: Handle the case where present and graphics are different
        queue_families := fill_array(VkQueueFamilyProperties, vkGetPhysicalDeviceQueueFamilyProperties, renderer.physical_device);
        found := false;
        for queue_families {
            supports_present := VK_FALSE;
            vkGetPhysicalDeviceSurfaceSupportKHR(renderer.physical_device, xx it_index, renderer.surface, *supports_present);
            if supports_present && (it.queueFlags & .GRAPHICS_BIT) {
                renderer.queue_family_index = xx it_index;
                found = true;
                break;
            }
        }
        assert(found, "No queue found.");
    }

    // Create device
    { 
        queue_create_info := VkDeviceQueueCreateInfo.{
            queueFamilyIndex = renderer.queue_family_index,
            queueCount = 1,
            pQueuePriorities = float.[1].data,
        };
        device_features := VkPhysicalDeviceFeatures.{
            samplerAnisotropy = VK_TRUE,
        };
        exts := *u8.[VK_KHR_SWAPCHAIN_EXTENSION_NAME.data];
        create_info := VkDeviceCreateInfo.{
            pQueueCreateInfos = *queue_create_info,
            queueCreateInfoCount = 1,
            pEnabledFeatures = *device_features,
            enabledExtensionCount = exts.count,
            ppEnabledExtensionNames = exts.data,
        };
        Vk_Check(vkCreateDevice(renderer.physical_device, *create_info, null, *renderer.device));
        log("Device created.");
    }

    // Fetch queues
    {
        vkGetDeviceQueue(renderer.device, renderer.queue_family_index, 0, *renderer.graphics_queue);
    }

    // Swapchain format 
    {
        surface_formats := fill_array(VkSurfaceFormatKHR, vkGetPhysicalDeviceSurfaceFormatsKHR, renderer.physical_device, renderer.surface);
        renderer.surface_format = surface_formats[0];
        renderer.surface_format.format = ifx renderer.surface_format.format == .UNDEFINED then .B8G8R8A8_UNORM else renderer.surface_format.format;
    }

    // Render pass
    renderer.render_pass = create_renderpass(renderer.device, renderer.surface_format.format);

    // Swapchain
    create_or_update_swapchain();
    log("Swapchain created");

    // Frame data
    {
        cmd_pool_ci := VkCommandPoolCreateInfo.{
            flags = .RESET_COMMAND_BUFFER_BIT,
            queueFamilyIndex = renderer.queue_family_index,
        };
        vkCreateCommandPool(renderer.device, *cmd_pool_ci, null, *renderer.command_pool);

        for *renderer.frame_data {
            cmd_buff_ci := VkCommandBufferAllocateInfo.{
                commandPool = renderer.command_pool,
                level = .PRIMARY,
                commandBufferCount = 1,
            };
            vkAllocateCommandBuffers(renderer.device, *cmd_buff_ci, *it.command_buffer);

            semaphore_ci := VkSemaphoreCreateInfo.{};
            vkCreateSemaphore(renderer.device, *semaphore_ci, null, *it.image_available_semaphore);
            vkCreateSemaphore(renderer.device, *semaphore_ci, null, *it.render_finished_semaphore);

            fence_ci := VkFenceCreateInfo.{
                flags = .SIGNALED_BIT,
            };
            vkCreateFence(renderer.device, *fence_ci, null, *it.frame_fence);
        }
        log("Rendering context created");
    }

    // Pipeline
    {
        vtx := create_shader_module(renderer.device, "shaders/shader.vert.spv");
        defer vkDestroyShaderModule(renderer.device, vtx, null);

        frag := create_shader_module(renderer.device, "shaders/shader.frag.spv");
        defer vkDestroyShaderModule(renderer.device, frag, null);

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
        
        Vk_Check(vkCreateDescriptorSetLayout(renderer.device, *layout_info, null, *renderer.descriptor_set_layout));

        /*
        for 0..Renderer.FRAME_COUNT {
            renderer.frame_data[it].uniform = create_buffer(
        }
        */

        push_constant_ci := VkPushConstantRange.{
            stageFlags = .VERTEX_BIT,
            offset = 0,
            size = size_of(PushConstantData),
        };

        layout_ci := VkPipelineLayoutCreateInfo.{ 
            pushConstantRangeCount = 1,
            pPushConstantRanges = *push_constant_ci,
            setLayoutCount = 1,
            pSetLayouts = *renderer.descriptor_set_layout,
        };
        vkCreatePipelineLayout(renderer.device, *layout_ci, null, *renderer.pipeline_layout);

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
            layout = renderer.pipeline_layout,
            renderPass = renderer.render_pass,
        };
        vkCreateGraphicsPipelines(renderer.device, null, 1, *create_info, null, *renderer.pipeline);
        log("Pipeline created.");
    }

    // Memory
    {
        find_compatible_memory_type :: (prop: *VkPhysicalDeviceMemoryProperties, flags: VkMemoryPropertyFlags) -> u32 {
            count := prop.memoryTypeCount;
            compatible_types : u32 = 0;
            for 0..count-1 {
                is_compat : u32 = xx ((prop.memoryTypes[it].propertyFlags & flags) == flags);
                compatible_types |= (is_compat << it);
            }
            return compatible_types;
        }
        vkGetPhysicalDeviceMemoryProperties(renderer.physical_device, *renderer.memory_properties);
        renderer.compatible_mem_types[Renderer.MemoryType.READBACK] = find_compatible_memory_type(*renderer.memory_properties, VkMemoryPropertyFlagBits.HOST_VISIBLE_BIT | .HOST_CACHED_BIT);
        renderer.compatible_mem_types[Renderer.MemoryType.UPLOAD] = find_compatible_memory_type(*renderer.memory_properties, VkMemoryPropertyFlagBits.HOST_VISIBLE_BIT | .HOST_COHERENT_BIT);
        renderer.compatible_mem_types[Renderer.MemoryType.LOCAL] = find_compatible_memory_type(*renderer.memory_properties, VkMemoryPropertyFlagBits.DEVICE_LOCAL_BIT);
    }

    // Buffer
    { 
        renderer.upload_buffer = create_buffer(Renderer.BUFFER_SIZE, VkBufferUsageFlagBits.VERTEX_BUFFER_BIT | .INDEX_BUFFER_BIT | .UNIFORM_BUFFER_BIT | .STORAGE_BUFFER_BIT | .TRANSFER_SRC_BIT, .UPLOAD);
        vkMapMemory(renderer.device, renderer.upload_buffer.memory, 0, VK_WHOLE_SIZE, 0, *renderer.buffer);
        log("Buffer created.");
    }

    // Sampler 
    {
        create_info := VkSamplerCreateInfo.{
            magFilter = .LINEAR,
            minFilter = .LINEAR,
            addressModeU = .REPEAT,
            addressModeV = .REPEAT,
            addressModeW = .REPEAT,
            anisotropyEnable = VK_TRUE,
            maxAnisotropy = physical_device_properties.limits.maxSamplerAnisotropy,
            borderColor = .INT_OPAQUE_BLACK,
            unnormalizedCoordinates = VK_FALSE,
            compareEnable = VK_FALSE,
            compareOp = .ALWAYS,
            mipmapMode = .LINEAR,
            mipLodBias = 0,
            minLod = 0,
            maxLod = 0,
        };
        Vk_Check(vkCreateSampler(renderer.device, *create_info, null, *renderer.sampler));
    }
    return renderer;
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
        for framebuffers {
            vkDestroyFramebuffer(device, it, null);
        }
        framebuffers.count = 0;

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

        framebuffer_ci := VkFramebufferCreateInfo.{
            renderPass = render_pass,
            attachmentCount = 1,
            pAttachments = *image_view,
            width = swapchain_extent.width,
            height = swapchain_extent.height,
            layers = 1,
        };
        framebuffer: VkFramebuffer = ---;
        vkCreateFramebuffer(device, *framebuffer_ci, null, *framebuffer);
        array_add(*framebuffers, framebuffer);
    }
    log("Swapchain created:");
    log("\tFormat: %", surface_format.format);
    log("\tPresent mode: %", present_mode);
    log("\tImage count: %", image_count);
    log("\tExtent: %", swapchain_extent);
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

renderer_resize :: (w: s32, h: s32) {
    create_or_update_swapchain(xx w, xx h);
}

renderer_deinit :: () {
    using global_renderer;
    vkDeviceWaitIdle(device);

    vkDestroySampler(device, sampler, null);

    destroy_buffer(upload_buffer);

    vkDestroyPipelineLayout(device, pipeline_layout, null);
    vkDestroyPipeline(device, pipeline, null);

    for framebuffers {
        vkDestroyFramebuffer(device, it, null);
    }
    array_reset(*framebuffers);

    for swapchain_image_views {
        vkDestroyImageView(device, it, null);
    }
    array_reset(*swapchain_image_views);

    vkDestroyRenderPass(device, render_pass, null);

    // Render context
    for frame_data {
        vkDestroyFence(device, it.frame_fence, null);
        vkDestroySemaphore(device, it.render_finished_semaphore, null);
        vkDestroySemaphore(device, it.image_available_semaphore, null);
    }
    vkDestroyCommandPool(device, command_pool, null);

    vkDestroySwapchainKHR(device, swapchain, null);
    vkDestroyDevice(device, null);
    vkDestroyDebugUtilsMessengerEXT(instance, debug_messenger, null);
    vkDestroySurfaceKHR(instance, surface, null);
    vkDestroyInstance(instance, null);
}

begin_frame :: (clear_color: Vector4 = .{0, 0, 0, 1}) -> *Frame_Data {
    using global_renderer;
    frame_index = (frame_index + 1) % FRAME_COUNT;
    idx := frame_index;
    frame := *frame_data[idx];

    vkWaitForFences(device, 1, *frame.frame_fence, VK_TRUE, U64_MAX);
    vkResetFences(device, 1, *frame.frame_fence);

    Vk_Check(vkAcquireNextImageKHR(device, swapchain, U64_MAX, frame.image_available_semaphore, VK_NULL_HANDLE, *frame.image_index));
    begin_info := VkCommandBufferBeginInfo.{
        flags = .ONE_TIME_SUBMIT_BIT,
    };
    vkBeginCommandBuffer(frame.command_buffer, *begin_info);

    vkCmdBeginRenderPass(frame.command_buffer, *VkRenderPassBeginInfo.{
        renderPass = render_pass,
        framebuffer = framebuffers[frame.image_index],
        clearValueCount = 1,
        pClearValues = *VkClearValue.{color = .{_float32 = clear_color.component }},
        renderArea = .{
            offset = .{0, 0},
            extent = swapchain_extent,
        },
    }, .INLINE);
    vkCmdBindPipeline(frame.command_buffer, .GRAPHICS, pipeline);
    vkCmdSetViewport(frame.command_buffer, 0, 1, *VkViewport.{0, 0, xx swapchain_extent.width, xx swapchain_extent.height, 0, 1});
    vkCmdSetScissor(frame.command_buffer, 0, 1, *VkRect2D.{.{0, 0}, swapchain_extent});
    return frame;
}

flush :: (cmd: VkCommandBuffer) {
    using global_renderer;
    offset : u64 = xx (frame_index * Renderer.REGION_SIZE);
    vkCmdBindVertexBuffers(cmd, 0, 1, *upload_buffer.buffer, *offset);
    vkCmdDraw(cmd, nb_vertices, 1, 0, 0);
    nb_vertices = 0;
}

set_transform_matrix :: (cmd: VkCommandBuffer, mat: Matrix4) {
    using global_renderer;
    constants := PushConstantData.{
        transpose(mat),
    };
    vkCmdPushConstants(cmd, pipeline_layout, .VERTEX_BIT, 0, size_of(type_of(constants)), *constants);
}

end_frame :: (frame: *Frame_Data) {
    using global_renderer;
    flush(frame.command_buffer);

    vkCmdEndRenderPass(frame.command_buffer);

    Vk_Check(vkEndCommandBuffer(frame.command_buffer));
    submit_info := VkSubmitInfo.{
        waitSemaphoreCount = 1,
        pWaitSemaphores = *frame.image_available_semaphore,
        pWaitDstStageMask = VkPipelineStageFlags.[.COLOR_ATTACHMENT_OUTPUT_BIT].data,
        commandBufferCount = 1,
        pCommandBuffers = *frame.command_buffer,
        signalSemaphoreCount = 1,
        pSignalSemaphores = *frame.render_finished_semaphore,
    };
    Vk_Check(vkQueueSubmit(graphics_queue, 1, *submit_info, frame.frame_fence));

    present_info := VkPresentInfoKHR.{
        waitSemaphoreCount = 1,
        pWaitSemaphores = *frame.render_finished_semaphore,
        swapchainCount = 1,
        pSwapchains = *swapchain,
        pImageIndices = *frame.image_index
    };
    result := vkQueuePresentKHR(graphics_queue, *present_info);
    if result == .ERROR_OUT_OF_DATE_KHR { // Window was resized
        create_or_update_swapchain();
    } else {
        Vk_Check(result);
    }
}