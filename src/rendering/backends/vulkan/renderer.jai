
Renderer :: struct {
    window: *SDL_Window;

    instance: VkInstance;
    debug_messenger: VkDebugUtilsMessengerEXT;
    surface: VkSurfaceKHR;
    
    physical_device: VkPhysicalDevice;
    physical_device_properties: VkPhysicalDeviceProperties;
    physical_device_features: VkPhysicalDeviceFeatures;
    compatible_mem_types: [MemoryType.COUNT]u32;
    queue_family_index: u32;

    device: VkDevice;

    allocator: VmaAllocator;

    graphics_queue: VkQueue;

    swapchain: Swapchain;

    DEPTH_FORMAT : VkFormat : .D32_SFLOAT_S8_UINT;
    SHADOWMAP_FORMAT : VkFormat : .D32_SFLOAT;
    
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
    shadowmap_texture: Render_Texture;
    shadowmap_descriptor_set: VkDescriptorSet;

    // Standard pass
    standard_render_pass: VkRenderPass;

    empty_descriptor_set: VkDescriptorSet;

    sampler: VkSampler;
    empty_texture: Texture;
    empty_texture_descriptor_set: VkDescriptorSet;

    projection: Matrix4;
    view: Matrix4;
    light_dir: Vector3;

    vertex_buffer_pool: Buffer_Pool = .{
        kind = .VERTEX_BUFFER_BIT | .INDEX_BUFFER_BIT,
        name = "vertex_buffer_pool"
    };
    immediate_buffer_pool: Buffer_Pool = .{
        kind = .VERTEX_BUFFER_BIT | .INDEX_BUFFER_BIT,
        name = "immediate_buffer_pool",
    };
    uniform_buffer_pool: Buffer_Pool = .{
        kind = .UNIFORM_BUFFER_BIT,
        name = "uniform_buffer_pool",
    };

    // command_buffers: [..]VkCommandBuffer;
}

#if OS == .WINDOWS {
    #import "Windows";
}

renderer_create :: (window: *SDL_Window) -> *Renderer {
    renderer := *global_renderer;

    renderer.window = window;

    api_version: u32 = ---;
    Vk_Check(vkEnumerateInstanceVersion(*api_version));
    log("Vulkan v%.%.%", VK_API_VERSION_MAJOR(api_version), VK_API_VERSION_MINOR(api_version), VK_API_VERSION_PATCH(api_version));
    
    renderer.instance = create_instance(window);
    load_function_pointers(renderer.instance);

    renderer.debug_messenger = create_debug_messenger(renderer.instance);

    SDL_Vulkan_CreateSurface(window, renderer.instance, *renderer.surface);
    
    renderer.physical_device = pick_physical_device(renderer.instance);
    // @TODO: Check limits & features
    vkGetPhysicalDeviceProperties(renderer.physical_device, *renderer.physical_device_properties);
    log("Physical device: %", cast(string)(renderer.physical_device_properties.deviceName));
    vkGetPhysicalDeviceFeatures(renderer.physical_device, *renderer.physical_device_features);

    // Setup limits where needed
    renderer.uniform_buffer_pool.alignement = renderer.physical_device_properties.limits.minUniformBufferOffsetAlignment;

    renderer.compatible_mem_types = get_memory_types(renderer.physical_device);
    renderer.swapchain.format = swapchain_pick_format(renderer.physical_device, renderer.surface);
    renderer.queue_family_index = get_queue_family_index(renderer.physical_device, renderer.surface);
    renderer.device = create_device(renderer.physical_device, renderer.queue_family_index);

    {  // Setup VMA

        create_info := VmaAllocatorCreateInfo.{
            flags = 0,
            instance = renderer.instance,
            physicalDevice = renderer.physical_device,
            device = renderer.device,
            vulkanApiVersion = VK_API_VERSION_1_3,
        };
        Vk_Check(vmaCreateAllocator(*create_info, *renderer.allocator));

    }

    vkGetDeviceQueue(renderer.device, renderer.queue_family_index, 0, *renderer.graphics_queue);
    
    renderer.descriptor_pool = create_descriptor_pool(renderer.device);
    create_descriptor_set_layouts(renderer);
    renderer.command_pool = create_command_pool(renderer.device, renderer.queue_family_index);
        
    for *renderer.frame_data {
        it.* = frame_data_create(renderer.device, renderer.command_pool, renderer.camera_set_layout);
    }       

    create_descriptor_sets(renderer);
    
    renderer.static_mesh_material = create_static_mesh_material(renderer.device);
    renderer.skinned_mesh_material = create_skinned_mesh_material(renderer.device);

    renderer.ui_pipeline = create_ui_pipeline(renderer.device);

    swapchain_create_or_update(*renderer.swapchain, renderer.device, renderer.physical_device, renderer.surface, renderer.window);

    // Default projection
    renderer.projection = make_projection_matrix(radians(45), cast(float)renderer.swapchain.extent.width/cast(float)renderer.swapchain.extent.height, 0.1, 1000);
    renderer.view = Matrix4_Identity;

    log("Renderer successfully initialized!");
    return renderer;
}

destroy :: (using self: *Renderer) {
    vkDeviceWaitIdle(device);

    destroy(*vertex_buffer_pool);
    destroy(*immediate_buffer_pool);
    destroy(*uniform_buffer_pool);

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

    destroy(*shadowmap_texture);

    vkDestroySampler(device, sampler, null);
    destroy(*empty_texture);
    destroy(*swapchain, device);

    // Render context
    for *frame_data {
        destroy(it, device);
    }
    vkDestroyCommandPool(device, command_pool, null);

    vmaDestroyAllocator(allocator);
    vkDestroyDevice(device, null);

    vkDestroyDebugUtilsMessengerEXT(instance, debug_messenger, null);
    vkDestroySurfaceKHR(instance, surface, null);
    vkDestroyInstance(instance, null);
}

prepare_framebuffer :: (command_buffer: VkCommandBuffer, frame_data: *Frame_Data) {
    transition_texture_layout(*frame_data.framebuffer, .UNDEFINED, .TRANSFER_DST_OPTIMAL, command_buffer);
    clear := VkClearColorValue.{ _float32 = .[0, 0, 0, 1] };
    range := VkImageSubresourceRange.{ .COLOR_BIT, 0, 1, 0, 1 };
    vkCmdClearColorImage(command_buffer, frame_data.framebuffer.image, .TRANSFER_DST_OPTIMAL, *clear, 1, *range);
    transition_texture_layout(*frame_data.framebuffer, .TRANSFER_DST_OPTIMAL, .COLOR_ATTACHMENT_OPTIMAL, command_buffer);
}

end_framebuffer :: (command_buffer: VkCommandBuffer, frame_data: *Frame_Data) { 
    transition_texture_layout(*frame_data.framebuffer, .COLOR_ATTACHMENT_OPTIMAL, .PRESENT_SRC_KHR, command_buffer);
}

begin_frame :: () -> *Frame_Data {
    using global_renderer;

    this_frame := *frame_data[frame_index];

    // Wait for image
    vkWaitForFences(device, 1, *this_frame.frame_fence, VK_TRUE, U64_MAX);
    vkResetFences(device, 1, *this_frame.frame_fence);
    Vk_Check(vkAcquireNextImageKHR(device, swapchain.handle, U64_MAX, this_frame.image_available_semaphore, VK_NULL_HANDLE, *this_frame.swapchain_image_index));
    this_frame.framebuffer.texture = .{
        image = swapchain.images[this_frame.swapchain_image_index],
        view = swapchain.image_views[this_frame.swapchain_image_index],
        w = swapchain.extent.width,
        h = swapchain.extent.height,
        aspect = .COLOR_BIT,
    };

    return this_frame;
}

end_frame :: (this_frame: *Frame_Data) {
    using global_renderer;

    {   // Update uniforms
        size:: 20;
        light_proj := orthographic_projection_matrix(size, -size, -size, size, -size, size, true);
        light_view := make_look_at_matrix(.{0, 0, 0}, light_dir, .{0, 1, 0}, false);

        cam := Camera_Data.{
            proj = transpose(projection),
            view = transpose(view),
            light = transpose(light_proj * light_view),
            light_dir = light_dir,
        };
        uniform_buffer_write(*this_frame.camera_descriptor, *cam);
        
        shadow_cam := Camera_Data.{
            proj = transpose(light_proj),
            view = transpose(light_view),
            light = cam.light,
            light_dir = light_dir,
        };
        uniform_buffer_write(*this_frame.shadowmap_camera_descriptor, *cam);

    }

    {   // Present
        present_info := VkPresentInfoKHR.{
            waitSemaphoreCount = 1,
            pWaitSemaphores = *this_frame.framebuffer.render_finished_semaphore,
            swapchainCount = 1,
            pSwapchains = *global_renderer.swapchain.handle,
            pImageIndices = *this_frame.swapchain_image_index
        };
        result := vkQueuePresentKHR(global_renderer.graphics_queue, *present_info);
        if result == .ERROR_OUT_OF_DATE_KHR { // Window was resized
            swapchain_create_or_update(*swapchain, device, physical_device, surface, window);
        } else {
            Vk_Check(result);
        }
    }

    {   // Prepare next frame
        frame_index = (frame_index + 1) % FRAME_COUNT;
        idx := frame_index;
    }

    buffer_pool_reset(*immediate_buffer_pool);

    // And some perf data
    global_engine.frame_time = cast(float)(SDL_GetPerformanceCounter() - global_engine.frame_start) / cast(float)(SDL_GetPerformanceFrequency() / 1000);
}

set_view_matrix :: (view: Matrix4) {
    global_renderer.view = view;
}

set_push_constants :: inline (mat: Matrix4, cmd: VkCommandBuffer, layout: VkPipelineLayout) {
    pc := Standard_Push_Constants.{
        transform = transpose(mat),
        inverse_transform = transpose(inverse(mat)),
    };
    vkCmdPushConstants(cmd, layout, .VERTEX_BIT, 0, size_of(type_of(pc)), *pc);
}

bind_diffuse :: (desc: VkDescriptorSet, cmd: VkCommandBuffer, layout: VkPipelineLayout) {
    vkCmdBindDescriptorSets(cmd, .GRAPHICS, layout, 2, 1, *desc, 0, null);
}

change_light_vector :: (dir: Vector3) {
    global_renderer.light_dir = dir;
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


create_instance :: (window: *SDL_Window) -> VkInstance {
    
    layers: [..]*u8; 
    layers.allocator = temp;
    // array_add(*layers, temp_c_string("VK_LAYER_KHRONOS_validation"));

    extensions: [..]*u8;
    extensions.allocator = temp;
    
    nb : u32;
    SDL_Vulkan_GetInstanceExtensions(window, *nb, null);
    array_reserve(*extensions, nb);
    SDL_Vulkan_GetInstanceExtensions(window, *nb, extensions.data);
    extensions.count += nb;

    array_add(*extensions, VK_EXT_DEBUG_UTILS_EXTENSION_NAME.data);
    // array_add(*extensions, VK_EXT_VALIDATION_FEATURES_EXTENSION_NAME.data);

    log("Extensions:");
    for ext : extensions {
        log("\t%", to_string(ext));
    }

    enabled_features := VkValidationFeatureEnableEXT.[
        // .GPU_ASSISTED_EXT,
        // .GPU_ASSISTED_RESERVE_BINDING_SLOT_EXT,
        // .BEST_PRACTICES_EXT,
        // .DEBUG_PRINTF_EXT,
        .SYNCHRONIZATION_VALIDATION_EXT,
    ];
    validation_features := VkValidationFeaturesEXT.{
        enabledValidationFeatureCount = xx enabled_features.count,
        pEnabledValidationFeatures = enabled_features.data,
    };
    
    app_info := VkApplicationInfo.{
        apiVersion = VK_MAKE_API_VERSION(0, 1, 3, 0),
    };

    create_info := VkInstanceCreateInfo.{
        // pNext = *validation_features,
        enabledLayerCount = xx layers.count,
        ppEnabledLayerNames = layers.data,
        enabledExtensionCount = xx extensions.count,
        ppEnabledExtensionNames = extensions.data,
        pApplicationInfo = *app_info,
    };
    create_info.enabledLayerCount = xx layers.count;
    instance : VkInstance = ---;
    Vk_Check(vkCreateInstance(*create_info, null, *instance));
    log("Instance created.");
    return instance;
}

create_debug_messenger :: (instance: VkInstance) -> VkDebugUtilsMessengerEXT {
    create_info := VkDebugUtilsMessengerCreateInfoEXT.{
        messageSeverity = .WARNING_BIT_EXT | .ERROR_BIT_EXT | .INFO_BIT_EXT, 
        messageType = .GENERAL_BIT_EXT | .VALIDATION_BIT_EXT | .PERFORMANCE_BIT_EXT | .DEVICE_ADDRESS_BINDING_BIT_EXT,
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
            return device;
        }
    }

    log("No discrete GPU found, picking the first device.");
    return physical_devices[0];
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
    features_1_3 := VkPhysicalDeviceVulkan13Features.{
        dynamicRendering = VK_TRUE,
    };

    create_info := VkDeviceCreateInfo.{
        pNext = *features_1_3,
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
        queueFamilyIndex = queue_family_index,
    };
    command_pool: VkCommandPool = ---;
    Vk_Check(vkCreateCommandPool(device, *cmd_pool_ci, null, *command_pool));
    return command_pool;

}

create_descriptor_sets :: (renderer: *Renderer) {
    renderer.sampler = create_sampler(renderer.device);

    alloc_info := VkDescriptorSetAllocateInfo.{
        descriptorPool = renderer.descriptor_pool,
        descriptorSetCount = 1,
        pSetLayouts = *renderer.empty_set_layout,
    };
    Vk_Check(vkAllocateDescriptorSets(global_renderer.device, *alloc_info, *renderer.empty_descriptor_set));

    data := u8.[255, 255, 255, 255];
    renderer.empty_texture = texture_from_data(data.data, 1, 1, 4, u8, "empty_texture", .SHADER_READ_ONLY_OPTIMAL);
    renderer.empty_texture_descriptor_set = create_texture_descriptor_set(renderer.empty_texture, renderer.single_texture_layout);

    renderer.shadowmap_texture = render_texture_create(Renderer.SHADOWMAP_SIZE, Renderer.SHADOWMAP_SIZE, Renderer.SHADOWMAP_FORMAT, .DEPTH_STENCIL_ATTACHMENT_BIT | .SAMPLED_BIT, .DEPTH_BIT, "shadowmap_texture");
    renderer.shadowmap_descriptor_set = create_texture_descriptor_set(renderer.shadowmap_texture, renderer.single_texture_layout);
}

// create_standard_renderpass :: (device: VkDevice) -> VkRenderPass {
//     format := global_renderer.swapchain.format.format;
//     depth_format := Renderer.DEPTH_FORMAT;

//     attachments := VkAttachmentDescription.[
//     .{
//         format = format,
//         samples = ._1_BIT,
//         loadOp = .CLEAR,
//         storeOp = .STORE,
//         stencilLoadOp = .DONT_CARE,
//         stencilStoreOp = .DONT_CARE,
//         initialLayout = .UNDEFINED,
//         finalLayout = .PRESENT_SRC_KHR,
//     },
//     .{
//         format = depth_format,
//         samples = ._1_BIT,
//         loadOp = .CLEAR,
//         storeOp = .STORE,
//         stencilLoadOp = .DONT_CARE,
//         stencilStoreOp = .DONT_CARE,
//         initialLayout = .UNDEFINED,
//         finalLayout = .DEPTH_STENCIL_ATTACHMENT_OPTIMAL,
//     }];

//     create_info := VkRenderPassCreateInfo.{
//         attachmentCount = attachments.count,
//         pAttachments = attachments.data,
//         subpassCount = 1,
//         pSubpasses = *VkSubpassDescription.{
//             pipelineBindPoint = .GRAPHICS,
//             colorAttachmentCount = 1,
//             pColorAttachments = *VkAttachmentReference.{
//                 attachment = 0,
//                 layout = .COLOR_ATTACHMENT_OPTIMAL,
//             },
//             pDepthStencilAttachment = *VkAttachmentReference.{
//                 attachment = 1,
//                 layout = .DEPTH_STENCIL_ATTACHMENT_OPTIMAL
//             },
//         },
//         dependencyCount = 1,
//         pDependencies = *VkSubpassDependency.{
//             srcSubpass = VK_SUBPASS_EXTERNAL,
//             dstSubpass = 0,
//             srcStageMask = .COLOR_ATTACHMENT_OUTPUT_BIT | .EARLY_FRAGMENT_TESTS_BIT,
//             dstStageMask = .COLOR_ATTACHMENT_OUTPUT_BIT | .EARLY_FRAGMENT_TESTS_BIT,
//             srcAccessMask = 0,
//             dstAccessMask = .COLOR_ATTACHMENT_WRITE_BIT | .DEPTH_STENCIL_ATTACHMENT_WRITE_BIT,
//             dependencyFlags = 0,
//         },
//     };
//     render_pass: VkRenderPass = ---;
//     Vk_Check(vkCreateRenderPass(device, *create_info, null, *render_pass));
//     return render_pass;
// }

// begin_standard_renderpass :: (renderer: *Renderer, command_buffer: VkCommandBuffer, framebuffer: VkFramebuffer) {
//     clear_color := Vector4.{0.529, 0.808, 0.922, 0};
//     clear_values := VkClearValue.[
//         .{color = .{float32_ = clear_color.component}},
//         .{depthStencil = .{1, 0}}
//     ];
//      vkCmdBeginRenderPass(command_buffer, *VkRenderPassBeginInfo.{
//         renderPass = renderer.standard_render_pass,
//         framebuffer = framebuffer,
//         clearValueCount = clear_values.count,
//         pClearValues = clear_values.data,
//         renderArea = .{
//             offset = .{0, 0},
//             extent = renderer.swapchain.extent,
//         },
//     }, VK_SUBPASS_CONTENTS_INLINE);
// }

// create_shadowmap_renderpass :: (device: VkDevice) -> VkRenderPass {
//     format := global_renderer.swapchain.format.format;
//     depth_format := Renderer.DEPTH_FORMAT;

//     attachments := VkAttachmentDescription.[.{
//         format = depth_format,
//         samples = ._1_BIT,
//         loadOp = .CLEAR,
//         storeOp = .STORE,
//         stencilLoadOp = .DONT_CARE,
//         stencilStoreOp = .DONT_CARE,
//         initialLayout = .UNDEFINED,
//         finalLayout = .DEPTH_STENCIL_READ_ONLY_OPTIMAL,
//     }];

//     dependencies := VkSubpassDependency.[.{
//         srcSubpass = VK_SUBPASS_EXTERNAL,
//         dstSubpass = 0,
//         srcStageMask = .FRAGMENT_SHADER_BIT, 
//         dstStageMask = .EARLY_FRAGMENT_TESTS_BIT,
//         srcAccessMask = .SHADER_READ_BIT,
//         dstAccessMask = .DEPTH_STENCIL_ATTACHMENT_WRITE_BIT,
//         dependencyFlags = VK_DEPENDENCY_BY_REGION_BIT,
//     },
//     .{
//         srcSubpass = 0,
//         dstSubpass = VK_SUBPASS_EXTERNAL,
//         srcStageMask = .LATE_FRAGMENT_TESTS_BIT, 
//         dstStageMask = .FRAGMENT_SHADER_BIT,
//         srcAccessMask = .DEPTH_STENCIL_ATTACHMENT_WRITE_BIT,
//         dstAccessMask = .SHADER_READ_BIT,
//         dependencyFlags = VK_DEPENDENCY_BY_REGION_BIT,
//     }];

//     create_info := VkRenderPassCreateInfo.{
//         attachmentCount = attachments.count,
//         pAttachments = attachments.data,
//         subpassCount = 1,
//         pSubpasses = *VkSubpassDescription.{
//             pipelineBindPoint = .GRAPHICS,
//             colorAttachmentCount = 0,
//             pDepthStencilAttachment = *VkAttachmentReference.{
//                 attachment = 0,
//                 layout = .DEPTH_STENCIL_ATTACHMENT_OPTIMAL
//             },
//         },
//         dependencyCount = dependencies.count,
//         pDependencies = dependencies.data
//     };
//     render_pass: VkRenderPass = ---;
//     Vk_Check(vkCreateRenderPass(device, *create_info, null, *render_pass));
//     return render_pass;
// }

// begin_shadowmap_renderpass :: (renderer: Renderer, command_buffer: VkCommandBuffer) {
//     clear_value := VkClearValue.{depthStencil = .{1, 0}};
//     vkCmdBeginRenderPass(command_buffer, *VkRenderPassBeginInfo.{
//         renderPass = renderer.shadowmap_render_pass,
//         framebuffer = renderer.shadowmap_framebuffer,
//         clearValueCount = 1,
//         pClearValues = *clear_value,
//         renderArea = .{
//             offset = .{0, 0},
//             extent = .{renderer.shadowmap_texture.w, renderer.shadowmap_texture.h}
//         },
//     }, VK_SUBPASS_CONTENTS_INLINE);
// }

// draw :: (using self: Mesh, command_buffer: VkCommandBuffer) {
//     for submeshes {
//         vkCmdBindVertexBuffers(command_buffer, 0, 1, *it.vertices_loc.buffer.buffer, *it.vertices_loc.offset);
//         vkCmdBindIndexBuffer(command_buffer, it.indices_loc.buffer.buffer, it.indices_loc.offset, .UINT32);
//         vkCmdDrawIndexed(command_buffer, xx it.index_count, 1, 0, 0, 0);
//     }
// }

// draw :: (using self: Skinned_Mesh, command_buffer: VkCommandBuffer) {

//     for submeshes {
//         vkCmdBindVertexBuffers(command_buffer, 0, 1, *it.vertices_loc.buffer.buffer, *it.vertices_loc.offset);
//         vkCmdBindVertexBuffers(command_buffer, 1, 1, *skins[it_index].buffer.buffer, *skins[it_index].offset);
//         vkCmdBindIndexBuffer(command_buffer, it.indices_loc.buffer.buffer, it.indices_loc.offset, .UINT32);
//         vkCmdDrawIndexed(command_buffer, xx it.index_count, 1, 0, 0, 0);
//     }
// }
