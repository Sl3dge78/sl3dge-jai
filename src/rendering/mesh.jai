

vertex_input_attribute :: #run () -> []VkVertexInputAttributeDescription {
    offset: *Vertex = null;
    vtx_attr := VkVertexInputAttributeDescription.[
        .{location = 0, binding = 0, format = .R32G32B32_SFLOAT, offset = xx *offset.position},
        .{location = 1, binding = 0, format = .R32G32B32_SFLOAT, offset = xx *offset.normal},
        .{location = 2, binding = 0, format = .R32G32_SFLOAT, offset = xx *offset.uv},
        .{location = 3, binding = 0, format = .R32G32B32A32_SFLOAT, offset = xx *offset.color}
    ];
    
    return vtx_attr;
}();

SubMesh :: struct {
    vertices_loc: Buffer_Pool_Location;
    vertex_count: u64;
    indices_loc : Buffer_Pool_Location;
    index_count : u64;
}

Mesh :: struct {
    submeshes : [..] SubMesh;

    deinit :: (using mesh : *Mesh) {
        array_reset(*submeshes);
    }
}

draw :: (using self: Mesh, command_buffer: VkCommandBuffer) {
    for submeshes {
        vkCmdBindVertexBuffers(command_buffer, 0, 1, *it.vertices_loc.buffer.buffer, *it.vertices_loc.offset);
        vkCmdBindIndexBuffer(command_buffer, it.indices_loc.buffer.buffer, it.indices_loc.offset, .UINT32);
        vkCmdDrawIndexed(command_buffer, xx it.index_count, 1, 0, 0, 0);
    }
}

load_mesh_from_data :: (gltf_data : GLTF_Data) -> Mesh {
    result : Mesh;

    for mesh: gltf_data.meshes {
        assert(mesh.primitives.count == 1, "No or multiple primitives found!"); // @TODO: handle multiple primitives
        using primitive := mesh.primitives[0];
        assert(position_accessor != -1, "No positions for vertices!");

        // Vertices
        accessor := gltf_data.accessors[position_accessor];
        assert(accessor.component_type == .FLOAT);
        vertices := NewArray(accessor.count, Vertex, allocator = temp);
        
        read_accessor_into_array(vertices.data, 0, size_of(Vertex), gltf_data, position_accessor);
        
        // Normals
        if normal_accessor != -1 {
            offset: *Vertex = null;
            read_accessor_into_array(vertices.data, xx *offset.normal, size_of(Vertex), gltf_data, normal_accessor);
        }
        
        // Indices
        idx_accessor := gltf_data.accessors[indices_accessor];
        indices := NewArray(idx_accessor.count, u32, allocator = temp);
        read_accessor_into_array(indices.data, 0, size_of(u32), gltf_data, indices_accessor);
        array_add(*result.submeshes, Buffer_Pool.load_mesh(*global_renderer.buffer_pool, vertices, indices));
    }
    return result;
}

load_gltf :: (path: string) -> Mesh {
    gltf_data := gltf_parse_file(path);
    defer gltf_free(*gltf_data);

    gltf_load_buffers(*gltf_data);

    return load_mesh_from_data(gltf_data);
}

read_accessor_into_array :: (dst: *void, dst_offset: u64, dst_stride: u64, gltf_data: GLTF_Data, accessor_id: int) {
    accessor := gltf_data.accessors[accessor_id];
    buffer_view := gltf_data.buffer_views[accessor.buffer_view];
    buffer      := gltf_data.buffers[buffer_view.buffer];
    component_info := get_component_info(accessor);
    offset := buffer_view.byte_offset + accessor.byte_offset;
        
    dst_data := dst + dst_offset;
    for data_index: 0..accessor.count - 1 {
        data := (buffer.data.data + offset + data_index * accessor.stride);
        memcpy(dst_data, data, component_info.stride);
        dst_data += dst_stride;
    }
}
