
Skinned_Vertex :: struct {
    joints: [4]u8;
    weights: Vector4;
}

skinned_vertex_input_attribute :: #run () -> []VkVertexInputAttributeDescription {
    skinned: *Skinned_Vertex = null;
    vertex: *Vertex = null;
    vtx_attr := VkVertexInputAttributeDescription.[
        .{location = 0, binding = 0, format = .R32G32B32_SFLOAT, offset = xx *vertex.position},
        .{location = 1, binding = 0, format = .R32G32B32_SFLOAT, offset = xx *vertex.normal},
        .{location = 2, binding = 0, format = .R32G32_SFLOAT, offset = xx *vertex.uv},
        .{location = 3, binding = 0, format = .R32G32B32A32_SFLOAT, offset = xx *vertex.color},
        .{location = 4, binding = 1, format = .R8G8B8A8_UINT, offset = xx *skinned.joints},
        .{location = 5, binding = 1, format = .R32G32B32A32_SFLOAT, offset = xx *skinned.weights},
    ];
    
    return vtx_attr;
}();

Joint :: struct {
    local_space_matrix: Matrix4;
    model_space_matrix: Matrix4;       
    dirty: bool;
}

Skeleton_Pose :: []Joint;

Skeleton_Definition :: struct {
    Joint_Definition :: struct {
        parent: int;
        children: [] int;
        inverse_bind_matrix: Matrix4;
    }
    bind_pose : Skeleton_Pose;
    joints : [] Joint_Definition;
    root: int;
    name_to_id : Table(string, int);

    deinit :: (using self: *Skeleton_Definition) {
        for joints {
            free(it.children.data);
        }
        free(joints.data);
        free(bind_pose.data);
        for *name_to_id {
            free(it_index);
        }
        deinit(*name_to_id);
    }
}

Skinned_Mesh :: struct {
    using #as mesh: Mesh;

    skins : [..] Buffer_Pool_Location;
    skeleton: Skeleton_Definition;

    deinit :: (using self : *Skinned_Mesh) {
        Skeleton_Definition.deinit(*skeleton);
        array_reset(*skins);
        Mesh.deinit(*mesh);
        self.* = .{};
    }
}

Skinned_Mesh_Instance :: struct {
    transform: Matrix4;
    mesh: *Skinned_Mesh;

    current_pose: Skeleton_Pose;
    joint_descriptor: VkDescriptorSet;
    joint_buffer: Buffer;
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

    result.skeleton.joints = NewArray(skin.joints.count, Skeleton_Definition.Joint_Definition);
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

    inverse_bind_matrices := NewArray(skin.joints.count, Matrix4, allocator = temp);
    result.skeleton.bind_pose = NewArray(skin.joints.count, Joint);
    read_accessor_into_array(inverse_bind_matrices.data, 0, size_of(Matrix4), gltf_data, skin.inverse_bind_matrices);
    for *inverse_bind_matrices {
        it.* = transpose(it.*);
    }
    for 0..skin.joints.count - 1 {
        node := gltf_data.nodes[skin.joints[it]];
        log("%", node.name);
        table_add(*result.skeleton.name_to_id, copy_string(node.name), it);

        d_joint := *result.skeleton.joints[it];
        d_joint.children = NewArray(node.children.count, int);
        d_joint.parent = find_joint_id(joint_ids, node.parent);
        if d_joint.parent == -1 {
            result.skeleton.root = it;
        }
        for node.children {
            d_joint.children[it_index] = find_joint_id(joint_ids, it);
        }
        d_joint.inverse_bind_matrix = inverse_bind_matrices[it];

        p_joint := *result.skeleton.bind_pose[it];
        p_joint.model_space_matrix = node.world_transform;
        p_joint.local_space_matrix = node.local_transform;
    }

    return result;
}

instantiate :: (scene: *Scene, mesh: *Skinned_Mesh, matrix := Matrix4_Identity) -> *Skinned_Mesh_Instance {
    instance := array_add(*scene.skinned_meshes);
    instance.mesh = mesh;
    instance.transform = matrix;

    size := size_of(Matrix4) * mesh.skeleton.joints.count;
    instance.joint_buffer = Buffer.create(xx size, .UNIFORM_BUFFER_BIT, .UPLOAD, true);
    instance.joint_descriptor = Descriptor_Set.create(global_renderer.skinned_mesh_layout);
    Descriptor_Set.write(instance.joint_descriptor, instance.joint_buffer.buffer, xx size);
    
    instance.current_pose = NewArray(mesh.skeleton.joints.count, Joint);
    for *instance.current_pose {
        it.* = mesh.skeleton.bind_pose[it_index];
        it.dirty = true;
    }
    upload_skeleton(instance);
    return instance;    
}

destroy :: (self: *Skinned_Mesh_Instance) {
    Buffer.destroy(*self.joint_buffer);
    free(self.current_pose.data);
}   

draw :: (using self: Skinned_Mesh, command_buffer: VkCommandBuffer) {

    for submeshes {
        vkCmdBindVertexBuffers(command_buffer, 0, 1, *it.vertices_loc.buffer.buffer, *it.vertices_loc.offset);
        vkCmdBindVertexBuffers(command_buffer, 1, 1, *skins[it_index].buffer.buffer, *skins[it_index].offset);
        vkCmdBindIndexBuffer(command_buffer, it.indices_loc.buffer.buffer, it.indices_loc.offset, .UINT32);
        vkCmdDrawIndexed(command_buffer, xx it.index_count, 1, 0, 0, 0);
    }
}

upload_skeleton :: (using self: *Skinned_Mesh_Instance) {

    update_branch_transforms :: (using self: *Skinned_Mesh_Instance, id: int, buffer: []Matrix4) {
        joint := *current_pose[id];
        def := self.mesh.skeleton.joints[id];
        parent_transform : Matrix4 = ---;
        if def.parent != -1 {
            joint.model_space_matrix = current_pose[def.parent].model_space_matrix * joint.local_space_matrix;
        } else {
            joint.model_space_matrix = joint.local_space_matrix;
        }
            
        buffer[id] = transpose(joint.model_space_matrix *def.inverse_bind_matrix);
        joint.dirty = false;

        for def.children {
            update_branch_transforms(self, it, buffer);
        }
    }

    buffer : [] Matrix4; 
    buffer.data = joint_buffer.mapped;
    buffer.count = mesh.skeleton.joints.count;

    // Traverse the tree from the root, only updating dirty elements
    for *self.current_pose {
        if it.dirty {
            update_branch_transforms(self, mesh.skeleton.root, buffer);
        }
    }
}

set_bone_matrix :: (using self: *Skinned_Mesh_Instance, name: string, matrix: Matrix4) {
    id, found := table_find(*mesh.skeleton.name_to_id, name);
    assert(found, "No bone named % in skeleton", name);

    current_pose[id].local_space_matrix = mesh.skeleton.bind_pose[id].local_space_matrix * matrix;
    current_pose[id].dirty = true;
}