Scene :: struct {
    static_meshes: [..]Mesh_Instance;
    skinned_meshes: [..]Skinned_Mesh_Instance;

    destroy :: (using self: *Scene) {
        array_reset(*static_meshes);
        for *skinned_meshes {
            destroy(it);
        }
        array_reset(*skinned_meshes);
    }

    draw :: (using self: *Scene, command_buffer: VkCommandBuffer, $kind: Pipeline_Kind) {
        current_material: *Material;

        // Static scene meshes
        if self.static_meshes.count > 0 && current_material != *global_renderer.static_mesh_material {
            bind_material(command_buffer, global_renderer.static_mesh_material, kind);
            current_material = *global_renderer.static_mesh_material;
        }

        for self.static_meshes {
            pc := PushConstantData.{transpose(it.transform), transpose(inverse(it.transform))};
            vkCmdPushConstants(command_buffer, current_material.pipelines[kind].layout, .VERTEX_BIT, 0, size_of(PushConstantData), *pc);
            draw(it.mesh, command_buffer);
        }

        // Skinned
        if self.skinned_meshes.count > 0 { 
            bind_material(command_buffer, global_renderer.skinned_mesh_material, kind);
            current_material = *global_renderer.skinned_mesh_material;
        }

        for *self.skinned_meshes {
            upload_skeleton(it);
            vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, current_material.pipelines[kind].layout, Renderer.INSTANCE_SET, 1, *it.joint_descriptor, 0, null);
            pc := PushConstantData.{transpose(it.transform), transpose(inverse(it.transform))};
            vkCmdPushConstants(command_buffer, current_material.pipelines[kind].layout, .VERTEX_BIT, 0, size_of(PushConstantData), *pc);
            draw(it.mesh, command_buffer);
        }
    }
}

Mesh_Instance :: struct {
    transform: Matrix4;
    mesh: *Mesh;
}

instantiate :: (scene: *Scene, mesh: *Mesh, matrix := Matrix4_Identity) -> *Mesh_Instance {
    inst := array_add(*scene.static_models);
    inst.transform = matrix;
    inst.mesh = mesh;
    return inst;
}

print_matrix :: (m: Matrix4) {
    log("%\n%\n%\n%", m.v[0], m.v[1], m.v[2], m.v[3]);
}

print_skeleton :: (skeleton: []Joint) {
    for skeleton {
        log("Lcl:");
        print_matrix(it.local_space_matrix);
        log("Mdl:");
        print_matrix(it.model_space_matrix);
    }
}