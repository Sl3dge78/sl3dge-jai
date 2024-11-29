
Vk_Check :: (result: VkResult) #expand #no_debug {
    assert(result == .SUCCESS, "Vk result is %", result);
}

fill_array :: ($type: Type, func: $R, arg: $S) -> [..]type #expand {
    nb: u32 = ---;
    array: [..]type;
    `defer array_reset(*array);
    array.allocator = temp;
    func(arg, *nb, null);
    array_reserve(*array, nb);
    func(arg, *nb, array.data);
    array.count = xx nb;

    return array;
}

fill_array :: ($type: Type, func: $R, arg1: $S, arg2: $U, allocator := temp) -> [..]type #expand {
    nb: u32 = ---;
    array: [..]type;
    array.allocator = allocator;
    func(arg1, arg2, *nb, null);
    array_reserve(*array, nb);
    func(arg1, arg2, *nb, array.data);
    array.count = xx nb;

    return array;
}

alloc_device_memory :: (item: $T, mem_type: MemoryType) -> VkDeviceMemory {
    memory_reqs: VkMemoryRequirements;
    memory: VkDeviceMemory;
    #if T == VkBuffer {
        vkGetBufferMemoryRequirements(global_renderer.device, item, *memory_reqs);
    } else #if T == VkImage {
        vkGetImageMemoryRequirements(global_renderer.device, item, *memory_reqs);
    } else {
        #assert false, "Cannot allocate memory for this item";
    }
    mem_index := bit_scan_forward(global_renderer.compatible_mem_types[mem_type]) - 1;
    alloc_info := VkMemoryAllocateInfo.{
        allocationSize = memory_reqs.size,
        memoryTypeIndex = xx mem_index,
    };
    Vk_Check(vkAllocateMemory(global_renderer.device, *alloc_info, null, *memory));

    #if T == VkBuffer {
        vkBindBufferMemory(global_renderer.device, item, memory, 0);
    } else #if T == VkImage {
        vkBindImageMemory(global_renderer.device, item, memory, 0);
    } else {
        #assert false, "Cannot bind memory for this item";
    }
    return memory;
}

// Maybe a bad idea, allocates and starts a command command then ends it at the end of the current scope.
begin_single_time_command_buffer :: () -> VkCommandBuffer {
    alloc_info := VkCommandBufferAllocateInfo.{
        level = .PRIMARY,
        commandPool = global_renderer.command_pool,
        commandBufferCount = 1,
    };

    cmd: VkCommandBuffer = ---;
    Vk_Check(vkAllocateCommandBuffers(global_renderer.device, *alloc_info, *cmd));

    begin_info := VkCommandBufferBeginInfo.{
        flags = .ONE_TIME_SUBMIT_BIT,
    };
    Vk_Check(vkBeginCommandBuffer(cmd, *begin_info));

    return cmd;
}

end_single_time_command_buffer :: (cmd: VkCommandBuffer) {
    vkEndCommandBuffer(cmd);
    si := VkSubmitInfo.{
        commandBufferCount = 1,
        pCommandBuffers = *cmd
    };
    vkQueueSubmit(global_renderer.graphics_queue, 1, *si, null);
    vkQueueWaitIdle(global_renderer.graphics_queue);

    vkFreeCommandBuffers(global_renderer.device, global_renderer.command_pool, 1, *cmd);
}

vkCmdInsertDebugUtilsLabelEXT : PFN_vkCmdInsertDebugUtilsLabelEXT;
vkCreateDebugUtilsMessengerEXT : PFN_vkCreateDebugUtilsMessengerEXT;
vkDestroyDebugUtilsMessengerEXT : PFN_vkDestroyDebugUtilsMessengerEXT;
vkSetDebugUtilsObjectNameEXT : PFN_vkSetDebugUtilsObjectNameEXT;

load_function_pointers :: (instance: VkInstance) {
    load :: (name: string) -> *void #expand {
        result := vkGetInstanceProcAddr(`instance, name);
        assert(result != null, "Unable to load pfn %", name);
        return xx result;
    }
    vkCmdInsertDebugUtilsLabelEXT = xx load("vkCmdInsertDebugUtilsLabelEXT");
    vkCreateDebugUtilsMessengerEXT = xx load("vkCreateDebugUtilsMessengerEXT");
    vkDestroyDebugUtilsMessengerEXT = xx load("vkDestroyDebugUtilsMessengerEXT");
    vkSetDebugUtilsObjectNameEXT = xx load("vkSetDebugUtilsObjectNameEXT");
}

debug_callback :: (severity: VkDebugUtilsMessageSeverityFlagsEXT, type: VkDebugUtilsMessageTypeFlagsEXT, callback_data: *VkDebugUtilsMessengerCallbackDataEXT,  data: *void) -> VkBool32 #c_call {
    ctx := (cast(*Context)data).*;
    push_context ctx {
        msg := to_string(callback_data.pMessage);
        log("%: %\n", severity, msg);
        if severity >= .ERROR_BIT_EXT {
            // assert(false);
            debug_break();
        }
    }
    return VK_TRUE;
}

debug_marker :: (command_buffer: VkCommandBuffer, label: string) {
    marker_info := VkDebugUtilsLabelEXT.{
        pLabelName = temp_c_string(label),
    };

    vkCmdInsertDebugUtilsLabelEXT(command_buffer, *marker_info);
}

debug_name_object :: (handle: $T, name: string) {
    name_info := VkDebugUtilsObjectNameInfoEXT.{
        objectType = get_vk_object_type(T),
        objectHandle = xx handle,
        pObjectName = temp_c_string(name),

    };
    Vk_Check(vkSetDebugUtilsObjectNameEXT(global_renderer.device, *name_info));
}

get_vk_object_type :: ($object: Type) -> VkObjectType {
    #if object == VkCommandBuffer {
        return .COMMAND_BUFFER;
    } else #if object == VkImageView {
        return .IMAGE_VIEW;
    } else #if object == VkImage {
        return .IMAGE;
    } else #if object == VkBuffer {
        return .BUFFER;
    } else #assert(false, "Unregistered object");
}