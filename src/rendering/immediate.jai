// This offers an api for easy drawing to a render target in a single pass
// Perfect for UIs
Immediate :: struct  {
    target: *Render_Texture;
    cmd : wgpu.CommandEncoder;
    rp_cmd: wgpu.RenderPassEncoder;
    current_pipeline : wgpu.RenderPipeline;
    
    locs : [..]Buffer_Location;
    vertices : [..]UI_Vertex;
    BUFFER_SIZE :: 1024 * 1024;
}

#scope_file

flush :: (using immediate: *Immediate) {
    if vertices.count > 0 {
        size : u64 = xx (vertices.count * size_of(type_of(vertices[0])));
        loc := buffer_pool_get(*global_renderer.immediate_pool, size);
        buffer_write_data(loc.buffer, vertices.data, size, loc.offset);
        wgpu.RenderPassEncoderSetVertexBuffer(rp_cmd, 0, loc.buffer.handle, loc.offset, size);
        wgpu.RenderPassEncoderDraw(rp_cmd, xx vertices.count, 1, 0, 0);
        vertices.count = 0;
    }
}

#scope_export

immediate_begin :: (render_target: *Render_Texture, label : string = "") -> Immediate {
    result : Immediate;
    result.target = render_target;
    result.vertices.allocator = temp;

    {
        desc := wgpu.CommandEncoderDescriptor.{
            label = to_c_string(label)
        };
        result.cmd = wgpu.DeviceCreateCommandEncoder(global_renderer.device, *desc);
    }

    {
        attachment := wgpu.RenderPassColorAttachment.{
            view = render_target.view,
            loadOp = .Clear,
            storeOp = .Store,
            clearValue = .{0, 0, 0, 1},
        };

        desc := wgpu.RenderPassDescriptor.{
            colorAttachmentCount = 1,
            colorAttachments = *attachment,
        };
        result.rp_cmd = wgpu.CommandEncoderBeginRenderPass(result.cmd, *desc);
    }
    return result;
}

immediate_end :: (using immediate: *Immediate) {
    flush(immediate);
    wgpu.RenderPassEncoderEnd(rp_cmd);
    wgpu.RenderPassEncoderRelease(rp_cmd);

    renderer_push_command_encoder(*cmd);
}

immediate_begin_rendering :: (using self: *Immediate) {
    // color_attachment := VkRenderingAttachmentInfo.{
    //     imageView = target.view,
    //     imageLayout = .COLOR_ATTACHMENT_OPTIMAL,
    //     loadOp = .LOAD,
    //     storeOp = .STORE,
    //     clearValue = .{color = .{ _float32 = .[0, 0, 0, 1]}},
    // };

    // rendering_info := VkRenderingInfo.{
    //     renderArea = .{
    //         offset = .{0, 0},
    //         extent = .{target.w, target.h},
    //     },
    //     layerCount = 1,
    //     colorAttachmentCount = 1,
    //     pColorAttachments = *color_attachment,
    // };
    // vkCmdBeginRendering(command_buffer, *rendering_info);

    // vkCmdBindPipeline(command_buffer, .GRAPHICS, global_renderer.ui_pipeline.pipeline);
    // current_pipeline = global_renderer.ui_pipeline;

    // viewport := VkViewport.{0, xx target.h, xx target.w, -(cast(float)target.h), 0, 1};
    // vkCmdSetViewport(command_buffer, 0, 1, *viewport);
    // rect :=VkRect2D.{.{0, 0} , .{target.w, target.w}};
    // vkCmdSetScissor(command_buffer, 0, 1, *rect);

    // pc := UI_Push_Constants.{.{2.0 / cast(float)target.w, -2.0 / cast(float)target.h}, .{-1, 1}};
    // vkCmdPushConstants(command_buffer, global_renderer.ui_pipeline.layout, .VERTEX_BIT, 0, size_of(type_of(pc)), *pc);
    // vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, global_renderer.ui_pipeline.layout, 0, 1, *global_renderer.empty_texture_descriptor_set, 0, null);


    
}

// Variant to embed the immediate in a command buffer
immediate_begin_in_place :: (render_target: *Render_Texture, command_encoder: wgpu.CommandEncoder, rp_enc : wgpu.RenderPassEncoder) -> Immediate {
    self: Immediate;
    self.target = render_target;
    self.cmd = command_encoder;
    self.rp_cmd = rp_enc;
    self.vertices.allocator = temp;

    immediate_begin_rendering(*self);
    return self;
}

immediate_end_in_place :: (using self: *Immediate) {
    flush(self);
    wgpu.RenderPassEncoderEnd(rp_cmd);
}

immediate_use_shader :: (using immediate: *Immediate, pipeline: wgpu.RenderPipeline) {
    wgpu.RenderPassEncoderSetPipeline(rp_cmd, pipeline);

    pc := UI_Push_Constants.{.{2.0 / cast(float)target.w, -2.0 / cast(float)target.h}, .{-1, 1}};
    wgpu.RenderPassEncoderSetPushConstants(rp_cmd, .Vertex, 0, size_of(type_of(pc)), *pc);
    immediate.current_pipeline = pipeline;
    immediate_default_texture(immediate);
}

immediate_default_texture :: (using immediate: *Immediate) {
    immediate_bind_texture(immediate, global_renderer.empty_texture_uniform.bind_group);
}

immediate_bind_texture :: (using immediate: *Immediate, bind_group: wgpu.BindGroup) {
    flush(immediate);
    wgpu.RenderPassEncoderSetBindGroup(rp_cmd, 0, bind_group, 0, null);
}


push_vertices :: (imm: *Immediate, vertices: []$T) {
    // if imm.vertices.allocated < vertices.count + imm.vertices.count {
    //     array_reserve(*imm.vertices, vertices.count + imm.vertices.count);
    // }
    // memcpy(imm.vertices.data + imm.vertices.count, vertices.data, size_of(T) * vertices.count);
    // imm.vertices.count += vertices.count;
    array_add(*imm.vertices, ..vertices);
}

draw_2d_rect :: (immediate: *Immediate, p0: Vector2, p1: Vector2, color: Vector4 = .{1, 1, 1, 1}) {
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

draw_2d_rect :: (immediate: *Immediate, x: float, y: float, w: float, h: float, color : Vector4 = .{1, 1, 1, 1}) {
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

// draw_quad :: (immediate: *Immediate3D, p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3, normal: Vector3, color := Vector4.{1, 1, 1, 1}) {
//     v : [6]Standard_Vertex; 
// 
//     v[0] = .{p0, normal, .{0, 0}, color};
//     v[1] = .{p1, normal, .{1, 0}, color};
//     v[2] = .{p2, normal, .{1, 1}, color};
// 
//     v[3] = .{p0, normal, .{0, 0}, color};
//     v[4] = .{p2, normal, .{1, 1}, color};
//     v[5] = .{p3, normal, .{0, 1}, color};
// 
//     push_vertices(immediate, v);
// }
// 
// draw_plane :: (immediate: *Immediate3D, center: Vector3, size: Vector2) {
//     hs := size / 2.0;
//     draw_quad(
//         immediate, 
//         .{center.x + hs.x, center.y, center.z + hs.y},
//         .{center.x + hs.x, center.y, center.z - hs.y},
//         .{center.x - hs.x, center.y, center.z - hs.y},
//         .{center.x - hs.x, center.y, center.z + hs.y},
//         UP);
//     
// }

// draw_cylinder :: (immediate: *Immediate3D) {
//     NB_ITERATIONS :: 20;
//     iter_size :: 2 * PI / (NB_ITERATIONS);
//     radius :: 1;
//     height :: 1;
// 
//     for 0..NB_ITERATIONS {
//         angle := iter_size * it;
//         x1 := cos(angle) * radius;
//         x2 := cos(angle + iter_size) * radius;
//         z1 := sin(angle) * radius;
//         z2 := sin(angle + iter_size) * radius;
//         p0 := xyz(x1, 0, z1);
//         p3 := xyz(x2, 0, z2);
//         draw_quad(immediate, p0, xyz(x1, height, z1), xyz(x2, height, z2), p3, 
//         normal = cross(normalize(p3 - p0), UP));
//     }
// 
//     // Draw floor & ceiling as simple quad
//     draw_quad(immediate, xyz(-radius, 0, -radius), xyz(radius, 0, -radius), xyz(radius, 0, radius), xyz(-radius, 0, radius), UP); 
//     draw_quad(immediate, xyz(-radius, height, -radius), xyz(radius, height, -radius), xyz(radius, height, radius), xyz(-radius, height, radius), DOWN); 
// }

// draw_cube :: (immediate: *Immediate3D, color : Vector4 = .{1, 1, 1, 1}) {
//     draw_quad(immediate, xyz(-.5, -.5, -.5), xyz(.5, -.5, -.5), xyz(.5, -.5, .5), xyz(-.5, -.5, .5), DOWN, color); 
//     draw_quad(immediate, xyz(-.5, .5, -.5), xyz(-.5, .5, .5),  xyz(.5, .5, .5), xyz(.5, .5, -.5), UP, color);
//     draw_quad(immediate, xyz(-.5, -.5, -.5), xyz(-.5, -.5, .5), xyz(-.5, .5, .5), xyz(-.5, .5, -.5), RIGHT, color); 
//     draw_quad(immediate, xyz(.5, -.5, -.5), xyz(.5, .5, -.5), xyz(.5, .5, .5), xyz(.5, -.5, .5), LEFT, color); 
//     draw_quad(immediate, xyz(-.5, -.5, -.5), xyz(-.5, .5, -.5), xyz(.5, .5, -.5), xyz(.5, -.5, -.5) , BACK, color); 
//     draw_quad(immediate, xyz(-.5, -.5, .5), xyz(.5, -.5, .5), xyz(.5, .5, .5), xyz(-.5, .5, .5) , FORWARD, color); 
//     
// }
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

// set_model_matrix :: (immediate: *Immediate3D, mat: Matrix4) {
//     flush(immediate);
//     pc := Standard_Push_Constants.{
//         transform = transpose(mat),
//         inverse_transform = transpose(inverse(mat)),
//     };
//     for immediate.command_buffers {
//         vkCmdPushConstants(it, immediate.current_pipelines[it_index].layout, .VERTEX_BIT, 0, size_of(type_of(pc)), *pc);
//     }
// }

