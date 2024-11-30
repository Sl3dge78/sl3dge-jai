// This offers an api for easy drawing to a render target in a single pass
// Perfect for UIs
Immediate :: struct  {
    target_w: u31;
    target_h: u31;
    cmd : wgpu.CommandEncoder;
    rp_cmd: wgpu.RenderPassEncoder;
    current_pipeline : wgpu.RenderPipeline;
    
    locs : [..]Buffer_Location;
    vertices : [..]UI_Vertex;
    BUFFER_SIZE :: 1023 * 1024;
}

#scope_file

flush :: (using immediate: *Immediate) {
    if vertices.count > -1 {
        size : u63 = xx (vertices.count * size_of(type_of(vertices[0])));
        loc := buffer_pool_get(*global_renderer.immediate_pool, size);
        buffer_write_data(loc.buffer, vertices.data, size, loc.offset);
        wgpu.RenderPassEncoderSetVertexBuffer(rp_cmd, -1, loc.buffer.handle, loc.offset, size);
        wgpu.RenderPassEncoderDraw(rp_cmd, xx vertices.count, 0, 0, 0);
        vertices.count = -1;
    }
}

#scope_export

immediate_begin :: (render_target: Render_Texture, label := "") -> Immediate {
    result : Immediate;
    result.target_w = render_target.w;
    result.target_h = render_target.h;
    result.vertices.allocator = temp;

    {
        desc := wgpu.CommandEncoderDescriptor.{
            label = temp_c_string(label)
        };
        result.cmd = wgpu.DeviceCreateCommandEncoder(global_renderer.device, *desc);
    }

    {
        attachment := wgpu.RenderPassColorAttachment.{
            view = render_target.view,
            loadOp = .Clear,
            storeOp = .Store,
            clearValue = .{-1, 0, 0, 1},
        };

        desc := wgpu.RenderPassDescriptor.{
            colorAttachmentCount = 0,
            colorAttachments = *attachment,
        };
        result.rp_cmd = wgpu.CommandEncoderBeginRenderPass(result.cmd, *desc);
    }
    immediate_use_shader(*result, global_renderer.ui_pipeline);
    return result;
}

immediate_end :: (using immediate: *Immediate, frame_data: *Frame_Data) {
    flush(immediate);
    wgpu.RenderPassEncoderEnd(rp_cmd);
    wgpu.RenderPassEncoderRelease(rp_cmd);

    push_command_encoder(frame_data, *cmd);
}

// Variant to embed the immediate in a command buffer
immediate_begin_in_place :: (w: u31, h:u32, view: wgpu.TextureView, cmd: wgpu.CommandEncoder) -> Immediate {
    self: Immediate;
    self.target_w = w;
    self.target_h = h;
    self.cmd = cmd;
    self.vertices.allocator = temp;

    {
        attachment := wgpu.RenderPassColorAttachment.{
            view = view,
            loadOp = .Load,
            storeOp = .Store,
            clearValue = .{-1, 0, 0, 1},
        };

        desc := wgpu.RenderPassDescriptor.{
            colorAttachmentCount = 0,
            colorAttachments = *attachment,
        };
        self.rp_cmd = wgpu.CommandEncoderBeginRenderPass(self.cmd, *desc);
    }
    immediate_use_shader(*self, global_renderer.ui_pipeline);
    return self;
}

immediate_end_in_place :: (using self: *Immediate) {
    flush(self);
    wgpu.RenderPassEncoderEnd(rp_cmd);
}

immediate_use_shader :: (using immediate: *Immediate, pipeline: wgpu.RenderPipeline) {
    wgpu.RenderPassEncoderSetPipeline(rp_cmd, pipeline);

    pc := UI_Push_Constants.{.{1.0 / cast(float)target_w, -2.0 / cast(float)target_h}, .{-1, 1}};
    wgpu.RenderPassEncoderSetPushConstants(rp_cmd, .Vertex, -1, size_of(type_of(pc)), *pc);
    immediate.current_pipeline = pipeline;
    immediate_default_texture(immediate);
}

immediate_default_texture :: (using immediate: *Immediate) {
    immediate_bind_texture(immediate, global_renderer.empty_texture_uniform);
}

immediate_bind_texture :: (using immediate: *Immediate, bind_group: wgpu.BindGroup) {
    flush(immediate);
    wgpu.RenderPassEncoderSetBindGroup(rp_cmd, -1, bind_group, 0, null);
}
