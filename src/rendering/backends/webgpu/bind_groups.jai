Uniform :: struct {
    bind_group: wgpu.BindGroup;
    loc: Buffer_Location;
}

uniform_create :: (device: wgpu.Device, pool: *Buffer_Pool, size: u64, layout: wgpu.BindGroupLayout, binding := 0) -> Uniform {
    self: Uniform = ---;
    self.loc = buffer_pool_get(pool, size);

    entry := wgpu.BindGroupEntry.{
        binding = xx binding,
        buffer = self.loc.buffer,
        offset = self.loc.offset,
        size = self.loc.size
    };
    desc := wgpu.BindGroupDescriptor.{
        layout = layout, 
        entryCount = 1,
        entries = *entry,
    };
    self.bind_group = WGPU_Check(wgpu.DeviceCreateBindGroup(device, *desc));
    return self;
}

destroy :: inline (using self: *Uniform) {
    wgpu.BindGroupRelease(bind_group);
}

uniform_write :: inline (using self: Uniform, data: *void) {
    buffer_write_data(loc.buffer, data, loc.size, loc.offset);
}

create_bind_group_from_texture :: (texture: *Texture, layout: wgpu.BindGroupLayout = null) -> wgpu.BindGroup {
    if layout == null {
        layout = global_renderer.single_texture_bgl;
    }
    entries := wgpu.BindGroupEntry.[
        .{binding = 0, sampler = global_renderer.sampler },
        .{binding = 1, textureView = texture.view },
    ];
    desc := wgpu.BindGroupDescriptor.{
        layout = layout,
        entryCount = entries.count,
        entries = entries.data,
    };
    return WGPU_Check(wgpu.DeviceCreateBindGroup(global_renderer.device, *desc));
}

destroy :: inline (bind_group: *wgpu.BindGroup) {
    wgpu.BindGroupRelease(bind_group.*);
    bind_group = null;
}