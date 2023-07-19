Mesh :: struct {
    vertices : []Vertex;
    indices : []int;

    deinit :: (mesh : *Mesh) {
        free(mesh.vertices.data);
        free(mesh.indices.data);
        mesh.* = .{};
    }
}

Skinned_Mesh :: struct {
    vertices : []Skinned_Vertex;
    indices: []int;

    joints: []Joint;
    inverse_bind_matrices: []Matrix4;

    deinit :: (mesh : *Skinned_Mesh) {
        free(mesh.vertices.data);
        free(mesh.indices.data);
        free(mesh.inverse_bind_matrices.data);
        for mesh.joints {
            free(it.children.data);
        }
        free(mesh.joints.data);
        mesh.* = .{};
    }
}

Joint :: struct {
    parent: int;
    children: []int;
    world_matrix: Matrix4;
    matrix: Matrix4;
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

load_skinned_gltf :: (path: string) -> Skinned_Mesh {
    result: Skinned_Mesh;

    gltf_data := gltf_parse_file(path);
    defer gltf_free(*gltf_data);

    gltf_load_buffers(*gltf_data);

    vertices : [..] Vertex;
    assert(gltf_data.meshes.count == 1, "No or multiple meshes found in gltf!"); // @TODO: handle multiple meshes
    mesh := gltf_data.meshes[0];

    assert(mesh.primitives.count == 1, "No or multiple primitives found!"); // @TODO: handle multiple primitives

    using primitive := mesh.primitives[0];

    assert(position_accessor != -1, "No positions for vertices!");

    accessor := gltf_data.accessors[position_accessor];
    assert(accessor.component_type == .FLOAT);
    result.vertices = NewArray(accessor.count, Skinned_Vertex);

    // Vertices
    read_accessor_into_array(result.vertices.data, 0, size_of(Vertex), gltf_data, position_accessor);

    // Indices
    idx_accessor := gltf_data.accessors[indices_accessor];
    result.indices = NewArray(idx_accessor.count, int);
    read_accessor_into_array(result.indices.data, 0, size_of(int), gltf_data, indices_accessor);

    // Other attributes
    offset: *Skinned_Vertex = null;
    
    if normal_accessor != -1 {
        read_accessor_into_array(result.vertices.data, xx *offset.normal, size_of(Vertex), gltf_data, normal_accessor);
    }

    if joints_accessor != -1 {
        read_accessor_into_array(result.vertices.data, xx *offset.joints_0, size_of(Vertex), gltf_data, normal_accessor);
    }

    if weights_accessor != -1 {
        read_accessor_into_array(result.vertices.data, xx *offset.weights, size_of(Vertex), gltf_data, normal_accessor);
    }
    
    assert(gltf_data.skins.count == 1, "No or multiple skins found in gltf, this isn't supported"); // @TODO
    skin := gltf_data.skins[0];

    result.joints = NewArray(skin.joints.count, Joint);
    joint_ids := NewArray(skin.joints.count, int, allocator = temp);
    
    // fill the ids
    for *joint_ids {
        joint_ids[it_index] = skin.joints[it_index];
    }

    find_joint_id :: (ids: []int, id: int) -> int {
        for ids {
            if it == id return it_index;
        }
        return -1;
    }

    result.inverse_bind_matrices = NewArray(skin.joints.count, Matrix4);
    read_accessor_into_array(result.inverse_bind_matrices.data, 0, size_of(Matrix4), gltf_data, skin.inverse_bind_matrices);
    for *joint: result.joints {
        node := gltf_data.nodes[skin.joints[it_index]];
        joint.world_matrix = node.world_transform;
        
        joint.children = NewArray(node.children.count, int);
        joint.parent = find_joint_id(joint_ids, node.parent);
        for *child: joint.children { 
            child.* = find_joint_id(joint_ids, node.children[it_index]);
        }
    }

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

immediate_mesh :: (mesh: Skinned_Mesh) {
    v := prepare_vertices(xx mesh.indices.count);
    for 0..mesh.indices.count - 1 {
        v[it].position = mesh.vertices[mesh.indices[it]].position;
        v[it].normal = mesh.vertices[mesh.indices[it]].normal;
    }
}