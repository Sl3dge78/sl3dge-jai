Font :: struct {
    first_char: int;
    char_data : [437]stbtt_packedchar;
    texture: Texture;
    line_height : float;
    width : float;
    // binding: wgpu.BindGroup;
    uniform : Texture_Uniform;
    // descriptor: VkDescriptorSet;
}

font_from_file :: (path: string, size: float) -> Font, bool {
    font_data, success := read_entire_file(path);
    if !success {
        assert(false, "Unable to load font from %", path);
        return .{}, false;
    }
    result, success2 := font_from_data(font_data, size);
    return result, success2;
}

font_from_data :: (font_data: string, size: float) -> Font, bool {
    self : Font = ---;
    bitmap : [512*512]u8 = ---;
    
    pack_context : stbtt_pack_context = ---;
    
    if !stbtt_PackBegin(*pack_context, bitmap.data, 512, 512, 0, 1, null) {
        assert(false, "Unable to begin font packing");
        return .{}, false;
    }
    // stbtt_PackSetOversampling(*pack_context, 2, 2);
    self.first_char = 0;
    stbtt_PackFontRange(*pack_context, font_data.data, 0, size, xx self.first_char, 437, self.char_data.data);
    stbtt_PackEnd(*pack_context);
    // @HACK: We do this so that we don't need to change textures when drawing a plain color
    x := bitmap.count - 1;
    bitmap[x] = 255;
    x -= 1;
    bitmap[x] = 255;
    x -= 512;
    bitmap[x] = 255;
    x += 1;
    bitmap[x] = 255;

    self.texture = texture_from_data(bitmap.data, 512, 512, 1, u8);

    self.uniform = texture_uniform_create(global_renderer.sampler, self.texture.view, global_renderer.single_texture_bgl);
    
    // Get additional font info
    info : stbtt_fontinfo = ---;
    stbtt_InitFont(*info, font_data.data, 0);
    scale := stbtt_ScaleForMappingEmToPixels(*info, size);

    advance_width : s32 = ---;
    left_side_bearing : s32 = ---;
    stbtt_GetCodepointHMetrics(*info, #char "W", *advance_width, *left_side_bearing);
    self.width = advance_width * scale;

    ascent, descent, line_gap: s32 = ---;
    stbtt_GetFontVMetrics(*info, *ascent, *descent, *line_gap);
    self.line_height = (ascent - descent + line_gap) * scale;
    return self, true;
}

destroy :: (font: *Font) {
    destroy(*font.texture);
    destroy(*font.uniform);
}

size_text :: (text: string, font: *Font) -> float {
    // @Incomplete: This wont work for non monospaced fonts.
    return text.count * font.width;
}

draw_char :: (immediate: *Immediate, it: u8, font: *Font, line_start: float, x: *float, y: *float, color: Vector4) {
    if it == #char "\n" {
        x.* = line_start;
        y.* += font.line_height;
        return;
    }
    if it == #char "\t" {
        x.* += font.width * 4;
        return;
    }
    
    q : stbtt_aligned_quad = ---;
    stbtt_GetPackedQuad(font.char_data.data, 512, 512, xx(it - font.first_char), x, y, *q, 0);
    v := prepare_vertices(immediate, 6);
    v[0] = UI_Vertex.{ .{q.x0, q.y0}, Vector2.{q.s0, q.t0}, color };
    v[1] = UI_Vertex.{ .{q.x1, q.y1}, Vector2.{q.s1, q.t1}, color };
    v[2] = UI_Vertex.{ .{q.x1, q.y0}, Vector2.{q.s1, q.t0}, color };
    v[3] = UI_Vertex.{ .{q.x0, q.y0}, Vector2.{q.s0, q.t0}, color };
    v[4] = UI_Vertex.{ .{q.x0, q.y1}, Vector2.{q.s0, q.t1}, color };
    v[5] = UI_Vertex.{ .{q.x1, q.y1}, Vector2.{q.s1, q.t1}, color };
}

draw_text :: (immediate: *Immediate, text: string, x: float, y: float, font: *Font, color: Vector4 = .{1, 1, 1, 1}) -> x: float, y: float{
    wgpu.RenderPassEncoderSetBindGroup(immediate.render_pass, 0, font.uniform.bind_group, 0, null);
    i := 0;
    start_x := x;
    while(i < text.count) {
        it := text[i];
        defer i += 1;
        draw_char(immediate, it, font, start_x, *x, *y, color);
    }
    y += font.line_height;
    return x, y;
}

draw_wrapped_text :: (immediate: *Immediate, text: string, x: float, w: float, y: float, font: *Font, color: Vector4 = .{1, 1, 1, 1}) -> x: float, y: float{
    wgpu.RenderPassEncoderSetBindGroup(immediate.render_pass, 0, font.uniform.bind_group, 0, null);
    i := 0;
    start_x := x;
    while(i < text.count) {
        it := text[i];
        defer i += 1;
        draw_char(immediate, it, font, start_x, *x, *y, color);
        if x > w {
            x = start_x;
            y += font.line_height;
        }
    }
    y += font.line_height;
    return x, y;
}
