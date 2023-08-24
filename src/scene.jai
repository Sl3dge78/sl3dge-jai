Scene :: struct {

    static_meshes: [..]Mesh_Instance;
    skinned_meshes: [..]Skinned_Mesh_Instance;

    destroy :: (using self: *Scene) {
        array_reset(*static_meshes);
        for *skinned_meshes {
            Skinned_Mesh_Instance.destroy(it);
        }
        array_reset(*skinned_meshes);
    }

    draw_static_meshes :: inline (using self: *Scene, render_pass: wgpu.RenderPassEncoder) {
        for static_meshes {
            pc := Standard_Push_Constants.{
                transform = transpose(it.transform),
                inverse_transform = transpose(inverse(it.transform)),
            };
            wgpu.RenderPassEncoderSetPushConstants(render_pass, .Vertex, 0, size_of(type_of(pc)), *pc);
            Mesh.draw(it.mesh, render_pass);
        }
    }

    draw_skinned_meshes :: inline (using self: *Scene, render_pass: wgpu.RenderPassEncoder) {
        for skinned_meshes {
             pc := Standard_Push_Constants.{
                transform = transpose(it.transform),
                inverse_transform = transpose(inverse(it.transform)),
            };
            wgpu.RenderPassEncoderSetPushConstants(render_pass, .Vertex, 0, size_of(type_of(pc)), *pc);
            wgpu.RenderPassEncoderSetBindGroup(render_pass, 2, it.joint_uniform.bind_group, 0, null);
            Skinned_Mesh.draw(it.skinned_mesh, render_pass);
        }
    }
}

Mesh_Instance :: struct {
    transform: Matrix4;
    mesh: *Mesh;
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

