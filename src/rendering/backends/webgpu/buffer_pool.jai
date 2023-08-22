Buffer_Location :: struct {
    buffer: *Buffer;
    offset: u64;
    size: u64;
}

Buffer_Pool :: struct {
    MIN_BUFFER_SIZE :: 32 * 1024 * 1024;

    buffers: [..] Buffer;
    current_position_in_buffer: u64;
    kind: wgpu.BufferUsageFlags; 

    maybe_grow :: (using buffer_pool: *Buffer_Pool, size: u64) {
        if buffers.count == 0 || size > (buffers[buffers.count - 1].size - current_position_in_buffer) {
            array_add(*buffers, Buffer.create(max(size, MIN_BUFFER_SIZE), kind));
            current_position_in_buffer = 0;
        }
    }

    get :: (using buffer_pool: *Buffer_Pool, size: u64) -> Buffer_Location {
        loc : Buffer_Location;
        aligned := aligned_size(size, global_renderer.uniform_buffer_alignement);
        Buffer_Pool.maybe_grow(buffer_pool, xx aligned);
        loc.buffer = *buffers[buffers.count - 1];
        loc.offset = current_position_in_buffer;
        loc.size = size;
        current_position_in_buffer += aligned;
        return loc;
    }

    load_data :: (using buffer_pool: *Buffer_Pool, data: []$T) -> Buffer_Location {
        size : u64 = xx (data.count * size_of(T));
        loc := get(buffer_pool, size);
        Buffer.write_data(loc.buffer, data.data, size, loc.offset);
        return loc;
    }

    load_mesh :: (using buffer_pool: *Buffer_Pool, vertices: []$T, indices: []u32) -> Sub_Mesh {
        mesh: Sub_Mesh;
        mesh.vertices = load_data(buffer_pool, vertices);
        mesh.vertex_count = xx vertices.count;
        mesh.indices = load_data(buffer_pool, indices);
        mesh.index_count = xx indices.count;
        return mesh;
    }

    reset :: (using buffer_pool: *Buffer_Pool) {
        for *buffers {
            Buffer.destroy(it);
        }
        array_reset(*buffers);
        current_position_in_buffer = 0;
    }

}