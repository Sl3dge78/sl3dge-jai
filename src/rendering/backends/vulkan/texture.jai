Texture :: struct {
    image: VkImage;
    memory: VkDeviceMemory;
    view: VkImageView;
    w : u32;
    h : u32;
    current_layout: VkImageLayout = VK_IMAGE_LAYOUT_UNDEFINED;
    aspect: VkImageAspectFlags;
}

texture_create :: (w: u32, h: u32, format: VkFormat, $usage: VkImageUsageFlags, aspect: VkImageAspectFlags = VK_IMAGE_ASPECT_COLOR_BIT, name: string) -> Texture {
    texture: Texture;
    texture.w = w;
    texture.h = h;

    create_info := VkImageCreateInfo.{
        imageType = VK_IMAGE_TYPE_2D,
        extent = .{xx texture.w, xx texture.h, 1},
        mipLevels = 1,
        arrayLayers = 1,
        format = format,
        tiling = VK_IMAGE_TILING_OPTIMAL,
        initialLayout = VK_IMAGE_LAYOUT_UNDEFINED,
        usage = usage,
        sharingMode = VK_SHARING_MODE_EXCLUSIVE,
        samples = VK_SAMPLE_COUNT_1_BIT
    }; 
    Vk_Check(vkCreateImage(global_renderer.device, *create_info, null, *texture.image));
    texture.memory = alloc_device_memory(texture.image, .LOCAL);
    texture.view = make_image_view(texture.image, format, aspect);
    debug_name_object(texture.view, name);
    debug_name_object(texture.image, name);
    texture.aspect = aspect;
    return texture;
}

texture_from_file :: (path: string) -> Texture {
    channels: s32;
    w: s32;
    h: s32;
    img := stbi_load(temp_c_string(path), *w, *h, *channels, 4);
    assert(img != null, "Unable to load %.", path);
    defer stbi_image_free(img);
    return texture_from_data(img, xx w, xx h, channels, u8, path_filename(path));
}

texture_from_data :: (ptr: *void, w: u32, h: u32, channels: int, $data_type: Type, name: string) -> Texture {
    format : VkFormat = ---;
    #if data_type == u8 {
        if channels == {
            case 1; format = VK_FORMAT_R8_UNORM;
            case 4; format = VK_FORMAT_R8G8B8A8_SRGB;
            case; assert(false, "Unhandled channel count of %!", channels);
        }
    } else #assert false;

    texture := texture_create(w, h, format, VK_IMAGE_USAGE_TRANSFER_DST_BIT | VK_IMAGE_USAGE_SAMPLED_BIT, name = name);

    image_size: VkDeviceSize = xx(texture.w * texture.h * channels);
    staging_buffer := buffer_create(image_size, VK_BUFFER_USAGE_TRANSFER_SRC_BIT, .UPLOAD, "texture_from_data::staging_buffer");
    defer destroy(*staging_buffer);
    buffer_write_data(staging_buffer, ptr, image_size);

    transition_texture_layout(*texture, VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL);
    copy_buffer_to_image(staging_buffer.handle, texture.image, xx texture.w, xx texture.h);

    return texture;
}

render_texture_create :: (w: u32, h: u32, name: string) -> Texture {
    return texture_create(w, h, global_renderer.swapchain.format.format, VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT | VK_IMAGE_USAGE_SAMPLED_BIT, name = name);
}

destroy :: (texture: *Texture) {
    vkDestroyImageView(global_renderer.device, texture.view, null);
    texture.view = null;
    vkDestroyImage(global_renderer.device, texture.image, null);
    texture.image = null;
    vkFreeMemory(global_renderer.device, texture.memory, null);
    texture.memory = null;
}

pipeline_barrier :: (image: VkImage, command_buffer: VkCommandBuffer,
    old_layout: VkImageLayout, src_stage: VkPipelineStageFlagBits, src_access: VkAccessFlagBits,
    new_layout: VkImageLayout, dst_stage: VkPipelineStageFlagBits, dst_access: VkAccessFlagBits, aspect_mask := VK_IMAGE_ASPECT_COLOR_BIT) {

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

transition_texture_layout :: (texture: *Texture, new_layout: VkImageLayout, cmd: VkCommandBuffer = VK_NULL_HANDLE) {
    assert(texture.current_layout != new_layout, "Trying to transition to the same state!");

    src_stage, src_access := get_src_stage_and_access_from_layout(texture.current_layout);
    dst_stage, dst_access := get_dst_stage_and_access_from_layout(new_layout);

    command_buffer := ifx cmd == VK_NULL_HANDLE then begin_single_time_command_buffer() else cmd;
    pipeline_barrier(texture.image, command_buffer, texture.current_layout, src_stage, src_access, new_layout, dst_stage, dst_access, texture.aspect);

    if cmd == VK_NULL_HANDLE {
        end_single_time_command_buffer(command_buffer);
    }
    texture.current_layout = new_layout;
}

get_src_stage_and_access_from_layout :: (layout: VkImageLayout) -> (VkPipelineStageFlags, VkAccessFlagBits) {
    if layout == {
        case VK_IMAGE_LAYOUT_UNDEFINED;            
            return VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT, 0;
        case VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
            return VK_PIPELINE_STAGE_TRANSFER_BIT, VK_ACCESS_TRANSFER_WRITE_BIT;
        case VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
            return VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT, VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;
        case VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;
            return VK_PIPELINE_STAGE_LATE_FRAGMENT_TESTS_BIT, VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT;
        case VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;
            return VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT, VK_ACCESS_UNIFORM_READ_BIT;
        case VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_OPTIMAL;
            return VK_PIPELINE_STAGE_LATE_FRAGMENT_TESTS_BIT, VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT;
        case; 
            assert(false, "Unhandled source layout: %", layout);
            return 0, 0;
    }
}

get_dst_stage_and_access_from_layout :: (layout: VkImageLayout) -> (VkPipelineStageFlags, VkAccessFlagBits) {
    if layout == {
        case VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL; 
            return VK_PIPELINE_STAGE_TRANSFER_BIT, VK_ACCESS_TRANSFER_WRITE_BIT;
        case VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;
            return VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT, VK_ACCESS_SHADER_READ_BIT;
        case VK_IMAGE_LAYOUT_PRESENT_SRC_KHR; 
            return VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT, 0;
        case VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
            return VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT, VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;
        case VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL; 
            return VK_PIPELINE_STAGE_EARLY_FRAGMENT_TESTS_BIT, VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT;
        case VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_OPTIMAL;
            return VK_PIPELINE_STAGE_EARLY_FRAGMENT_TESTS_BIT, VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT;
        case; 
            assert(false, "Unhanded destination layout: %", layout);
            return 0, 0;
    }
}

copy_buffer_to_image :: (buffer: VkBuffer, image: VkImage, w: u32, h: u32) {
    cmd := begin_single_time_command_buffer();
    defer end_single_time_command_buffer(cmd);
    region := VkBufferImageCopy.{
        imageSubresource = .{
            aspectMask = VK_IMAGE_ASPECT_COLOR_BIT,
            layerCount = 1,
        },
        imageExtent = .{w, h, 1},
    };
    vkCmdCopyBufferToImage(cmd, buffer, image, VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, 1, *region);
}

make_image_view :: (image: VkImage, format: VkFormat, aspect_mask : VkImageAspectFlags = VK_IMAGE_ASPECT_COLOR_BIT) -> VkImageView {
    img_view : VkImageView;
    image_view_ci := VkImageViewCreateInfo.{
        image = image,
        viewType = VK_IMAGE_VIEW_TYPE_2D,
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
