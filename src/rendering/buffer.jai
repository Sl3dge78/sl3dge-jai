

buffer_write_data :: (buffer: *SDL_GPUBuffer, data: *void, size: u32, buffer_offset: u32 = 0) {

    trans_ci := SDL_GPUTransferBufferCreateInfo.{ .UPLOAD, size, 0 };
    transfer_buffer := SDL_NullCheck(SDL_CreateGPUTransferBuffer(global_renderer.device, *trans_ci));

    src := SDL_GPUTransferBufferLocation.{
        transfer_buffer = transfer_buffer,
        offset = 0,
    };
    dst := SDL_GPUBufferRegion.{
        buffer = buffer,
        offset = buffer_offset,
        size = size,
    };

    ptr := SDL_NullCheck(SDL_MapGPUTransferBuffer(global_renderer.device, transfer_buffer, false));
    SDL_memcpy(ptr, data, size);
    SDL_UnmapGPUTransferBuffer(global_renderer.device, transfer_buffer);

    cmd := SDL_NullCheck(SDL_AcquireGPUCommandBuffer(global_renderer.device));
    copy_pass := SDL_BeginGPUCopyPass(cmd);
    SDL_UploadToGPUBuffer(copy_pass, *src, *dst, false);
    SDL_EndGPUCopyPass(copy_pass);
    SDL_SubmitGPUCommandBuffer(cmd);
    SDL_ReleaseGPUTransferBuffer(global_renderer.device, transfer_buffer);
}

Buffer_Mapping :: struct {
    ptr : *void;
    size: u32;
    transfer_buffer: *SDL_GPUTransferBuffer;
    src: SDL_GPUTransferBufferLocation;
    dst: SDL_GPUBufferRegion;
}

buffer_map :: (buffer: *SDL_GPUBuffer, size: u32, offset: u32 = 0) -> Buffer_Mapping {
    result : Buffer_Mapping = ---;
    trans_ci := SDL_GPUTransferBufferCreateInfo.{ .UPLOAD, size, 0 };
    result.size = size;
    result.transfer_buffer = SDL_NullCheck(SDL_CreateGPUTransferBuffer(global_renderer.device, *trans_ci));

    result.ptr = SDL_NullCheck(SDL_MapGPUTransferBuffer(global_renderer.device, result.transfer_buffer, false));

    result.src = SDL_GPUTransferBufferLocation.{
        transfer_buffer = result.transfer_buffer,
        offset = 0,
    };
    result.dst = SDL_GPUBufferRegion.{
        buffer = buffer,
        offset = offset,
        size = size,
    };
    return result;
}

buffer_unmap :: (using buffer_mapping: Buffer_Mapping) {
    SDL_UnmapGPUTransferBuffer(global_renderer.device, transfer_buffer);
    cmd := SDL_NullCheck(SDL_AcquireGPUCommandBuffer(global_renderer.device));
    copy_pass := SDL_BeginGPUCopyPass(cmd);
    SDL_UploadToGPUBuffer(copy_pass, *src, *dst, false);
    SDL_EndGPUCopyPass(copy_pass);
    SDL_SubmitGPUCommandBuffer(cmd);
    SDL_ReleaseGPUTransferBuffer(global_renderer.device, transfer_buffer);
}

