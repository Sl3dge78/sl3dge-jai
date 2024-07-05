Frame_Data :: struct {
    framebuffer: Texture;
    surface_texture: wgpu.SurfaceTexture;

    cmds : [..] wgpu.CommandBuffer;
}

begin_frame :: () -> Frame_Data {
    result : Frame_Data;

    wgpu.SurfaceGetCurrentTexture(global_renderer.surface, *result.surface_texture);

    while result.surface_texture.status != .Success  {
        wgpu.SurfaceGetCurrentTexture(global_renderer.surface, *result.surface_texture);
        // assert(renderer.surface_texture.status == .Success, "Surface status: %", renderer.surface_texture.status);
    }

    result.framebuffer.texture = result.surface_texture.texture;

    desc := wgpu.TextureViewDescriptor.{
        format = global_renderer.surface_format,
        dimension = ._2D,
        baseMipLevel= 0,
        mipLevelCount = 1,
        baseArrayLayer = 0,
        arrayLayerCount = 1,
        aspect = .All
    };
    result.framebuffer.view = wgpu.TextureCreateView(result.framebuffer.texture, *desc);
    result.framebuffer.w = global_renderer.width;
    result.framebuffer.h = global_renderer.height;
    return result;
}

end_frame :: (frame_data: Frame_Data) {
    wgpu.QueueSubmit(global_renderer.queue, xx frame_data.cmds.count, frame_data.cmds.data);

    // Before present to have the real time
    frame_end := SDL_GetPerformanceCounter();
    global_engine.frame_time = cast(float)(frame_end - global_engine.frame_start) / cast(float)SDL_GetPerformanceFrequency();
    wgpu.SurfacePresent(global_renderer.surface);

    wgpu.TextureViewRelease(frame_data.framebuffer.view);
    
    for frame_data.cmds {
        defer wgpu.CommandBufferRelease(it);
    }
    array_reset(*frame_data.cmds);
    buffer_pool_reset_keeping_memory(*global_renderer.immediate_pool);
}

push_command_encoder :: (frame_data: *Frame_Data, encoder: *wgpu.CommandEncoder, label := "") {
    desc := wgpu.CommandBufferDescriptor.{ 
        label = temp_c_string(label)
    };
    command_buffer := WGPU_Check(wgpu.CommandEncoderFinish(encoder.*, *desc));
    array_add(*frame_data.cmds, command_buffer);
    encoder.* = null;
}