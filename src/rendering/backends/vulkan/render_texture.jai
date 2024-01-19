
Render_Texture :: struct {
    using #as texture: Texture;
    render_finished_semaphore: VkSemaphore;
}

render_texture_create :: (w: u32, h: u32, format: VkFormat, usage: VkImageUsageFlags = .COLOR_ATTACHMENT_BIT | .SAMPLED_BIT, aspect : VkImageAspectFlags = .COLOR_BIT, name : string) -> Render_Texture {
    self: Render_Texture = ---;
    self.texture = texture_create(w, h, format, usage, aspect, name = name); 
    self.render_finished_semaphore = create_semaphore(global_renderer.device);
    return self;
}

destroy :: (self: *Render_Texture) {
    destroy(*self.texture);
    vkDestroySemaphore(global_renderer.device, self.render_finished_semaphore, null);
}