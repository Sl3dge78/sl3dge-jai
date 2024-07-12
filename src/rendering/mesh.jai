Sub_Mesh :: struct {
    vertices : Buffer_Location;
    vertex_count: u64;
    indices : Buffer_Location;
    index_count : u32;
}

Mesh :: struct {
    submeshes : [..] Sub_Mesh;
}

destroy :: (using mesh : *Mesh) {
    array_reset(*submeshes);
}

draw :: inline (using self: Mesh, rp_enc: wgpu.RenderPassEncoder) {
    for submeshes {
        wgpu.RenderPassEncoderSetVertexBuffer(rp_enc, 0, it.vertices.buffer.handle, it.vertices.offset, it.vertices.size);
        wgpu.RenderPassEncoderSetIndexBuffer(rp_enc, it.indices.buffer.handle, .Uint32, it.indices.offset, it.indices.size);
        wgpu.RenderPassEncoderDrawIndexed(rp_enc, it.index_count, 1, 0, 0, 0);
    }
}

load_mesh_from_vertices :: (vertices: []Standard_Vertex, indices: []u32) -> Mesh {
    result: Mesh;
    array_add(*result.submeshes, buffer_pool_load_mesh(*global_renderer.vertex_pool, vertices, indices));
    return result;
}

load_mesh_from_gltf_data :: (gltf_data : GLTF_Data) -> Mesh {
    result : Mesh;

    for mesh: gltf_data.meshes {
        assert(mesh.primitives.count == 1, "No or multiple primitives found!"); // @TODO: handle multiple primitives
        using primitive := mesh.primitives[0];
        assert(position_accessor != -1, "No positions for vertices!");

        // Vertices
        accessor := gltf_data.accessors[position_accessor];
        assert(accessor.component_type == .FLOAT);
        vertices := NewArray(accessor.count, Standard_Vertex,, allocator = temp);
        
        read_accessor_into_array(vertices.data, 0, size_of(Standard_Vertex), gltf_data, position_accessor);
        
        // Normals
        if normal_accessor != -1 {
            offset: *Standard_Vertex = null;
            read_accessor_into_array(vertices.data, xx *offset.normal, size_of(Standard_Vertex), gltf_data, normal_accessor);
        }

        color: Vector4 = .{1, 1, 1, 1};

        if material != -1 {
            color.component = gltf_data.materials[material].metallic_roughness.base_color_factor;
        }

        for *vertices {
            it.color = color;
        }
        
        // Indices
        idx_accessor := gltf_data.accessors[indices_accessor];
        indices := NewArray(idx_accessor.count, u32,, allocator = temp);
        read_accessor_into_array(indices.data, 0, size_of(u32), gltf_data, indices_accessor);
        array_add(*result.submeshes, buffer_pool_load_mesh(*global_renderer.vertex_pool, vertices, indices));
    }
    return result;
}

load_mesh_from_file :: (path: string) -> Mesh {
    gltf_data := gltf_parse_file(path);
    defer gltf_free(*gltf_data);

    gltf_load_buffers(*gltf_data);

    return load_mesh_from_gltf_data(gltf_data);
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

Mesh_Builder :: struct {
    vertices: [..]Standard_Vertex;
    indices: [..]u32;
}

mesh_builder_push_quad :: (using builder: *Mesh_Builder, p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3, normal: Vector3, color: Vector4 = .{1, 1, 1, 1}) {
    vertices.allocator = temp;
    indices.allocator = temp;
    i : u32 = xx vertices.count;
    array_add(*vertices, .{p0, normal, .{0, 0}, color});
    array_add(*vertices, .{p1, normal, .{1, 0}, color});
    array_add(*vertices, .{p2, normal, .{1, 1}, color});
    array_add(*vertices, .{p3, normal, .{0, 1}, color});

    array_add(*indices, ..u32.[i, i+1, i+2, i, i+2, i+3]);
}

mesh_builder_load_mesh :: (using builder: *Mesh_Builder) -> Mesh {
    return load_mesh_from_vertices(vertices, indices);
}
