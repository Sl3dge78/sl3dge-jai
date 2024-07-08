Frame_Data :: struct {
    framebuffer: wgpu.Texture;
    render_to_view: wgpu.TextureView;
    read_from_view: wgpu.TextureView;

    bind_group : wgpu.BindGroup;

    cmds : [..] wgpu.CommandBuffer;
}

begin_frame :: () -> Frame_Data {
    result: Frame_Data;

    result.framebuffer = create_texture(global_renderer.width, global_renderer.height, wgpu.TextureUsage.TextureBinding | .RenderAttachment, global_renderer.render_format, global_renderer.render_format, global_renderer.surface_format, label = "Framebuffer");
    result.read_from_view = create_texture_view(result.framebuffer, global_renderer.surface_format);
    result.render_to_view = create_texture_view(result.framebuffer, global_renderer.render_format);

    result.bind_group = create_bind_group_from_view(result.read_from_view);

    return result;
}

end_frame :: (frame_data: Frame_Data) {
    surface_texture: wgpu.SurfaceTexture = ---;
    wgpu.SurfaceGetCurrentTexture(global_renderer.surface, *surface_texture);
    while surface_texture.status != .Success  {
        wgpu.SurfaceGetCurrentTexture(global_renderer.surface, *surface_texture);
    }

    desc := wgpu.TextureViewDescriptor.{
        format = global_renderer.surface_format,
        dimension = ._2D,
        baseMipLevel= 0,
        mipLevelCount = 1,
        baseArrayLayer = 0,
        arrayLayerCount = 1,
        aspect = .All
    };
    surface_view := wgpu.TextureCreateView(surface_texture.texture, *desc);


    {   // Blit to framebuffer
        cmd := create_command_encoder("Blit");
        defer push_command_encoder(*frame_data, *cmd);
        render_pass : wgpu.RenderPassEncoder = ---;

        {
            attachment := wgpu.RenderPassColorAttachment.{
                view = surface_view,
                loadOp = .Clear,
                storeOp = .Store,
                clearValue = .{0, 0, 0, 1},
            };

            desc := wgpu.RenderPassDescriptor.{
                colorAttachmentCount = 1,
                colorAttachments = *attachment,
            };
            render_pass = wgpu.CommandEncoderBeginRenderPass(cmd, *desc);
        }

        wgpu.RenderPassEncoderSetPipeline(render_pass, global_renderer.blit_pipeline);
        wgpu.RenderPassEncoderSetBindGroup(render_pass, 0, frame_data.bind_group, 0, null);
        wgpu.RenderPassEncoderDraw(render_pass, 6, 1, 0, 0);
        wgpu.RenderPassEncoderEnd(render_pass);
    }

    wgpu.QueueSubmit(global_renderer.queue, xx frame_data.cmds.count, frame_data.cmds.data);

    // Before present to have the real time
    frame_end := SDL_GetPerformanceCounter();
    global_engine.frame_time = cast(float)(frame_end - global_engine.frame_start) / cast(float)SDL_GetPerformanceFrequency();
    wgpu.SurfacePresent(global_renderer.surface);

    for frame_data.cmds {
        defer wgpu.CommandBufferRelease(it);
    }
    array_reset(*frame_data.cmds);
    buffer_pool_reset_keeping_memory(*global_renderer.immediate_pool);
    destroy(frame_data.framebuffer);
    destroy(frame_data.render_to_view);
    destroy(frame_data.read_from_view);
}

push_command_encoder :: (frame_data: *Frame_Data, encoder: *wgpu.CommandEncoder, label := "") {
    desc := wgpu.CommandBufferDescriptor.{ 
        label = temp_c_string(label)
    };
    command_buffer := WGPU_Check(wgpu.CommandEncoderFinish(encoder.*, *desc));
    array_add(*frame_data.cmds, command_buffer);
    encoder.* = null;
}