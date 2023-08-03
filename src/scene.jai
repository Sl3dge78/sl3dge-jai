Scene :: struct {
    static_models: [..]Instanced(Mesh);
    skinned_meshes: [..]Instanced(Skinned_Mesh);

    color_draw_data: Draw_Data;
    ui_draw_data: Draw_Data;

    destroy :: (using self: *Scene) {
        array_reset(*static_models);
        array_reset(*skinned_meshes);
        Draw_Data.destroy(*self.color_draw_data);
        Draw_Data.destroy(*self.ui_draw_data);
    }

    prepare_for_rendering :: (using self: *Scene) {
        Draw_Data.upload(*self.color_draw_data);
        Draw_Data.upload(*self.ui_draw_data);
    }
}

Draw_Data :: struct {
    vertex_buffer: Buffer;
    vertices: [..]Vertex;
    draw_cmds : [..]Draw_Cmd;
    transform: Matrix4;


    destroy :: (dd: *Draw_Data) {
        array_reset(*dd.draw_cmds);
        array_reset(*dd.vertices);
        destroy_buffer(*dd.vertex_buffer);
    }

    upload :: (dd: *Draw_Data) {
        if dd.vertices.count == 0 then return; 
        size : u64 = xx (dd.vertices.count * size_of(Vertex));
        create_or_update_buffer(*dd.vertex_buffer, size, .VERTEX_BUFFER_BIT | .INDEX_BUFFER_BIT | .UNIFORM_BUFFER_BIT | .STORAGE_BUFFER_BIT | .TRANSFER_SRC_BIT, .UPLOAD);
        copy_data(dd.vertex_buffer, dd.vertices.data, size);
    }
}

Draw_Cmd :: struct {
    id: u32;
    count: u32;
    xform: Matrix4;
}

Instanced :: struct(T: Type) {
    transform: Matrix4;
    mesh: *T;
}

instantiate :: (scene: *Scene, mesh: *$T, matrix := Matrix4_Identity) -> *Instanced(T) {
    inst : *Instanced(T); 
    #if T == Mesh {
        inst = array_add(*scene.static_models);
    } else #if T == Skinned_Mesh {
        inst = array_add(*scene.skinned_meshes);
    } else {
        #assert false, "Unsupported mesh type";
    }

    inst.transform = matrix;
    inst.mesh = mesh;
    return inst;
}

record_3d_commands :: (scene: *Scene, command_buffer: VkCommandBuffer, $kind: Pipeline_Kind) {
    last_material: *Material;

    // Immediate meshes
    if scene.color_draw_data.vertices.count != 0 {
        bind_material(command_buffer, global_renderer.static_mesh_material, kind);
        last_material = *global_renderer.static_mesh_material;

        offset : u64 = 0;
        vkCmdBindVertexBuffers(command_buffer, 0, 1, *scene.color_draw_data.vertex_buffer.buffer, *offset);

        // Issue draw calls & end command buffer
        for scene.color_draw_data.draw_cmds {
            pc := PushConstantData.{transpose(it.xform), transpose(inverse(it.xform))};
            vkCmdPushConstants(command_buffer, last_material.pipelines[kind].pipeline_layout, .VERTEX_BIT, 0, size_of(PushConstantData), *pc);
            vkCmdDraw(command_buffer, it.count, 1, it.id, 0);
        }
    }

    // Static scene meshes
    if scene.static_models.count > 0 && last_material != *global_renderer.static_mesh_material {
        bind_material(command_buffer, global_renderer.static_mesh_material, kind);
        last_material = *global_renderer.static_mesh_material;
    }

    for scene.static_models {
        bind(it.mesh, command_buffer);
        pc := PushConstantData.{transpose(it.transform), transpose(inverse(it.transform))};
        vkCmdPushConstants(command_buffer, last_material.pipelines[kind].pipeline_layout, .VERTEX_BIT, 0, size_of(PushConstantData), *pc);
        vkCmdDrawIndexed(command_buffer, xx it.mesh.index_count, 1, 0, 0, 0);
    }

    // Skinned
    if scene.skinned_meshes.count > 0 { 
        bind_material(command_buffer, global_renderer.skinned_mesh_material, kind);
        last_material = *global_renderer.skinned_mesh_material;
    }

    for scene.skinned_meshes {
        bind(it.mesh, command_buffer);
        pc := PushConstantData.{transpose(it.transform), transpose(inverse(it.transform))};
        vkCmdPushConstants(command_buffer, last_material.pipelines[kind].pipeline_layout, .VERTEX_BIT, 0, size_of(PushConstantData), *pc);
        vkCmdDrawIndexed(command_buffer, xx it.mesh.index_count, 1, 0, 0, 0);
    }
}

record_2d_commands :: (scene: *Scene, command_buffer: VkCommandBuffer, pipeline: Pipeline) {
    pc := float.[2.0 / cast(float)global_renderer.swapchain_extent.width, 2.0 / cast(float)global_renderer.swapchain_extent.height, -1, -1];
    vkCmdPushConstants(command_buffer, pipeline.pipeline_layout, .VERTEX_BIT, 0, size_of(type_of(pc)), *pc);

    offset : u64 = 0;
    vkCmdBindVertexBuffers(command_buffer, 0, 1, *scene.ui_draw_data.vertex_buffer.buffer, *offset);

    // Issue draw calls & end command buffer
    for scene.ui_draw_data.draw_cmds {
        vkCmdDraw(command_buffer, it.count, 1, it.id, 0);
    }
}