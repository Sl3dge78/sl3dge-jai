Mesh :: struct {
    vertices : []Vertex;
    indices : []int;

    deinit :: (mesh : *Mesh) {
        free(mesh.vertices.data);
        free(mesh.indices.data);
        mesh.* = .{};
    }
}

load_gltf :: (path: string) -> Mesh {
    result: Mesh;

    gltf_data := gltf_parse_file(path);
    defer gltf_free(*gltf_data);

    gltf_load_buffers(*gltf_data);

    vertices : [..] Vertex;
    assert(gltf_data.meshes.count == 1, "No mesh found in gltf!"); // @TODO: handle multiple meshes
    mesh := gltf_data.meshes[0];

    assert(mesh.primitives.count == 1, "No or multiple primitives found!"); // @TODO: handle multiple primitives

    using primitive := mesh.primitives[0];

    assert(position_accessor != -1, "No positions for vertices!");

    accessor := gltf_data.accessors[position_accessor];
    assert(accessor.component_type == .FLOAT);
    result.vertices = NewArray(accessor.count, Vertex);

    // Vertices
    read_accessor_into_array(result.vertices.data, 0, size_of(Vertex), gltf_data, position_accessor);

    // Normals
    if normal_accessor != -1 {
        offset: *Vertex = null;
        read_accessor_into_array(result.vertices.data, xx *offset.normal, size_of(Vertex), gltf_data, normal_accessor);
    }
    
    // Indices
    idx_accessor := gltf_data.accessors[indices_accessor];
    result.indices = NewArray(idx_accessor.count, int);
    read_accessor_into_array(result.indices.data, 0, size_of(int), gltf_data, indices_accessor);

    return result;
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

immediate_mesh :: (mesh: Mesh) {
    v := prepare_vertices(xx mesh.indices.count);
    for 0..mesh.indices.count - 1 {
        v[it] = mesh.vertices[mesh.indices[it]];
    }
}