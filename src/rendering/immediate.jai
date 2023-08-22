Vertex :: struct {
    position: Vector3;
    normal: Vector3;
    uv: Vector2;
    color: Vector4 = .{1, 1, 1, 1};
}

Immediate :: struct {
    _3d_draw_data: Draw_Data;
    _2d_draw_data: Draw_Data;

    draw_3d :: (render_pass: wgpu.RenderPassEncoder) {
        using context.immediate._3d_draw_data;
        
        wgpu.RenderPassEncoderSetVertexBuffer(render_pass, 0, vertex_buffer.handle, 0, vertex_buffer.size);
        for draw_cmds {
            pc := Standard_Push_Constants.{transpose(it.xform), transpose(inverse(it.xform))};
            wgpu.RenderPassEncoderSetPushConstants(render_pass, .Vertex, 0, size_of(type_of(pc)), *pc);
            wgpu.RenderPassEncoderDraw(render_pass, it.count, 1, it.id, 0);
        }
    }

    draw_2d :: (render_pass: wgpu.RenderPassEncoder) {
        using context.immediate._2d_draw_data;
        wgpu.RenderPassEncoderSetPipeline(render_pass, global_renderer.ui_pipeline);
        wgpu.RenderPassEncoderSetBindGroup(render_pass, 0, global_engine.default_font.binding, 0, null);
        wgpu.RenderPassEncoderSetVertexBuffer(render_pass, 0, vertex_buffer.handle, 0, vertex_buffer.size);
        pc := float.[2.0 / cast(float)global_renderer.width, -2.0 / cast(float)global_renderer.height, -1, 1];
        wgpu.RenderPassEncoderSetPushConstants(render_pass, .Vertex, 0, size_of(type_of(pc)), *pc);
        for context.immediate._2d_draw_data.draw_cmds {
            wgpu.RenderPassEncoderDraw(render_pass, it.count, 1, it.id, 0);
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

#add_context immediate : Immediate;

Draw_Data :: struct {
    vertex_buffer: Buffer;
    vertices: [..]Vertex;
    draw_cmds : [..]Draw_Cmd;
    transform: Matrix4 = Matrix4_Identity;

    destroy :: (dd: *Draw_Data) {
        array_reset(*dd.draw_cmds);
        array_reset(*dd.vertices);
        Buffer.destroy(*dd.vertex_buffer);
    }

    upload :: (dd: *Draw_Data) {
        if dd.vertices.count == 0 then return; 
        size : u64 = xx (dd.vertices.count * size_of(Vertex));
        Buffer.create_or_update(*dd.vertex_buffer, size, .Vertex | .CopyDst);
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

immediate_triangle :: () {
    v := prepare_vertices(3);
    v[0] = .{.{0.0, 0.0, 0.0}, .{1, 0, 0, 1}};
    v[1] = .{.{100.0, 100.0, 0.0}, .{0, 1, 0, 1}};
    v[2] = .{.{0.0, 100.0, 0}, .{0, 0, 1, 1}};
}
