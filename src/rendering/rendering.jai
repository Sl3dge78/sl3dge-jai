destroy :: (self: Texture) {
    assert(self != null);
    SDL_ReleaseGPUTexture(global_renderer.device, self);
}

texture_from_file :: (path: string, $$format: SDL_GPUTextureFormat = .INVALID) -> Texture {
    channels: s32;
    w: s32;
    h: s32;
    img := stbi_load(temp_c_string(path), *w, *h, *channels, 4);
    log("[Texture] Loading %. %x%:%", path, w, h, channels);
    assert(img != null, "Unable to load %.", path);
    defer stbi_image_free(img);
    return texture_from_data(img, xx w, xx h, 4, u8, format, name = path_filename(path));
}

texture_from_memory :: (data: *u8, len: s32, $$name := "", $$format : SDL_GPUTextureFormat = .INVALID) -> Texture {
    channels: s32;
    w: s32;
    h: s32;
    img := stbi_load_from_memory(data, xx len, *w, *h, *channels, 4);
    log("[Texture] Loading from memory (%). %x%:%", name, w, h, channels);
    assert(img != null, "Unable to load texture from memory.");
    defer stbi_image_free(img);
    return texture_from_data(img, xx w, xx h, 4, u8, format, name);
}

texture_from_data :: (buffer: *u8, w: u32, h: u32, channels: u32, $type: Type, $$format := SDL_GPUTextureFormat.INVALID, $$name := "") -> Texture {
    size := w * h * channels * size_of(type);
    tbuf_ci := SDL_GPUTransferBufferCreateInfo.{
        usage = .UPLOAD,
        size = size,
        props = 0,
    };
    tbuf := SDL_CreateGPUTransferBuffer(global_renderer.device, *tbuf_ci);
    defer SDL_ReleaseGPUTransferBuffer(global_renderer.device, tbuf);

    f : SDL_GPUTextureFormat;
    #if is_constant(format) {
        #if format != .INVALID { 
            f = format;
        } else { 
            if channels == {
                case 1; f = .R8_UNORM;
                case 3; #through;
                case 4; f = .R8G8B8A8_UNORM_SRGB;
                case; assert(false, "Unhandled channel count of %.", channels);
            }
        }
    } else {
        f = format;
    }

    texture_ci := SDL_GPUTextureCreateInfo.{
        type = ._2D,
        format = f,
        usage = .SAMPLER,
        width = w,
        height = h,
        layer_count_or_depth = 1,
        num_levels = 1,
        sample_count = ._1,

        props = 0,
    };
    texture := SDL_CreateGPUTexture(global_renderer.device, *texture_ci);

    data := SDL_MapGPUTransferBuffer(global_renderer.device, tbuf, false);
    SDL_memcpy(data, buffer, size);
    SDL_UnmapGPUTransferBuffer(global_renderer.device, tbuf);

    cmd := SDL_AcquireGPUCommandBuffer(global_renderer.device);
    defer SDL_SubmitGPUCommandBuffer(cmd);

    copy_pass := SDL_BeginGPUCopyPass(cmd);
    defer SDL_EndGPUCopyPass(copy_pass);
    src := SDL_GPUTextureTransferInfo.{ tbuf, 0, w, h };

    dst := SDL_GPUTextureRegion.{
        texture,
        0, 0,
        0, 0, 0,
        w, h, 1,
    };
    SDL_UploadToGPUTexture(copy_pass, *src, *dst, false);
    #if is_constant(name) { 
        #if name != "" {
            SDL_SetGPUTextureName(global_renderer.device, texture, name.data);
        }
    } else { 
        assert(name != "");
        SDL_SetGPUTextureName(global_renderer.device, texture, name.data);
    }
    return texture;
}
