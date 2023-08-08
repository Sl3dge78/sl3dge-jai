Texture :: struct {
    image: VkImage;
    memory: VkDeviceMemory;
    view: VkImageView;
    w : u32;
    h : u32;
}

create_texture :: (w: u32, h: u32, format: VkFormat, $usage: VkImageUsageFlags, aspect: VkImageAspectFlags = .COLOR_BIT) -> Texture {
    texture: Texture;
    texture.w = w;
    texture.h = h;

    create_info := VkImageCreateInfo.{
        imageType = ._2D,
        extent = .{xx texture.w, xx texture.h, 1},
        mipLevels = 1,
        arrayLayers = 1,
        format = format,
        tiling = .OPTIMAL,
        initialLayout = .UNDEFINED,
        usage = usage,
        sharingMode = .EXCLUSIVE,
        samples = ._1_BIT
    }; 
    Vk_Check(vkCreateImage(global_renderer.device, *create_info, null, *texture.image));
    texture.memory = alloc_device_memory(texture.image, .LOCAL);
    texture.view = make_image_view(texture.image, format, aspect);
    return texture;
}



create_texture_from_data :: (ptr: *void, w: u32, h: u32, channels: int, $data_type: Type) -> Texture {
    format : VkFormat = ---;
    #if data_type == u8 {
        if channels == {
            case 1; format = .R8_UNORM;
            case 4; format = .R8G8B8A8_SRGB;
            case; assert(false, "Unhandled channel count of %!", channels);
        }
    } else #assert false;

    texture := create_texture(w, h, format, .TRANSFER_DST_BIT | .SAMPLED_BIT);

    image_size: VkDeviceSize = xx(texture.w * texture.h * channels);
    staging_buffer := create_buffer(image_size, .TRANSFER_SRC_BIT, .UPLOAD);
    defer destroy_buffer(*staging_buffer);
    copy_data(staging_buffer, ptr, image_size);

    transition_image_layout(texture.image, .UNDEFINED, .TRANSFER_DST_OPTIMAL);
    copy_buffer_to_image(staging_buffer.buffer, texture.image, xx texture.w, xx texture.h);
    transition_image_layout(texture.image, .TRANSFER_DST_OPTIMAL, .SHADER_READ_ONLY_OPTIMAL);

    return texture;
}

destroy_texture :: (texture: *Texture) {
    vkDestroyImageView(global_renderer.device, texture.view, null);
    vkDestroyImage(global_renderer.device, texture.image, null);
    texture.image = null;
    vkFreeMemory(global_renderer.device, texture.memory, null);
    texture.memory = null;
}

transition_image_layout :: (image: VkImage, $old_layout: VkImageLayout, $new_layout: VkImageLayout, cmd: VkCommandBuffer = VK_NULL_HANDLE) {
    src_access: VkAccessFlagBits;
    dst_access: VkAccessFlagBits;
    src_stage: VkPipelineStageFlagBits;
    dst_stage: VkPipelineStageFlagBits;
    barrier := VkImageMemoryBarrier.{
        oldLayout = old_layout,
        newLayout = new_layout,
        srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED,
        dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED,
        image = image,
        subresourceRange = .{
            aspectMask = .COLOR_BIT,
            baseMipLevel = 0,
            levelCount = 1,
            baseArrayLayer = 0,
            layerCount = 1,
        },
        srcAccessMask = src_access,
        dstAccessMask = dst_access,
    };

    #if old_layout == .UNDEFINED {
        src_access = 0;
        src_stage = .TOP_OF_PIPE_BIT;
    } else #if old_layout == .TRANSFER_DST_OPTIMAL {
        src_access = .TRANSFER_WRITE_BIT;
        src_stage = .TRANSFER_BIT;
    } else #if old_layout == .COLOR_ATTACHMENT_OPTIMAL { 
        src_access = .COLOR_ATTACHMENT_WRITE_BIT;
        src_stage = .COLOR_ATTACHMENT_OUTPUT_BIT;
    } else {
        #assert false, "Unsupported image layout transition.";
    }

    #if new_layout == .TRANSFER_DST_OPTIMAL {
        dst_access = .TRANSFER_WRITE_BIT;
        dst_stage = .TRANSFER_BIT;
    } else #if new_layout == .SHADER_READ_ONLY_OPTIMAL {
        dst_access = .SHADER_READ_BIT;
        dst_stage = .FRAGMENT_SHADER_BIT;
    } else #if new_layout == .PRESENT_SRC_KHR {
        dst_stage = .BOTTOM_OF_PIPE_BIT;
    } else #if new_layout == .COLOR_ATTACHMENT_OPTIMAL {
        dst_access = .COLOR_ATTACHMENT_WRITE_BIT;
        dst_stage = .COLOR_ATTACHMENT_OUTPUT_BIT;
    } else #if new_layout == .DEPTH_STENCIL_ATTACHMENT_OPTIMAL {
        dst_access = .DEPTH_STENCIL_ATTACHMENT_WRITE_BIT | .DEPTH_STENCIL_ATTACHMENT_READ_BIT;
        dst_stage  = .EARLY_FRAGMENT_TESTS_BIT;
        barrier.subresourceRange.aspectMask = .DEPTH_BIT | .STENCIL_BIT;
    } else {
        #assert false, "Unsupported image layout transition.";
    }

    command_buffer := ifx cmd == VK_NULL_HANDLE then begin_single_time_command_buffer() else cmd;
    vkCmdPipelineBarrier(
        command_buffer,
        src_stage, dst_stage,
        0,
        0, null,
        0, null,
        1, *barrier);

    if cmd == VK_NULL_HANDLE {
        end_single_time_command_buffer(command_buffer);
    }
}

copy_buffer_to_image :: (buffer: VkBuffer, image: VkImage, w: u32, h: u32) {
    cmd := begin_single_time_command_buffer();
    defer end_single_time_command_buffer(cmd);
    region := VkBufferImageCopy.{
        imageSubresource = .{
            aspectMask = .COLOR_BIT,
            layerCount = 1,
        },
        imageExtent = .{w, h, 1},
    };
    vkCmdCopyBufferToImage(cmd, buffer, image, .TRANSFER_DST_OPTIMAL, 1, *region);
}

make_image_view :: (image: VkImage, format: VkFormat, aspect_mask : VkImageAspectFlags = .COLOR_BIT) -> VkImageView {
    img_view : VkImageView;
    image_view_ci := VkImageViewCreateInfo.{
        image = image,
        viewType = ._2D,
        format = format,
        subresourceRange = .{
            aspectMask = aspect_mask, 
            baseMipLevel = 0,
            levelCount = 1,
            baseArrayLayer = 0,
            layerCount = 1
        },
    };
    Vk_Check(vkCreateImageView(global_renderer.device, *image_view_ci, null, *img_view));
    return img_view;
}
