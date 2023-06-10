Font :: struct {
    first_char: int;
    char_data : [437]stbtt_packedchar;
    texture: Texture;
    line_height : float;
    width : float;
}

create_font_from_file :: (path: string, size: float) -> Font, bool {
    font_data, success := read_entire_file(path);
    if !success {
        assert(false, "Unable to load font from %", path);
        return .{}, false;
    }
    result, success2 := create_font_from_data(font_data, size);
    return result, success2;
}

create_font_from_data :: (font_data: string, size: float) -> Font, bool {
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

    self.texture = create_texture_from_data(bitmap.data, 512, 512, 1, u8);
    
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

destroy_font :: (font : *Font) {
    destroy_texture(*font.texture);
}

size_text :: (text: string, font: *Font) -> float {
    // @Incomplete: This wont work for non monospaced fonts.
    return text.count * font.width;
}

draw_text :: (text: string, x: float, y: float, font: *Font, color: Vector4 = .{1, 1, 1, 1}) {
    // bind_texture(font.texture); // @TODO
    i := 0;
    while(i < text.count) {
        it := text[i];
        
        q : stbtt_aligned_quad = ---;
        stbtt_GetPackedQuad(font.char_data.data, 512, 512, xx(it - font.first_char), *x, *y, *q, 0);
        v := prepare_vertices(6);
        v[0] = Vertex.{ .{q.x0, q.y0, 0}, .{0.0, 0.0, 1.0}, Vector2.{q.s0, q.t0}, color };
        v[1] = Vertex.{ .{q.x1, q.y1, 0}, .{0.0, 0.0, 1.0}, Vector2.{q.s1, q.t1}, color };
        v[2] = Vertex.{ .{q.x1, q.y0, 0}, .{0.0, 0.0, 1.0}, Vector2.{q.s1, q.t0}, color };
        v[3] = Vertex.{ .{q.x0, q.y0, 0}, .{0.0, 0.0, 1.0}, Vector2.{q.s0, q.t0}, color };
        v[4] = Vertex.{ .{q.x0, q.y1, 0}, .{0.0, 0.0, 1.0}, Vector2.{q.s0, q.t1}, color };
        v[5] = Vertex.{ .{q.x1, q.y1, 0}, .{0.0, 0.0, 1.0}, Vector2.{q.s1, q.t1}, color };
        i += 1;
    }
}
