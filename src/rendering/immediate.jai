Vertex :: struct {
    position: Vector3;
    normal: Vector3;
    uv: Vector2;
    color: Vector4 = .{1, 1, 1, 1};
}

Immediate_Context :: struct {
    _3d_draw_data: Draw_Data;
    _2d_draw_data: Draw_Data;
}

#add_context immediate : Immediate_Context;

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
        Buffer.create_or_update(*dd.vertex_buffer, size, .Vertex | .CopyDst);

        // create_or_update_buffer(*dd.vertex_buffer, size, .VERTEX_BUFFER_BIT | .INDEX_BUFFER_BIT | .UNIFORM_BUFFER_BIT | .STORAGE_BUFFER_BIT | .TRANSFER_SRC_BIT, .UPLOAD);
        Buffer.write_data(dd.vertex_buffer, dd.vertices.data, size);
    }

    reset :: (dd: *Draw_Data) {
        dd.vertices.count = 0;
        dd.draw_cmds.count = 0;
        dd. transform = Matrix4_Identity;
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

immediate_quad :: (p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3, normal: Vector3, color := Vector4.{1, 1, 1, 1}) {
    v := prepare_vertices(6);
    v[0] = .{p0, normal, .{0, 0}, color};
    v[1] = .{p1, normal, .{1, 0}, color};
    v[2] = .{p2, normal, .{1, 1}, color};

    v[3] = .{p0, normal, .{0, 0}, color};
    v[4] = .{p2, normal, .{1, 1}, color};
    v[5] = .{p3, normal, .{0, 1}, color};
}

immediate_cube :: (offset: Vector3 = .{0, 0, 0}, color: Vector4 = .{1, 1, 1, 1}) {
    immediate_quad(xyz(-.5, -.5, -.5) + offset, xyz(.5, -.5, -.5) + offset, xyz(.5, -.5, .5) + offset, xyz(-.5, -.5, .5) + offset, DOWN, color); 
    immediate_quad(xyz(-.5, .5, -.5) + offset, xyz(-.5, .5, .5) + offset,  xyz(.5, .5, .5) + offset, xyz(.5, .5, -.5) + offset, UP, color);

    immediate_quad(xyz(-.5, -.5, -.5) + offset, xyz(-.5, -.5, .5) + offset, xyz(-.5, .5, .5) + offset, xyz(-.5, .5, -.5) + offset, RIGHT, color); 
    immediate_quad(xyz(.5, -.5, -.5) + offset, xyz(.5, .5, -.5) + offset, xyz(.5, .5, .5) + offset, xyz(.5, -.5, .5) + offset, LEFT, color); 

    immediate_quad(xyz(-.5, -.5, -.5) + offset, xyz(-.5, .5, -.5) + offset, xyz(.5, .5, -.5) + offset, xyz(.5, -.5, -.5) + offset, BACK, color); 
    immediate_quad(xyz(-.5, -.5, .5) + offset, xyz(.5, -.5, .5) + offset, xyz(.5, .5, .5) + offset, xyz(-.5, .5, .5) + offset, FORWARD, color); 
}