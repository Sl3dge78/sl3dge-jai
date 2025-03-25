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

draw :: inline(using self: Mesh, render_pass: *SDL_GPURenderPass, instances : u32 = 1) {
    for submeshes {
        SDL_BindGPUIndexBuffer(render_pass, *it.indices, ._32BIT);
        SDL_BindGPUVertexBuffers(render_pass, 0, *it.vertices, 1);
        SDL_DrawGPUIndexedPrimitives(render_pass, it.index_count, instances, 0, 0, 0);
    }
}

load_mesh_from_vertices :: (vertices: []Standard_Vertex, indices: []u32) -> Mesh {
    result: Mesh;
    array_add(*result.submeshes, buffer_pool_load_mesh(*global_renderer.vertex_buffer_pool, vertices, indices));
    return result;
}

load_mesh_from_gltf_data :: (gltf_data : GLTF_Data) -> Mesh {
    result : Mesh;

    for mesh: gltf_data.meshes {
        assert(mesh.primitives.count == 1, "No or multiple primitives found!"); // @TODO: handle multiple primitives
        using primitive := mesh.primitives[0];
        assert(position_accessor != -1, "No positions for vertices!");

        // Indices
        idx_accessor := gltf_data.accessors[indices_accessor];
        indices := NewArray(idx_accessor.count, u32,, allocator = temp);
        read_accessor_into_array(indices.data, 0, size_of(u32), size_of(u32), gltf_data, indices_accessor);

        // Vertices
        offset: *Standard_Vertex = null;
        accessor := gltf_data.accessors[position_accessor];
        assert(accessor.component_type == .FLOAT);

        vertices := NewArray(accessor.count, Standard_Vertex,, allocator = temp);
        read_accessor_into_array(vertices.data, xx *offset.position, size_of(Standard_Vertex), size_of(type_of(offset.position)), gltf_data, position_accessor);
        
        // Normals
        if normal_accessor != -1 {
            read_accessor_into_array(vertices.data, xx *offset.normal, size_of(Standard_Vertex), size_of(type_of(offset.normal)), gltf_data, normal_accessor);
        }

        if texcoord_0_accessor != -1 {
            read_accessor_into_array(vertices.data, xx *offset.uv, size_of(Standard_Vertex), size_of(type_of(offset.uv)), gltf_data, texcoord_0_accessor);
        }

        if tangent_accessor != -1 {
            read_accessor_into_array(vertices.data, xx *offset.tangent, size_of(Standard_Vertex), size_of(type_of(offset.tangent)), gltf_data, tangent_accessor);
        } else {
            log("[MESH] Calculating tangents");
            calculate_tangents(vertices, indices);
        }

        array_add(*result.submeshes, buffer_pool_load_mesh(*global_renderer.vertex_buffer_pool, vertices, indices));

    }
    return result;
}

load_mesh_from_file :: (path: string) -> Mesh {
    log("[MESH] Loading %.", path);
    gltf_data := gltf_parse_file(path);
    defer gltf_free(*gltf_data);

    gltf_load_buffers(*gltf_data);

    return load_mesh_from_gltf_data(gltf_data);
}

read_accessor_into_array :: (dst: *void, dst_offset: u64, dst_stride: u64, dst_size: s64, gltf_data: GLTF_Data, accessor_id: int) {
    accessor := gltf_data.accessors[accessor_id];
    buffer_view := gltf_data.buffer_views[accessor.buffer_view];
    buffer      := gltf_data.buffers[buffer_view.buffer];
    component_info := get_component_info(accessor);
    offset := buffer_view.byte_offset + accessor.byte_offset;
        
    dst_data := dst + dst_offset;
    for data_index: 0..accessor.count - 1 {
        data := (buffer.data.data + offset + data_index * accessor.stride);
        memcpy(dst_data, data, min(dst_size, component_info.stride));
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
    array_add(*vertices, .{p0, normal, .{0, 0}, .{}});
    array_add(*vertices, .{p1, normal, .{1, 0}, .{}});
    array_add(*vertices, .{p2, normal, .{1, 1}, .{}});
    array_add(*vertices, .{p3, normal, .{0, 1}, .{}});

    array_add(*indices, ..u32.[i, i+1, i+2, i, i+2, i+3]);
}

mesh_builder_push_triangle :: (using builder: *Mesh_Builder, p0: Vector3, p1: Vector3, p2: Vector3, normal: Vector3, color:= Vector4.{1, 1, 1, 1}) {
    vertices.allocator = temp;
    indices.allocator = temp;
    i : u32 = xx vertices.count;
    array_add(*vertices, .{p0, normal, .{0, 0}, .{}});
    array_add(*vertices, .{p1, normal, .{1, 0}, .{}});
    array_add(*vertices, .{p2, normal, .{1, 1}, .{}});

    array_add(*indices, ..u32.[i, i+1, i+2]);
}

mesh_builder_load_mesh :: (using builder: *Mesh_Builder) -> Mesh {
    assert(vertices.count != 0);
    assert(indices.count != 0);

    calculate_tangents(vertices, indices);

    return load_mesh_from_vertices(vertices, indices);
}

calculate_tangents :: (vertices: []Standard_Vertex, indices: []u32) {
    for 0..(indices.count / 3) - 1 {
        v0 := vertices[indices[it + 0]];
        v1 := vertices[indices[it + 1]];
        v2 := vertices[indices[it + 2]];

        e0 := v1.position - v0.position;
        e1 := v2.position - v0.position;

        duv1 := v1.uv - v0.uv;
        duv2 := v2.uv - v0.uv;

        f := 1 / (duv1.x * duv2.y - duv2.x * duv1.y);
        tangent := Vector3.{
            f * (duv2.y * e0.x - duv1.y * e1.x),
            f * (duv2.y * e0.y - duv1.y * e1.y),
            f * (duv2.y * e0.z - duv1.y * e1.z),
        };
        vertices[indices[it + 0]].tangent = tangent;
        vertices[indices[it + 1]].tangent = tangent;
        vertices[indices[it + 2]].tangent = tangent;
    }
}
