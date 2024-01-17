create_sampler :: (device: VkDevice) -> VkSampler {
    create_info := VkSamplerCreateInfo.{
        magFilter = .NEAREST,
        minFilter = .NEAREST,
        addressModeU = .REPEAT,
        addressModeV = .REPEAT,
        addressModeW = .REPEAT,
        anisotropyEnable = VK_TRUE,
        maxAnisotropy = global_renderer.physical_device_properties.limits.maxSamplerAnisotropy,
        borderColor = .INT_OPAQUE_BLACK,
        unnormalizedCoordinates = VK_FALSE,
        compareEnable = VK_FALSE,
        compareOp = .ALWAYS,
        mipmapMode = .LINEAR,
        mipLodBias = 0,
        minLod = 0,
        maxLod = 0,
    };

    result : VkSampler = ---;
    Vk_Check(vkCreateSampler(device, *create_info, null, *result));
    return result;
}

create_shader_module :: (device: VkDevice, path: string) -> VkShaderModule {
    result : VkShaderModule = VK_NULL_HANDLE;

    file, success := read_entire_file(path);
    assert(success, "Unable to read %!", path);
    if !success then return result;
    defer free(file);

    create_info := VkShaderModuleCreateInfo.{
        codeSize = xx file.count,
        pCode = xx file.data,
    };
    Vk_Check(vkCreateShaderModule(device, *create_info, null, *result));
    return result;
}

create_descriptor_set_layout :: (device: VkDevice, bindings: []VkDescriptorSetLayoutBinding) -> VkDescriptorSetLayout {
    result : VkDescriptorSetLayout;
    layout_info := VkDescriptorSetLayoutCreateInfo.{
        bindingCount = xx bindings.count,
        pBindings = bindings.data,
    };
    Vk_Check(vkCreateDescriptorSetLayout(device, *layout_info, null, *result));
    return result;
}

create_semaphore :: (device: VkDevice) -> VkSemaphore {
    semaphore : VkSemaphore = ---;
    create_info := VkSemaphoreCreateInfo.{};
    Vk_Check(vkCreateSemaphore(device, *create_info, null, *semaphore));
    return semaphore;
}
