Texture :: struct {
    image: VkImage;
    memory: VmaAllocation;
    view: VkImageView;
    w : u32;
    h : u32;
    aspect: VkImageAspectFlags;
}

texture_create :: (w: u32, h: u32, format: VkFormat, usage: VkImageUsageFlags, aspect: VkImageAspectFlags = .COLOR_BIT, name: string) -> Texture {
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

    alloc_ci := VmaAllocationCreateInfo.{
        usage = .AUTO,
    };

    Vk_Check(vmaCreateImage(global_renderer.allocator, *create_info, *alloc_ci, *texture.image, *texture.memory, null));
    texture.view = make_image_view(texture.image, format, aspect);
    debug_name_object(texture.view, name);
    debug_name_object(texture.image, name);
    texture.aspect = aspect;
    return texture;
}

texture_from_file :: (path: string, final_layout: VkImageLayout = .SHADER_READ_ONLY_OPTIMAL) -> Texture {
    channels: s32;
    w: s32;
    h: s32;
    img := stbi_load(temp_c_string(path), *w, *h, *channels, 4);
    assert(img != null, "Unable to load %.", path);
    defer stbi_image_free(img);
    return texture_from_data(img, xx w, xx h, channels, u8, path_filename(path), final_layout);
}

texture_from_data :: (ptr: *void, w: u32, h: u32, src_channels: int, $data_type: Type, name: string, final_layout: VkImageLayout = .SHADER_READ_ONLY_OPTIMAL) -> Texture {
    format : VkFormat = ---;
    dst_channels: int;
    #if data_type == u8 {
        if src_channels == {
            case 1; {
                format = .R8_UNORM;
                dst_channels = 1;
            }
            case 3; #through;
            case 4; {
                dst_channels = 4;
                format = .R8G8B8A8_SRGB;
            }
            case; assert(false, "Unhandled channel count of %!", src_channels);
        }
    } else #assert false;

    texture := texture_create(w, h, format, .TRANSFER_DST_BIT | .SAMPLED_BIT, name = name);

    image_size: VkDeviceSize = xx(texture.w * texture.h * dst_channels);
    staging_buffer := buffer_create(image_size, .TRANSFER_SRC_BIT,  "texture_from_data::staging_buffer");
    defer destroy(*staging_buffer);
    buffer_write_data(staging_buffer, ptr, image_size);

    cmd := begin_single_time_command_buffer();
    defer end_single_time_command_buffer(cmd);
    transition_texture_layout(*texture, .UNDEFINED, .TRANSFER_DST_OPTIMAL, cmd);
    copy_buffer_to_image(staging_buffer.handle, texture.image, xx texture.w, xx texture.h, cmd);
    transition_texture_layout(*texture, .TRANSFER_DST_OPTIMAL, final_layout, cmd);

    return texture;
}


destroy :: (texture: *Texture) {
    vkDestroyImageView(global_renderer.device, texture.view, null);
    vmaDestroyImage(global_renderer.allocator, texture.image, texture.memory);
    texture.view = null;
    texture.image = null;
    texture.memory = null;
}

pipeline_barrier :: (image: VkImage, command_buffer: VkCommandBuffer,
    old_layout: VkImageLayout, src_stage: VkPipelineStageFlagBits, src_access: VkAccessFlagBits,
    new_layout: VkImageLayout, dst_stage: VkPipelineStageFlagBits, dst_access: VkAccessFlagBits, aspect_mask : VkImageAspectFlags = .COLOR_BIT) {

    barrier := VkImageMemoryBarrier.{
        oldLayout = old_layout,
        newLayout = new_layout,
        srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED,
        dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED,
        image = image,
        subresourceRange = .{
            aspectMask = aspect_mask,
            baseMipLevel = 0,
            levelCount = 1,
            baseArrayLayer = 0,
            layerCount = 1,
        },
        srcAccessMask = src_access,
        dstAccessMask = dst_access,
    };

    vkCmdPipelineBarrier(
        command_buffer,
        src_stage, dst_stage,
        0,
        0, null,
        0, null,
        1, *barrier);

}

transition_texture_layout :: (texture: *Texture, old_layout: VkImageLayout, new_layout: VkImageLayout, cmd: VkCommandBuffer = VK_NULL_HANDLE) {
    assert(old_layout != new_layout, "Trying to transition to the same state!");
    src_stage, src_access := get_src_stage_and_access_from_layout(old_layout);
    dst_stage, dst_access := get_dst_stage_and_access_from_layout(new_layout);

    command_buffer := ifx cmd == VK_NULL_HANDLE then begin_single_time_command_buffer() else cmd;
    pipeline_barrier(texture.image, command_buffer, old_layout, src_stage, src_access, new_layout, dst_stage, dst_access, texture.aspect);

    if cmd == VK_NULL_HANDLE {
        end_single_time_command_buffer(command_buffer);
    }
}

// transition_texture_layout :: (texture: *Texture, new_layout: VkImageLayout, cmd: VkCommandBuffer = VK_NULL_HANDLE) {

//     assert(texture.current_layout != new_layout, "Trying to transition to the same state!");
//     transition_texture_layout(texture, texture.current_layout, new_layout, cmd);
// }

get_src_stage_and_access_from_layout :: (layout: VkImageLayout) -> (VkPipelineStageFlags, VkAccessFlagBits) {
    if layout == {
        case .UNDEFINED;      #through;
        case .PREINITIALIZED;
            return .TOP_OF_PIPE_BIT, 0;
        case .TRANSFER_DST_OPTIMAL;
            return .TRANSFER_BIT, .TRANSFER_WRITE_BIT;
        case .COLOR_ATTACHMENT_OPTIMAL;
            return .COLOR_ATTACHMENT_OUTPUT_BIT, .COLOR_ATTACHMENT_WRITE_BIT;
        case .DEPTH_STENCIL_ATTACHMENT_OPTIMAL;
            return .LATE_FRAGMENT_TESTS_BIT, .DEPTH_STENCIL_ATTACHMENT_WRITE_BIT;
        case .SHADER_READ_ONLY_OPTIMAL;
            return .FRAGMENT_SHADER_BIT, .SHADER_READ_BIT;
        case .DEPTH_ATTACHMENT_OPTIMAL;
            return .LATE_FRAGMENT_TESTS_BIT, .DEPTH_STENCIL_ATTACHMENT_WRITE_BIT;
        case; 
            assert(false, "Unhandled source layout: %", layout);
            return 0, 0;
    }
}

get_dst_stage_and_access_from_layout :: (layout: VkImageLayout) -> (VkPipelineStageFlags, VkAccessFlagBits) {
    if layout == {
        case .TRANSFER_DST_OPTIMAL; 
            return .TRANSFER_BIT, .TRANSFER_WRITE_BIT;
        case .SHADER_READ_ONLY_OPTIMAL;
            return .FRAGMENT_SHADER_BIT, .SHADER_READ_BIT;
        case .PRESENT_SRC_KHR; 
            return .BOTTOM_OF_PIPE_BIT, 0;
        case .COLOR_ATTACHMENT_OPTIMAL;
            return .COLOR_ATTACHMENT_OUTPUT_BIT, .COLOR_ATTACHMENT_WRITE_BIT;
        case .DEPTH_STENCIL_ATTACHMENT_OPTIMAL; 
            return .EARLY_FRAGMENT_TESTS_BIT, .DEPTH_STENCIL_ATTACHMENT_WRITE_BIT;
        case .DEPTH_ATTACHMENT_OPTIMAL;
            return .EARLY_FRAGMENT_TESTS_BIT, .DEPTH_STENCIL_ATTACHMENT_WRITE_BIT;
        case; 
            assert(false, "Unhanded destination layout: %", layout);
            return 0, 0;
    }
}

copy_buffer_to_image :: (buffer: VkBuffer, image: VkImage, w: u32, h: u32, cmd: VkCommandBuffer) {
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

