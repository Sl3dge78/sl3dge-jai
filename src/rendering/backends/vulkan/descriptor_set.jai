Descriptor_Set :: struct {

    create :: (layout: ..VkDescriptorSetLayout) -> VkDescriptorSet {
        alloc_info := VkDescriptorSetAllocateInfo.{
        descriptorPool = global_renderer.descriptor_pool,
        descriptorSetCount = xx layout.count,
        pSetLayouts = layout.data,
        };
        result: VkDescriptorSet = ---;
        Vk_Check(vkAllocateDescriptorSets(global_renderer.device, *alloc_info, *result));
        return result;
    }

    write :: (self: VkDescriptorSet, sampler: VkSampler, view: VkImageView, layout: VkImageLayout) {
        image_info := VkDescriptorImageInfo.{
            sampler = sampler, 
            imageView = view, 
            imageLayout = layout,
        };
        descriptor_writes := VkWriteDescriptorSet.[.{
            dstSet = self,
            dstBinding = 0,
            dstArrayElement = 0,
            descriptorType = .COMBINED_IMAGE_SAMPLER,
            descriptorCount = 1,
            pImageInfo = *image_info,
        }];
        vkUpdateDescriptorSets(global_renderer.device, descriptor_writes.count, descriptor_writes.data, 0, null);
    }

    write :: (self: VkDescriptorSet, buffer: VkBuffer, size: u64, offset: u64 = 0) {
        buffer_info := VkDescriptorBufferInfo.{
            buffer = buffer,
            offset = offset,
            range = size,
        };

        writes := VkWriteDescriptorSet.[.{
            dstSet = self,
            dstBinding = 0,
            dstArrayElement = 0,
            descriptorType = .UNIFORM_BUFFER,
            descriptorCount = 1,
            pBufferInfo = *buffer_info
        }];

        vkUpdateDescriptorSets(global_renderer.device, writes.count, writes.data, 0, null);

    }
}