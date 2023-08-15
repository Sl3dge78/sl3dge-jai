
Immediate :: struct {
    _3d_draw_data: Draw_Data;
    _2d_draw_data: Draw_Data;

    draw_2d :: (command_buffer: VkCommandBuffer, pipeline: Pipeline) {
        pc := float.[2.0 / cast(float)global_renderer.swapchain_extent.width, 2.0 / cast(float)global_renderer.swapchain_extent.height, -1, -1];
        vkCmdPushConstants(command_buffer, pipeline.layout, .VERTEX_BIT, 0, size_of(type_of(pc)), *pc);

        offset : u64 = 0;
        vkCmdBindVertexBuffers(command_buffer, 0, 1, *context.immediate._2d_draw_data.vertex_buffer.buffer, *offset);

        // Issue draw calls & end command buffer
        for context.immediate._2d_draw_data.draw_cmds {
            vkCmdDraw(command_buffer, it.count, 1, it.id, 0);
        }
    }

    draw_3d :: (command_buffer: VkCommandBuffer, $kind: Pipeline_Kind) {
        current_material: *Material;

        if context.immediate._3d_draw_data.vertices.count != 0 {
            using context.immediate._3d_draw_data;
            bind_material(command_buffer, global_renderer.static_mesh_material, kind);
            current_material = *global_renderer.static_mesh_material;

            offset : u64 = 0;
            vkCmdBindVertexBuffers(command_buffer, 0, 1, *vertex_buffer.buffer, *offset);

            for draw_cmds {
                pc := PushConstantData.{transpose(it.xform), transpose(inverse(it.xform))};
                vkCmdPushConstants(command_buffer, current_material.pipelines[kind].layout, .VERTEX_BIT, 0, size_of(PushConstantData), *pc);
                vkCmdDraw(command_buffer, it.count, 1, it.id, 0);
            }
        }
    }

    quad :: (p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3, normal: Vector3, color := Vector4.{1, 1, 1, 1}) {
        v := prepare_3d_vertices(6);
        v[0] = .{p0, normal, .{0, 0}, color};
        v[1] = .{p1, normal, .{1, 0}, color};
        v[2] = .{p2, normal, .{1, 1}, color};

        v[3] = .{p0, normal, .{0, 0}, color};
        v[4] = .{p2, normal, .{1, 1}, color};
        v[5] = .{p3, normal, .{0, 1}, color};
    }

    cube :: (offset: Vector3 = .{0, 0, 0}, color: Vector4 = .{1, 1, 1, 1}) {
        quad(xyz(-.5, -.5, -.5) + offset, xyz(.5, -.5, -.5) + offset, xyz(.5, -.5, .5) + offset, xyz(-.5, -.5, .5) + offset, DOWN, color); 
        quad(xyz(-.5, .5, -.5) + offset, xyz(-.5, .5, .5) + offset,  xyz(.5, .5, .5) + offset, xyz(.5, .5, -.5) + offset, UP, color);

        quad(xyz(-.5, -.5, -.5) + offset, xyz(-.5, -.5, .5) + offset, xyz(-.5, .5, .5) + offset, xyz(-.5, .5, -.5) + offset, RIGHT, color); 
        quad(xyz(.5, -.5, -.5) + offset, xyz(.5, .5, -.5) + offset, xyz(.5, .5, .5) + offset, xyz(.5, -.5, .5) + offset, LEFT, color); 

        quad(xyz(-.5, -.5, -.5) + offset, xyz(-.5, .5, -.5) + offset, xyz(.5, .5, -.5) + offset, xyz(.5, -.5, -.5) + offset, BACK, color); 
        quad(xyz(-.5, -.5, .5) + offset, xyz(.5, -.5, .5) + offset, xyz(.5, .5, .5) + offset, xyz(-.5, .5, .5) + offset, FORWARD, color); 
    }
}

#add_context immediate: Immediate;

Draw_Data :: struct {
    vertex_buffer: Buffer;
    vertices: [..]Vertex;
    draw_cmds : [..]Draw_Cmd;
    transform: Matrix4;

    destroy :: (dd: *Draw_Data) {
        array_reset(*dd.draw_cmds);
        array_reset(*dd.vertices);
        Buffer.destroy(*dd.vertex_buffer);
    }

    upload :: (dd: *Draw_Data) {
        if dd.vertices.count == 0 then return; 
        size : u64 = xx (dd.vertices.count * size_of(Vertex));
        Buffer.create_or_update(*dd.vertex_buffer, size, .VERTEX_BUFFER_BIT | .INDEX_BUFFER_BIT | .UNIFORM_BUFFER_BIT | .STORAGE_BUFFER_BIT | .TRANSFER_SRC_BIT, .UPLOAD);
        Buffer.write_data(dd.vertex_buffer, dd.vertices.data, size);
    }

    reset :: (dd: *Draw_Data) {
        dd.vertices.count = 0;
        dd.draw_cmds.count = 0;
        dd.transform = Matrix4_Identity;
    }
}

Draw_Cmd :: struct {
    id: u32;
    count: u32;
    xform: Matrix4;
}

prepare_2d_vertices :: inline (nb: u32) -> *Vertex {
    return prepare_vertices(*context.immediate._2d_draw_data, nb);
}

prepare_3d_vertices :: inline (nb: u32) -> *Vertex {
    return prepare_vertices(*context.immediate._3d_draw_data, nb);
}

prepare_vertices :: (using dd : *Draw_Data, nb: u32) -> *Vertex {
    array_reserve(*vertices, vertices.count + nb);
    if draw_cmds.count == 0 {
        array_add(*draw_cmds, Draw_Cmd.{xx vertices.count, nb, transform});
    } else { 
        prev := *draw_cmds[draw_cmds.count - 1];
        if prev.xform == transform { // Don't create a new entry if the state hasn't changed
            prev.count += nb;
        } else {
            array_add(*draw_cmds, Draw_Cmd.{xx vertices.count, nb, transform});
        }
    }
    ptr := vertices.data + vertices.count;
    vertices.count += nb;

    return ptr;
}

