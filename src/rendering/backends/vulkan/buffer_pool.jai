Buffer_Location :: struct {
    buffer: Buffer; 
    offset: u64;
    size: VkDeviceSize;
}

Buffer_Pool :: struct {
    BUFFER_SIZE :: 32 * 1024 * 1024;

    buffers: [..]Buffer;
    current_position_in_buffer: VkDeviceSize;
}

maybe_grow :: (using buffer_pool: *Buffer_Pool, size: VkDeviceSize) {
    if buffers.count == 0 || size > (BUFFER_SIZE - current_position_in_buffer) {
        array_add(*buffers, buffer_create(BUFFER_SIZE, VK_BUFFER_USAGE_VERTEX_BUFFER_BIT | VK_BUFFER_USAGE_INDEX_BUFFER_BIT | VK_BUFFER_USAGE_STORAGE_BUFFER_BIT | VK_BUFFER_USAGE_TRANSFER_SRC_BIT, .UPLOAD));
        current_position_in_buffer = 0;
    }
}

buffer_pool_get :: (using self: *Buffer_Pool, size: VkDeviceSize) -> Buffer_Location {
    maybe_grow(self, size);
    result := Buffer_Location.{
        buffer = buffers[buffers.count - 1],
        offset = current_position_in_buffer,
        size = size,
    };
    current_position_in_buffer += size;
    return result;
}

buffer_pool_load_data :: (using self: *Buffer_Pool, data: []$T) -> Buffer_Location {
    size : VkDeviceSize = xx (data.count * size_of(T));
    loc := buffer_pool_get(self, size);
    maybe_grow(self, xx size);
    buffer_write_data(loc.buffer, data.data, size, loc.offset);
    return loc;
}

buffer_pool_load_mesh :: (using buffer_pool: *Buffer_Pool, vertices: []$T, indices: []u32) -> Sub_Mesh {
    mesh: Sub_Mesh;
    mesh.vertices= buffer_pool_load_data(buffer_pool, vertices);
    mesh.vertex_count = xx vertices.count;
    mesh.indices= buffer_pool_load_data(buffer_pool, indices);
    mesh.index_count = xx indices.count;
    return mesh;
}

buffer_pool_reset :: (using buffer_pool: *Buffer_Pool) {
    for *buffers {
        destroy(it);
    }
    array_reset(*buffers);
    current_position_in_buffer = 0;
}