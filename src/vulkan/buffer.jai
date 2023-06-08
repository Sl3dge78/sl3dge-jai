Buffer :: struct {
    buffer: VkBuffer;
    memory: VkDeviceMemory;
    mapped: *void;
}

create_buffer :: (size: u64, usage: VkBufferUsageFlagBits, mem_type: Renderer.MemoryType, $map := false) -> Buffer {
    result: Buffer;
    buffer_ci := VkBufferCreateInfo.{
        size = size,
        usage = usage,
        sharingMode = .EXCLUSIVE,
        queueFamilyIndexCount = 1,
        pQueueFamilyIndices = *global_renderer.queue_family_index,
    };
    Vk_Check(vkCreateBuffer(global_renderer.device, *buffer_ci, null, *result.buffer));

    result.memory = alloc_device_memory(result.buffer, mem_type);

    #if map {
        map_buffer(*result);
    }
    return result;
}

destroy_buffer :: (buffer: Buffer) {
    vkFreeMemory(global_renderer.device, buffer.memory, null);
    vkDestroyBuffer(global_renderer.device, buffer.buffer, null);
}

copy_data :: (buffer: Buffer, data: *void, size: u64) {
    ptr: *void;
    vkMapMemory(global_renderer.device, buffer.memory, 0, size, 0, *ptr);
    defer vkUnmapMemory(global_renderer.device, buffer.memory);

    memcpy(ptr, data, xx size);
}

map_buffer :: (buffer: *Buffer) -> *void {
    ptr: *void;
    vkMapMemory(global_renderer.device, buffer.memory, 0, VK_WHOLE_SIZE, 0, *ptr);
    buffer.mapped = ptr;
    return ptr;
}

unmap_buffer :: (buffer: *Buffer) {
    vkUnmapMemory(global_renderer.device, buffer.memory);
    buffer.mapped = null;
}
