

prepare_vertices :: (nb: u32) -> *Vertex {
    using global_renderer;
    if nb_vertices + nb > Renderer.MAX_VERTICES then flush();
    ptr := vertex_buffer.mapped + (frame_index * Renderer.REGION_SIZE) + (nb_vertices * size_of(Vertex));
    nb_vertices += nb;
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

change_light_direction :: (dir: Vector3) {
    // @todo
}