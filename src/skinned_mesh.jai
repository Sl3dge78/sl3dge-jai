
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
    // @NOTE: The model space matrices are stored directly on the gpu
    name: string;
    parent: int;
    children: []int;
    local_space_matrix: Matrix4;
    model_space_matrix: Matrix4;
    dirty: bool;
}

Skinned_Mesh :: struct {
    using #as mesh: Mesh;

    skins : [..] Buffer_Pool_Location;
    
    skeleton: []Joint;
    root_bone: int;
    bind_pose : []Matrix4;
    inverse_bind_matrices: []Matrix4;

    deinit :: (mesh : *Skinned_Mesh) {
        free(mesh.inverse_bind_matrices.data);
        for mesh.skeleton {
            free(it.children.data);
            free(it.name);
        }
        free(mesh.skeleton.data);
        free(mesh.bind_pose.data);
        array_reset(*mesh.skins);
        Mesh.deinit(*mesh.mesh);
        mesh.* = .{};
    }
}

Skinned_Mesh_Instance :: struct {
    transform: Matrix4;
    mesh: *Skinned_Mesh;
    skeleton: []Joint;
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

    result.skeleton = NewArray(skin.joints.count, Joint);
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
    for *joint: result.skeleton {
        node := gltf_data.nodes[skin.joints[it_index]];
        joint.model_space_matrix = node.world_transform;
        joint.local_space_matrix = node.local_transform;
        joint.name = copy_string(node.name);
        result.bind_pose[it_index] = node.local_transform;

        joint.children = NewArray(node.children.count, int);
        joint.parent = find_joint_id(joint_ids, node.parent);
        if joint.parent == -1 {
            result.root_bone = it_index;
        }
        for *child: joint.children { 
            child.* = find_joint_id(joint_ids, node.children[it_index]);
        }
    }

    return result;
}

instantiate :: (scene: *Scene, mesh: *Skinned_Mesh, matrix := Matrix4_Identity) -> *Skinned_Mesh_Instance {
    instance := array_add(*scene.skinned_meshes);
    instance.mesh = mesh;
    instance.transform = matrix;
    alloc_info := VkDescriptorSetAllocateInfo.{
        descriptorPool = global_renderer.descriptor_pool,
        descriptorSetCount = 1,
        pSetLayouts = *global_renderer.skinned_mesh_layout
    };
    Vk_Check(vkAllocateDescriptorSets(global_renderer.device, *alloc_info, *instance.joint_descriptor));
    size := size_of(Matrix4) * mesh.skeleton.count;
    instance.joint_buffer = create_buffer(xx size, .UNIFORM_BUFFER_BIT, .UPLOAD, true);
    
    buffer_info := VkDescriptorBufferInfo.{
        buffer = instance.joint_buffer.buffer,
        offset = 0,
        range = xx size
    };
    writes := VkWriteDescriptorSet.[.{
        dstSet = instance.joint_descriptor,
        dstBinding = 0,
        dstArrayElement = 0,
        descriptorType = .UNIFORM_BUFFER,
        descriptorCount = 1,
        pBufferInfo = *buffer_info
    }];
    vkUpdateDescriptorSets(global_renderer.device, writes.count, writes.data, 0, null);

    instance.skeleton = array_copy(mesh.skeleton);
    for *instance.skeleton {
        it.dirty = true;
    }
    return instance;    
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
        joint := skeleton[id];
        if !joint.dirty then return;

        parent_transform : Matrix4 = ---;
        if joint.parent != -1 {
            joint.model_space_matrix = skeleton[joint.parent].model_space_matrix * joint.local_space_matrix;
        } else {
            joint.model_space_matrix = joint.local_space_matrix;
        }
        
        buffer[id] = transpose(joint.model_space_matrix * mesh.inverse_bind_matrices[id]);
        joint.dirty = false;

        for joint.children {
            update_branch_transforms(self, it, buffer);
        }
    }

    // TODO: Dirty flag, do the world calculation here 
    buffer : [] Matrix4; 
    buffer.data = joint_buffer.mapped;
    buffer.count = mesh.skeleton.count;

    // Traverse the tree from the root, only updating dirty elements
    update_branch_transforms(self, mesh.root_bone, buffer); 
}

set_bone_matrix :: (skeleton: []Joint, name: string, matrix: Matrix4) {

    for skeleton {
        if it.name == name {
            it.local_space_matrix = matrix;
            it.dirty = true;
        }
    }
}