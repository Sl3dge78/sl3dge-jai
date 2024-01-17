Scene :: struct {

    static_meshes: [..]Mesh_Instance;
    skinned_meshes: [..]Skinned_Mesh_Instance;
}

Mesh_Instance :: struct {
    hidden := false;
    transform: Matrix4;
    mesh: *Mesh;
}

destroy :: (using self: *Scene) {
    array_reset(*static_meshes);
    for *skinned_meshes {
        destroy(it);
    }
    array_reset(*skinned_meshes);
}

draw_static_meshes :: inline (using self: *Scene, command_buffer: VkCommandBuffer, current_pipeline: Pipeline) {
    for static_meshes {
        pc := Standard_Push_Constants.{
            transform = transpose(it.transform),
            inverse_transform = transpose(inverse(it.transform)),
        };
        vkCmdPushConstants(command_buffer, current_pipeline.layout, .VERTEX_BIT, 0, size_of(type_of(pc)), *pc);
        draw(it.mesh, command_buffer);
    }
}

draw_skinned_meshes :: inline (using self: *Scene, command_buffer: VkCommandBuffer, current_pipeline: Pipeline) {
    for skinned_meshes {
            pc := Standard_Push_Constants.{
            transform = transpose(it.transform),
            inverse_transform = transpose(inverse(it.transform)),
        };
        vkCmdPushConstants(command_buffer, current_pipeline.layout, .VERTEX_BIT, 0, size_of(type_of(pc)), *pc);
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, current_pipeline.layout, 2, 1, *it.joint_uniform.descriptor_set, 0, null);
        draw(it.skinned_mesh, command_buffer);
    }
}

instantiate :: (scene: *Scene, mesh: *Mesh, matrix := Matrix4_Identity) -> *Mesh_Instance {
    inst := array_add(*scene.static_meshes);
    inst.transform = matrix;
    inst.mesh = mesh;
    return inst;
}

print_matrix :: (m: Matrix4) {
    log("%\n%\n%\n%", m.v[0], m.v[1], m.v[2], m.v[3]);
}

