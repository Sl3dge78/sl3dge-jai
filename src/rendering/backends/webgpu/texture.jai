Texture :: struct {
    #as texture: wgpu.Texture;
    view : wgpu.TextureView;
    w: u32;
    h: u32;
}

Render_Texture :: struct {
    using #as tex: Texture;
    bind_group: wgpu.BindGroup;
}

texture_from_data :: (data: *void, w: u32, h: u32, channels: int, $data_type: Type, name := "") -> Texture {
    format : wgpu.TextureFormat = ---;
    #if data_type == u8 {
        if channels == {
            case 1; format = .R8Unorm;
            case 4; format = .BGRA8UnormSrgb;
            case; assert(false, "Unhandled channel count of %", channels);
        }
    } else #assert(false);

    result := texture_create(w, h, wgpu.TextureUsage.TextureBinding | .CopyDst, format);

    destination := wgpu.ImageCopyTexture.{
        texture =  result.texture,
        mipLevel = 0,
        origin =   wgpu.Origin3D.{0, 0, 0},
        aspect =   .All,
    };

    data_layout := wgpu.TextureDataLayout.{
        offset =       0,
        bytesPerRow = xx (w * size_of(data_type) * channels),
        rowsPerImage = h,
    };
    extent := wgpu.Extent3D.{w, h, 1};
    wgpu.QueueWriteTexture(global_renderer.queue, *destination, data, xx (w * h * size_of(data_type) * channels), *data_layout, *extent);

    return result;
}

texture_from_file :: (path: string) -> Texture {
    channels: s32;
    w: s32;
    h: s32;
    img := stbi_load(temp_c_string(path), *w, *h, *channels, 4);
    assert(img != null, "Unable to load %.", path);
    defer stbi_image_free(img);
    return texture_from_data(img, xx w, xx h, channels, u8);
}

create_texture :: (w: u32, h: u32, usage: wgpu.TextureUsage, format: wgpu.TextureFormat, view_formats: ..wgpu.TextureFormat, label := "") -> wgpu.Texture {
    desc := wgpu.TextureDescriptor.{
        label = temp_c_string(label),
        usage = xx usage,
        dimension = ._2D,
        size = .{w, h, 1},
        format = format,
        mipLevelCount = 1,
        sampleCount = 1,
        viewFormatCount = xx view_formats.count,
        viewFormats = view_formats.data,
    };
    return WGPU_Check(wgpu.DeviceCreateTexture(global_renderer.device, *desc));
}

destroy :: (texture: wgpu.Texture) {
    wgpu.TextureRelease(texture);
}

destroy :: (view: wgpu.TextureView) {
    wgpu.TextureViewRelease(view);
}

create_texture_view :: (texture: wgpu.Texture, format: wgpu.TextureFormat) -> wgpu.TextureView {
    view_desc := wgpu.TextureViewDescriptor.{
        format = format,
        dimension = ._2D,
        baseMipLevel = 0,
        mipLevelCount = 1,
        baseArrayLayer = 0,
        arrayLayerCount = 1,
        aspect = .All,
    };

    if format == {
        case .Depth24Plus; #through;
        case .Depth32Float; view_desc.aspect = .DepthOnly;
    }
    return WGPU_Check(wgpu.TextureCreateView(texture, *view_desc));
}

texture_create :: (w: u32, h: u32, usage: wgpu.TextureUsage, format: wgpu.TextureFormat, name := "") -> Texture {
    result : Texture;
    result.w = w;
    result.h = h;
    result.texture = create_texture(w, h, usage, format, label = name);
    result.view = create_texture_view(result.texture, format);
    return result;
}

cubemap_create :: (w: u32, h: u32, usage: wgpu.TextureUsage, format: wgpu.TextureFormat) -> Texture {
    result : Texture;
    result.w = w;
    result.h = h;
    desc := wgpu.TextureDescriptor.{
        usage = xx usage,
        dimension = ._2D,
        size = .{w, h, 6},
        format = format,
        mipLevelCount = 1,
        sampleCount = 1,
        viewFormatCount = 0,
        viewFormats = null,
    };

    result.texture = WGPU_Check(wgpu.DeviceCreateTexture(global_renderer.device, *desc));

    view_desc := wgpu.TextureViewDescriptor.{
        format = format,
        dimension = ._2D,
        baseMipLevel = 0,
        mipLevelCount = 1,
        baseArrayLayer = 0,
        arrayLayerCount = 6,
        aspect = .All,
    };

    if format == {
        case .Depth24Plus; #through;
        case .Depth32Float; view_desc.aspect = .DepthOnly;
    }
    result.view = WGPU_Check(wgpu.TextureCreateView(result.texture, *view_desc));
    return result;
}

render_texture_create :: (w: u32, h: u32, name : string = "") -> Render_Texture {
    result : Render_Texture;
    result.tex = texture_create(w, h, .TextureBinding | .RenderAttachment, global_renderer.render_format, name);
    result.bind_group = create_bind_group_from_texture(*result.tex);
    return result;
}

destroy :: (texture: *Texture) {
    wgpu.TextureRelease(texture.texture);
    wgpu.TextureViewRelease(texture.view);
    texture.texture = null;
}