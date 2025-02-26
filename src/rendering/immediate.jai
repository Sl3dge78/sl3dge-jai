Immediate :: struct {
    render_pass: *SDL_GPURenderPass;
    vertices: [..]UI_Vertex;
    BUFFER_SIZE :: 1024 * 1024;
}

immediate_begin :: (frame_data: Frame_Data) -> Immediate {
    self: Immediate;
    self.vertices.allocator = temp;
    color_target := create_color_target(frame_data.target); 
    self.render_pass = SDL_NullCheck(SDL_BeginGPURenderPass(frame_data.cmd, *color_target, 1, null));
    SDL_BindGPUGraphicsPipeline(self.render_pass, resources.ui);
    pc := UI_Push_Constants.{.{2.0 / cast(float)frame_data.width, -2.0 / cast(float)frame_data.height}, .{-1, 1}};
    SDL_PushGPUVertexUniformData(frame_data.cmd, 0, *pc, size_of(type_of(pc)));
    return self;
}

immediate_end :: (using self: *Immediate) {
    flush(self);
    SDL_EndGPURenderPass(self.render_pass);
}

flush :: (using immediate: *Immediate) {
    if vertices.count > 0 {
        size : u32 = xx (vertices.count * size_of(type_of(vertices[0])));
        loc := buffer_pool_get(*global_renderer.immediate_buffer_pool, size);
        buffer_write_data(loc.buffer, vertices.data, size, loc.offset);
        SDL_BindGPUVertexBuffers(render_pass, 0, *loc.binding, 1);
        SDL_DrawGPUPrimitives(render_pass, xx vertices.count, 1, 0, 0);
        vertices.count = 0;
    }
}

immediate_bind_texture :: (using immediate: *Immediate, texture: *SDL_GPUTexture) {
    flush(immediate);
    b := SDL_GPUTextureSamplerBinding.{
        texture = texture,
        sampler = global_renderer.sampler,
    };
    SDL_BindGPUFragmentSamplers(render_pass, 0, *b, 1);
}

immediate_default_texture :: (using immediate: *Immediate) {
    immediate_bind_texture(immediate, global_renderer.empty_texture);
}

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
