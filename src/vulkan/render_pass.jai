Render_Pass_Builder :: struct {

    attachments : [..] VkAttachmentDescription;
    dependencies : [..] VkSubpassDependency;
    subpasses : [..] VkSubpassDescription;

    add_attachments :: (self: *Render_Pass_Builder, attachments: ..VkAttachmentDescription) {
        self.attachments.allocator = temp;
        array_add(*self.attachments, ..attachment);
    }

    add_dependencies :: (self: *Render_Pass_Builder, dependencies: .. VkSubpassDependency) {
        self.dependencies.allocator = temp;
        array_add(*self.dependencies, ..dependencies);
    }

    add_subpass :: (self: *Render_Pass_Builder, color_attachment: *VkAttachmentReference = null, depth_attachment: *VkAttachmentReference = null) {
        
    }

    build :: (using self: *Render_Pass_Builder) -> VkRenderPass {
        create_info := VkRenderPassCreateInfo.{
            attachmentCount = attachments.count,
            pAttachments = attachments.data,
            subpassCount = 1,
            pSubpasses = *VkSubpassDescription.{
                pipelineBindPoint = .GRAPHICS,
                colorAttachmentCount = 0,
                pDepthStencilAttachment = *VkAttachmentReference.{
                    attachment = 0,
                    layout = .DEPTH_STENCIL_ATTACHMENT_OPTIMAL
                },
            },
            dependencyCount = dependencies.count,
            pDependencies = dependencies.data
        };
        render_pass: VkRenderPass = ---;
        Vk_Check(vkCreateRenderPass(device, *create_info, null, *render_pass));
        return render_pass;
    }
}