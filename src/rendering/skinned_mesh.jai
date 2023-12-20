
Joint :: struct {
    // /!\ We may not set these 3 upon loading the gltf. 
    // So they may not reflect the actual state of the model_space_matrix.
    // This shouldn't be an issue because model_space_matrix gets set for sure 
    // when loading, and when changing t, r or s you should set the dirty flag
    // to true to recalculate the model_space_matrix.
    translation: Vector3;
    rotation: Quaternion;
    scale: Vector3;
    // Requests a recalc of model_space_matrix in upload_skeleton with the trs above
    dirty: bool; 
    // This is multiplied with the inverse_bind_matrix then sent to the shader
    model_space_matrix: Matrix4; 
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
}

Skinned_Mesh :: struct {
    using mesh: Mesh;

    skins : [..] Buffer_Location;
    skeleton: Skeleton_Definition;
}

Skinned_Mesh_Instance :: struct {
    using skinned_mesh: *Skinned_Mesh;
    transform: Matrix4;

    current_pose: Skeleton_Pose;
    joint_uniform: Uniform_Buffer;
}

destroy :: (using self: *Skeleton_Definition) {
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


destroy :: (using self : *Skinned_Mesh) {
    destroy(*skeleton);
    array_reset(*skins);
    destroy(*mesh);
    self.* = .{};
}

draw :: inline (using self: Skinned_Mesh, command_buffer: VkCommandBuffer) {
    for submeshes {
        buffers := VkBuffer.[it.vertices.buffer.handle, skins[it_index].buffer.handle];
        offsets := VkDeviceSize.[it.vertices.offset, skins[it_index].offset];
        vkCmdBindVertexBuffers(command_buffer, 0, 2, buffers.data, offsets.data);
        vkCmdBindIndexBuffer(command_buffer, it.indices.buffer.handle, it.indices.offset, .UINT32);
        vkCmdDrawIndexed(command_buffer, it.index_count, 1, 0, 0, 0);
    }
}

destroy :: (self: *Skinned_Mesh_Instance) {
    free(self.current_pose.data);
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
            assert(gltf_data.accessors[primitive.joints_accessor].component_type == .UNSIGNED_BYTE, "Unsupported: The joint index accessor should be an unsigned byte");

            read_accessor_into_array(vertices.data, xx *offset.joints, size_of(Skinned_Vertex), gltf_data, primitive.joints_accessor);
        }

        if primitive.weights_accessor != -1 {
            assert(gltf_data.accessors[primitive.weights_accessor].count == xx vtx_count, "The amount of weight data != the amount of vertices!");

            read_accessor_into_array(vertices.data, xx *offset.weights, size_of(Skinned_Vertex), gltf_data, primitive.weights_accessor);
        }

        skinned_loc := buffer_pool_load_data(*global_renderer.mesh_buffer_pool, vertices);
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
        if node.has_translation 
            p_joint.translation.component = node.translation;
        if node.has_rotation 
            p_joint.scale.component = node.scale;
        if node.has_scale 
            p_joint.rotation.component = node.rotation;
    }

    return result;
}

instantiate :: (scene: *Scene, mesh: *Skinned_Mesh, matrix := Matrix4_Identity) -> *Skinned_Mesh_Instance {
    instance := array_add(*scene.skinned_meshes);
    instance.skinned_mesh = mesh;
    instance.transform = matrix;

    size := size_of(Instance_Data);
    instance.joint_uniform = uniform_create(global_renderer.device, *global_renderer.uniform_pool, xx size, global_renderer.instance_data_bgl);
    
    instance.current_pose = NewArray(mesh.skeleton.joints.count, Joint);
    
    buffer : Instance_Data = ---;
    for *instance.current_pose {
        it.* = mesh.skeleton.bind_pose[it_index];
        buffer.joint_matrices[it_index] = transpose(it.model_space_matrix * mesh.skeleton.joints[it_index].inverse_bind_matrix);
    }
    uniform_write(instance.joint_uniform, *buffer);
    return instance;    
}

update_branch_transforms :: (using self: *Skinned_Mesh_Instance, id: int, buffer: []Matrix4) {
    joint := *current_pose[id];
    def := self.skinned_mesh.skeleton.joints[id];
    parent_transform : Matrix4 = ---;
    local_matrix := // self.skeleton.bind_pose[id].local_space_matrix *
            make_translation_matrix4 (joint.translation) 
            * make_scale_matrix4 (joint.scale) 
            * rotation_matrix(Matrix4, joint.rotation);
    if def.parent != -1 {
        joint.model_space_matrix = current_pose[def.parent].model_space_matrix * local_matrix;
    } else {
        joint.model_space_matrix = local_matrix;
    }
    immediate_debug_matrix(self.transform * joint.model_space_matrix, 0.1);
        
    buffer[id] = transpose(joint.model_space_matrix * def.inverse_bind_matrix);
    joint.dirty = false;

    for def.children {
        update_branch_transforms(self, it, buffer);
    }
}

upload_skeleton :: (using self: *Skinned_Mesh_Instance) {

    buffer : Instance_Data = ---;
    
    // Traverse the tree from the root, only updating dirty elements
    for *self.current_pose {
        if it.dirty {
            update_branch_transforms(self, self.skeleton.root, buffer.joint_matrices);
        }
    }

    uniform_buffer_write(*self.joint_uniform, *buffer);
}

// set_bone_matrix :: (using self: *Skinned_Mesh_Instance, name: string, matrix: Matrix4) {
//     id, found := table_find(*self.skeleton.name_to_id, name);
//     assert(found, "No bone named % in skeleton", name);

//     current_pose[id].local_space_matrix = self.skeleton.bind_pose[id].local_space_matrix * matrix;
//     current_pose[id].dirty = true;
// }