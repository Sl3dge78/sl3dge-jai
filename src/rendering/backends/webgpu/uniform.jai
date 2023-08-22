Uniform :: struct {
    bind_group: wgpu.BindGroup;
    loc: Buffer_Location;

    create :: (device: wgpu.Device, pool: *Buffer_Pool, size: u64, layout: wgpu.BindGroupLayout, binding := 0) -> Uniform {
        self: Uniform = ---;
        self.loc = Buffer_Pool.get(pool, size);

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

    destroy :: (using self: *Uniform) {
        wgpu.BindGroupRelease(bind_group);
    }

    write :: inline (using self: Uniform, data: *void) {
        Buffer.write_data(loc.buffer, data, loc.size, loc.offset);
    }
}