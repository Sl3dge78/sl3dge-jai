Frame_Data :: struct {
    command_buffer: VkCommandBuffer;
    current_draw_data: *Draw_Data;
    
    frame_fence: VkFence;
    image_available_semaphore: VkSemaphore;
    render_finished_semaphore: VkSemaphore;
    image_index: u32;

    camera_buffer: Buffer;
    camera_data : *Camera_Data;
    camera_descriptor: VkDescriptorSet;

    shadowmap_camera_descriptor: VkDescriptorSet;
    shadowmap_camera_data : *Camera_Data;

    create :: (device: VkDevice, command_pool: VkCommandPool, camera_dsl: VkDescriptorSetLayout) -> Frame_Data {
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
        cam_data_aligned := aligned_size(size_of(Camera_Data), global_renderer.physical_device_properties.limits.minUniformBufferOffsetAlignment);
        self.camera_buffer = Buffer.create(cam_data_aligned * 2, .UNIFORM_BUFFER_BIT, .UPLOAD, true);
        self.shadowmap_camera_data = cast(*Camera_Data)self.camera_buffer.mapped;
        self.camera_data = self.camera_buffer.mapped + cam_data_aligned;
        
        self.shadowmap_camera_descriptor = Descriptor_Set.create(camera_dsl);
        Descriptor_Set.write(self.shadowmap_camera_descriptor, self.camera_buffer.buffer, size_of(Camera_Data), 0);

        self.camera_descriptor = Descriptor_Set.create(camera_dsl);
        Descriptor_Set.write(self.camera_descriptor, self.camera_buffer.buffer, size_of(Camera_Data), cam_data_aligned);
        return self;
    }

    destroy :: (using self: *Frame_Data, device: VkDevice) {
        vkDestroyFence(device, frame_fence, null);
        vkDestroySemaphore(device, render_finished_semaphore, null);
        vkDestroySemaphore(device, image_available_semaphore, null);
        Buffer.destroy(*camera_buffer);    
    }
}

#add_context vk: Frame_Data;