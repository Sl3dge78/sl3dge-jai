
push_vertices :: (imm: *Immediate, vertices: []$T) {
    // if imm.vertices.allocated < vertices.count + imm.vertices.count {
    //     array_reserve(*imm.vertices, vertices.count + imm.vertices.count);
    // }
    // memcpy(imm.vertices.data + imm.vertices.count, vertices.data, size_of(T) * vertices.count);
    // imm.vertices.count += vertices.count;
    array_add(*imm.vertices, ..vertices);
}

draw_2d_rect :: (immediate: *Immediate, p0: Vector2, p1: Vector2, color: Vector4 = .{1, 1, 1, 1}) {
    v : [6]UI_Vertex; 
    n := Vector3.{0, 0, 1};
    v[0] = .{ p0, .{0, 0}, color};
    v[1] = .{ xy(p0.x, p1.y), .{0, 1}, color};
    v[2] = .{ p1, .{1, 1}, color};
    
    v[3] = .{ p0, .{0, 0}, color};
    v[4] = .{ p1, .{1, 1}, color};
    v[5] = .{ xy(p1.x, p0.y), .{1, 0} , color};
    push_vertices(immediate, v);
}

draw_2d_rect :: (immediate: *Immediate, x: float, y: float, w: float, h: float, color : Vector4 = .{1, 1, 1, 1}) {
    v : [6]UI_Vertex; 
    n := Vector3.{0, 0, 1};
    v[0] = .{ .{x, y},         .{0, 0}, color};
    v[1] = .{ .{x, y + h},     .{0, 1}, color};
    v[2] = .{ .{x + w, y},     .{1, 0}, color};
    
    v[3] = .{ .{x + w, y},     .{1, 0}, color};
    v[4] = .{ .{x, y + h},     .{0, 1}, color};
    v[5] = .{ .{x + w, y + h}, .{1, 1}, color};
    push_vertices(immediate, v);
}
