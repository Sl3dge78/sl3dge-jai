
Renderer :: struct {
    instance: VkInstance;
    debug_messenger: VkDebugUtilsMessengerEXT;
    surface: VkSurfaceKHR;
    physical_device: VkPhysicalDevice;
    physical_device_properties: VkPhysicalDeviceProperties;

    window: *SDL_Window;
    device: VkDevice;
    queue_family_index: u32;
    graphics_queue: VkQueue;

    swapchain: VkSwapchainKHR;
    swapchain_extent: VkExtent2D;
    swapchain_images: [..]VkImage;
    surface_format: VkSurfaceFormatKHR;
    swapchain_image_views: [..]VkImageView;
    framebuffers: [FRAME_COUNT]VkFramebuffer;
    
    descriptor_pool: VkDescriptorPool;
    command_pool : VkCommandPool;

    FRAME_COUNT :: 2;
    frame_index := 0;
    frame_data: [FRAME_COUNT]Frame_Data;

    sampler: VkSampler;

    memory_properties: VkPhysicalDeviceMemoryProperties;
    MemoryType :: enum {
        READBACK :: 0; // HOST_VISIBLE_BIT | .HOST_CACHED_BIT
        UPLOAD;        // HOST_VISIBLE_BIT | .HOST_COHERENT_BIT
        LOCAL;         // DEVICE_LOCAL_BIT
        COUNT;
    }
    compatible_mem_types: [MemoryType.COUNT]u32;

    render_pass: VkRenderPass;

    color_pipeline: Pipeline;
    color_draw_data: Draw_Data;

    ui_pipeline: Pipeline;
    ui_draw_data: Draw_Data;
}

Frame_Data :: struct {
    command_buffer: VkCommandBuffer;
    current_draw_data: *Draw_Data;
    frame_fence: VkFence;
    image_available_semaphore: VkSemaphore;
    render_finished_semaphore: VkSemaphore;
    image_index: u32;
}

Draw_Data :: struct {
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

#add_context vk: Frame_Data;

global_renderer: Renderer;

CameraData :: struct {
    view: Matrix4;
    proj: Matrix4;
    view_proj: Matrix4;
}

PushConstantData :: struct {
    transform: Matrix4;
}

panic :: () {
    write_string("Panic");
    breakpoint();
    abort();
}

debug_callback :: (severity: VkDebugUtilsMessageSeverityFlagsEXT, type: VkDebugUtilsMessageTypeFlagsEXT, callback_data: *VkDebugUtilsMessengerCallbackDataEXT,  data: *void) -> VkBool32 #c_call {
    ctx := (cast(*Context)data).*;
    push_context ctx {
        msg := to_string(callback_data.pMessage);
        log("%: %", severity, msg);
        if severity >= .ERROR_BIT_EXT {
            assert(false);
        }
    }
    return VK_TRUE;
}

renderer_init :: (window: *SDL_Window) -> Renderer {
    renderer := *global_renderer;

    api_version: u32 = ---;
    Vk_Check(vkEnumerateInstanceVersion(*api_version));
    log("Vk v%.%.%", VK_VERSION_MAJOR(api_version), VK_VERSION_MINOR(api_version), VK_VERSION_PATCH(api_version));
    
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
        array_add(*extensions, VK_KHR_GET_PHYSICAL_DEVICE_PROPERTIES_2_EXTENSION_NAME.data);

        log("Extensions:");
        for ext : extensions {
            log("\t%", to_string(ext));
        }

        create_info := VkInstanceCreateInfo.{
            enabledLayerCount = xx layers.count,
            ppEnabledLayerNames = layers.data,
            enabledExtensionCount = xx extensions.count,
            ppEnabledExtensionNames = extensions.data,
            pApplicationInfo = *VkApplicationInfo.{
                apiVersion = VK_MAKE_VERSION(3, 0 ,0),
            },
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
            vkGetPhysicalDeviceProperties(device, *renderer.physical_device_properties);
            if (renderer.physical_device_properties.deviceType == .DISCRETE_GPU) {
                renderer.physical_device = device;
                log("Physical device: %", to_string(renderer.physical_device_properties.deviceName));
                break;
            }
        }
        if (!renderer.physical_device) {
            renderer.physical_device = physical_devices[0];
            vkGetPhysicalDeviceProperties(renderer.physical_device, *renderer.physical_device_properties);
        }
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
        features_13 := VkPhysicalDeviceVulkan13Features.{
            dynamicRendering = VK_TRUE,
        };
        device_features := VkPhysicalDeviceFeatures.{
            samplerAnisotropy = VK_TRUE,
        };
        dynamic_rendering_feature := VkPhysicalDeviceDynamicRenderingFeaturesKHR.{
            pNext = *features_13,
            dynamicRendering = VK_TRUE,
        };
        exts := *u8.[
            VK_KHR_SWAPCHAIN_EXTENSION_NAME.data,
            VK_KHR_DYNAMIC_RENDERING_EXTENSION_NAME.data,
            VK_KHR_DEPTH_STENCIL_RESOLVE_EXTENSION_NAME.data,
            VK_KHR_CREATE_RENDERPASS_2_EXTENSION_NAME.data,
            VK_KHR_MAINTENANCE2_EXTENSION_NAME.data,
            VK_KHR_MULTIVIEW_EXTENSION_NAME.data,
        ];
        create_info := VkDeviceCreateInfo.{
            pNext = *features_13,
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

    // Descriptor pools
    {
        pool_sizes : [2]VkDescriptorPoolSize;
        pool_sizes[0] = VkDescriptorPoolSize.{
            type = .UNIFORM_BUFFER,
            descriptorCount = 32,
        };
        pool_sizes[1] = VkDescriptorPoolSize.{
            type = .COMBINED_IMAGE_SAMPLER,
            descriptorCount = 32, 
        };

        pool_info := VkDescriptorPoolCreateInfo.{
            poolSizeCount = pool_sizes.count,
            pPoolSizes = pool_sizes.data,
            maxSets = 8,
        };
        Vk_Check(vkCreateDescriptorPool(renderer.device, *pool_info, null, *renderer.descriptor_pool));
    }

    renderer.sampler = create_sampler(renderer.device);

    renderer.render_pass = create_renderpass(renderer.device, global_renderer.surface_format.format, .CLEAR, .UNDEFINED, .PRESENT_SRC_KHR);
    renderer.color_pipeline = create_color_pipeline(renderer.device, renderer.render_pass);
    renderer.ui_pipeline = create_ui_pipeline(renderer.device, renderer.render_pass);

    // Swapchain
    create_or_update_swapchain();
    log("Swapchain created");


    log("Renderer successfully initialized!");
    return renderer;
}

renderer_wait_idle :: () {
    vkDeviceWaitIdle(global_renderer.device);
}

renderer_resize :: (w: s32, h: s32) {
    create_or_update_swapchain(xx w, xx h);
}

create_framebuffers :: () {
    framebuffer_ci := VkFramebufferCreateInfo.{
        renderPass = global_renderer.render_pass,
        attachmentCount = 1,
        pAttachments = *global_renderer.swapchain_image_views[0],
        width = global_renderer.swapchain_extent.width,
        height = global_renderer.swapchain_extent.height,
        layers = 1,
    };
    vkCreateFramebuffer(global_renderer.device, *framebuffer_ci, null, *global_renderer.framebuffers[0]);
    framebuffer_ci.pAttachments = *global_renderer.swapchain_image_views[1];
    vkCreateFramebuffer(global_renderer.device, *framebuffer_ci, null, *global_renderer.framebuffers[1]);
}

get_window_dims :: () -> Vector2i {
    return .{global_renderer.swapchain_extent.width, global_renderer.swapchain_extent.height};
}

renderer_deinit :: () {
    using global_renderer;
    vkDeviceWaitIdle(device);

    vkDestroyDescriptorPool(device, descriptor_pool, null);
    vkDestroyRenderPass(device, render_pass, null);
    
    destroy_pipeline(*color_pipeline, device);
    destroy_buffer(*color_draw_data.vertex_buffer);

    destroy_pipeline(*ui_pipeline, device);
    destroy_buffer(*ui_draw_data.vertex_buffer);

    vkDestroySampler(device, sampler, null);

    for swapchain_image_views {
        vkDestroyImageView(device, it, null);
    }
    array_reset(*swapchain_image_views);

    // Render context
    for frame_data {
        vkDestroyFence(device, it.frame_fence, null);
        vkDestroySemaphore(device, it.render_finished_semaphore, null);
        vkDestroySemaphore(device, it.image_available_semaphore, null);
    }
    vkDestroyCommandPool(device, command_pool, null);
    for framebuffers {
        vkDestroyFramebuffer(device, it, null);
    }

    vkDestroySwapchainKHR(device, swapchain, null);
    vkDestroyDevice(device, null);
    vkDestroyDebugUtilsMessengerEXT(instance, debug_messenger, null);
    vkDestroySurfaceKHR(instance, surface, null);
    vkDestroyInstance(instance, null);
}

begin_frame :: () {
    using global_renderer;

    // Update the context's frame data
    frame_index = (frame_index + 1) % FRAME_COUNT;
    idx := frame_index;
    context.vk = *frame_data[idx];
    using context.vk;

    color_draw_data.vertices.count = 0;
    color_draw_data.draw_cmds.count = 0;
    color_draw_data.transform = Matrix4_Identity;

    ui_draw_data.vertices.count = 0;
    ui_draw_data.draw_cmds.count = 0;
    ui_draw_data.transform = Matrix4_Identity;

    // Wait for image
    vkWaitForFences(device, 1, *frame_fence, VK_TRUE, U64_MAX);
    vkResetFences(device, 1, *frame_fence);
    Vk_Check(vkAcquireNextImageKHR(device, swapchain, U64_MAX, image_available_semaphore, VK_NULL_HANDLE, *image_index));
}

end_frame :: () {
    using global_renderer;
    using context.vk;

    clear_color := Vector4.{0, 0, 0, 0};
    vkBeginCommandBuffer(command_buffer, *VkCommandBufferBeginInfo.{flags = .ONE_TIME_SUBMIT_BIT});
    vkCmdBeginRenderPass(command_buffer, *VkRenderPassBeginInfo.{
        renderPass = render_pass,
        framebuffer = framebuffers[image_index],
        clearValueCount = 1,
        pClearValues = *VkClearValue.{color = .{_float32 = clear_color.component }},
        renderArea = .{
            offset = .{0, 0},
            extent = swapchain_extent,
        },
    }, .INLINE);

    draw_color_pipeline(*color_draw_data, command_buffer);
    draw_ui_pipeline(*ui_draw_data, command_buffer);

    vkCmdEndRenderPass(command_buffer);
    Vk_Check(vkEndCommandBuffer(command_buffer));

    submit_info := VkSubmitInfo.{
        waitSemaphoreCount = 1,
        pWaitSemaphores = *image_available_semaphore,
        pWaitDstStageMask = VkPipelineStageFlags.[.COLOR_ATTACHMENT_OUTPUT_BIT].data,
        commandBufferCount = 1,
        pCommandBuffers = *command_buffer,
        signalSemaphoreCount = 1,
        pSignalSemaphores = *render_finished_semaphore,
    };
    Vk_Check(vkQueueSubmit(graphics_queue, 1, *submit_info, frame_fence));

    present_info := VkPresentInfoKHR.{
        waitSemaphoreCount = 1,
        pWaitSemaphores = *context.vk.render_finished_semaphore,
        swapchainCount = 1,
        pSwapchains = *global_renderer.swapchain,
        pImageIndices = *context.vk.image_index
    };
    result := vkQueuePresentKHR(global_renderer.graphics_queue, *present_info);
    if result == .ERROR_OUT_OF_DATE_KHR { // Window was resized
        create_or_update_swapchain();
    } else {
        Vk_Check(result);
    }
}

begin_3d :: () {
    context.vk.current_draw_data = *global_renderer.color_draw_data;
}

begin_2d :: () {
    context.vk.current_draw_data = *global_renderer.ui_draw_data;
}

set_transform_matrix :: (mat: Matrix4) {
    context.vk.current_draw_data.transform = mat;
}

set_view_matrix :: (view: Matrix4) {
    using global_renderer;
    {   // Update uniform data 
        proj := make_projection_matrix(radians(45), cast(float)global_renderer.swapchain_extent.width/cast(float)global_renderer.swapchain_extent.height, 0.1, 1000);
        proj._22 *= -1;
        camera_data := CameraData.{
            proj = transpose(proj),
            view = transpose(view),
            view_proj = transpose(view * proj),
        };
        memcpy(color_pipeline.uniform_data[context.vk.image_index].mapped, *camera_data, size_of(type_of(camera_data)));

        // @Hardcoded: Create a Material struct, that allocates a descriptor set on a specific pipline and gets bound when needed
        // @Todo: Only write the frame constant data here
        descriptor_writes : [2]VkWriteDescriptorSet;
        buffer_info := VkDescriptorBufferInfo .{
            buffer = color_pipeline.uniform_data[context.vk.image_index].buffer,
            offset = 0,
            range = size_of(CameraData),
        };
        descriptor_writes[0] = .{
            dstSet = color_pipeline.descriptor_sets[context.vk.image_index][0],
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
            dstSet = color_pipeline.descriptor_sets[context.vk.image_index][1],
            dstBinding = 0,
            dstArrayElement = 0,
            descriptorType = .COMBINED_IMAGE_SAMPLER,
            descriptorCount = 1,
            pImageInfo = *image_info,
        };
        vkUpdateDescriptorSets(global_renderer.device, descriptor_writes.count, descriptor_writes.data, 0, null);
    }
}
