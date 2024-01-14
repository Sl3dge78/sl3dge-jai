Buffer :: struct {
    #as handle: VkBuffer;
    memory: VmaAllocation;
    size: VkDeviceSize;
}

buffer_create :: (size: u64, usage: VkBufferUsageFlagBits, name: string) -> Buffer {
    result: Buffer;
    buffer_ci := VkBufferCreateInfo.{
        size = size,
        usage = usage,
        sharingMode = .EXCLUSIVE,
        queueFamilyIndexCount = 1,
        pQueueFamilyIndices = *global_renderer.queue_family_index,
    };

    alloc_ci := VmaAllocationCreateInfo.{
        usage = .AUTO,
        flags = .HOST_ACCESS_SEQUENTIAL_WRITE_BIT,
    };
    Vk_Check(vmaCreateBuffer(global_renderer.allocator, *buffer_ci, *alloc_ci, *result.handle, *result.memory, null));
    debug_name_object(result.handle, name);

    result.size = size;

    return result;
}

buffer_from_data :: (data: []$T, usage: VkBufferUsageFlagBits) -> Buffer {
    size : VkDeviceSize = xx (data.count * size_of(T));
    self := buffer_create(size, usage, "");
    buffer_write_data(self, data.data, size, 0);
    return self;
}

buffer_create_mesh :: (vertices: []$T, indices: []u32) -> Sub_Mesh {
    vtx := buffer_from_data(vertices, .VERTEX_BUFFER_BIT);
    idx := buffer_from_data(indices, .INDEX_BUFFER_BIT);
    return Sub_Mesh.{
        vtx,
        xx vertices.count,
        idx,
        xx indices.count
    };
}

buffer_create_or_update :: (buffer: *Buffer, size: u64, usage: VkBufferUsageFlagBits, mem_type: MemoryType, $map := false) {
    if buffer.buffer != VK_NULL_HANDLE && buffer.size >= size then return;
    if buffer.buffer != VK_NULL_HANDLE {
        wait_idle();
        destroy(buffer);
    }

    buffer.* = buffer_create(size, usage, mem_type, map);
}

destroy :: (buffer: *Buffer) {
    vmaDestroyBuffer(global_renderer.allocator, buffer.handle, buffer.memory);
    buffer.* = .{};
}

buffer_write_data :: (buffer: Buffer, data: *void, size: u64, offset: VkDeviceSize = 0) {
    ptr: *void;
    Vk_Check(vmaMapMemory(global_renderer.allocator, buffer.memory, *ptr));
    defer vmaUnmapMemory(global_renderer.allocator, buffer.memory);
    assert(ptr != null, "Unable to map memory");
    ptr += offset;

    memcpy(ptr, data, xx size);
    Vk_Check(vmaFlushAllocation(global_renderer.allocator, buffer.memory, 0, VK_WHOLE_SIZE));
}

buffer_map :: (buffer: *Buffer) -> *void {
    ptr: *void;
    Vk_Check(vmaMapMemory(global_renderer.allocator, buffer.memory, *ptr));
    return ptr;
}

buffer_unmap :: (buffer: *Buffer) {
    vmaUnmapMemory(global_renderer.allocator, buffer.memory);
}