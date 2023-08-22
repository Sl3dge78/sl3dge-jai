
Renderer :: struct {
    window: *SDL_Window;

    instance: VkInstance;
    debug_messenger: VkDebugUtilsMessengerEXT;
    surface: VkSurfaceKHR;
    
    physical_device: VkPhysicalDevice;
    physical_device_properties: VkPhysicalDeviceProperties;
    compatible_mem_types: [MemoryType.COUNT]u32;
    queue_family_index: u32;

    device: VkDevice;
    graphics_queue: VkQueue;

    swapchain: Swapchain;

    DEPTH_FORMAT :: VkFormat.D32_SFLOAT_S8_UINT;
    
    // Descriptors
    descriptor_pool: VkDescriptorPool;
    
    empty_set_layout: VkDescriptorSetLayout; 
    camera_set_layout: VkDescriptorSetLayout; // Camera buffer
    shadowmap_layout: VkDescriptorSetLayout;  // Texture
    single_texture_layout: VkDescriptorSetLayout; // Texture
    skinned_mesh_layout: VkDescriptorSetLayout;  // Joint matrices   
        
    FRAME_CAMERADATA_SET :: 0;
    FRAME_SHADOWMAP_SET  :: 1;
    MATERIAL_SET :: 2;
    INSTANCE_SET :: 3;
    
    command_pool : VkCommandPool;

    FRAME_COUNT :: 2;
    frame_index := 0;
    frame_data: [FRAME_COUNT]Frame_Data;

    // Pipelines
    static_mesh_material: Material;
    skinned_mesh_material: Material;
    ui_pipeline: Pipeline;

    // Shadowmap pass
    SHADOWMAP_SIZE :: 2048;
    shadowmap_render_pass: VkRenderPass;
    shadowmap_framebuffer: VkFramebuffer;
    shadowmap_texture: Texture;
    shadowmap_descriptor_set: VkDescriptorSet;

    // Standard pass
    standard_render_pass: VkRenderPass;

    sampler: VkSampler;
    default_texture: Texture;
    default_texture_descriptor: VkDescriptorSet;

    projection: Matrix4;
    view: Matrix4;
    light_dir: Vector3;

    // Scene rendering
    buffer_pool: Buffer_Pool;
    scene: *Scene;

    create :: (window: *SDL_Window) -> Renderer {
        renderer := *global_renderer;

        renderer.window = window;

        api_version: u32 = ---;
        Vk_Check(vkEnumerateInstanceVersion(*api_version));
        log("Vk v%.%.%", VK_VERSION_MAJOR(api_version), VK_VERSION_MINOR(api_version), VK_VERSION_PATCH(api_version));
        
        renderer.instance = create_instance(window);
        
        load_function_pointers(renderer.instance);
        SDL_Vulkan_CreateSurface(window, renderer.instance, *renderer.surface);

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
        renderer.command_pool = create_command_pool(renderer.device, renderer.queue_family_index);
           
        for *renderer.frame_data {
            it.* = Frame_Data.create(renderer.device, renderer.command_pool, renderer.camera_set_layout);
        }       

        create_descriptor_sets(renderer);

        // Shadowmap
        renderer.shadowmap_render_pass = create_shadowmap_renderpass(renderer.device);
        fb_ci := VkFramebufferCreateInfo.{
            renderPass = renderer.shadowmap_render_pass,
            attachmentCount = 1,
            pAttachments = *renderer.shadowmap_texture.view,
            width = renderer.shadowmap_texture.w,
            height = renderer.shadowmap_texture.h,
            layers = 1
        };
        Vk_Check(vkCreateFramebuffer(renderer.device, *fb_ci, null, *renderer.shadowmap_framebuffer));
        
        renderer.standard_render_pass = create_standard_renderpass(renderer.device);
        
        renderer.static_mesh_material = create_static_mesh_material(renderer.device, renderer.shadowmap_render_pass, renderer.standard_render_pass);
        renderer.skinned_mesh_material = create_skinned_mesh_material(renderer.device, renderer.shadowmap_render_pass, renderer.standard_render_pass);

        renderer.ui_pipeline = create_ui_pipeline(renderer.device, renderer.standard_render_pass);

        Swapchain.create_or_update(*renderer.swapchain, renderer.device, renderer.physical_device, renderer.surface, renderer.window);

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
        vkDestroyRenderPass(device, standard_render_pass, null);

        // Shadowmap render pass
        vkDestroyRenderPass(device, shadowmap_render_pass, null);
        vkDestroyFramebuffer(device, shadowmap_framebuffer, null);
        Texture.destroy(*shadowmap_texture);

        vkDestroySampler(device, sampler, null);
        Texture.destroy(*default_texture);
        Swapchain.destroy(*swapchain, device);

        // Render context
        for *frame_data {
            Frame_Data.destroy(it, device);
        }
        vkDestroyCommandPool(device, command_pool, null);
    
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
        Vk_Check(vkAcquireNextImageKHR(device, swapchain.handle, U64_MAX, image_available_semaphore, VK_NULL_HANDLE, *image_index));

        {   // Update uniforms
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
        }

        {   // Record Command Buffer
            vkBeginCommandBuffer(command_buffer, *VkCommandBufferBeginInfo.{flags = .ONE_TIME_SUBMIT_BIT});

            // Shadowmap
            begin_shadowmap_renderpass(*global_renderer, command_buffer);
            Immediate.draw_3d(command_buffer, .SHADOWMAP);
            Scene.draw(scene, command_buffer, .SHADOWMAP);
            vkCmdEndRenderPass(command_buffer);

            // Standard
            begin_standard_renderpass(*global_renderer, command_buffer, swapchain.framebuffers[image_index]);
            Immediate.draw_3d(command_buffer, .COLOR);
            Scene.draw(scene, command_buffer, .COLOR);

            Immediate.draw_2d(command_buffer, global_renderer.ui_pipeline);
            vkCmdEndRenderPass(command_buffer);
            Vk_Check(vkEndCommandBuffer(command_buffer));
        }

        {   // Submit and Present
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
        }

        {   // Prepare next frame
            frame_index = (frame_index + 1) % FRAME_COUNT;
            idx := frame_index;
            context.vk = *frame_data[idx];
            Draw_Data.reset(*context.immediate._3d_draw_data);
            Draw_Data.reset(*context.immediate._2d_draw_data);
        }

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

    get_window_dims :: () -> Vector2i {
        return .{global_renderer.swapchain.extent.width, global_renderer.swapchain.extent.height};
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

#scope_file

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

create_command_pool :: (device: VkDevice, queue_family_index: u32) -> VkCommandPool {

    cmd_pool_ci := VkCommandPoolCreateInfo.{
        flags = .RESET_COMMAND_BUFFER_BIT,
        queueFamilyIndex = queue_family_index,
    };
    command_pool: VkCommandPool = ---;
    Vk_Check(vkCreateCommandPool(device, *cmd_pool_ci, null, *command_pool));
    return command_pool;

}

create_descriptor_sets :: (renderer: *Renderer) {
    renderer.sampler = create_sampler(renderer.device);

    data := u8.[255, 255, 255, 255];
    renderer.default_texture = Texture.from_data(data.data, 1, 1, 4, u8);
    renderer.default_texture_descriptor = Descriptor_Set.create(renderer.single_texture_layout);
    Descriptor_Set.write(renderer.default_texture_descriptor, global_renderer.sampler, global_renderer.default_texture.view, .SHADER_READ_ONLY_OPTIMAL);

    renderer.shadowmap_texture = Texture.create(Renderer.SHADOWMAP_SIZE, Renderer.SHADOWMAP_SIZE, Renderer.DEPTH_FORMAT, .DEPTH_STENCIL_ATTACHMENT_BIT | .SAMPLED_BIT, .DEPTH_BIT);
    renderer.shadowmap_descriptor_set = Descriptor_Set.create(renderer.shadowmap_layout);
    Descriptor_Set.write(renderer.shadowmap_descriptor_set, global_renderer.sampler, global_renderer.shadowmap_texture.view, .DEPTH_STENCIL_READ_ONLY_OPTIMAL);
}

create_standard_renderpass :: (device: VkDevice) -> VkRenderPass {
    format := global_renderer.swapchain.format.format;
    depth_format := Renderer.DEPTH_FORMAT;

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

begin_standard_renderpass :: (renderer: *Renderer, command_buffer: VkCommandBuffer, framebuffer: VkFramebuffer) {
    clear_color := Vector4.{0.529, 0.808, 0.922, 0};
    clear_values := VkClearValue.[
        .{color = .{_float32 = clear_color.component}},
        .{depthStencil = .{1, 0}}
    ];
     vkCmdBeginRenderPass(command_buffer, *VkRenderPassBeginInfo.{
        renderPass = renderer.standard_render_pass,
        framebuffer = framebuffer,
        clearValueCount = clear_values.count,
        pClearValues = clear_values.data,
        renderArea = .{
            offset = .{0, 0},
            extent = renderer.swapchain.extent,
        },
    }, .INLINE);
}

create_shadowmap_renderpass :: (device: VkDevice) -> VkRenderPass {
    format := global_renderer.swapchain.format.format;
    depth_format := Renderer.DEPTH_FORMAT;

    attachments := VkAttachmentDescription.[.{
        format = depth_format,
        samples = ._1_BIT,
        loadOp = .CLEAR,
        storeOp = .STORE,
        stencilLoadOp = .DONT_CARE,
        stencilStoreOp = .DONT_CARE,
        initialLayout = .UNDEFINED,
        finalLayout = .DEPTH_STENCIL_READ_ONLY_OPTIMAL,
    }];

    dependencies := VkSubpassDependency.[.{
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

begin_shadowmap_renderpass :: (renderer: Renderer, command_buffer: VkCommandBuffer) {
    clear_value := VkClearValue.{depthStencil = .{1, 0}};
    vkCmdBeginRenderPass(command_buffer, *VkRenderPassBeginInfo.{
        renderPass = renderer.shadowmap_render_pass,
        framebuffer = renderer.shadowmap_framebuffer,
        clearValueCount = 1,
        pClearValues = *clear_value,
        renderArea = .{
            offset = .{0, 0},
            extent = .{renderer.shadowmap_texture.w, renderer.shadowmap_texture.h}
        },
    }, .INLINE);
}

draw :: (using self: Mesh, command_buffer: VkCommandBuffer) {
    for submeshes {
        vkCmdBindVertexBuffers(command_buffer, 0, 1, *it.vertices_loc.buffer.buffer, *it.vertices_loc.offset);
        vkCmdBindIndexBuffer(command_buffer, it.indices_loc.buffer.buffer, it.indices_loc.offset, .UINT32);
        vkCmdDrawIndexed(command_buffer, xx it.index_count, 1, 0, 0, 0);
    }
}

draw :: (using self: Skinned_Mesh, command_buffer: VkCommandBuffer) {

    for submeshes {
        vkCmdBindVertexBuffers(command_buffer, 0, 1, *it.vertices_loc.buffer.buffer, *it.vertices_loc.offset);
        vkCmdBindVertexBuffers(command_buffer, 1, 1, *skins[it_index].buffer.buffer, *skins[it_index].offset);
        vkCmdBindIndexBuffer(command_buffer, it.indices_loc.buffer.buffer, it.indices_loc.offset, .UINT32);
        vkCmdDrawIndexed(command_buffer, xx it.index_count, 1, 0, 0, 0);
    }
}
