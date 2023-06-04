

prepare_vertices :: (cmd: VkCommandBuffer, nb: u32) -> *Vertex {
    using global_renderer;
    if nb_vertices + nb > Renderer.MAX_VERTICES then flush(cmd);
    ptr := buffer + (frame_index * Renderer.REGION_SIZE) + (nb_vertices * size_of(Vertex));
    nb_vertices += nb;
    return ptr;
}

immediate_triangle :: (cmd: VkCommandBuffer) {
    v := prepare_vertices(cmd, 3);
    v[0] = .{.{0.0, 0.0, 0.0}, .{1, 0, 0, 1}};
    v[1] = .{.{100.0, 100.0, 0.0}, .{0, 1, 0, 1}};
    v[2] = .{.{0.0, 100.0, 0}, .{0, 0, 1, 1}};
}

immediate_quad :: (cmd: VkCommandBuffer, p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3, color := Vector4.{1, 1, 1, 1}) {
    v := prepare_vertices(cmd, 6);
    v[0] = .{p0, color, .{0, 0}};
    v[1] = .{p1, color, .{1, 0}};
    v[2] = .{p2, color, .{1, 1}};

    v[3] = .{p0, color, .{0, 0}};
    v[4] = .{p2, color, .{1, 1}};
    v[5] = .{p3, color, .{0, 1}};
}
