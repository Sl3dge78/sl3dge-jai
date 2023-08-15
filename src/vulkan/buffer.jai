Buffer :: struct {
    buffer: VkBuffer;
    memory: VkDeviceMemory;
    mapped: *void;
    size: u64;

    create :: (size: u64, usage: VkBufferUsageFlagBits, mem_type: Renderer.MemoryType, $map := false) -> Buffer {
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
        result.size = size;

        #if map {
            Buffer.map(*result);
        }
        return result;
    }

    create_or_update :: (buffer: *Buffer, size: u64, usage: VkBufferUsageFlagBits, mem_type: Renderer.MemoryType, $map := false) {
        if buffer.buffer != VK_NULL_HANDLE && buffer.size >= size then return;
        if buffer.buffer != VK_NULL_HANDLE {
            Renderer.wait_idle();
            Buffer.destroy(buffer);
        }

        buffer.* = Buffer.create(size, usage, mem_type, map);
    }

    destroy :: (buffer: *Buffer) {
        vkFreeMemory(global_renderer.device, buffer.memory, null);
        vkDestroyBuffer(global_renderer.device, buffer.buffer, null);
        buffer.* = .{};
    }

    write_data :: (buffer: Buffer, data: *void, size: u64, offset: VkDeviceSize = 0) {
        ptr: *void;
        vkMapMemory(global_renderer.device, buffer.memory, offset, size, 0, *ptr);
        defer vkUnmapMemory(global_renderer.device, buffer.memory);

        memcpy(ptr, data, xx size);
    }

    map :: (buffer: *Buffer) -> *void {
        ptr: *void;
        vkMapMemory(global_renderer.device, buffer.memory, 0, VK_WHOLE_SIZE, 0, *ptr);
        buffer.mapped = ptr;
        return ptr;
    }

    unmap :: (buffer: *Buffer) {
        vkUnmapMemory(global_renderer.device, buffer.memory);
        buffer.mapped = null;
    }

}