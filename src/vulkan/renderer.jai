

Renderer :: struct {
    window: *SDL_Window;

    instance: VkInstance;
    debug_messenger: VkDebugUtilsMessengerEXT;
    surface: VkSurfaceKHR;
    
    physical_device: VkPhysicalDevice;
    physical_device_properties: VkPhysicalDeviceProperties;
    
    compatible_mem_types: [MemoryType.COUNT]u32;

    device: VkDevice;
    queue_family_index: u32;
    graphics_queue: VkQueue;

    swapchain: Swapchain;
    // swapchain: VkSwapchainKHR;
    // swapchain_extent: VkExtent2D;
    // swapchain_images: [..]VkImage;
    // swapchain_format: VkSurfaceFormatKHR;
    // swapchain_image_views: [..]VkImageView;
    // framebuffers: [FRAME_COUNT]VkFramebuffer;

    depth_texture: Texture;
    depth_format: VkFormat : .D32_SFLOAT_S8_UINT;
    
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

    create :: (window: *SDL_Window) -> Renderer {
        renderer := *global_renderer;

        api_version: u32 = ---;
        Vk_Check(vkEnumerateInstanceVersion(*api_version));
        log("Vk v%.%.%", VK_VERSION_MAJOR(api_version), VK_VERSION_MINOR(api_version), VK_VERSION_PATCH(api_version));
        
        renderer.instance = create_instance(window);
        
        load_function_pointers(renderer.instance);
        SDL_Vulkan_CreateSurface(window, renderer.instance, *renderer.surface);

        renderer.window = window;
        
        renderer.debug_messenger = create_debug_messenger(renderer.instance);
        
        renderer.physical_device = pick_physical_device(renderer.instance);
        vkGetPhysicalDeviceProperties(renderer.physical_device, *renderer.physical_device_properties);
        renderer.compatible_mem_types = get_memory_types(renderer.physical_device);

        renderer.swapchain.format = Swapchain.pick_format(renderer.physical_device, renderer.surface);

        renderer.queue_family_index = get_queue_family_index(renderer.physical_device, renderer.surface);
        renderer.device = create_device(renderer.physical_device, renderer.queue_family_index);
        vkGetDeviceQueue(renderer.device, renderer.queue_family_index, 0, *renderer.graphics_queue);
        
        renderer.descriptor_pool = create_descriptor_pool(renderer.device);
        create_descriptor_set_layouts(renderer);

        {   // Frame data
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
        
        {   // Default texture  & sampler
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
        Swapchain.create_or_update(*renderer.swapchain, renderer.device, renderer.physical_device, renderer.surface, renderer.window);
        log("Swapchain created");

        // Default projection
        renderer.projection = make_projection_matrix(radians(45), cast(float)renderer.swapchain.extent.width/cast(float)renderer.swapchain.extent.height, 0.1, 1000);
        renderer.view = Matrix4_Identity;

        context.vk = *renderer.frame_data[0];

        log("Renderer successfully initialized!");
        return renderer;
    }

    destroy :: () {
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
        Swapchain.destroy(*swapchain, device);

        // Render context
        for frame_data {
            vkDestroyFence(device, it.frame_fence, null);
            vkDestroySemaphore(device, it.render_finished_semaphore, null);
            vkDestroySemaphore(device, it.image_available_semaphore, null);
            Buffer.destroy(*it.camera_buffer);    
        }
        vkDestroyCommandPool(device, command_pool, null);
    
        vkDestroyDevice(device, null);
        vkDestroyDebugUtilsMessengerEXT(instance, debug_messenger, null);
        vkDestroySurfaceKHR(instance, surface, null);
        vkDestroyInstance(instance, null);
    }



    wait_idle :: () {
        vkDeviceWaitIdle(global_renderer.device);
    }
}

MemoryType :: enum {
    READBACK :: 0; // HOST_VISIBLE_BIT | .HOST_CACHED_BIT
    UPLOAD;        // HOST_VISIBLE_BIT | .HOST_COHERENT_BIT
    LOCAL;         // DEVICE_LOCAL_BIT
    COUNT;
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

get_window_dims :: () -> Vector2i {
    return .{global_renderer.swapchain.extent.width, global_renderer.swapchain.extent.height};
}

end_frame :: () {
    using global_renderer;
    using context.vk;

    // Wait for image
    vkWaitForFences(device, 1, *frame_fence, VK_TRUE, U64_MAX);
    vkResetFences(device, 1, *frame_fence);
    Vk_Check(vkAcquireNextImageKHR(device, swapchain.handle, U64_MAX, image_available_semaphore, VK_NULL_HANDLE, *image_index));

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
        Immediate.draw_3d(command_buffer, .SHADOWMAP);
        Scene.draw(scene, command_buffer, .SHADOWMAP);
    vkCmdEndRenderPass(command_buffer);

    vkCmdBeginRenderPass(command_buffer, *VkRenderPassBeginInfo.{
        renderPass = render_pass,
        framebuffer = swapchain.framebuffers[image_index],
        clearValueCount = clear_values.count,
        pClearValues = clear_values.data,
        renderArea = .{
            offset = .{0, 0},
            extent = swapchain.extent,
        },
    }, .INLINE);
        Immediate.draw_3d(command_buffer, .COLOR);
        Scene.draw(scene, command_buffer, .COLOR);

        bind_ui_pipeline(command_buffer);
        Immediate.draw_2d(command_buffer, global_renderer.ui_pipeline);

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
        pSwapchains = *global_renderer.swapchain.handle,
        pImageIndices = *context.vk.image_index
    };
    result := vkQueuePresentKHR(global_renderer.graphics_queue, *present_info);
    if result == .ERROR_OUT_OF_DATE_KHR { // Window was resized
        Swapchain.create_or_update(*swapchain, device, physical_device, surface, window);
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
    set_projection_matrix(make_projection_matrix(radians(fov), cast(float)global_renderer.swapchain.extent.width/cast(float)global_renderer.swapchain.extent.height, 0.1, 1000));
}

set_scene :: (scene: *Scene) {
    global_renderer.scene = scene;
}

change_light_direction :: (dir: Vector3) {
    global_renderer.light_dir = dir;
}


#scope_file
create_instance :: (window: *SDL_Window) -> VkInstance {
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
    instance : VkInstance = ---;
    Vk_Check(vkCreateInstance(*create_info, null, *instance));
    log("Instance created.");
    return instance;
}

create_debug_messenger :: (instance: VkInstance) -> VkDebugUtilsMessengerEXT {
    create_info := VkDebugUtilsMessengerCreateInfoEXT.{
        messageSeverity = .WARNING_BIT_EXT | .ERROR_BIT_EXT,
        messageType = .GENERAL_BIT_EXT | .VALIDATION_BIT_EXT | .PERFORMANCE_BIT_EXT,
        pfnUserCallback = debug_callback,
        pUserData = *context,
    };

    debug_messenger: VkDebugUtilsMessengerEXT = ---;
    Vk_Check(vkCreateDebugUtilsMessengerEXT(instance, *create_info, null, *debug_messenger));
    log("Debug messenger created.");
    return debug_messenger;
}

pick_physical_device :: (instance: VkInstance) -> VkPhysicalDevice {
    physical_devices := fill_array(VkPhysicalDevice, vkEnumeratePhysicalDevices, instance);
    if(physical_devices.count <= 0) {
        log_error("No physical device found!");
        panic();
    }

    for device : physical_devices {
        // @Robustness: Better picking:
        // - Check extensions
        // - Pick depending on queues
        prop: VkPhysicalDeviceProperties = ---;
        vkGetPhysicalDeviceProperties(device, *prop);
        if (prop.deviceType == .DISCRETE_GPU) {
            
            log("Physical device: %", to_string(prop.deviceName));
            return device;
        }
    }
    assert(false, "No discrete GPU found!");
    log_error("No discrete GPU found!");
    panic();
    return VK_NULL_HANDLE;
}

get_memory_types :: (physical_device: VkPhysicalDevice) -> [MemoryType.COUNT]u32 {
    find_compatible_memory_type :: (prop: *VkPhysicalDeviceMemoryProperties, flags: VkMemoryPropertyFlags) -> u32 {
        count := prop.memoryTypeCount;
        compatible_types : u32 = 0;
        for 0..count-1 {
            is_compat : u32 = xx ((prop.memoryTypes[it].propertyFlags & flags) == flags);
            compatible_types |= (is_compat << it);
        }
        return compatible_types;
    }
    memory_properties : VkPhysicalDeviceMemoryProperties = ---;
    vkGetPhysicalDeviceMemoryProperties(physical_device, *memory_properties);

    result : [MemoryType.COUNT]u32 = ---;
    result[MemoryType.READBACK] = find_compatible_memory_type(*memory_properties, .HOST_VISIBLE_BIT | .HOST_CACHED_BIT);
    result[MemoryType.UPLOAD] = find_compatible_memory_type(*memory_properties, .HOST_VISIBLE_BIT | .HOST_COHERENT_BIT);
    result[MemoryType.LOCAL] = find_compatible_memory_type(*memory_properties, .DEVICE_LOCAL_BIT);
    return result;
}

get_queue_family_index :: (physical_device: VkPhysicalDevice, surface: VkSurfaceKHR) -> u32 {
    // @Robustness: Handle the case where present and graphics are different
    queue_families := fill_array(VkQueueFamilyProperties, vkGetPhysicalDeviceQueueFamilyProperties, physical_device);
    for queue_families {
        supports_present := VK_FALSE;
        vkGetPhysicalDeviceSurfaceSupportKHR(physical_device, xx it_index, surface, *supports_present);
        if supports_present && (it.queueFlags & .GRAPHICS_BIT) {
            return xx it_index;
        }
    }
    assert(false, "No queue found.");
    log_error("No queue found!");
    return 0;
}

create_device :: (physical_device: VkPhysicalDevice, queue_family_index: u32) -> VkDevice {
    queue_create_info := VkDeviceQueueCreateInfo.{
        queueFamilyIndex = queue_family_index,
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
    device: VkDevice = ---;
    Vk_Check(vkCreateDevice(physical_device, *create_info, null, *device));
    log("Device created."); 
    return device;
}


create_descriptor_pool :: (device: VkDevice) -> VkDescriptorPool {
    pool_sizes := VkDescriptorPoolSize.[.{ 
        type = .UNIFORM_BUFFER,
        descriptorCount = 32,
    }, .{ 
        type = .COMBINED_IMAGE_SAMPLER,
        descriptorCount = 32,
    }
    ];

    pool_info := VkDescriptorPoolCreateInfo.{
        poolSizeCount = pool_sizes.count,
        pPoolSizes = pool_sizes.data,
        maxSets = 16,
    };
    descriptor_pool: VkDescriptorPool = ---;
    Vk_Check(vkCreateDescriptorPool(device, *pool_info, null, *descriptor_pool));
    return descriptor_pool;
}

create_descriptor_set_layouts :: (renderer: *Renderer) {
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