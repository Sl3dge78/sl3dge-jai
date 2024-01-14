Frame_Data :: struct {
    command_buffer: VkCommandBuffer;
    // current_draw_data: *Draw_Data;
    
    frame_fence: VkFence;
    image_available_semaphore: VkSemaphore;
    render_finished_semaphore: VkSemaphore;
    framebuffer: Texture;

    camera_descriptor: Uniform_Buffer;
    shadowmap_camera_descriptor: Uniform_Buffer;
    swapchain_image_index: u32;
}

frame_data_create :: (device: VkDevice, command_pool: VkCommandPool, camera_dsl: VkDescriptorSetLayout) -> Frame_Data {
    self: Frame_Data;
    cmd_buff_ci := VkCommandBufferAllocateInfo.{
        commandPool = command_pool,
        level = .PRIMARY,
        commandBufferCount = 1,
    };
    vkAllocateCommandBuffers(device, *cmd_buff_ci, *self.command_buffer);

    semaphore_ci := VkSemaphoreCreateInfo.{};
    vkCreateSemaphore(device, *semaphore_ci, null, *self.image_available_semaphore);
    vkCreateSemaphore(device, *semaphore_ci, null, *self.render_finished_semaphore);

    fence_ci := VkFenceCreateInfo.{ flags = .SIGNALED_BIT, };
    vkCreateFence(device, *fence_ci, null, *self.frame_fence);

    // Camera uniforms
    self.shadowmap_camera_descriptor = uniform_buffer_create(camera_dsl, size_of(Camera_Data));
    self.camera_descriptor = uniform_buffer_create(camera_dsl, size_of(Camera_Data));
    return self;
}

destroy :: (using self: *Frame_Data, device: VkDevice) {
    vkDestroyFence(device, frame_fence, null);
    vkDestroySemaphore(device, render_finished_semaphore, null);
    vkDestroySemaphore(device, image_available_semaphore, null);
}
