Bindings_Builder :: struct {

    entries: [..] wgpu.BindGroupLayoutEntry;

    add_entry :: (using builder: *Bindings_Builder, entry: $T, binding: u32, visibility: wgpu.ShaderStageFlags) {
        
        group_entry := wgpu.BindGroupLayoutEntry.{
            binding = binding,
            visibility = visibility
        };
        #if T == wgpu.BufferBindingLayout {
            group_entry.buffer = entry;
        } else #if T == wgpu.SamplerBindingLayout {
            group_entry.sampler = entry;
        } else #if wgpu.TextureBindingLayout {
            group_entry.texture = entry;
        } else #if wgpu.StorageTextureBindingLayout {
            group_entry.storageTexture = entry;
        } else { #assert(false); }

        array_add(*entries, group_entry);
    }

    build :: (using builder: *Bindings_Builder) -> wgpu.BindGroupLayout {
        
        desc := wgpu.BindGroupLayoutDescriptor.{
            entryCount = xx entries.count,
            entries = entries.data,
        };
        group_layout := wgpu.DeviceCreateBindGroupLayout(global_renderer.device, *desc);
        assert(group_layout != null, "Unable to create Bind Group Layout");
        
        array_reset(*entries);
        return group_layout;
    }
}