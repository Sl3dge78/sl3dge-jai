Texture :: struct {
    using #as handle: wgpu.Texture;
    view : wgpu.TextureView;

    from_data :: (data: *void, w: u32, h: u32, channels: int, $data_type: Type) -> Texture {

        result : Texture;

        format : wgpu.TextureFormat = ---;
        #if data_type == u8 {
            if channels == {
                case 1; format = .R8Unorm;
                case 4; format = .RGBA8UnormSrgb;
                case; assert(false, "Unhandled channel count of %", channels);
            }
        } else #assert(false);

        desc := wgpu.TextureDescriptor.{
            usage = xx(wgpu.TextureUsage.TextureBinding | .CopyDst),
            dimension = ._2D,
            size = .{w, h, 1},
            format = format,
            mipLevelCount = 1,
            sampleCount = 1,
            viewFormatCount = 0,
            viewFormats = null,
        };

        result.handle = wgpu.DeviceCreateTexture(global_renderer.device, *desc);
        assert(result.handle != null, "Unable to create texture");

        view_desc := wgpu.TextureViewDescriptor.{
            format = format,
            dimension = ._2D,
            baseMipLevel = 0,
            mipLevelCount = 1,
            baseArrayLayer = 0,
            arrayLayerCount = 1,
            aspect = .All,
        };
        result.view = wgpu.TextureCreateView(result.handle, *view_desc);
        assert(result.view != null, "Unable to create texture view");

        destination := wgpu.ImageCopyTexture.{
            texture =  result.handle,
            mipLevel = 0,
            origin =   wgpu.Origin3D.{0, 0, 0},
            aspect =   .All,
        };

        data_layout := wgpu.TextureDataLayout.{
            offset =       0,
            bytesPerRow = xx (w * size_of(data_type) * channels),
            rowsPerImage = h,
        };
        wgpu.QueueWriteTexture(global_renderer.queue, *destination, data, xx (w * h * size_of(data_type) * channels), *data_layout, *wgpu.Extent3D.{w, h, 1});

        return result;
    }

    from_file :: (path: string) -> Texture {
    channels: s32;
    w: s32;
    h: s32;
    img := stbi_load(temp_c_string(path), *w, *h, *channels, 4);
    assert(img != null, "Unable to load %.", path);
    defer stbi_image_free(img);
    return from_data(img, xx w, xx h, channels, u8);
}

    destroy :: (texture: *Texture) {
        wgpu.TextureRelease(texture.handle);
        wgpu.TextureViewRelease(texture.view);
        texture.handle = null;
    }
}