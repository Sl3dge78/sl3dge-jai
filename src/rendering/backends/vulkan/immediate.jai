// This offers an api for easy drawing to a render target in a single pass
// Perfect for UIs
Immediate :: struct  {
    target: *Render_Texture;
    command_buffer : VkCommandBuffer;
    current_pipeline : Pipeline;
    
    locs : [..]Buffer_Location;
    vertices : [..]UI_Vertex;
    BUFFER_SIZE :: 1024 * 1024;
}

#scope_file

flush :: (using immediate: *Immediate) {
    if vertices.count > 0 {
        size : u64 = xx (vertices.count * size_of(type_of(vertices[0])));
        loc := buffer_pool_get(*global_renderer.immediate_buffer_pool, size);
        buffer_write_data(loc.buffer, vertices.data, size, loc.offset);
        vkCmdBindVertexBuffers(command_buffer, 0, 1, *loc.buffer.handle, *(loc.offset));
        vkCmdDraw(command_buffer, xx vertices.count, 1, 0, 0);
        vertices.count = 0;
    }
}

#scope_export

immediate_begin :: (render_target: *Render_Texture, label : string = "") -> Immediate {
    result : Immediate;
    result.target = render_target;
    result.vertices.allocator = temp;

    // @TODO: maybe look into secondary command buffers?
    alloc_info := VkCommandBufferAllocateInfo.{
        commandPool = global_renderer.command_pool,
        level = .PRIMARY,
        commandBufferCount = 1,
    };
    Vk_Check(vkAllocateCommandBuffers(global_renderer.device, *alloc_info, *result.command_buffer));
    debug_name_object(result.command_buffer, label);

    begin_info := VkCommandBufferBeginInfo.{
        flags = .ONE_TIME_SUBMIT_BIT,
    };
    Vk_Check(vkBeginCommandBuffer(result.command_buffer, *begin_info));

    // Prepare the render target for rendering
    // According to the spec : 
    // This layout [UNDEFINED] can be used in place of the current image layout in a layout transition,
    // but doing so will cause the contents of the image’s memory to be undefined.
    transition_texture_layout(result.target, .UNDEFINED, .COLOR_ATTACHMENT_OPTIMAL, result.command_buffer);

    immediate_begin_rendering(*result);
    return result;
}

immediate_end :: (using immediate: *Immediate) {
    flush(immediate);
    vkCmdEndRendering(command_buffer);

    transition_texture_layout(immediate.target, .COLOR_ATTACHMENT_OPTIMAL, .SHADER_READ_ONLY_OPTIMAL, command_buffer);

    vkEndCommandBuffer(command_buffer);

    submit_info := VkSubmitInfo.{
        waitSemaphoreCount = 0,
        pWaitSemaphores = null,
        pWaitDstStageMask = VkPipelineStageFlags.[.COLOR_ATTACHMENT_OUTPUT_BIT].data,
        commandBufferCount = 1,
        pCommandBuffers = *command_buffer,
        signalSemaphoreCount = 1,
        pSignalSemaphores = *target.render_finished_semaphore,
    };
    Vk_Check(vkQueueSubmit(global_renderer.graphics_queue, 1, *submit_info, VK_NULL_HANDLE));
}

immediate_begin_rendering :: (using self: *Immediate) {
    color_attachment := VkRenderingAttachmentInfo.{
        imageView = target.view,
        imageLayout = .COLOR_ATTACHMENT_OPTIMAL,
        loadOp = .LOAD,
        storeOp = .STORE,
        clearValue = .{color = .{ _float32 = .[0, 0, 0, 1]}},
    };

    rendering_info := VkRenderingInfo.{
        renderArea = .{
            offset = .{0, 0},
            extent = .{target.w, target.h},
        },
        layerCount = 1,
        colorAttachmentCount = 1,
        pColorAttachments = *color_attachment,
    };
    vkCmdBeginRendering(command_buffer, *rendering_info);

    vkCmdBindPipeline(command_buffer, .GRAPHICS, global_renderer.ui_pipeline.pipeline);
    current_pipeline = global_renderer.ui_pipeline;

    viewport := VkViewport.{0, xx target.h, xx target.w, -(cast(float)target.h), 0, 1};
    vkCmdSetViewport(command_buffer, 0, 1, *viewport);
    rect :=VkRect2D.{.{0, 0} , .{target.w, target.w}};
    vkCmdSetScissor(command_buffer, 0, 1, *rect);

    pc := UI_Push_Constants.{.{2.0 / cast(float)target.w, -2.0 / cast(float)target.h}, .{-1, 1}};
    vkCmdPushConstants(command_buffer, global_renderer.ui_pipeline.layout, .VERTEX_BIT, 0, size_of(type_of(pc)), *pc);
    vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, global_renderer.ui_pipeline.layout, 0, 1, *global_renderer.empty_texture_descriptor_set, 0, null);
}

// Variant to embed the immediate in a command buffer
immediate_begin_in_place :: (render_target: *Render_Texture, command_buffer: VkCommandBuffer) -> Immediate {
    self: Immediate;
    self.target = render_target;
    self.command_buffer = command_buffer;
    self.vertices.allocator = temp;

    immediate_begin_rendering(*self);
    return self;
}

immediate_end_in_place :: (using self: *Immediate) {
    flush(self);
    vkCmdEndRendering(command_buffer);
}

immediate_use_shader :: (using immediate: *Immediate, pipeline: Pipeline) {
    vkCmdBindPipeline(command_buffer, .GRAPHICS, pipeline.pipeline);
    pc := UI_Push_Constants.{.{2.0 / cast(float)target.w, -2.0 / cast(float)target.h}, .{-1, 1}};
    vkCmdPushConstants(command_buffer, pipeline.layout, .VERTEX_BIT, 0, size_of(type_of(pc)), *pc);
    vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.layout, 0, 1, *global_renderer.empty_texture_descriptor_set, 0, null);
    immediate.current_pipeline = pipeline;
}

immediate_default_texture :: (using immediate: *Immediate) {
    immediate_bind_texture(immediate, global_renderer.empty_texture_descriptor_set);
}

immediate_bind_texture :: (using immediate: *Immediate, descriptor_set: VkDescriptorSet) {
    flush(immediate);
    vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, current_pipeline.layout, 0, 1, *descriptor_set, 0, null);
}
