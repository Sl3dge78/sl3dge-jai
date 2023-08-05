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

Joint :: struct {
    parent: int;
    children: []int;
    model_space_matrix: Matrix4;
    local_space_matrix: Matrix4;
}

Skinned_Mesh :: struct {
    using #as mesh: Mesh;

    skins : [..] Buffer_Pool_Location;

    joints: []Joint;
    bind_pose : []Matrix4;
    inverse_bind_matrices: []Matrix4;

    deinit :: (mesh : *Skinned_Mesh) {
        free(mesh.inverse_bind_matrices.data);
        for mesh.joints {
            free(it.children.data);
        }
        free(mesh.joints.data);
        free(mesh.bind_pose.data);
        array_reset(*mesh.skins);
        Mesh.deinit(*mesh.mesh);
        mesh.* = .{};
    }
}

draw :: (using self: Skinned_Mesh, command_buffer: VkCommandBuffer) {
    for submeshes {
        vkCmdBindVertexBuffers(command_buffer, 0, 1, *it.vertices_loc.buffer.buffer, *it.vertices_loc.offset);
        vkCmdBindVertexBuffers(command_buffer, 1, 1, *skins[it_index].buffer.buffer, *skins[it_index].offset);
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

load_skinned_gltf :: (path: string) -> Skinned_Mesh {
    result: Skinned_Mesh;
    log("Loading skinned mesh: %", path);
    gltf_data := gltf_parse_file(path);
    defer gltf_free(*gltf_data);

    gltf_load_buffers(*gltf_data);

    result.mesh = load_mesh_from_data(gltf_data);

    for mesh: gltf_data.meshes {
        assert(mesh.primitives.count == 1, "No or multiple primitives found in mesh %", it_index);
        primitive := mesh.primitives[0];
        vtx_count := result.mesh.submeshes[it_index].vertex_count;

        // Other attributes
        vertices := NewArray(xx vtx_count, Skinned_Vertex, allocator = temp);
        offset: *Skinned_Vertex = null;

        if primitive.joints_accessor != -1 {
            assert(gltf_data.accessors[primitive.joints_accessor].count == xx vtx_count, "The amount of joint data != the amount of vertices!");

            read_accessor_into_array(vertices.data, xx *offset.joints, size_of(Skinned_Vertex), gltf_data, primitive.joints_accessor);
        }

        if primitive.weights_accessor != -1 {
            assert(gltf_data.accessors[primitive.weights_accessor].count == xx vtx_count, "The amount of weight data != the amount of vertices!");

            read_accessor_into_array(vertices.data, xx *offset.weights, size_of(Skinned_Vertex), gltf_data, primitive.weights_accessor);
        }

        skinned_loc := Buffer_Pool.load_data(*global_renderer.buffer_pool, vertices);
        array_add(*result.skins, skinned_loc);
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
    result.bind_pose = NewArray(skin.joints.count, Matrix4);
    read_accessor_into_array(result.inverse_bind_matrices.data, 0, size_of(Matrix4), gltf_data, skin.inverse_bind_matrices);
    for *result.inverse_bind_matrices {
        it.* = transpose(it.*);
    }
    for *joint: result.joints {
        node := gltf_data.nodes[skin.joints[it_index]];
        joint.model_space_matrix = node.world_transform;
        joint.local_space_matrix = node.local_transform;
        result.bind_pose[it_index] = node.local_transform;

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
/*
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
        v[it].color = mesh.vertices[mesh.indices[it]].color;
    }
}
*/