Immediate :: struct(Vertex_Type: Type)  {
    command_buffers : [..]VkCommandBuffer;
    current_pipelines : [..]Pipeline;
    target: *Texture;
    
    locs : [..]Buffer_Location;
    vertices : [..]Vertex_Type;
    BUFFER_SIZE :: 1024 * 1024;
}

#scope_file

flush :: (using immediate: *Immediate) {
    if vertices.count > 0 {
        size : u64 = xx (vertices.count * size_of(type_of(vertices[0])));
        loc := buffer_pool_get(*global_renderer.immediate_buffer_pool, size);
        buffer_write_data(loc.buffer, vertices.data, size, loc.offset);
        for command_buffers {
            vkCmdBindVertexBuffers(it, 0, 1, *loc.buffer.handle, *(loc.offset));
            vkCmdDraw(it, xx vertices.count, 1, 0, 0);
        }
        vertices.count = 0;
    }
}

#scope_export

Immediate2D :: Immediate(UI_Vertex);
Immediate3D :: Immediate(Standard_Vertex);

immediate_2d :: #bake_arguments immediate_begin(vertex_type = UI_Vertex);
immediate_3d :: #bake_arguments immediate_begin(vertex_type = Standard_Vertex);

immediate_begin :: (render_target: *Texture = null, $vertex_type: Type, label : string = "") -> Immediate(vertex_type) {
    result : Immediate(vertex_type);

    if render_target == null {
        result.target = *global_renderer.frame_data[global_renderer.frame_index].framebuffer;
    } else {
        result.target = render_target;
    }

    count : u32 = 0;
    #if vertex_type == UI_Vertex {
        count = 1;
    } else #if vertex_type == Standard_Vertex {
        count = 2;
    }

    array_reserve(*result.current_pipelines, count);
    result.current_pipelines.count = count;

    array_reserve(*result.command_buffers, count);
    // @TODO: maybe look into secondary command buffers?
    alloc_info := VkCommandBufferAllocateInfo.{
        commandPool = global_renderer.command_pool,
        level = .PRIMARY,
        commandBufferCount = count,
    };
    Vk_Check(vkAllocateCommandBuffers(global_renderer.device, *alloc_info, result.command_buffers.data));
    result.command_buffers.count = count;

    begin_info := VkCommandBufferBeginInfo.{
        flags = .ONE_TIME_SUBMIT_BIT,
    };
    for result.command_buffers {
        Vk_Check(vkBeginCommandBuffer(it, *begin_info));
    }

    // Prepare the render target for rendering
    if result.target.current_layout != .COLOR_ATTACHMENT_OPTIMAL {
        transition_texture_layout(result.target, .COLOR_ATTACHMENT_OPTIMAL, result.command_buffers[0]);
    }

    #if vertex_type == UI_Vertex {
        cmd := result.command_buffers[0];
        debug_name_object(cmd, "UI Command Buffer");

        color_attachment := VkRenderingAttachmentInfo.{
            imageView = result.target.view,
            imageLayout = .COLOR_ATTACHMENT_OPTIMAL,
            loadOp = .LOAD,
            storeOp = .STORE,
            clearValue = .{color = .{ _float32 = .[0, 0, 0, 1]}},
        };

        rendering_info := VkRenderingInfo.{
            renderArea = .{
                offset = .{0, 0},
                extent = .{result.target.w, result.target.h},
            },
            layerCount = 1,
            colorAttachmentCount = 1,
            pColorAttachments = *color_attachment,
        };
        vkCmdBeginRendering(cmd, *rendering_info);

        debug_marker(cmd, label);
        vkCmdBindPipeline(cmd, .GRAPHICS, global_renderer.ui_pipeline.pipeline);
        result.current_pipelines[0] = global_renderer.ui_pipeline;

        vkCmdSetViewport(cmd, 0, 1, *VkViewport.{0, xx result.target.h, xx result.target.w, -(cast(float)result.target.h), 0, 1});
        vkCmdSetScissor(cmd, 0, 1, *VkRect2D.{.{0, 0}, .{result.target.w, result.target.w}});

        pc := UI_Push_Constants.{.{2.0 / cast(float)result.target.w, -2.0 / cast(float)result.target.h}, .{-1, 1}};
        vkCmdPushConstants(cmd, global_renderer.ui_pipeline.layout, .VERTEX_BIT, 0, size_of(type_of(pc)), *pc);
        vkCmdBindDescriptorSets(cmd, .GRAPHICS, global_renderer.ui_pipeline.layout, 0, 1, *global_renderer.empty_texture_uniform.descriptor_set, 0, null);

    } else #if vertex_type == Standard_Vertex {
        {   // Color
            cmd := result.command_buffers[0];

            // Prepare the shadowmap texture for sampling
            transition_texture_layout(*global_renderer.shadowmap_texture, .SHADER_READ_ONLY_OPTIMAL, cmd);

            debug_name_object(cmd, "3D Color Command Buffer");
            depth_attachment := VkRenderingAttachmentInfo.{
                imageView = global_renderer.swapchain.depth_texture.view, 
                imageLayout = .DEPTH_STENCIL_ATTACHMENT_OPTIMAL,
                loadOp = .CLEAR,
                storeOp = .STORE,
                clearValue = .{depthStencil = .{1, 0}},
            };
            color_attachment := VkRenderingAttachmentInfo.{
                imageView = result.target.view,
                imageLayout = .COLOR_ATTACHMENT_OPTIMAL,
                loadOp = .LOAD,
                storeOp = .STORE,
                clearValue = .{color = .{ _float32 = .[0, 0, 0, 1]}},
            };
            rendering_info := VkRenderingInfo.{
                renderArea = .{
                    offset = .{0, 0},
                    extent = .{result.target.w, result.target.h}, 
                },
                layerCount = 1,
                colorAttachmentCount = 1,
                pColorAttachments = *color_attachment, 
                pDepthAttachment = *depth_attachment,
            };
            vkCmdBeginRendering(cmd, *rendering_info);
            result.current_pipelines[0] = global_renderer.static_mesh_material.color;
            bind_material(cmd, global_renderer.static_mesh_material, .COLOR);
        }
        {   // Directionnal Shadow
            cmd := result.command_buffers[1];
            debug_name_object(cmd, "3D Shadowmap Command Buffer");

            // Prepare the shadowmap texture for rendering
            transition_texture_layout(*global_renderer.shadowmap_texture, .DEPTH_ATTACHMENT_OPTIMAL, cmd);

            depth_attachment := VkRenderingAttachmentInfo.{
                imageView = global_renderer.shadowmap_texture.view, 
                imageLayout = .DEPTH_STENCIL_ATTACHMENT_OPTIMAL,
                loadOp = .CLEAR,
                storeOp = .STORE,
                clearValue = .{depthStencil = .{1, 0}},
            };
            rendering_info := VkRenderingInfo.{
                renderArea = .{
                    offset = .{0, 0},
                    extent = .{Renderer.SHADOWMAP_SIZE, Renderer.SHADOWMAP_SIZE}, 
                },
                layerCount = 1,
                colorAttachmentCount = 0,
                pDepthAttachment = *depth_attachment,
            };
            vkCmdBeginRendering(cmd, *rendering_info);
            result.current_pipelines[1] = global_renderer.static_mesh_material.shadowmap;
            bind_material(cmd, global_renderer.static_mesh_material, .SHADOWMAP);
        }

        set_model_matrix(*result, Matrix4_Identity);
        
    } else {
        #assert false, "Unsupported vertex type %", vertex_type;
    }
    return result;
}

// Only for 2d for now...
immediate_use_shader :: (using immediate: *Immediate2D, pipeline: Pipeline) {
    vkCmdBindPipeline(command_buffers[0], .GRAPHICS, pipeline.pipeline);
    pc := UI_Push_Constants.{.{2.0 / cast(float)target.w, -2.0 / cast(float)target.h}, .{-1, 1}};
    vkCmdPushConstants(command_buffers[0], pipeline.layout, .VERTEX_BIT, 0, size_of(type_of(pc)), *pc);
    vkCmdBindDescriptorSets(command_buffers[0], .GRAPHICS, pipeline.layout, 0, 1, *global_renderer.empty_texture_uniform.descriptor_set, 0, null);
    immediate.current_pipelines[0] = pipeline;
}

immediate_default_texture :: (using immediate: *Immediate2D) {
    immediate_bind_texture(immediate, global_renderer.empty_texture_uniform);
}

immediate_default_texture :: (using immediate: *Immediate3D) {
    immediate_bind_texture(immediate, global_renderer.empty_texture_uniform);
}

immediate_bind_texture :: (using immediate: *Immediate2D, texture: Uniform_Texture) {
    flush(immediate);
    vkCmdBindDescriptorSets(command_buffers[0], .GRAPHICS, current_pipelines[0].layout, 0, 1, *texture.descriptor_set, 0, null);
}

immediate_bind_texture :: (using immediate: *Immediate3D, texture: Uniform_Texture) {
    flush(immediate);
    vkCmdBindDescriptorSets(command_buffers[0], .GRAPHICS, current_pipelines[0].layout, Renderer.MATERIAL_SET, 1, *texture.descriptor_set, 0, null);
}

set_model_matrix :: (immediate: *Immediate3D, mat: Matrix4) {
    flush(immediate);
    pc := Standard_Push_Constants.{
        transform = transpose(mat),
        inverse_transform = transpose(inverse(mat)),
    };
    for immediate.command_buffers {
        vkCmdPushConstants(it, immediate.current_pipelines[it_index].layout, .VERTEX_BIT, 0, size_of(type_of(pc)), *pc);
    }
}

immediate_end :: (using immediate: *Immediate, final: bool = false) {
    flush(immediate);
    for command_buffers {
        vkCmdEndRendering(it);
    }

    if final { 
        transition_texture_layout(immediate.target, .SHADER_READ_ONLY_OPTIMAL, command_buffers[0]);
    }

    for command_buffers {
        vkEndCommandBuffer(it);
    }
    renderer_push_command_buffers(*global_renderer, immediate.command_buffers);
}

push_vertices :: (imm: *Immediate, vertices: []$T) {
    if imm.vertices.allocated < vertices.count + imm.vertices.count {
        array_reserve(*imm.vertices, vertices.count + imm.vertices.count);
    }
    memcpy(imm.vertices.data + imm.vertices.count, vertices.data, size_of(T) * vertices.count);
    imm.vertices.count += vertices.count;
}

draw_2d_rect :: (immediate: *Immediate2D, p0: Vector2, p1: Vector2, color: Vector4 = . {1, 1, 1, 1}) {
    v : [6]UI_Vertex; 
    n := Vector3.{0, 0, 1};
    v[0] = .{ p0, .{0, 0}, color};
    v[1] = .{ xy(p0.x, p1.y), .{0, 1}, color};
    v[2] = .{ p1, .{1, 1}, color};
    
    v[3] = .{ p0, .{0, 0}, color};
    v[4] = .{ p1, .{1, 1}, color};
    v[5] = .{ xy(p1.x, p0.y), .{1, 0} , color};
    push_vertices(immediate, v);
}

draw_2d_rect :: (immediate: *Immediate2D, x: float, y: float, w: float, h: float, color : Vector4 = .{1, 1, 1, 1}) {
    v : [6]UI_Vertex; 
    n := Vector3.{0, 0, 1};
    v[0] = .{ .{x, y},         .{0, 0}, color};
    v[1] = .{ .{x, y + h},     .{0, 1}, color};
    v[2] = .{ .{x + w, y},     .{1, 0}, color};
    
    v[3] = .{ .{x + w, y},     .{1, 0}, color};
    v[4] = .{ .{x, y + h},     .{0, 1}, color};
    v[5] = .{ .{x + w, y + h}, .{1, 1}, color};
    push_vertices(immediate, v);
}

draw_quad :: (immediate: *Immediate3D, p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3, normal: Vector3, color := Vector4.{1, 1, 1, 1}) {
    v : [6]Standard_Vertex; 

    v[0] = .{p0, normal, .{0, 0}, color};
    v[1] = .{p1, normal, .{1, 0}, color};
    v[2] = .{p2, normal, .{1, 1}, color};

    v[3] = .{p0, normal, .{0, 0}, color};
    v[4] = .{p2, normal, .{1, 1}, color};
    v[5] = .{p3, normal, .{0, 1}, color};

    push_vertices(immediate, v);
}

draw_plane :: (immediate: *Immediate3D, center: Vector3, size: Vector2) {
    hs := size / 2.0;
    draw_quad(
        immediate, 
        .{center.x + hs.x, center.y, center.z + hs.y},
        .{center.x + hs.x, center.y, center.z - hs.y},
        .{center.x - hs.x, center.y, center.z - hs.y},
        .{center.x - hs.x, center.y, center.z + hs.y},
        UP);
    
}

draw_cylinder :: (immediate: *Immediate3D) {
    NB_ITERATIONS :: 20;
    iter_size :: 2 * PI / (NB_ITERATIONS);
    radius :: 1;
    height :: 1;

    for 0..NB_ITERATIONS {
        angle := iter_size * it;
        x1 := cos(angle) * radius;
        x2 := cos(angle + iter_size) * radius;
        z1 := sin(angle) * radius;
        z2 := sin(angle + iter_size) * radius;
        p0 := xyz(x1, 0, z1);
        p3 := xyz(x2, 0, z2);
        draw_quad(immediate, p0, xyz(x1, height, z1), xyz(x2, height, z2), p3, 
        normal = cross(normalize(p3 - p0), UP));
    }

    // Draw floor & ceiling as simple quad
    draw_quad(immediate, xyz(-radius, 0, -radius), xyz(radius, 0, -radius), xyz(radius, 0, radius), xyz(-radius, 0, radius), UP); 
    draw_quad(immediate, xyz(-radius, height, -radius), xyz(radius, height, -radius), xyz(radius, height, radius), xyz(-radius, height, radius), DOWN); 
}

draw_cube :: (immediate: *Immediate3D, color : Vector4 = .{1, 1, 1, 1}) {
    draw_quad(immediate, xyz(-.5, -.5, -.5), xyz(.5, -.5, -.5), xyz(.5, -.5, .5), xyz(-.5, -.5, .5), DOWN, color); 
    draw_quad(immediate, xyz(-.5, .5, -.5), xyz(-.5, .5, .5),  xyz(.5, .5, .5), xyz(.5, .5, -.5), UP, color);
    draw_quad(immediate, xyz(-.5, -.5, -.5), xyz(-.5, -.5, .5), xyz(-.5, .5, .5), xyz(-.5, .5, -.5), RIGHT, color); 
    draw_quad(immediate, xyz(.5, -.5, -.5), xyz(.5, .5, -.5), xyz(.5, .5, .5), xyz(.5, -.5, .5), LEFT, color); 
    draw_quad(immediate, xyz(-.5, -.5, -.5), xyz(-.5, .5, -.5), xyz(.5, .5, -.5), xyz(.5, -.5, -.5) , BACK, color); 
    draw_quad(immediate, xyz(-.5, -.5, .5), xyz(.5, -.5, .5), xyz(.5, .5, .5), xyz(-.5, .5, .5) , FORWARD, color); 
    
}
// immediate_cube :: (offset: Vector3 = .{0, 0, 0}, color: Vector4 = .{1, 1, 1, 1}) {
// }


// Immediate :: struct {
//     _3d_draw_data: Draw_Data(Vertex);
//     _2d_draw_data: Draw_Data(Vertex);
//     debug_draw_data: Draw_Data(Debug_Vertex);
// }

// #add_context immediate : Immediate;

// Draw_Data :: struct(vertex_type: Type) {
//     vertex_buffer: Buffer;
//     vertices: [..]vertex_type;
//     draw_cmds : [..]Draw_Cmd;
//     transform: Matrix4 = Matrix4_Identity;
// }

// Draw_Cmd :: struct {
//     id: u32;
//     count: u32;
//     xform: Matrix4;
// }

// immediate_draw_3d :: (render_pass: wgpu.RenderPassEncoder) {
//     using context.immediate._3d_draw_data;
//     if draw_cmds.count == 0 return;
    
//     wgpu.RenderPassEncoderSetVertexBuffer(render_pass, 0, vertex_buffer.handle, 0, vertex_buffer.size);
//     for draw_cmds {
//         pc := Standard_Push_Constants.{transpose(it.xform), transpose(inverse(it.xform))};
//         wgpu.RenderPassEncoderSetPushConstants(render_pass, .Vertex, 0, size_of(type_of(pc)), *pc);
//         wgpu.RenderPassEncoderDraw(render_pass, it.count, 1, it.id, 0);
//     }
// }

// immediate_draw_2d :: (render_pass: wgpu.RenderPassEncoder) {
//     using context.immediate._2d_draw_data;
//     if draw_cmds.count == 0 return;

//     wgpu.RenderPassEncoderSetPipeline(render_pass, global_renderer.ui_pipeline);
//     wgpu.RenderPassEncoderSetBindGroup(render_pass, 0, global_engine.default_font.uniform.bind_group, 0, null);
//     wgpu.RenderPassEncoderSetVertexBuffer(render_pass, 0, vertex_buffer.handle, 0, vertex_buffer.size);
//     pc := float.[2.0 / cast(float)global_renderer.width, -2.0 / cast(float)global_renderer.height, -1, 1];
//     wgpu.RenderPassEncoderSetPushConstants(render_pass, .Vertex, 0, size_of(type_of(pc)), *pc);
//     for context.immediate._2d_draw_data.draw_cmds {
//         wgpu.RenderPassEncoderDraw(render_pass, it.count, 1, it.id, 0);
//     }
// }

// immediate_draw_debug :: (render_pass: wgpu.RenderPassEncoder) {
//     using context.immediate.debug_draw_data;
//     if draw_cmds.count == 0 return;

//     wgpu.RenderPassEncoderSetPipeline(render_pass, global_renderer.debug_pipeline);
//     wgpu.RenderPassEncoderSetBindGroup(render_pass, 0, global_renderer.global_matrices_uniform.bind_group, 0, null);
//     wgpu.RenderPassEncoderSetVertexBuffer(render_pass, 0, vertex_buffer.handle, 0, vertex_buffer.size);
//     for draw_cmds {
//         pc := Standard_Push_Constants.{transpose(it.xform), transpose(inverse(it.xform))};
//         wgpu.RenderPassEncoderSetPushConstants(render_pass, .Vertex, 0, size_of(type_of(pc)), *pc);
//         wgpu.RenderPassEncoderDraw(render_pass, it.count, 1, it.id, 0);
//     }
// }

// immediate_quad :: (p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3, normal: Vector3, color := Vector4.{1, 1, 1, 1}) {
//     v := prepare_3d_vertices(6);
//     v[0] = .{p0, normal, .{0, 0}, color};
//     v[1] = .{p1, normal, .{1, 0}, color};
//     v[2] = .{p2, normal, .{1, 1}, color};

//     v[3] = .{p0, normal, .{0, 0}, color};
//     v[4] = .{p2, normal, .{1, 1}, color};
//     v[5] = .{p3, normal, .{0, 1}, color};
// }


// immediate_set_transform :: (xform: Matrix4) {
//     context.immediate._3d_draw_data.transform = xform;
// }


// prepare_2d_vertices :: inline (nb: u32) -> *Vertex {
//     return prepare_vertices(*context.immediate._2d_draw_data, nb);
// }

// prepare_3d_vertices :: inline (nb: u32) -> *Vertex {
//     return prepare_vertices(*context.immediate._3d_draw_data, nb);
// }

// prepare_debug_vertices :: inline (nb: u32) ->*Debug_Vertex {
//     using context.immediate.debug_draw_data;
//     array_reserve(*vertices, vertices.count + nb);
//     if draw_cmds.count == 0 {
//         array_add(*draw_cmds, Draw_Cmd.{xx vertices.count, nb, transform});
//     } else { 
//         prev := *draw_cmds[draw_cmds.count - 1];
//         if prev.xform == transform { // Don't create a new entry if the state hasn't changed
//             prev.count += nb;
//         } else {
//             array_add(*draw_cmds, Draw_Cmd.{xx vertices.count, nb, transform});
//         }
//     }
//     ptr := vertices.data + vertices.count;
//     vertices.count += nb;

//     return ptr;
// }

// prepare_vertices :: (using dd : *Draw_Data, nb: u32) -> *Vertex {
//     array_reserve(*vertices, vertices.count + nb);
//     if draw_cmds.count == 0 {
//         array_add(*draw_cmds, Draw_Cmd.{xx vertices.count, nb, transform});
//     } else { 
//         prev := *draw_cmds[draw_cmds.count - 1];
//         if prev.xform == transform { // Don't create a new entry if the state hasn't changed
//             prev.count += nb;
//         } else {
//             array_add(*draw_cmds, Draw_Cmd.{xx vertices.count, nb, transform});
//         }
//     }
//     ptr := vertices.data + vertices.count;
//     vertices.count += nb;

//     return ptr;
// }

// immediate_2d_rect :: (p0: Vector2, p1: Vector2, color: Vector4) {
//     v := prepare_2d_vertices(6);
//     n := Vector3.{0, 0, 1};
//     v[0] = .{ xyz(p0, 0), n, .{1, 1}, color};
//     v[1] = .{ xyz(p0.x, p1.y, 0), n, .{1, 1}, color};
//     v[2] = .{ xyz(p1, 0), n, .{1, 1}, color};
    
//     v[3] = .{ xyz(p0, 0), n, .{1, 1}, color};
//     v[4] = .{ xyz(p1, 0), n, .{1, 1}, color};
//     v[5] = .{ xyz(p1.x, p0.y, 0), n, .{1, 1} , color};
// }


// immediate_debug_line :: (p0: Vector3, p1: Vector3, color: Vector4) {
//     v := prepare_debug_vertices(2);
//     v[0] = .{p0, color};
//     v[1] = .{p1, color};
// }

// immediate_debug_matrix :: (mat: Matrix4, line_length : float = 1) {
//     v := prepare_debug_vertices(6);
//     org := (mat * .{0, 0, 0, 1}).xyz;
//     x :=   (mat * .{line_length, 0, 0, 1}).xyz;
//     y :=   (mat * .{0, line_length, 0, 1}).xyz;
//     z :=   (mat * .{0, 0, line_length, 1}).xyz;
//     v[0] = .{org, RED};
//     v[1] = .{x, RED};
//     v[2] = .{org, GREEN};
//     v[3] = .{y, GREEN};
//     v[4] = .{org, BLUE};
//     v[5] = .{z, BLUE};
// }

// destroy :: (dd: *Draw_Data) {
//     array_reset(*dd.draw_cmds);
//     array_reset(*dd.vertices);
//     destroy(*dd.vertex_buffer);
// }

// reset :: (dd: *Draw_Data) {
//     dd.vertices.count = 0;
//     dd.draw_cmds.count = 0;
//     dd.transform = Matrix4_Identity;
// }

// upload :: (dd: *Draw_Data) {
//     if dd.vertices.count == 0 then return; 
//     size : u64 = xx (dd.vertices.count * size_of(Vertex));
//     buffer_create_or_update(*dd.vertex_buffer, size, .Vertex | .CopyDst);
//     buffer_write_data(dd.vertex_buffer, dd.vertices.data, size);
// }
