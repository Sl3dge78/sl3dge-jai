Buffer_Location :: struct {
    buffer: Buffer; 
    offset: u64;
    size: VkDeviceSize;
}

Buffer_Pool :: struct {
    BUFFER_SIZE :: 32 * 1024 * 1024;

    name: string;
    kind: VkBufferUsageFlagBits;
    buffers: [..]Buffer;
    current_buffer: s64 = 0;
    current_position_in_buffer: VkDeviceSize;
    alignement: VkDeviceSize = 1;
}

maybe_grow :: (using buffer_pool: *Buffer_Pool, size: VkDeviceSize) {
    assert(size < BUFFER_SIZE, "Trying to allocate too much from pool!");

    if buffers.count - 1 > current_buffer {
        current_buffer += 1;
        current_position_in_buffer = 0;
        return;
    }

    if buffers.count == 0 || size > (BUFFER_SIZE - current_position_in_buffer) {
        buffer := buffer_create(BUFFER_SIZE, kind, .UPLOAD, tprint("%_%", name, buffers.count));
        array_add(*buffers, buffer);
        current_position_in_buffer = 0;
        current_buffer = buffers.count - 1;
        return;
    }
}

buffer_pool_get :: (using self: *Buffer_Pool, size: VkDeviceSize) -> Buffer_Location {
    aligned_size := get_aligned_size(size, alignement);
    maybe_grow(self, aligned_size);
    result := Buffer_Location.{
        buffer = buffers[current_buffer],
        offset = current_position_in_buffer,
        size = size,
    };
    current_position_in_buffer += aligned_size;
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
    current_buffer = 0;
    current_position_in_buffer = 0;
}

destroy :: (using buffer_pool: *Buffer_Pool) {
    for buffers {
        destroy(*buffers[it_index]);
    }
    array_reset(*buffers);
    current_position_in_buffer = 0;
}