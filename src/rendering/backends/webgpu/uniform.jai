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

Texture_Uniform :: struct {
    bind_group: wgpu.BindGroup;
}

texture_uniform_create :: (sampler: wgpu.Sampler, texture_view: wgpu.TextureView, layout: wgpu.BindGroupLayout) -> Texture_Uniform {
    entries := wgpu.BindGroupEntry.[
        .{binding = 0, sampler = sampler },
        .{binding = 1, textureView = texture_view },
    ];
    desc := wgpu.BindGroupDescriptor.{
        layout = layout,
        entryCount = entries.count,
        entries = entries.data,
    };
    return .{WGPU_Check(wgpu.DeviceCreateBindGroup(global_renderer.device, *desc))};
}

destroy :: inline (using self: *Texture_Uniform) {
    wgpu.BindGroupRelease(bind_group);
}