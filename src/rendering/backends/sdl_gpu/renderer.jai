
Renderer :: struct {
    device: *SDL_GPUDevice;

    swapchain_format : SDL_GPUTextureFormat;
    depth_stencil_format: SDL_GPUTextureFormat;
    depth_stencil_texture: *SDL_GPUTexture;
    depth_stencil_target: SDL_GPUDepthStencilTargetInfo;
    projection: Matrix4;

    ui_pipeline: *SDL_GPUGraphicsPipeline;
    static_mesh_material: Material;

    sampler : *SDL_GPUSampler;
    empty_texture: *SDL_GPUTexture;

    immediate_buffer_pool: Buffer_Pool = .{ kind = .VERTEX };
    vertex_buffer_pool:    Buffer_Pool = .{ kind = .VERTEX | .INDEX };

}

global_renderer : Renderer;

renderer_create :: (window: *SDL_Window) -> *Renderer {
    using renderer := *global_renderer;

    shader_formats := SDL_GPU_SHADERFORMAT_SPIRV;
    assert(SDL_GPUSupportsShaderFormats(xx shader_formats, null), "Shader aren't supported on this device!");
    device = SDL_NullCheck(SDL_CreateGPUDevice(xx shader_formats, true, null));
    SDL_Check(SDL_ClaimWindowForGPUDevice(device, window));

    present_mode : SDL_GPUPresentMode = .VSYNC;
    if SDL_WindowSupportsGPUPresentMode(device, window, .MAILBOX) {
        present_mode = .MAILBOX;
    }
    SDL_Log("Swapchain Present mode: %", present_mode);
    composition : SDL_GPUSwapchainComposition = .SDR;
    if SDL_WindowSupportsGPUSwapchainComposition(device, window, .HDR10_ST2048) {
        composition = .HDR10_ST2048;
    } else if SDL_WindowSupportsGPUSwapchainComposition(device, window, .HDR_EXTENDED_LINEAR) {
        composition = .HDR_EXTENDED_LINEAR;
    } else if SDL_WindowSupportsGPUSwapchainComposition(device, window, .SDR_LINEAR) {
        composition = .SDR_LINEAR;
    }
    SDL_Log("Swapchain Composition: %", composition);
    SDL_Check(SDL_SetGPUSwapchainParameters(device, window, composition, present_mode));

    depth_stencil_format = get_depth_stencil_format(device);

    w: s32 = ---;
    h: s32 = ---;
    SDL_GetWindowSizeInPixels(window, *w, *h);

    {   // Depth stencil target
        // @TODO recreate on window resize
        ci := SDL_GPUTextureCreateInfo.{
            type = ._2D,
            format = depth_stencil_format,
            usage = .DEPTH_STENCIL_TARGET,
            width = xx w,
            height = xx h,
            layer_count_or_depth = 1,
            num_levels = 1,
            sample_count = ._1,
        };
        depth_stencil_texture = SDL_CreateGPUTexture(device, *ci);
        depth_stencil_target = .{
            texture = depth_stencil_texture,
            clear_depth = 0,
            load_op = .CLEAR,
            store_op = .DONT_CARE,
            stencil_load_op = .DONT_CARE,
            stencil_store_op = .DONT_CARE,
            cycle = true,
            clear_stencil = 0,
        };

    }

    swapchain_format = SDL_GetGPUSwapchainTextureFormat(device, window);

    {   // UI Pipeline
        builder: Pipeline_Builder;
        add_shader(*builder, device, "shaders/ui.vert.spv");
        add_shader(*builder, device, "shaders/ui.frag.spv");
        add_vertex_type(*builder, UI_Vertex);
        add_color_target(*builder, swapchain_format);
        ui_pipeline = build_pipeline(*builder, device);
    }

    static_mesh_material = create_material("shaders/static.vert.spv", "shaders/color.frag.spv");

    sampler_ci := SDL_GPUSamplerCreateInfo.{
        min_filter = .LINEAR,
        mag_filter = .LINEAR,
        mipmap_mode = .LINEAR,
        address_mode_u = .REPEAT,
        address_mode_v = .REPEAT,
        address_mode_w = .REPEAT,
        mip_lod_bias = 0,
        // max_anisotropy = 16,
        compare_op = .ALWAYS,
        min_lod = 0,
        max_lod = 0,
        enable_anisotropy = false,
        enable_compare = false,
    };
    sampler = SDL_NullCheck(SDL_CreateGPUSampler(device, *sampler_ci));

    data := u8.[255, 255, 255, 255];
    empty_texture = texture_from_data(data.data, 1, 1, 4, u8, "empty_texture");

    projection = make_projection_matrix(radians(45), cast(float)w/cast(float)h, 0.1, 1000);

    return renderer;
}

destroy :: (using self: *Renderer) {
    destroy(empty_texture);
    buffer_pool_reset(*immediate_buffer_pool);
    buffer_pool_reset(*vertex_buffer_pool);
    SDL_ReleaseGPUSampler(device, sampler);
    destroy(static_mesh_material);
    SDL_ReleaseGPUGraphicsPipeline(device, ui_pipeline);
    destroy(depth_stencil_texture);
    SDL_DestroyGPUDevice(device);
}

Texture :: *SDL_GPUTexture;  

texture_from_data :: (buffer: *u8, w: u32, h: u32, channels: u32, $type: Type, name: string) -> Texture {
    size := w * h * channels * size_of(type);
    tbuf_ci := SDL_GPUTransferBufferCreateInfo.{
        usage = .UPLOAD,
        size = size,
        props = 0,
    };
    tbuf := SDL_CreateGPUTransferBuffer(global_renderer.device, *tbuf_ci);
    defer SDL_ReleaseGPUTransferBuffer(global_renderer.device, tbuf);

    format : SDL_GPUTextureFormat;
    if channels == {
        case 1; format = .R8_UNORM;
        case 4; format = .R8G8B8A8_UNORM_SRGB;
        case; assert(false, "Unhandled channel count of %.", channels);
    }

    texture_ci := SDL_GPUTextureCreateInfo.{
        type = ._2D,
        format = format,
        usage = .SAMPLER,
        width = w,
        height = h,
        layer_count_or_depth = 1,
        num_levels = 1,
        sample_count = ._1,

        props = 0,
    };
    texture := SDL_CreateGPUTexture(global_renderer.device, *texture_ci);

    data := SDL_MapGPUTransferBuffer(global_renderer.device, tbuf, false);
    SDL_memcpy(data, buffer, size);
    SDL_UnmapGPUTransferBuffer(global_renderer.device, tbuf);

    cmd := SDL_AcquireGPUCommandBuffer(global_renderer.device);
    defer SDL_SubmitGPUCommandBuffer(cmd);

    copy_pass := SDL_BeginGPUCopyPass(cmd);
    defer SDL_EndGPUCopyPass(copy_pass);
    src := SDL_GPUTextureTransferInfo.{ tbuf, 0, w, h };

    dst := SDL_GPUTextureRegion.{
        texture,
        0, 0,
        0, 0, 0,
        w, h, 1,
    };
    SDL_UploadToGPUTexture(copy_pass, *src, *dst, false);
    SDL_SetGPUTextureName(global_renderer.device, texture, name.data);
    return texture;
}

destroy :: (self: Texture) {
    assert(self != null);
    SDL_ReleaseGPUTexture(global_renderer.device, self);
}

Frame_Data :: struct {
    cmd: *SDL_GPUCommandBuffer;
    target: *SDL_GPUTexture;
    width: u32;
    height: u32;
}

begin_frame :: () -> bool, Frame_Data {
    fd : Frame_Data;
    fd.cmd = SDL_NullCheck(SDL_AcquireGPUCommandBuffer(global_renderer.device));
    SDL_Check(SDL_AcquireGPUSwapchainTexture(fd.cmd, global_engine.window, *fd.target, *fd.width, *fd.height));
    if fd.target == null {
        SDL_Check(SDL_CancelGPUCommandBuffer(fd.cmd));
        return false, .{};
    }
    return true, fd;
}

end_frame :: (frame_data: Frame_Data) {
    SDL_Check(SDL_SubmitGPUCommandBuffer(frame_data.cmd));
}

Buffer :: struct {
    #as handle: *SDL_GPUBuffer;
    size: u32;
}

buffer_create :: (size: u32, flags: SDL_GPUBufferUsageFlags) -> Buffer {
    ci := SDL_GPUBufferCreateInfo.{
        usage = flags,
        size = xx size,
        props = 0,
    };
    return .{
        SDL_NullCheck(SDL_CreateGPUBuffer(global_renderer.device, *ci)),
        size,
    };
}

destroy :: (buf: Buffer) {
    SDL_ReleaseGPUBuffer(global_renderer.device, buf.handle);
}

create_color_target :: (texture: *SDL_GPUTexture, load_op : SDL_GPULoadOp = .LOAD, clear_color : SDL_FColor = .{0,0,0,1}, store_op : SDL_GPUStoreOp = .STORE) -> SDL_GPUColorTargetInfo {
    return SDL_GPUColorTargetInfo.{
        texture = texture,
        mip_level = 0,
        layer_or_depth_plane = 0,
        clear_color = clear_color,
        load_op = load_op,
        store_op = store_op,
        // resolve_texture = null,
        // resolve_mip_level = 1,
        // resolve_layer = 1,
        cycle = false,
        // cycle_resolve_texture = false,
    };

}

get_depth_stencil_format :: (device: *SDL_GPUDevice) -> SDL_GPUTextureFormat {
    if(SDL_GPUTextureSupportsFormat(device, .D24_UNORM_S8_UINT, ._2D, .DEPTH_STENCIL_TARGET)) {
        return .D24_UNORM_S8_UINT;
    } else if(SDL_GPUTextureSupportsFormat(device, .D32_FLOAT_S8_UINT, ._2D, .DEPTH_STENCIL_TARGET)) {
        return .D32_FLOAT_S8_UINT;
    } else {
        SDL_LogError(0, "Unsupported depth formats!");
        return .INVALID;
    }
}

Pipeline_Kind :: enum {
    SHADOWMAP :: 0;
    COLOR :: 1;
}

Material :: struct {
    shadowmap: *SDL_GPUGraphicsPipeline;
    color: *SDL_GPUGraphicsPipeline;
    #place shadowmap; pipelines: [2]*SDL_GPUGraphicsPipeline;
}

create_material :: (vertex_shader_path: string, fragment_shader_path: string, $vertex_type := Standard_Vertex) -> Material {
    result : Material = ---;
    {   // Shadowmap   
        builder: Pipeline_Builder;
        add_shader(*builder, global_renderer.device, vertex_shader_path);
        add_shader(*builder, global_renderer.device, "shaders/noop.frag.spv");
        add_vertex_type(*builder, vertex_type);
        set_depth_bias(*builder, 1.25, 0, 1.75);
        add_depth_stencil_target(*builder, global_renderer.depth_stencil_format);
        result.pipelines[Pipeline_Kind.SHADOWMAP] = build_pipeline(*builder, global_renderer.device);
    }

    {   // Color   
        builder: Pipeline_Builder;
        add_shader(*builder, global_renderer.device, vertex_shader_path);
        add_shader(*builder, global_renderer.device, fragment_shader_path);
        add_vertex_type(*builder, vertex_type);
        add_color_target(*builder, global_renderer.swapchain_format, false);
        add_depth_stencil_target(*builder, global_renderer.depth_stencil_format);
        result.pipelines[Pipeline_Kind.COLOR] = build_pipeline(*builder, global_renderer.device);
    }

    return result;

}

destroy :: (material: Material) {
    SDL_ReleaseGPUGraphicsPipeline(global_renderer.device, material.shadowmap);
    SDL_ReleaseGPUGraphicsPipeline(global_renderer.device, material.color);
}
