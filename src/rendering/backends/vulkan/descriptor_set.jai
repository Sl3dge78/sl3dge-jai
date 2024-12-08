Uniform_Buffer :: struct {
    descriptor_set: VkDescriptorSet;
    loc: Buffer_Location;
}

uniform_buffer_create :: (layout: VkDescriptorSetLayout, size: VkDeviceSize) -> Uniform_Buffer {
    self: Uniform_Buffer = ---;
    self.loc = buffer_pool_get(*global_renderer.uniform_buffer_pool, size);

    alloc_info := VkDescriptorSetAllocateInfo.{
        descriptorPool = global_renderer.descriptor_pool,
        descriptorSetCount = 1,
        pSetLayouts = *layout,
    };
    Vk_Check(vkAllocateDescriptorSets(global_renderer.device, *alloc_info, *self.descriptor_set));

    buffer_info := VkDescriptorBufferInfo.{
        buffer = self.loc.buffer.handle,
        offset = self.loc.offset,
        range = size,
    };

    writes := VkWriteDescriptorSet.[.{
        dstSet = self.descriptor_set,
        dstBinding = 0,
        dstArrayElement = 0,
        descriptorType = .UNIFORM_BUFFER,
        descriptorCount = 1,
        pBufferInfo = *buffer_info
    }];
    vkUpdateDescriptorSets(global_renderer.device, writes.count, writes.data, 0, null);

    return self;
}

uniform_buffer_write :: (using self: *Uniform_Buffer, data: *$T) {
    assert(size_of(T) == loc.size);
    buffer_write_data(loc.buffer, data, loc.size, loc.offset);
}

destroy :: (using self: *Uniform_Buffer) {
    // @TODO: release buffer location
}

create_texture_descriptor_set :: (sampler: VkSampler, view: VkImageView, layout: VkDescriptorSetLayout) -> VkDescriptorSet {
    result: VkDescriptorSet = ---;
    alloc_info := VkDescriptorSetAllocateInfo.{
        descriptorPool = global_renderer.descriptor_pool,
        descriptorSetCount = 1,
        pSetLayouts = *layout,
    };
    Vk_Check(vkAllocateDescriptorSets(global_renderer.device, *alloc_info, *result));

    image_info := VkDescriptorImageInfo.{
        sampler = sampler, 
        imageView = view, 
        imageLayout = .SHADER_READ_ONLY_OPTIMAL,
    };
    descriptor_writes := VkWriteDescriptorSet.[.{
        dstSet = result,
        dstBinding = 0,
        dstArrayElement = 0,
        descriptorType = .COMBINED_IMAGE_SAMPLER,
        descriptorCount = 1,
        pImageInfo = *image_info,
    }];
    vkUpdateDescriptorSets(global_renderer.device, descriptor_writes.count, descriptor_writes.data, 0, null);

    return result;
}

create_texture_descriptor_set :: (texture: Texture, layout: VkDescriptorSetLayout = null) -> VkDescriptorSet { 
    if layout == null {
        layout = global_renderer.single_texture_layout;
    }

    return create_texture_descriptor_set(global_renderer.sampler, texture.view, layout);
}

destroy :: (ds: VkDescriptorSet) {

}