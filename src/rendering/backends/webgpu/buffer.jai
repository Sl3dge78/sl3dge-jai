Buffer :: struct {
    using #as handle: wgpu.Buffer;
    size: u64;

    create :: (size: u64, usage: wgpu.BufferUsageFlags, $map := false) -> Buffer {
        self: Buffer = ---;
        self.size = size;
        desc := wgpu.BufferDescriptor.{
            usage = usage,
            size = size, 
            mappedAtCreation = map
        };
        self.handle = WGPU_Check(wgpu.DeviceCreateBuffer(global_renderer.device, *desc));

        return self;
    }

    create_or_update :: (self: *Buffer, size: u64, usage: wgpu.BufferUsageFlags, $map := false) {
        if self.handle != null && self.size >= size then return;
        if self.handle != null {
            Buffer.destroy(self);
        }
        new_size : u64 = 1024;
        while new_size < size {
            new_size += new_size;
        }
        self.* = create(new_size, usage, map);
    }

    destroy :: (self: *Buffer) {
        wgpu.BufferRelease(self.handle);
        self.handle = null;
    }

    write_data :: (self: Buffer, data: *void, size: u64, offset : u64 = 0) {
        wgpu.QueueWriteBuffer(global_renderer.queue, self.handle, offset, data, size);
    }
};