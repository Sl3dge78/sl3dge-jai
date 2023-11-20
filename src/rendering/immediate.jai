Immediate :: struct {
    command_encoder : wgpu.CommandEncoder;
    render_pass : wgpu.RenderPassEncoder;
    
    locs : [..]Buffer_Location;
    current_position_in_buffer : u32; // in bytes
    vertices : [..]UI_Vertex;
    BUFFER_SIZE :: 1024 * 1024;
}

immediate_begin :: (render_target: *Texture = null) -> Immediate {
    pc : UI_Push_Constants = ---;
    view: wgpu.TextureView = ---;
    if render_target == null {
        view = global_renderer.window_framebuffer;
        pc = UI_Push_Constants.{.{2.0 / cast(float)global_renderer.width, -2.0 / cast(float)global_renderer.height}, .{-1, 1}};
    } else {
        view = render_target.view;
        pc = UI_Push_Constants.{.{2.0 / cast(float)wgpu.TextureGetWidth(render_target), -2.0 / cast(float)wgpu.TextureGetHeight(render_target)}, .{-1, 1}};
    }

    command_encoder := WGPU_Check(wgpu.DeviceCreateCommandEncoder(global_renderer.device, *wgpu.CommandEncoderDescriptor.{ label = "Immediate Command Encoder" }));

    color_attachment := wgpu.RenderPassColorAttachment.{
        view = view,
        resolveTarget = null,
        loadOp = .Clear,
        storeOp = .Store,
        clearValue = .{0.0, 0.0, 0.0, 1.0}
    };
    render_pass_desc := wgpu.RenderPassDescriptor.{
        label = "Immediate",
        colorAttachmentCount = 1,
        colorAttachments = *color_attachment,
    };
    render_pass := WGPU_Check(wgpu.CommandEncoderBeginRenderPass(command_encoder, *render_pass_desc));
    wgpu.RenderPassEncoderSetPipeline(render_pass, global_renderer.ui_pipeline);    
    wgpu.RenderPassEncoderSetPushConstants(render_pass, .Vertex, 0, size_of(type_of(pc)), *pc);

    wgpu.RenderPassEncoderSetBindGroup(render_pass, 0, global_renderer.empty_texture_uniform.bind_group, 0, null);

    return Immediate.{
        command_encoder = command_encoder,
        render_pass = render_pass
    };
}

immediate_default_texture :: (using immediate: *Immediate) {
    wgpu.RenderPassEncoderSetBindGroup(render_pass, 0, global_renderer.empty_texture_uniform.bind_group, 0, null);
}

immediate_end :: (using immediate: *Immediate) {
    flush(immediate);
    wgpu.RenderPassEncoderEnd(render_pass);
    renderer_push_command_encoder(*immediate.command_encoder, "Immediate Command Buffer");
    
}

flush :: (using immediate: *Immediate) {
    if vertices.count > 0 {
        loc := locs[locs.count - 1];
        buffer_write_data(loc.buffer, vertices.data, xx (vertices.count * size_of(UI_Vertex)), loc.offset);
        wgpu.RenderPassEncoderSetVertexBuffer(render_pass, 0, loc.buffer.handle, loc.offset, loc.size);
        wgpu.RenderPassEncoderDraw(render_pass, xx vertices.count, 1, 0, 0);
        vertices.count = 0;
    }
}

maybe_grow :: (using immediate: *Immediate, nb: u32) -> Buffer_Location {
    size := nb * size_of(UI_Vertex);
    assert(size < BUFFER_SIZE, "Pushing too many vertices to immediate!!");
    if locs.count == 0 ||  size + current_position_in_buffer >= locs[locs.count - 1].size {
        flush(immediate);
        loc := buffer_pool_get(*global_renderer.immediate_pool, BUFFER_SIZE);
        array_add(*locs, loc);
        current_position_in_buffer = 0;
        
    }
    loc := locs[locs.count - 1];
    return loc;
}

push_vertices :: (imm: *Immediate, vertices: []$T) {
    loc := maybe_grow(imm, xx vertices.count);
    array_add(*imm.vertices, ..vertices);
}

draw_2d_rect :: (immediate: *Immediate, p0: Vector2, p1: Vector2, color: Vector4 = . {1, 1, 1, 1}) {
    v : [6]UI_Vertex; 
    n := Vector3.{0, 0, 1};
    v[0] = .{ p0, .{1, 1}, color};
    v[1] = .{ xy(p0.x, p1.y), .{1, 1}, color};
    v[2] = .{ p1, .{1, 1}, color};
    
    v[3] = .{ p0, .{1, 1}, color};
    v[4] = .{ p1, .{1, 1}, color};
    v[5] = .{ xy(p1.x, p0.y), .{1, 1} , color};
    push_vertices(immediate, v);
}

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

// immediate_cube :: (offset: Vector3 = .{0, 0, 0}, color: Vector4 = .{1, 1, 1, 1}) {
//     immediate_quad(xyz(-.5, -.5, -.5) + offset, xyz(.5, -.5, -.5) + offset, xyz(.5, -.5, .5) + offset, xyz(-.5, -.5, .5) + offset, DOWN, color); 
//     immediate_quad(xyz(-.5, .5, -.5) + offset, xyz(-.5, .5, .5) + offset,  xyz(.5, .5, .5) + offset, xyz(.5, .5, -.5) + offset, UP, color);

//     immediate_quad(xyz(-.5, -.5, -.5) + offset, xyz(-.5, -.5, .5) + offset, xyz(-.5, .5, .5) + offset, xyz(-.5, .5, -.5) + offset, RIGHT, color); 
//     immediate_quad(xyz(.5, -.5, -.5) + offset, xyz(.5, .5, -.5) + offset, xyz(.5, .5, .5) + offset, xyz(.5, -.5, .5) + offset, LEFT, color); 

//     immediate_quad(xyz(-.5, -.5, -.5) + offset, xyz(-.5, .5, -.5) + offset, xyz(.5, .5, -.5) + offset, xyz(.5, -.5, -.5) + offset, BACK, color); 
//     immediate_quad(xyz(-.5, -.5, .5) + offset, xyz(.5, -.5, .5) + offset, xyz(.5, .5, .5) + offset, xyz(-.5, .5, .5) + offset, FORWARD, color); 
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
