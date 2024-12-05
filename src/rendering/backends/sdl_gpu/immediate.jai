
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
    SDL_BindGPUGraphicsPipeline(self.render_pass, global_renderer.ui_pipeline);
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