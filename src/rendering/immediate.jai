Vertex :: struct {
    position: Vector3;
    normal: Vector3;
    uv: Vector2;
    color: Vector4 = .{1, 1, 1, 1};
}

Debug_Vertex :: struct {
    position: Vector3;
    color: Vector4 = .{1, 1, 1, 1};
}

Immediate :: struct {
    _3d_draw_data: Draw_Data(Vertex);
    _2d_draw_data: Draw_Data(Vertex);
    debug_draw_data: Draw_Data(Debug_Vertex);

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
        wgpu.RenderPassEncoderSetBindGroup(render_pass, 0, global_engine.default_font.uniform.bind_group, 0, null);
        wgpu.RenderPassEncoderSetVertexBuffer(render_pass, 0, vertex_buffer.handle, 0, vertex_buffer.size);
        pc := float.[2.0 / cast(float)global_renderer.width, -2.0 / cast(float)global_renderer.height, -1, 1];
        wgpu.RenderPassEncoderSetPushConstants(render_pass, .Vertex, 0, size_of(type_of(pc)), *pc);
        for context.immediate._2d_draw_data.draw_cmds {
            wgpu.RenderPassEncoderDraw(render_pass, it.count, 1, it.id, 0);
        }
    }

    draw_debug :: (render_pass: wgpu.RenderPassEncoder) {
        using context.immediate.debug_draw_data;
        wgpu.RenderPassEncoderSetPipeline(render_pass, global_renderer.debug_pipeline);
        wgpu.RenderPassEncoderSetBindGroup(render_pass, 0, global_renderer.global_matrices_uniform.bind_group, 0, null);
        wgpu.RenderPassEncoderSetVertexBuffer(render_pass, 0, vertex_buffer.handle, 0, vertex_buffer.size);
        for draw_cmds {
            pc := Standard_Push_Constants.{transpose(it.xform), transpose(inverse(it.xform))};
            wgpu.RenderPassEncoderSetPushConstants(render_pass, .Vertex, 0, size_of(type_of(pc)), *pc);
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


prepare_2d_vertices :: inline (nb: u32) -> *Vertex {
    return prepare_vertices(*context.immediate._2d_draw_data, nb);
}

prepare_3d_vertices :: inline (nb: u32) -> *Vertex {
    return prepare_vertices(*context.immediate._3d_draw_data, nb);
}

prepare_debug_vertices :: inline (nb: u32) ->*Debug_Vertex {
    using context.immediate.debug_draw_data;
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

immediate_2d_rect :: (p0: Vector2, p1: Vector2, color: Vector4) {
    v := prepare_2d_vertices(6);
    n := Vector3.{0, 0, 1};
    v[0] = .{ xyz(p0, 0), n, .{1, 1}, color};
    v[1] = .{ xyz(p0.x, p1.y, 0), n, .{1, 1}, color};
    v[2] = .{ xyz(p1, 0), n, .{1, 1}, color};
    
    v[3] = .{ xyz(p0, 0), n, .{1, 1}, color};
    v[4] = .{ xyz(p1, 0), n, .{1, 1}, color};
    v[5] = .{ xyz(p1.x, p0.y, 0), n, .{1, 1} , color};
}


immediate_debug_line :: (p0: Vector3, p1: Vector3, color: Vector4) {
    v := prepare_debug_vertices(2);
    v[0] = .{p0, color};
    v[1] = .{p1, color};
}

immediate_debug_matrix :: (mat: Matrix4, line_length : float = 1) {
    v := prepare_debug_vertices(6);
    org := (mat * .{0, 0, 0, 1}).xyz;
    x :=   (mat * .{line_length, 0, 0, 1}).xyz;
    y :=   (mat * .{0, line_length, 0, 1}).xyz;
    z :=   (mat * .{0, 0, line_length, 1}).xyz;
    v[0] = .{org, RED};
    v[1] = .{x, RED};
    v[2] = .{org, GREEN};
    v[3] = .{y, GREEN};
    v[4] = .{org, BLUE};
    v[5] = .{z, BLUE};
}

#add_context immediate : Immediate;

Draw_Data :: struct(vertex_type: Type) {
    vertex_buffer: Buffer;
    vertices: [..]vertex_type;
    draw_cmds : [..]Draw_Cmd;
    transform: Matrix4 = Matrix4_Identity;
}

destroy :: (dd: *Draw_Data) {
    array_reset(*dd.draw_cmds);
    array_reset(*dd.vertices);
    Buffer.destroy(*dd.vertex_buffer);
}

reset :: (dd: *Draw_Data) {
    dd.vertices.count = 0;
    dd.draw_cmds.count = 0;
    dd.transform = Matrix4_Identity;
}

upload :: (dd: *Draw_Data) {
    if dd.vertices.count == 0 then return; 
    size : u64 = xx (dd.vertices.count * size_of(Vertex));
    Buffer.create_or_update(*dd.vertex_buffer, size, .Vertex | .CopyDst);
    Buffer.write_data(dd.vertex_buffer, dd.vertices.data, size);
}

Draw_Cmd :: struct {
    id: u32;
    count: u32;
    xform: Matrix4;
}

