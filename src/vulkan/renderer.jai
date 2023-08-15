

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
    depth_texture: Texture;
    depth_format: VkFormat = .D32_SFLOAT_S8_UINT;
    
    descriptor_pool: VkDescriptorPool;
    
    empty_set_layout: VkDescriptorSetLayout; // Camera buffer
    camera_set_layout: VkDescriptorSetLayout; // Camera buffer

    shadowmap_layout: VkDescriptorSetLayout;  // Texture
    shadowmap_descriptor_set: VkDescriptorSet;

    single_texture_layout: VkDescriptorSetLayout; // Texture
    skinned_mesh_layout: VkDescriptorSetLayout;  // Joint matrices

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

    static_mesh_material: Material;
    skinned_mesh_material: Material;

    render_pass: VkRenderPass;
    
    ui_pipeline: Pipeline;

    SHADOWMAP_SIZE :: 2048;
    shadowmap_render_pass: VkRenderPass;
    shadowmap_texture: Texture;
    shadowmap_framebuffer: VkFramebuffer;

    default_texture: Texture;
    default_texture_descriptor: VkDescriptorSet;

    projection: Matrix4;
    view: Matrix4;
    light_dir: Vector3;

    // Scene rendering
    buffer_pool: Buffer_Pool;
    scene: *Scene;

    immediate_3d_draw_data: Draw_Data;
    immediate_2d_draw_data: Draw_Data;
    
    FRAME_CAMERADATA_SET :: 0;
    FRAME_SHADOWMAP_SET  :: 1;
    MATERIAL_SET :: 2;
    INSTANCE_SET :: 3;

    wait_idle :: () {
        vkDeviceWaitIdle(global_renderer.device);
    }
}

Frame_Data :: struct {
    command_buffer: VkCommandBuffer;
    current_draw_data: *Draw_Data;
    
    frame_fence: VkFence;
    image_available_semaphore: VkSemaphore;
    render_finished_semaphore: VkSemaphore;
    image_index: u32;

    camera_buffer: Buffer;
    camera_data : *Camera_Data;
    camera_descriptor: VkDescriptorSet;

    shadowmap_camera_descriptor: VkDescriptorSet;
    shadowmap_camera_data : *Camera_Data;

}

#add_context vk: Frame_Data;

global_renderer: Renderer;

Camera_Data :: struct {
    view: Matrix4;
    proj: Matrix4;
    light: Matrix4;
    light_dir: Vector3;
}

PushConstantData :: struct {
    transform: Matrix4;
    inv_transform: Matrix4;
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

        array_add(*extensions, VK_EXT_DEBUG_UTILS_EXTENSION_NAME.data);
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
                apiVersion = VK_MAKE_API_VERSION(0, 1, 3, 0),
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
            messageSeverity = .WARNING_BIT_EXT | .ERROR_BIT_EXT,
            messageType = .GENERAL_BIT_EXT | .VALIDATION_BIT_EXT | .PERFORMANCE_BIT_EXT,
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
        renderer.compatible_mem_types[Renderer.MemoryType.READBACK] = find_compatible_memory_type(*renderer.memory_properties, .HOST_VISIBLE_BIT | .HOST_CACHED_BIT);
        renderer.compatible_mem_types[Renderer.MemoryType.UPLOAD] = find_compatible_memory_type(*renderer.memory_properties, .HOST_VISIBLE_BIT | .HOST_COHERENT_BIT);
        renderer.compatible_mem_types[Renderer.MemoryType.LOCAL] = find_compatible_memory_type(*renderer.memory_properties, .DEVICE_LOCAL_BIT);
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
        exts := *u8.[
            VK_KHR_SWAPCHAIN_EXTENSION_NAME.data,
        ];
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

    // Descriptor pools
    {
        pool_sizes := VkDescriptorPoolSize.[
            .{ type = .UNIFORM_BUFFER,
                descriptorCount = 32, },
            .{ type = .COMBINED_IMAGE_SAMPLER,
                descriptorCount = 32, }
        ];

        pool_info := VkDescriptorPoolCreateInfo.{
            poolSizeCount = pool_sizes.count,
            pPoolSizes = pool_sizes.data,
            maxSets = 16,
        };
        Vk_Check(vkCreateDescriptorPool(renderer.device, *pool_info, null, *renderer.descriptor_pool));
    }

    { // Descriptor Set Layouts 
        renderer.empty_set_layout = create_descriptor_set_layout(renderer.device, .[]);
        renderer.camera_set_layout = create_descriptor_set_layout(renderer.device, .[.{
            binding = 0, 
            descriptorType = .UNIFORM_BUFFER,
            descriptorCount = 1,
            stageFlags = .VERTEX_BIT | .FRAGMENT_BIT,
            pImmutableSamplers = null,
        }]);
        renderer.shadowmap_layout = create_descriptor_set_layout(renderer.device, .[.{
            binding = 0,
            descriptorType = .COMBINED_IMAGE_SAMPLER,
            descriptorCount = 1,
            stageFlags = .FRAGMENT_BIT,
            pImmutableSamplers = null,
        }]);
        renderer.single_texture_layout = create_descriptor_set_layout(renderer.device, .[.{
            binding = 0,
            descriptorType = .COMBINED_IMAGE_SAMPLER,
            descriptorCount = 1,
            stageFlags = .FRAGMENT_BIT,
            pImmutableSamplers = null,
        }]);
        renderer.skinned_mesh_layout = create_descriptor_set_layout(renderer.device, .[.{
            binding = 0,
            descriptorType = .UNIFORM_BUFFER,
            descriptorCount = 1,
            stageFlags = .VERTEX_BIT,
            pImmutableSamplers = null,
        }]);
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

            fence_ci := VkFenceCreateInfo.{ flags = .SIGNALED_BIT, };
            vkCreateFence(renderer.device, *fence_ci, null, *it.frame_fence);

            // Camera uniforms
            cam_data_aligned := aligned_size(size_of(Camera_Data), renderer.physical_device_properties.limits.minUniformBufferOffsetAlignment);
            it.camera_buffer = Buffer.create(cam_data_aligned * 2, .UNIFORM_BUFFER_BIT, .UPLOAD, true);
            it.shadowmap_camera_data = cast(*Camera_Data)it.camera_buffer.mapped;
            it.camera_data = it.camera_buffer.mapped + cam_data_aligned;
            
            it.shadowmap_camera_descriptor = Descriptor_Set.create(renderer.camera_set_layout);
            Descriptor_Set.write(it.shadowmap_camera_descriptor, it.camera_buffer.buffer, size_of(Camera_Data), 0);

            it.camera_descriptor = Descriptor_Set.create(renderer.camera_set_layout);
            Descriptor_Set.write(it.camera_descriptor, it.camera_buffer.buffer, size_of(Camera_Data), cam_data_aligned);
        }
        log("Rendering context created");
    }

    // Default texture  & sampler
    { 
        renderer.sampler = create_sampler(renderer.device);

        data := u8.[255, 255, 255, 255];
        renderer.default_texture = Texture.from_data(data.data, 1, 1, 4, u8);

        renderer.default_texture_descriptor = Descriptor_Set.create(renderer.single_texture_layout);
        Descriptor_Set.write(renderer.default_texture_descriptor, global_renderer.sampler, global_renderer.default_texture.view, .SHADER_READ_ONLY_OPTIMAL);
    }

    {   // Shadowmap
        renderer.shadowmap_render_pass = create_shadowmap_renderpass(renderer.device);
        renderer.shadowmap_texture = Texture.create(Renderer.SHADOWMAP_SIZE, Renderer.SHADOWMAP_SIZE, global_renderer.depth_format, .DEPTH_STENCIL_ATTACHMENT_BIT | .SAMPLED_BIT, .DEPTH_BIT);

        renderer.shadowmap_descriptor_set = Descriptor_Set.create(renderer.shadowmap_layout);
        Descriptor_Set.write(renderer.shadowmap_descriptor_set, global_renderer.sampler, global_renderer.shadowmap_texture.view, .DEPTH_STENCIL_READ_ONLY_OPTIMAL);

        // @todo: separate sampler
        fb_ci := VkFramebufferCreateInfo.{
            renderPass = renderer.shadowmap_render_pass,
            attachmentCount = 1,
            pAttachments = *renderer.shadowmap_texture.view,
            width = renderer.shadowmap_texture.w,
            height = renderer.shadowmap_texture.h,
            layers = 1
        };
        Vk_Check(vkCreateFramebuffer(renderer.device, *fb_ci, null, *renderer.shadowmap_framebuffer));
    }

    renderer.render_pass = create_standard_renderpass(renderer.device);
    renderer.static_mesh_material = create_static_mesh_material(renderer.device, renderer.shadowmap_render_pass, renderer.render_pass);
    renderer.skinned_mesh_material = create_skinned_mesh_material(renderer.device, renderer.shadowmap_render_pass, renderer.render_pass);

    renderer.ui_pipeline = create_ui_pipeline(renderer.device, renderer.render_pass);

    // Swapchain
    create_or_update_swapchain();
    log("Swapchain created");

    // Default projection
    renderer.projection = make_projection_matrix(radians(45), cast(float)renderer.swapchain_extent.width/cast(float)renderer.swapchain_extent.height, 0.1, 1000);
    renderer.view = Matrix4_Identity;

    context.vk = *renderer.frame_data[0];

    log("Renderer successfully initialized!");
    return renderer;
}



renderer_resize :: (w: s32, h: s32) {
    create_or_update_swapchain(xx w, xx h);
}

create_framebuffers :: () {
    attachments := VkImageView.[
        global_renderer.swapchain_image_views[0],
        global_renderer.depth_texture.view
    ];

    framebuffer_ci := VkFramebufferCreateInfo.{
        renderPass = global_renderer.render_pass,
        attachmentCount = attachments.count,
        pAttachments = attachments.data,
        width = global_renderer.swapchain_extent.width,
        height = global_renderer.swapchain_extent.height,
        layers = 1,
    };
    vkCreateFramebuffer(global_renderer.device, *framebuffer_ci, null, *global_renderer.framebuffers[0]);
    attachments[0] = global_renderer.swapchain_image_views[1];
    vkCreateFramebuffer(global_renderer.device, *framebuffer_ci, null, *global_renderer.framebuffers[1]);
}

get_window_dims :: () -> Vector2i {
    return .{global_renderer.swapchain_extent.width, global_renderer.swapchain_extent.height};
}

renderer_deinit :: () {
    using global_renderer;
    vkDeviceWaitIdle(device);

    Buffer_Pool.reset_pool(*buffer_pool);

    Draw_Data.destroy(*context.immediate._3d_draw_data);
    Draw_Data.destroy(*context.immediate._2d_draw_data);

    Texture.destroy(*depth_texture);

    vkDestroyDescriptorPool(device, descriptor_pool, null);
    vkDestroyDescriptorSetLayout(device, empty_set_layout, null);
    vkDestroyDescriptorSetLayout(device, camera_set_layout, null);
    vkDestroyDescriptorSetLayout(device, shadowmap_layout, null);
    vkDestroyDescriptorSetLayout(device, single_texture_layout, null);
    vkDestroyDescriptorSetLayout(device, skinned_mesh_layout, null);

    Material.destroy(device, *static_mesh_material);
    Material.destroy(device, *skinned_mesh_material);

    vkDestroyPipelineLayout(device, ui_pipeline.layout, null);
    vkDestroyPipeline(device, ui_pipeline.pipeline, null);

    // Standard render pass
    vkDestroyRenderPass(device, render_pass, null);

    // Shadowmap render pass
    vkDestroyRenderPass(device, shadowmap_render_pass, null);
    vkDestroyFramebuffer(device, shadowmap_framebuffer, null);
    Texture.destroy(*shadowmap_texture);

    vkDestroySampler(device, sampler, null);
    Texture.destroy(*default_texture);

    for swapchain_image_views {
        vkDestroyImageView(device, it, null);
    }
    array_reset(*swapchain_image_views);

    // Render context
    for frame_data {
        vkDestroyFence(device, it.frame_fence, null);
        vkDestroySemaphore(device, it.render_finished_semaphore, null);
        vkDestroySemaphore(device, it.image_available_semaphore, null);
        Buffer.destroy(*it.camera_buffer);    
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

end_frame :: () {
    using global_renderer;
    using context.vk;

    // Wait for image
    vkWaitForFences(device, 1, *frame_fence, VK_TRUE, U64_MAX);
    vkResetFences(device, 1, *frame_fence);
    Vk_Check(vkAcquireNextImageKHR(device, swapchain, U64_MAX, image_available_semaphore, VK_NULL_HANDLE, *image_index));

    // Commit draw data
    Draw_Data.upload(*context.immediate._2d_draw_data);
    Draw_Data.upload(*context.immediate._3d_draw_data);

    size:: 20;
    light_proj := orthographic_projection_matrix(size, -size, -size, size, -size, size, true);
    light_view := make_look_at_matrix(.{0, 0, 0}, light_dir, .{0, 1, 0}, false);
    
    camera_data.proj = transpose(projection);
    camera_data.view = transpose(view);
    camera_data.light = transpose(light_proj * light_view);
    camera_data.light_dir = light_dir;

    shadowmap_camera_data.proj = transpose(light_proj);
    shadowmap_camera_data.view = transpose(light_view);
    shadowmap_camera_data.light = camera_data.light;
    shadowmap_camera_data.light_dir = light_dir;

    clear_color := Vector4.{0.529, 0.808, 0.922, 0};
    clear_values := VkClearValue.[
        .{color = .{_float32 = clear_color.component}},
        .{depthStencil = .{1, 0}}
    ];
    vkBeginCommandBuffer(command_buffer, *VkCommandBufferBeginInfo.{flags = .ONE_TIME_SUBMIT_BIT});
    vkCmdBeginRenderPass(command_buffer, *VkRenderPassBeginInfo.{
        renderPass = shadowmap_render_pass,
        framebuffer = shadowmap_framebuffer,
        clearValueCount = 1,
        pClearValues = *clear_values[1],
        renderArea = .{ offset = .{0, 0}, extent = .{shadowmap_texture.w, shadowmap_texture.h}},
    }, .INLINE);
        record_3d_commands(scene, command_buffer, .SHADOWMAP);
    vkCmdEndRenderPass(command_buffer);

    vkCmdBeginRenderPass(command_buffer, *VkRenderPassBeginInfo.{
        renderPass = render_pass,
        framebuffer = framebuffers[image_index],
        clearValueCount = clear_values.count,
        pClearValues = clear_values.data,
        renderArea = .{
            offset = .{0, 0},
            extent = swapchain_extent,
        },
    }, .INLINE);
        record_3d_commands(scene, command_buffer, .COLOR);

        bind_ui_pipeline(command_buffer);
        record_2d_commands(scene, command_buffer, global_renderer.ui_pipeline);

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

    Draw_Data.reset(*context.immediate._3d_draw_data);
    Draw_Data.reset(*context.immediate._2d_draw_data);

    // Update the context's frame data
    frame_index = (frame_index + 1) % FRAME_COUNT;
    idx := frame_index;
    context.vk = *frame_data[idx];

    // And some perf data
    global_engine.frame_time = cast(float)(SDL_GetPerformanceCounter() - global_engine.frame_start) / cast(float)(SDL_GetPerformanceFrequency() / 1000);
}

set_transform_matrix :: (mat: Matrix4) {
    context.immediate._3d_draw_data.transform = mat;
}

set_view_matrix :: (view: Matrix4) {
    global_renderer.view = view;
}

set_projection_matrix :: (proj: Matrix4) {
    global_renderer.projection = proj;
}

set_projection_matrix :: (fov: float) {
    set_projection_matrix(make_projection_matrix(radians(fov), cast(float)global_renderer.swapchain_extent.width/cast(float)global_renderer.swapchain_extent.height, 0.1, 1000));
}

set_scene :: (scene: *Scene) {
    global_renderer.scene = scene;
}

change_light_direction :: (dir: Vector3) {
    global_renderer.light_dir = dir;
}
