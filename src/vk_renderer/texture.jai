Texture :: struct {
    image: VkImage;
    memory: VkDeviceMemory;
    view: VkImageView;
    w : s32;
    h : s32;
}

load_texture_from_file :: (path: string) -> Texture {
    texture : Texture;

    channels: s32;
    img := stbi_load(temp_c_string(path), *texture.w, *texture.h, *channels, 4);
    assert(img != null, "Unable to load %.", path);
    defer stbi_image_free(img);
    format :: VkFormat.R8G8B8A8_SRGB;
    image_size: VkDeviceSize = xx(texture.w * texture.h * 4);

    staging_buffer := create_buffer(image_size, .TRANSFER_SRC_BIT, .UPLOAD);
    defer destroy_buffer(staging_buffer);
    copy_data(staging_buffer, img, image_size);

    create_info := VkImageCreateInfo.{
        imageType = ._2D,
        extent = .{xx texture.w, xx texture.h, 1},
        mipLevels = 1,
        arrayLayers = 1,
        format = format,
        tiling = .OPTIMAL,
        initialLayout = .UNDEFINED,
        usage = VkImageUsageFlags.TRANSFER_DST_BIT | .SAMPLED_BIT,
        sharingMode = .EXCLUSIVE,
        samples = ._1_BIT
    }; 
    Vk_Check(vkCreateImage(global_renderer.device, *create_info, null, *texture.image));
    texture.memory = alloc_device_memory(texture.image, .LOCAL);

    transition_image_layout(texture.image, format, .UNDEFINED, .TRANSFER_DST_OPTIMAL);
    copy_buffer_to_image(staging_buffer.buffer, texture.image, xx texture.w, xx texture.h);
    transition_image_layout(texture.image, format, .TRANSFER_DST_OPTIMAL, .SHADER_READ_ONLY_OPTIMAL);

    texture.view = make_image_view(texture.image, format);

    return texture;
}

destroy_texture :: (texture: *Texture) {
    vkDestroyImageView(global_renderer.device, texture.view, null);
    vkDestroyImage(global_renderer.device, texture.image, null);
    texture.image = null;
    vkFreeMemory(global_renderer.device, texture.memory, null);
    texture.memory = null;
}

transition_image_layout :: (image: VkImage, format: VkFormat, $old_layout: VkImageLayout, $new_layout: VkImageLayout) {
    cmd := single_time_command_buffer();
    src_access: VkAccessFlagBits;
    dst_access: VkAccessFlagBits;
    src_stage: VkPipelineStageFlagBits;
    dst_stage: VkPipelineStageFlagBits;

    #if old_layout == .UNDEFINED && new_layout == .TRANSFER_DST_OPTIMAL {
        src_access = 0;
        dst_access = .TRANSFER_WRITE_BIT;
        src_stage = .TOP_OF_PIPE_BIT;
        dst_stage = .TRANSFER_BIT;
    } else #if old_layout == .TRANSFER_DST_OPTIMAL && new_layout == .SHADER_READ_ONLY_OPTIMAL {
        src_access = .TRANSFER_WRITE_BIT;
        dst_access = .SHADER_READ_BIT;
        src_stage = .TRANSFER_BIT;
        dst_stage = .FRAGMENT_SHADER_BIT;
    } else {
        #assert false, "Unsupported image layout transition.";
    }

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

    vkCmdPipelineBarrier(
        cmd,
        src_stage, dst_stage,
        0,
        0, null,
        0, null,
        1, *barrier);
}

copy_buffer_to_image :: (buffer: VkBuffer, image: VkImage, w: u32, h: u32) {
    cmd := single_time_command_buffer();
    region := VkBufferImageCopy.{
        imageSubresource = .{
            aspectMask = .COLOR_BIT,
            layerCount = 1,
        },
        imageExtent = .{w, h, 1},
    };
    vkCmdCopyBufferToImage(cmd, buffer, image, .TRANSFER_DST_OPTIMAL, 1, *region);
}

make_image_view :: (image: VkImage, format: VkFormat) -> VkImageView {
    img_view : VkImageView;
    image_view_ci := VkImageViewCreateInfo.{
        image = image,
        viewType = ._2D,
        format = format,
        subresourceRange = .{
            aspectMask = .COLOR_BIT, 
            baseMipLevel = 0,
            levelCount = 1,
            baseArrayLayer = 0,
            layerCount = 1
        },
    };
    Vk_Check(vkCreateImageView(global_renderer.device, *image_view_ci, null, *img_view));
    return img_view;
}