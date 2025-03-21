Font :: struct {
    first_char: int;
    char_data : [437]stbtt_packedchar;
    texture: Texture;
    line_height : float;
    width : float;
}

font_from_file :: (path: string, size: float) -> Font, bool {
    font_data, success := read_entire_file(path,, temp);
    if !success {
        assert(false, "Unable to load font from %", path);
        return .{}, false;
    }
    result, success2 := font_from_data(font_data, size, path_filename(path));
    return result, success2;
}

font_from_data :: (font_data: string, size: float, resource_name: string) -> Font, bool {
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

    self.texture = texture_from_data(bitmap.data, 512, 512, 1, u8, resource_name);

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
    destroy(font.texture);
}

size_text :: (text: string, font: *Font) -> float {
    // @Incomplete: This wont work for non monospaced fonts.
    return text.count * font.width;
}

immediate_bind_font :: (immediate: *Immediate, font: *Font) {
    immediate_bind_texture(immediate, font.texture);
}

draw_char :: inline (immediate: *Immediate, it: u8, font: *Font, line_start: float, x: *float, y: *float, color: Vector4) {
    if it == #char "\n" {
        x.* = line_start;
        y.* += font.line_height;
        return;
    }
    if it == #char "\t" {
        x.* += font.width * 4;
        return;
    }

    draw_char_raw(immediate, it, font, x, y.*, color);
}

draw_char_raw :: inline (immediate: *Immediate, it: u8, font: *Font, x: *float, y: float, color: Vector4) {
     q : stbtt_aligned_quad = ---;
    stbtt_GetPackedQuad(font.char_data.data, 512, 512, xx(it - font.first_char), x, *y, *q, 0);
    v : [6] UI_Vertex = ---; // = prepare_vertices(immediate, 6);
    v[0] = UI_Vertex.{ .{q.x0, q.y0}, Vector2.{q.s0, q.t0}, color };
    v[1] = UI_Vertex.{ .{q.x1, q.y1}, Vector2.{q.s1, q.t1}, color };
    v[2] = UI_Vertex.{ .{q.x1, q.y0}, Vector2.{q.s1, q.t0}, color };
    v[3] = UI_Vertex.{ .{q.x0, q.y0}, Vector2.{q.s0, q.t0}, color };
    v[4] = UI_Vertex.{ .{q.x0, q.y1}, Vector2.{q.s0, q.t1}, color };
    v[5] = UI_Vertex.{ .{q.x1, q.y1}, Vector2.{q.s1, q.t1}, color };
    push_vertices(immediate, v);
}

draw_text :: (immediate: *Immediate, text: string, x: float, y: float, font: *Font, color: Vector4 = .{1, 1, 1, 1}, $bind:= true) -> x: float, y: float{
    #if bind {
        immediate_bind_font(immediate, font);
    }
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

/*
draw_text_right_aligned :: (immediate: *Immediate, text: string, x: float, y: float, font: *Font, color: Vector4 = .{1, 1, 1, 1}) -> x: float, y: float {

    size := size_text(text, font);
    x, y := draw_text(immediate, text, immediate.target_w - size, y, font, color);
    return x, y;
}
*/

draw_wrapped_text :: (immediate: *Immediate, text: string, x: float, w: float, y: float, font: *Font, color: Vector4 = .{1, 1, 1, 1}, $bind := true) -> x: float, y: float{
    #if bind {
        immediate_bind_font(immediate, font);
    }
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
