Buffer_Pool_Location :: struct {
    buffer: *Buffer;
    offset: u64;
}

Buffer_Pool :: struct {
    BUFFER_SIZE :: 32 * 1024 * 1024;

    buffers: [..] Buffer;
    current_position_in_buffer: VkDeviceSize;

    maybe_grow :: (using buffer_pool: *Buffer_Pool, size: VkDeviceSize) {
        if buffers.count == 0 || size > (BUFFER_SIZE - current_position_in_buffer) {
            array_add(*buffers, buffer_create(BUFFER_SIZE, .VERTEX_BUFFER_BIT | .INDEX_BUFFER_BIT | .STORAGE_BUFFER_BIT | .TRANSFER_SRC_BIT, .UPLOAD));
            current_position_in_buffer = 0;
        }
    }

    load_data :: (using buffer_pool: *Buffer_Pool, data: []$T) -> Buffer_Pool_Location {
        loc : Buffer_Pool_Location;
        size : VkDeviceSize = xx (data.count * size_of(T));
        Buffer_Pool.maybe_grow(buffer_pool, xx size);
        loc.buffer = *buffers[buffers.count - 1];
        loc.offset = current_position_in_buffer;
        buffer_write_data(loc.buffer, data.data, size, loc.offset);
        current_position_in_buffer += size;
        return loc;
    }

    load_mesh :: (using buffer_pool: *Buffer_Pool, vertices: []$T, indices: []u32) -> SubMesh {
        mesh: SubMesh;
        mesh.vertices_loc = load_data(buffer_pool, vertices);
        mesh.vertex_count = xx vertices.count;
        mesh.indices_loc = load_data(buffer_pool, indices);
        mesh.index_count = xx indices.count;
        return mesh;
    }

    reset_pool :: (using buffer_pool: *Buffer_Pool) {
        for *buffers {
            buffer_destroy(it);
        }
        array_reset(*buffers);
        current_position_in_buffer = 0;
    }

}