Frame_Data :: struct {
    frame_fence: VkFence;
    image_available_semaphore: VkSemaphore;
    framebuffer: Render_Texture;

    camera_descriptor: Uniform_Buffer;
    shadowmap_camera_descriptor: Uniform_Buffer;
    swapchain_image_index: u32;
}

frame_data_create :: (device: VkDevice, command_pool: VkCommandPool, camera_dsl: VkDescriptorSetLayout) -> Frame_Data {
    self: Frame_Data;
    semaphore_ci := VkSemaphoreCreateInfo.{};
    Vk_Check(vkCreateSemaphore(device, *semaphore_ci, null, *self.image_available_semaphore));
    Vk_Check(vkCreateSemaphore(device, *semaphore_ci, null, *self.framebuffer.render_finished_semaphore));

    fence_ci := VkFenceCreateInfo.{ flags = .SIGNALED_BIT, };
    vkCreateFence(device, *fence_ci, null, *self.frame_fence);

    // Camera uniforms
    self.shadowmap_camera_descriptor = uniform_buffer_create(camera_dsl, size_of(Global_Matrices));
    self.camera_descriptor = uniform_buffer_create(camera_dsl, size_of(Global_Matrices));
    return self;
}

destroy :: (using self: *Frame_Data, device: VkDevice) {
    vkDestroyFence(device, frame_fence, null);
    vkDestroySemaphore(device, framebuffer.render_finished_semaphore, null);
    vkDestroySemaphore(device, image_available_semaphore, null);
}
