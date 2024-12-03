

buffer_write_data :: (buffer: *SDL_GPUBuffer, data: *void, size: u32, buffer_offset: u32 = 0) {
    cmd := SDL_NullCheck(SDL_AcquireGPUCommandBuffer(global_renderer.device));
    defer SDL_SubmitGPUCommandBuffer(cmd);

    copy_pass := SDL_BeginGPUCopyPass(cmd);
    defer SDL_EndGPUCopyPass(copy_pass);

    trans_ci := SDL_GPUTransferBufferCreateInfo.{ .UPLOAD, size, 0 };
    trans := SDL_NullCheck(SDL_CreateGPUTransferBuffer(global_renderer.device, *trans_ci));
    defer SDL_ReleaseGPUTransferBuffer(global_renderer.device, trans);

    ptr := SDL_NullCheck(SDL_MapGPUTransferBuffer(global_renderer.device, trans, false));
    SDL_memcpy(ptr, data, size);
    SDL_UnmapGPUTransferBuffer(global_renderer.device, trans);

    src := SDL_GPUTransferBufferLocation.{
        transfer_buffer = trans,
        offset = 0,
    };
    dst := SDL_GPUBufferRegion.{
        buffer = buffer,
        offset = buffer_offset,
        size = size,
    };
    SDL_UploadToGPUBuffer(copy_pass, *src, *dst, false);
}