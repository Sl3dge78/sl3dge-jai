//
// This file was auto-generated using the following command:
//
// jai ./generate.jai
//



STBTT_MACSTYLE_DONTCARE :: 0;
STBTT_MACSTYLE_BOLD :: 1;
STBTT_MACSTYLE_ITALIC :: 2;
STBTT_MACSTYLE_UNDERSCORE :: 4;
STBTT_MACSTYLE_NONE :: 8;

// private structure
stbtt__buf :: struct {
    data:   *u8;
    cursor: s32;
    size:   s32;
}
#run {
    instance: stbtt__buf;
    assert(((cast(*void)(*instance.data)) - cast(*void)(*instance)) == 0, "stbtt__buf.data has unexpected offset % instead of 0", ((cast(*void)(*instance.data)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt__buf.data)) == 8, "stbtt__buf.data has unexpected size % instead of 8", size_of(type_of(stbtt__buf.data)));
    assert(((cast(*void)(*instance.cursor)) - cast(*void)(*instance)) == 8, "stbtt__buf.cursor has unexpected offset % instead of 8", ((cast(*void)(*instance.cursor)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt__buf.cursor)) == 4, "stbtt__buf.cursor has unexpected size % instead of 4", size_of(type_of(stbtt__buf.cursor)));
    assert(((cast(*void)(*instance.size)) - cast(*void)(*instance)) == 12, "stbtt__buf.size has unexpected offset % instead of 12", ((cast(*void)(*instance.size)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt__buf.size)) == 4, "stbtt__buf.size has unexpected size % instead of 4", size_of(type_of(stbtt__buf.size)));
    assert(size_of(stbtt__buf) == 16, "stbtt__buf has size % instead of 16", size_of(stbtt__buf));
}

//////////////////////////////////////////////////////////////////////////////
//
// TEXTURE BAKING API
//
// If you use this API, you only have to call two functions ever.
//
stbtt_bakedchar :: struct {
    x0:       u16; // coordinates of bbox in bitmap
    y0:       u16; // coordinates of bbox in bitmap
    x1:       u16; // coordinates of bbox in bitmap
    y1:       u16; // coordinates of bbox in bitmap
    xoff:     float;
    yoff:     float;
    xadvance: float;
}
#run {
    instance: stbtt_bakedchar;
    assert(((cast(*void)(*instance.x0)) - cast(*void)(*instance)) == 0, "stbtt_bakedchar.x0 has unexpected offset % instead of 0", ((cast(*void)(*instance.x0)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_bakedchar.x0)) == 2, "stbtt_bakedchar.x0 has unexpected size % instead of 2", size_of(type_of(stbtt_bakedchar.x0)));
    assert(((cast(*void)(*instance.y0)) - cast(*void)(*instance)) == 2, "stbtt_bakedchar.y0 has unexpected offset % instead of 2", ((cast(*void)(*instance.y0)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_bakedchar.y0)) == 2, "stbtt_bakedchar.y0 has unexpected size % instead of 2", size_of(type_of(stbtt_bakedchar.y0)));
    assert(((cast(*void)(*instance.x1)) - cast(*void)(*instance)) == 4, "stbtt_bakedchar.x1 has unexpected offset % instead of 4", ((cast(*void)(*instance.x1)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_bakedchar.x1)) == 2, "stbtt_bakedchar.x1 has unexpected size % instead of 2", size_of(type_of(stbtt_bakedchar.x1)));
    assert(((cast(*void)(*instance.y1)) - cast(*void)(*instance)) == 6, "stbtt_bakedchar.y1 has unexpected offset % instead of 6", ((cast(*void)(*instance.y1)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_bakedchar.y1)) == 2, "stbtt_bakedchar.y1 has unexpected size % instead of 2", size_of(type_of(stbtt_bakedchar.y1)));
    assert(((cast(*void)(*instance.xoff)) - cast(*void)(*instance)) == 8, "stbtt_bakedchar.xoff has unexpected offset % instead of 8", ((cast(*void)(*instance.xoff)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_bakedchar.xoff)) == 4, "stbtt_bakedchar.xoff has unexpected size % instead of 4", size_of(type_of(stbtt_bakedchar.xoff)));
    assert(((cast(*void)(*instance.yoff)) - cast(*void)(*instance)) == 12, "stbtt_bakedchar.yoff has unexpected offset % instead of 12", ((cast(*void)(*instance.yoff)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_bakedchar.yoff)) == 4, "stbtt_bakedchar.yoff has unexpected size % instead of 4", size_of(type_of(stbtt_bakedchar.yoff)));
    assert(((cast(*void)(*instance.xadvance)) - cast(*void)(*instance)) == 16, "stbtt_bakedchar.xadvance has unexpected offset % instead of 16", ((cast(*void)(*instance.xadvance)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_bakedchar.xadvance)) == 4, "stbtt_bakedchar.xadvance has unexpected size % instead of 4", size_of(type_of(stbtt_bakedchar.xadvance)));
    assert(size_of(stbtt_bakedchar) == 20, "stbtt_bakedchar has size % instead of 20", size_of(stbtt_bakedchar));
}

stbtt_BakeFontBitmap :: (data: *u8, offset: s32, pixel_height: float, pixels: *u8, pw: s32, ph: s32, first_char: s32, num_chars: s32, chardata: *stbtt_bakedchar) -> s32 #foreign stbtruetype;

// if return is positive, the first unused row of the bitmap
// if return is negative, returns the negative of the number of characters that fit
// if return is 0, no characters fit and no rows were used
// This uses a very crappy packing.
stbtt_aligned_quad :: struct {
    x0: float; // top-left
    y0: float; // top-left
    s0: float; // top-left
    t0: float; // top-left
    x1: float; // bottom-right
    y1: float; // bottom-right
    s1: float; // bottom-right
    t1: float; // bottom-right
}
#run {
    instance: stbtt_aligned_quad;
    assert(((cast(*void)(*instance.x0)) - cast(*void)(*instance)) == 0, "stbtt_aligned_quad.x0 has unexpected offset % instead of 0", ((cast(*void)(*instance.x0)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_aligned_quad.x0)) == 4, "stbtt_aligned_quad.x0 has unexpected size % instead of 4", size_of(type_of(stbtt_aligned_quad.x0)));
    assert(((cast(*void)(*instance.y0)) - cast(*void)(*instance)) == 4, "stbtt_aligned_quad.y0 has unexpected offset % instead of 4", ((cast(*void)(*instance.y0)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_aligned_quad.y0)) == 4, "stbtt_aligned_quad.y0 has unexpected size % instead of 4", size_of(type_of(stbtt_aligned_quad.y0)));
    assert(((cast(*void)(*instance.s0)) - cast(*void)(*instance)) == 8, "stbtt_aligned_quad.s0 has unexpected offset % instead of 8", ((cast(*void)(*instance.s0)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_aligned_quad.s0)) == 4, "stbtt_aligned_quad.s0 has unexpected size % instead of 4", size_of(type_of(stbtt_aligned_quad.s0)));
    assert(((cast(*void)(*instance.t0)) - cast(*void)(*instance)) == 12, "stbtt_aligned_quad.t0 has unexpected offset % instead of 12", ((cast(*void)(*instance.t0)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_aligned_quad.t0)) == 4, "stbtt_aligned_quad.t0 has unexpected size % instead of 4", size_of(type_of(stbtt_aligned_quad.t0)));
    assert(((cast(*void)(*instance.x1)) - cast(*void)(*instance)) == 16, "stbtt_aligned_quad.x1 has unexpected offset % instead of 16", ((cast(*void)(*instance.x1)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_aligned_quad.x1)) == 4, "stbtt_aligned_quad.x1 has unexpected size % instead of 4", size_of(type_of(stbtt_aligned_quad.x1)));
    assert(((cast(*void)(*instance.y1)) - cast(*void)(*instance)) == 20, "stbtt_aligned_quad.y1 has unexpected offset % instead of 20", ((cast(*void)(*instance.y1)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_aligned_quad.y1)) == 4, "stbtt_aligned_quad.y1 has unexpected size % instead of 4", size_of(type_of(stbtt_aligned_quad.y1)));
    assert(((cast(*void)(*instance.s1)) - cast(*void)(*instance)) == 24, "stbtt_aligned_quad.s1 has unexpected offset % instead of 24", ((cast(*void)(*instance.s1)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_aligned_quad.s1)) == 4, "stbtt_aligned_quad.s1 has unexpected size % instead of 4", size_of(type_of(stbtt_aligned_quad.s1)));
    assert(((cast(*void)(*instance.t1)) - cast(*void)(*instance)) == 28, "stbtt_aligned_quad.t1 has unexpected offset % instead of 28", ((cast(*void)(*instance.t1)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_aligned_quad.t1)) == 4, "stbtt_aligned_quad.t1 has unexpected size % instead of 4", size_of(type_of(stbtt_aligned_quad.t1)));
    assert(size_of(stbtt_aligned_quad) == 32, "stbtt_aligned_quad has size % instead of 32", size_of(stbtt_aligned_quad));
}

stbtt_GetBakedQuad :: (chardata: *stbtt_bakedchar, pw: s32, ph: s32, char_index: s32, xpos: *float, ypos: *float, q: *stbtt_aligned_quad, opengl_fillrule: s32) -> void #foreign stbtruetype;

// Call GetBakedQuad with char_index = 'character - first_char', and it
// creates the quad you need to draw and advances the current position.
//
// The coordinate system used assumes y increases downwards.
//
// Characters will extend both above and below the current position;
// see discussion of "BASELINE" above.
//
// It's inefficient; you might want to c&p it and optimize it.
stbtt_GetScaledFontVMetrics :: (fontdata: *u8, index: s32, size: float, ascent: *float, descent: *float, lineGap: *float) -> void #foreign stbtruetype;

//////////////////////////////////////////////////////////////////////////////
//
// NEW TEXTURE BAKING API
//
// This provides options for packing multiple fonts into one atlas, not
// perfectly but better than nothing.
stbtt_packedchar :: struct {
    x0:       u16; // coordinates of bbox in bitmap
    y0:       u16; // coordinates of bbox in bitmap
    x1:       u16; // coordinates of bbox in bitmap
    y1:       u16; // coordinates of bbox in bitmap
    xoff:     float;
    yoff:     float;
    xadvance: float;
    xoff2:    float;
    yoff2:    float;
}
#run {
    instance: stbtt_packedchar;
    assert(((cast(*void)(*instance.x0)) - cast(*void)(*instance)) == 0, "stbtt_packedchar.x0 has unexpected offset % instead of 0", ((cast(*void)(*instance.x0)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_packedchar.x0)) == 2, "stbtt_packedchar.x0 has unexpected size % instead of 2", size_of(type_of(stbtt_packedchar.x0)));
    assert(((cast(*void)(*instance.y0)) - cast(*void)(*instance)) == 2, "stbtt_packedchar.y0 has unexpected offset % instead of 2", ((cast(*void)(*instance.y0)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_packedchar.y0)) == 2, "stbtt_packedchar.y0 has unexpected size % instead of 2", size_of(type_of(stbtt_packedchar.y0)));
    assert(((cast(*void)(*instance.x1)) - cast(*void)(*instance)) == 4, "stbtt_packedchar.x1 has unexpected offset % instead of 4", ((cast(*void)(*instance.x1)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_packedchar.x1)) == 2, "stbtt_packedchar.x1 has unexpected size % instead of 2", size_of(type_of(stbtt_packedchar.x1)));
    assert(((cast(*void)(*instance.y1)) - cast(*void)(*instance)) == 6, "stbtt_packedchar.y1 has unexpected offset % instead of 6", ((cast(*void)(*instance.y1)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_packedchar.y1)) == 2, "stbtt_packedchar.y1 has unexpected size % instead of 2", size_of(type_of(stbtt_packedchar.y1)));
    assert(((cast(*void)(*instance.xoff)) - cast(*void)(*instance)) == 8, "stbtt_packedchar.xoff has unexpected offset % instead of 8", ((cast(*void)(*instance.xoff)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_packedchar.xoff)) == 4, "stbtt_packedchar.xoff has unexpected size % instead of 4", size_of(type_of(stbtt_packedchar.xoff)));
    assert(((cast(*void)(*instance.yoff)) - cast(*void)(*instance)) == 12, "stbtt_packedchar.yoff has unexpected offset % instead of 12", ((cast(*void)(*instance.yoff)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_packedchar.yoff)) == 4, "stbtt_packedchar.yoff has unexpected size % instead of 4", size_of(type_of(stbtt_packedchar.yoff)));
    assert(((cast(*void)(*instance.xadvance)) - cast(*void)(*instance)) == 16, "stbtt_packedchar.xadvance has unexpected offset % instead of 16", ((cast(*void)(*instance.xadvance)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_packedchar.xadvance)) == 4, "stbtt_packedchar.xadvance has unexpected size % instead of 4", size_of(type_of(stbtt_packedchar.xadvance)));
    assert(((cast(*void)(*instance.xoff2)) - cast(*void)(*instance)) == 20, "stbtt_packedchar.xoff2 has unexpected offset % instead of 20", ((cast(*void)(*instance.xoff2)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_packedchar.xoff2)) == 4, "stbtt_packedchar.xoff2 has unexpected size % instead of 4", size_of(type_of(stbtt_packedchar.xoff2)));
    assert(((cast(*void)(*instance.yoff2)) - cast(*void)(*instance)) == 24, "stbtt_packedchar.yoff2 has unexpected offset % instead of 24", ((cast(*void)(*instance.yoff2)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_packedchar.yoff2)) == 4, "stbtt_packedchar.yoff2 has unexpected size % instead of 4", size_of(type_of(stbtt_packedchar.yoff2)));
    assert(size_of(stbtt_packedchar) == 28, "stbtt_packedchar has size % instead of 28", size_of(stbtt_packedchar));
}

stbrp_rect :: struct {}

stbtt_PackBegin :: (spc: *stbtt_pack_context, pixels: *u8, width: s32, height: s32, stride_in_bytes: s32, padding: s32, alloc_context: *void) -> s32 #foreign stbtruetype;

// Initializes a packing context stored in the passed-in stbtt_pack_context.
// Future calls using this context will pack characters into the bitmap passed
// in here: a 1-channel bitmap that is width * height. stride_in_bytes is
// the distance from one row to the next (or 0 to mean they are packed tightly
// together). "padding" is the amount of padding to leave between each
// character (normally you want '1' for bitmaps you'll use as textures with
// bilinear filtering).
//
// Returns 0 on failure, 1 on success.
stbtt_PackEnd :: (spc: *stbtt_pack_context) -> void #foreign stbtruetype;

stbtt_PackFontRange :: (spc: *stbtt_pack_context, fontdata: *u8, font_index: s32, font_size: float, first_unicode_char_in_range: s32, num_chars_in_range: s32, chardata_for_range: *stbtt_packedchar) -> s32 #foreign stbtruetype;

// Creates character bitmaps from the font_index'th font found in fontdata (use
// font_index=0 if you don't know what that is). It creates num_chars_in_range
// bitmaps for characters with unicode values starting at first_unicode_char_in_range
// and increasing. Data for how to render them is stored in chardata_for_range;
// pass these to stbtt_GetPackedQuad to get back renderable quads.
//
// font_size is the full height of the character from ascender to descender,
// as computed by stbtt_ScaleForPixelHeight. To use a point size as computed
// by stbtt_ScaleForMappingEmToPixels, wrap the point size in STBTT_POINT_SIZE()
// and pass that result as 'font_size':
//       ...,                  20 , ... // font max minus min y is 20 pixels tall
//       ..., STBTT_POINT_SIZE(20), ... // 'M' is 20 pixels tall
stbtt_pack_range :: struct {
    font_size:                        float;
    first_unicode_codepoint_in_range: s32; // if non-zero, then the chars are continuous, and this is the first codepoint
    array_of_unicode_codepoints:      *s32; // if non-zero, then this is an array of unicode codepoints
    num_chars:                        s32;
    chardata_for_range:               *stbtt_packedchar; // output
    h_oversample:                     u8; // don't set these, they're used internally
    v_oversample:                     u8; // don't set these, they're used internally
}
#run {
    instance: stbtt_pack_range;
    assert(((cast(*void)(*instance.font_size)) - cast(*void)(*instance)) == 0, "stbtt_pack_range.font_size has unexpected offset % instead of 0", ((cast(*void)(*instance.font_size)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_pack_range.font_size)) == 4, "stbtt_pack_range.font_size has unexpected size % instead of 4", size_of(type_of(stbtt_pack_range.font_size)));
    assert(((cast(*void)(*instance.first_unicode_codepoint_in_range)) - cast(*void)(*instance)) == 4, "stbtt_pack_range.first_unicode_codepoint_in_range has unexpected offset % instead of 4", ((cast(*void)(*instance.first_unicode_codepoint_in_range)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_pack_range.first_unicode_codepoint_in_range)) == 4, "stbtt_pack_range.first_unicode_codepoint_in_range has unexpected size % instead of 4", size_of(type_of(stbtt_pack_range.first_unicode_codepoint_in_range)));
    assert(((cast(*void)(*instance.array_of_unicode_codepoints)) - cast(*void)(*instance)) == 8, "stbtt_pack_range.array_of_unicode_codepoints has unexpected offset % instead of 8", ((cast(*void)(*instance.array_of_unicode_codepoints)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_pack_range.array_of_unicode_codepoints)) == 8, "stbtt_pack_range.array_of_unicode_codepoints has unexpected size % instead of 8", size_of(type_of(stbtt_pack_range.array_of_unicode_codepoints)));
    assert(((cast(*void)(*instance.num_chars)) - cast(*void)(*instance)) == 16, "stbtt_pack_range.num_chars has unexpected offset % instead of 16", ((cast(*void)(*instance.num_chars)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_pack_range.num_chars)) == 4, "stbtt_pack_range.num_chars has unexpected size % instead of 4", size_of(type_of(stbtt_pack_range.num_chars)));
    assert(((cast(*void)(*instance.chardata_for_range)) - cast(*void)(*instance)) == 24, "stbtt_pack_range.chardata_for_range has unexpected offset % instead of 24", ((cast(*void)(*instance.chardata_for_range)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_pack_range.chardata_for_range)) == 8, "stbtt_pack_range.chardata_for_range has unexpected size % instead of 8", size_of(type_of(stbtt_pack_range.chardata_for_range)));
    assert(((cast(*void)(*instance.h_oversample)) - cast(*void)(*instance)) == 32, "stbtt_pack_range.h_oversample has unexpected offset % instead of 32", ((cast(*void)(*instance.h_oversample)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_pack_range.h_oversample)) == 1, "stbtt_pack_range.h_oversample has unexpected size % instead of 1", size_of(type_of(stbtt_pack_range.h_oversample)));
    assert(((cast(*void)(*instance.v_oversample)) - cast(*void)(*instance)) == 33, "stbtt_pack_range.v_oversample has unexpected offset % instead of 33", ((cast(*void)(*instance.v_oversample)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_pack_range.v_oversample)) == 1, "stbtt_pack_range.v_oversample has unexpected size % instead of 1", size_of(type_of(stbtt_pack_range.v_oversample)));
    assert(size_of(stbtt_pack_range) == 40, "stbtt_pack_range has size % instead of 40", size_of(stbtt_pack_range));
}

stbtt_PackFontRanges :: (spc: *stbtt_pack_context, fontdata: *u8, font_index: s32, ranges: *stbtt_pack_range, num_ranges: s32) -> s32 #foreign stbtruetype;

// Creates character bitmaps from multiple ranges of characters stored in
// ranges. This will usually create a better-packed bitmap than multiple
// calls to stbtt_PackFontRange. Note that you can call this multiple
// times within a single PackBegin/PackEnd.
stbtt_PackSetOversampling :: (spc: *stbtt_pack_context, h_oversample: u32, v_oversample: u32) -> void #foreign stbtruetype;

// Oversampling a font increases the quality by allowing higher-quality subpixel
// positioning, and is especially valuable at smaller text sizes.
//
// This function sets the amount of oversampling for all following calls to
// stbtt_PackFontRange(s) or stbtt_PackFontRangesGatherRects for a given
// pack context. The default (no oversampling) is achieved by h_oversample=1
// and v_oversample=1. The total number of pixels required is
// h_oversample*v_oversample larger than the default; for example, 2x2
// oversampling requires 4x the storage of 1x1. For best results, render
// oversampled textures with bilinear filtering. Look at the readme in
// stb/tests/oversample for information about oversampled fonts
//
// To use with PackFontRangesGather etc., you must set it before calls
// call to PackFontRangesGatherRects.
stbtt_PackSetSkipMissingCodepoints :: (spc: *stbtt_pack_context, skip: s32) -> void #foreign stbtruetype;

// If skip != 0, this tells stb_truetype to skip any codepoints for which
// there is no corresponding glyph. If skip=0, which is the default, then
// codepoints without a glyph recived the font's "missing character" glyph,
// typically an empty box by convention.
stbtt_GetPackedQuad :: (chardata: *stbtt_packedchar, pw: s32, ph: s32, char_index: s32, xpos: *float, ypos: *float, q: *stbtt_aligned_quad, align_to_integer: s32) -> void #foreign stbtruetype;

stbtt_PackFontRangesGatherRects :: (spc: *stbtt_pack_context, info: *stbtt_fontinfo, ranges: *stbtt_pack_range, num_ranges: s32, rects: *stbrp_rect) -> s32 #foreign stbtruetype;
stbtt_PackFontRangesPackRects :: (spc: *stbtt_pack_context, rects: *stbrp_rect, num_rects: s32) -> void #foreign stbtruetype;
stbtt_PackFontRangesRenderIntoRects :: (spc: *stbtt_pack_context, info: *stbtt_fontinfo, ranges: *stbtt_pack_range, num_ranges: s32, rects: *stbrp_rect) -> s32 #foreign stbtruetype;

// this is an opaque structure that you shouldn't mess with which holds
// all the context needed from PackBegin to PackEnd.
stbtt_pack_context :: struct {
    user_allocator_context: *void;
    pack_info:              *void;
    width:                  s32;
    height:                 s32;
    stride_in_bytes:        s32;
    padding:                s32;
    skip_missing:           s32;
    h_oversample:           u32;
    v_oversample:           u32;
    pixels:                 *u8;
    nodes:                  *void;
}
#run {
    instance: stbtt_pack_context;
    assert(((cast(*void)(*instance.user_allocator_context)) - cast(*void)(*instance)) == 0, "stbtt_pack_context.user_allocator_context has unexpected offset % instead of 0", ((cast(*void)(*instance.user_allocator_context)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_pack_context.user_allocator_context)) == 8, "stbtt_pack_context.user_allocator_context has unexpected size % instead of 8", size_of(type_of(stbtt_pack_context.user_allocator_context)));
    assert(((cast(*void)(*instance.pack_info)) - cast(*void)(*instance)) == 8, "stbtt_pack_context.pack_info has unexpected offset % instead of 8", ((cast(*void)(*instance.pack_info)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_pack_context.pack_info)) == 8, "stbtt_pack_context.pack_info has unexpected size % instead of 8", size_of(type_of(stbtt_pack_context.pack_info)));
    assert(((cast(*void)(*instance.width)) - cast(*void)(*instance)) == 16, "stbtt_pack_context.width has unexpected offset % instead of 16", ((cast(*void)(*instance.width)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_pack_context.width)) == 4, "stbtt_pack_context.width has unexpected size % instead of 4", size_of(type_of(stbtt_pack_context.width)));
    assert(((cast(*void)(*instance.height)) - cast(*void)(*instance)) == 20, "stbtt_pack_context.height has unexpected offset % instead of 20", ((cast(*void)(*instance.height)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_pack_context.height)) == 4, "stbtt_pack_context.height has unexpected size % instead of 4", size_of(type_of(stbtt_pack_context.height)));
    assert(((cast(*void)(*instance.stride_in_bytes)) - cast(*void)(*instance)) == 24, "stbtt_pack_context.stride_in_bytes has unexpected offset % instead of 24", ((cast(*void)(*instance.stride_in_bytes)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_pack_context.stride_in_bytes)) == 4, "stbtt_pack_context.stride_in_bytes has unexpected size % instead of 4", size_of(type_of(stbtt_pack_context.stride_in_bytes)));
    assert(((cast(*void)(*instance.padding)) - cast(*void)(*instance)) == 28, "stbtt_pack_context.padding has unexpected offset % instead of 28", ((cast(*void)(*instance.padding)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_pack_context.padding)) == 4, "stbtt_pack_context.padding has unexpected size % instead of 4", size_of(type_of(stbtt_pack_context.padding)));
    assert(((cast(*void)(*instance.skip_missing)) - cast(*void)(*instance)) == 32, "stbtt_pack_context.skip_missing has unexpected offset % instead of 32", ((cast(*void)(*instance.skip_missing)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_pack_context.skip_missing)) == 4, "stbtt_pack_context.skip_missing has unexpected size % instead of 4", size_of(type_of(stbtt_pack_context.skip_missing)));
    assert(((cast(*void)(*instance.h_oversample)) - cast(*void)(*instance)) == 36, "stbtt_pack_context.h_oversample has unexpected offset % instead of 36", ((cast(*void)(*instance.h_oversample)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_pack_context.h_oversample)) == 4, "stbtt_pack_context.h_oversample has unexpected size % instead of 4", size_of(type_of(stbtt_pack_context.h_oversample)));
    assert(((cast(*void)(*instance.v_oversample)) - cast(*void)(*instance)) == 40, "stbtt_pack_context.v_oversample has unexpected offset % instead of 40", ((cast(*void)(*instance.v_oversample)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_pack_context.v_oversample)) == 4, "stbtt_pack_context.v_oversample has unexpected size % instead of 4", size_of(type_of(stbtt_pack_context.v_oversample)));
    assert(((cast(*void)(*instance.pixels)) - cast(*void)(*instance)) == 48, "stbtt_pack_context.pixels has unexpected offset % instead of 48", ((cast(*void)(*instance.pixels)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_pack_context.pixels)) == 8, "stbtt_pack_context.pixels has unexpected size % instead of 8", size_of(type_of(stbtt_pack_context.pixels)));
    assert(((cast(*void)(*instance.nodes)) - cast(*void)(*instance)) == 56, "stbtt_pack_context.nodes has unexpected offset % instead of 56", ((cast(*void)(*instance.nodes)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_pack_context.nodes)) == 8, "stbtt_pack_context.nodes has unexpected size % instead of 8", size_of(type_of(stbtt_pack_context.nodes)));
    assert(size_of(stbtt_pack_context) == 64, "stbtt_pack_context has size % instead of 64", size_of(stbtt_pack_context));
}

//////////////////////////////////////////////////////////////////////////////
//
// FONT LOADING
//
//
stbtt_GetNumberOfFonts :: (data: *u8) -> s32 #foreign stbtruetype;

// This function will determine the number of fonts in a font file.  TrueType
// collection (.ttc) files may contain multiple fonts, while TrueType font
// (.ttf) files only contain one font. The number of fonts can be used for
// indexing with the previous function where the index is between zero and one
// less than the total fonts. If an error occurs, -1 is returned.
stbtt_GetFontOffsetForIndex :: (data: *u8, index: s32) -> s32 #foreign stbtruetype;

// The following structure is defined publicly so you can declare one on
// the stack or as a global or etc, but you should treat it as opaque.
stbtt_fontinfo :: struct {
    userdata:         *void;
    data:             *u8; // pointer to .ttf file
    fontstart:        s32; // offset of start of font

    numGlyphs:        s32; // number of glyphs, needed for range checking

    loca:             s32; // table locations as offset from start of .ttf
    head:             s32; // table locations as offset from start of .ttf
    glyf:             s32; // table locations as offset from start of .ttf
    hhea:             s32; // table locations as offset from start of .ttf
    hmtx:             s32; // table locations as offset from start of .ttf
    kern:             s32; // table locations as offset from start of .ttf
    gpos:             s32; // table locations as offset from start of .ttf
    svg:              s32; // table locations as offset from start of .ttf
    index_map:        s32; // a cmap mapping for our chosen character encoding
    indexToLocFormat: s32; // format needed to map from glyph index to glyph

    cff:              stbtt__buf; // cff font data
    charstrings:      stbtt__buf; // the charstring index
    gsubrs:           stbtt__buf; // global charstring subroutines index
    subrs:            stbtt__buf; // private charstring subroutines index
    fontdicts:        stbtt__buf; // array of font dicts
    fdselect:         stbtt__buf; // map from glyph to fontdict
}
#run {
    instance: stbtt_fontinfo;
    assert(((cast(*void)(*instance.userdata)) - cast(*void)(*instance)) == 0, "stbtt_fontinfo.userdata has unexpected offset % instead of 0", ((cast(*void)(*instance.userdata)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_fontinfo.userdata)) == 8, "stbtt_fontinfo.userdata has unexpected size % instead of 8", size_of(type_of(stbtt_fontinfo.userdata)));
    assert(((cast(*void)(*instance.data)) - cast(*void)(*instance)) == 8, "stbtt_fontinfo.data has unexpected offset % instead of 8", ((cast(*void)(*instance.data)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_fontinfo.data)) == 8, "stbtt_fontinfo.data has unexpected size % instead of 8", size_of(type_of(stbtt_fontinfo.data)));
    assert(((cast(*void)(*instance.fontstart)) - cast(*void)(*instance)) == 16, "stbtt_fontinfo.fontstart has unexpected offset % instead of 16", ((cast(*void)(*instance.fontstart)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_fontinfo.fontstart)) == 4, "stbtt_fontinfo.fontstart has unexpected size % instead of 4", size_of(type_of(stbtt_fontinfo.fontstart)));
    assert(((cast(*void)(*instance.numGlyphs)) - cast(*void)(*instance)) == 20, "stbtt_fontinfo.numGlyphs has unexpected offset % instead of 20", ((cast(*void)(*instance.numGlyphs)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_fontinfo.numGlyphs)) == 4, "stbtt_fontinfo.numGlyphs has unexpected size % instead of 4", size_of(type_of(stbtt_fontinfo.numGlyphs)));
    assert(((cast(*void)(*instance.loca)) - cast(*void)(*instance)) == 24, "stbtt_fontinfo.loca has unexpected offset % instead of 24", ((cast(*void)(*instance.loca)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_fontinfo.loca)) == 4, "stbtt_fontinfo.loca has unexpected size % instead of 4", size_of(type_of(stbtt_fontinfo.loca)));
    assert(((cast(*void)(*instance.head)) - cast(*void)(*instance)) == 28, "stbtt_fontinfo.head has unexpected offset % instead of 28", ((cast(*void)(*instance.head)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_fontinfo.head)) == 4, "stbtt_fontinfo.head has unexpected size % instead of 4", size_of(type_of(stbtt_fontinfo.head)));
    assert(((cast(*void)(*instance.glyf)) - cast(*void)(*instance)) == 32, "stbtt_fontinfo.glyf has unexpected offset % instead of 32", ((cast(*void)(*instance.glyf)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_fontinfo.glyf)) == 4, "stbtt_fontinfo.glyf has unexpected size % instead of 4", size_of(type_of(stbtt_fontinfo.glyf)));
    assert(((cast(*void)(*instance.hhea)) - cast(*void)(*instance)) == 36, "stbtt_fontinfo.hhea has unexpected offset % instead of 36", ((cast(*void)(*instance.hhea)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_fontinfo.hhea)) == 4, "stbtt_fontinfo.hhea has unexpected size % instead of 4", size_of(type_of(stbtt_fontinfo.hhea)));
    assert(((cast(*void)(*instance.hmtx)) - cast(*void)(*instance)) == 40, "stbtt_fontinfo.hmtx has unexpected offset % instead of 40", ((cast(*void)(*instance.hmtx)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_fontinfo.hmtx)) == 4, "stbtt_fontinfo.hmtx has unexpected size % instead of 4", size_of(type_of(stbtt_fontinfo.hmtx)));
    assert(((cast(*void)(*instance.kern)) - cast(*void)(*instance)) == 44, "stbtt_fontinfo.kern has unexpected offset % instead of 44", ((cast(*void)(*instance.kern)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_fontinfo.kern)) == 4, "stbtt_fontinfo.kern has unexpected size % instead of 4", size_of(type_of(stbtt_fontinfo.kern)));
    assert(((cast(*void)(*instance.gpos)) - cast(*void)(*instance)) == 48, "stbtt_fontinfo.gpos has unexpected offset % instead of 48", ((cast(*void)(*instance.gpos)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_fontinfo.gpos)) == 4, "stbtt_fontinfo.gpos has unexpected size % instead of 4", size_of(type_of(stbtt_fontinfo.gpos)));
    assert(((cast(*void)(*instance.svg)) - cast(*void)(*instance)) == 52, "stbtt_fontinfo.svg has unexpected offset % instead of 52", ((cast(*void)(*instance.svg)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_fontinfo.svg)) == 4, "stbtt_fontinfo.svg has unexpected size % instead of 4", size_of(type_of(stbtt_fontinfo.svg)));
    assert(((cast(*void)(*instance.index_map)) - cast(*void)(*instance)) == 56, "stbtt_fontinfo.index_map has unexpected offset % instead of 56", ((cast(*void)(*instance.index_map)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_fontinfo.index_map)) == 4, "stbtt_fontinfo.index_map has unexpected size % instead of 4", size_of(type_of(stbtt_fontinfo.index_map)));
    assert(((cast(*void)(*instance.indexToLocFormat)) - cast(*void)(*instance)) == 60, "stbtt_fontinfo.indexToLocFormat has unexpected offset % instead of 60", ((cast(*void)(*instance.indexToLocFormat)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_fontinfo.indexToLocFormat)) == 4, "stbtt_fontinfo.indexToLocFormat has unexpected size % instead of 4", size_of(type_of(stbtt_fontinfo.indexToLocFormat)));
    assert(((cast(*void)(*instance.cff)) - cast(*void)(*instance)) == 64, "stbtt_fontinfo.cff has unexpected offset % instead of 64", ((cast(*void)(*instance.cff)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_fontinfo.cff)) == 16, "stbtt_fontinfo.cff has unexpected size % instead of 16", size_of(type_of(stbtt_fontinfo.cff)));
    assert(((cast(*void)(*instance.charstrings)) - cast(*void)(*instance)) == 80, "stbtt_fontinfo.charstrings has unexpected offset % instead of 80", ((cast(*void)(*instance.charstrings)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_fontinfo.charstrings)) == 16, "stbtt_fontinfo.charstrings has unexpected size % instead of 16", size_of(type_of(stbtt_fontinfo.charstrings)));
    assert(((cast(*void)(*instance.gsubrs)) - cast(*void)(*instance)) == 96, "stbtt_fontinfo.gsubrs has unexpected offset % instead of 96", ((cast(*void)(*instance.gsubrs)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_fontinfo.gsubrs)) == 16, "stbtt_fontinfo.gsubrs has unexpected size % instead of 16", size_of(type_of(stbtt_fontinfo.gsubrs)));
    assert(((cast(*void)(*instance.subrs)) - cast(*void)(*instance)) == 112, "stbtt_fontinfo.subrs has unexpected offset % instead of 112", ((cast(*void)(*instance.subrs)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_fontinfo.subrs)) == 16, "stbtt_fontinfo.subrs has unexpected size % instead of 16", size_of(type_of(stbtt_fontinfo.subrs)));
    assert(((cast(*void)(*instance.fontdicts)) - cast(*void)(*instance)) == 128, "stbtt_fontinfo.fontdicts has unexpected offset % instead of 128", ((cast(*void)(*instance.fontdicts)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_fontinfo.fontdicts)) == 16, "stbtt_fontinfo.fontdicts has unexpected size % instead of 16", size_of(type_of(stbtt_fontinfo.fontdicts)));
    assert(((cast(*void)(*instance.fdselect)) - cast(*void)(*instance)) == 144, "stbtt_fontinfo.fdselect has unexpected offset % instead of 144", ((cast(*void)(*instance.fdselect)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_fontinfo.fdselect)) == 16, "stbtt_fontinfo.fdselect has unexpected size % instead of 16", size_of(type_of(stbtt_fontinfo.fdselect)));
    assert(size_of(stbtt_fontinfo) == 160, "stbtt_fontinfo has size % instead of 160", size_of(stbtt_fontinfo));
}

stbtt_InitFont :: (info: *stbtt_fontinfo, data: *u8, offset: s32) -> s32 #foreign stbtruetype;

//////////////////////////////////////////////////////////////////////////////
//
// CHARACTER TO GLYPH-INDEX CONVERSIOn
stbtt_FindGlyphIndex :: (info: *stbtt_fontinfo, unicode_codepoint: s32) -> s32 #foreign stbtruetype;

//////////////////////////////////////////////////////////////////////////////
//
// CHARACTER PROPERTIES
//
stbtt_ScaleForPixelHeight :: (info: *stbtt_fontinfo, pixels: float) -> float #foreign stbtruetype;

// computes a scale factor to produce a font whose "height" is 'pixels' tall.
// Height is measured as the distance from the highest ascender to the lowest
// descender; in other words, it's equivalent to calling stbtt_GetFontVMetrics
// and computing:
//       scale = pixels / (ascent - descent)
// so if you prefer to measure height by the ascent only, use a similar calculation.
stbtt_ScaleForMappingEmToPixels :: (info: *stbtt_fontinfo, pixels: float) -> float #foreign stbtruetype;

// computes a scale factor to produce a font whose EM size is mapped to
// 'pixels' tall. This is probably what traditional APIs compute, but
// I'm not positive.
stbtt_GetFontVMetrics :: (info: *stbtt_fontinfo, ascent: *s32, descent: *s32, lineGap: *s32) -> void #foreign stbtruetype;

// ascent is the coordinate above the baseline the font extends; descent
// is the coordinate below the baseline the font extends (i.e. it is typically negative)
// lineGap is the spacing between one row's descent and the next row's ascent...
// so you should advance the vertical position by "*ascent - *descent + *lineGap"
//   these are expressed in unscaled coordinates, so you must multiply by
//   the scale factor for a given size
stbtt_GetFontVMetricsOS2 :: (info: *stbtt_fontinfo, typoAscent: *s32, typoDescent: *s32, typoLineGap: *s32) -> s32 #foreign stbtruetype;

// analogous to GetFontVMetrics, but returns the "typographic" values from the OS/2
// table (specific to MS/Windows TTF files).
//
// Returns 1 on success (table present), 0 on failure.
stbtt_GetFontBoundingBox :: (info: *stbtt_fontinfo, x0: *s32, y0: *s32, x1: *s32, y1: *s32) -> void #foreign stbtruetype;

// the bounding box around all possible characters
stbtt_GetCodepointHMetrics :: (info: *stbtt_fontinfo, codepoint: s32, advanceWidth: *s32, leftSideBearing: *s32) -> void #foreign stbtruetype;

// leftSideBearing is the offset from the current horizontal position to the left edge of the character
// advanceWidth is the offset from the current horizontal position to the next horizontal position
//   these are expressed in unscaled coordinates
stbtt_GetCodepointKernAdvance :: (info: *stbtt_fontinfo, ch1: s32, ch2: s32) -> s32 #foreign stbtruetype;

// an additional amount to add to the 'advance' value between ch1 and ch2
stbtt_GetCodepointBox :: (info: *stbtt_fontinfo, codepoint: s32, x0: *s32, y0: *s32, x1: *s32, y1: *s32) -> s32 #foreign stbtruetype;

// Gets the bounding box of the visible part of the glyph, in unscaled coordinates
stbtt_GetGlyphHMetrics :: (info: *stbtt_fontinfo, glyph_index: s32, advanceWidth: *s32, leftSideBearing: *s32) -> void #foreign stbtruetype;
stbtt_GetGlyphKernAdvance :: (info: *stbtt_fontinfo, glyph1: s32, glyph2: s32) -> s32 #foreign stbtruetype;
stbtt_GetGlyphBox :: (info: *stbtt_fontinfo, glyph_index: s32, x0: *s32, y0: *s32, x1: *s32, y1: *s32) -> s32 #foreign stbtruetype;

// as above, but takes one or more glyph indices for greater efficiency
stbtt_kerningentry :: struct {
    glyph1:  s32; // use stbtt_FindGlyphIndex
    glyph2:  s32;
    advance: s32;
}
#run {
    instance: stbtt_kerningentry;
    assert(((cast(*void)(*instance.glyph1)) - cast(*void)(*instance)) == 0, "stbtt_kerningentry.glyph1 has unexpected offset % instead of 0", ((cast(*void)(*instance.glyph1)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_kerningentry.glyph1)) == 4, "stbtt_kerningentry.glyph1 has unexpected size % instead of 4", size_of(type_of(stbtt_kerningentry.glyph1)));
    assert(((cast(*void)(*instance.glyph2)) - cast(*void)(*instance)) == 4, "stbtt_kerningentry.glyph2 has unexpected offset % instead of 4", ((cast(*void)(*instance.glyph2)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_kerningentry.glyph2)) == 4, "stbtt_kerningentry.glyph2 has unexpected size % instead of 4", size_of(type_of(stbtt_kerningentry.glyph2)));
    assert(((cast(*void)(*instance.advance)) - cast(*void)(*instance)) == 8, "stbtt_kerningentry.advance has unexpected offset % instead of 8", ((cast(*void)(*instance.advance)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_kerningentry.advance)) == 4, "stbtt_kerningentry.advance has unexpected size % instead of 4", size_of(type_of(stbtt_kerningentry.advance)));
    assert(size_of(stbtt_kerningentry) == 12, "stbtt_kerningentry has size % instead of 12", size_of(stbtt_kerningentry));
}

stbtt_GetKerningTableLength :: (info: *stbtt_fontinfo) -> s32 #foreign stbtruetype;
stbtt_GetKerningTable :: (info: *stbtt_fontinfo, table: *stbtt_kerningentry, table_length: s32) -> s32 #foreign stbtruetype;

STBTT :: enum s32 {
    vmove  :: 1;
    vline  :: 2;
    vcurve :: 3;
    vcubic :: 4;

    STBTT_vmove  :: vmove;
    STBTT_vline  :: vline;
    STBTT_vcurve :: vcurve;
    STBTT_vcubic :: vcubic;
}

stbtt_vertex :: struct {
    x:       s16;
    y:       s16;
    cx:      s16;
    cy:      s16;
    cx1:     s16;
    cy1:     s16;
    type:    u8;
    padding: u8;
}
#run {
    instance: stbtt_vertex;
    assert(((cast(*void)(*instance.x)) - cast(*void)(*instance)) == 0, "stbtt_vertex.x has unexpected offset % instead of 0", ((cast(*void)(*instance.x)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_vertex.x)) == 2, "stbtt_vertex.x has unexpected size % instead of 2", size_of(type_of(stbtt_vertex.x)));
    assert(((cast(*void)(*instance.y)) - cast(*void)(*instance)) == 2, "stbtt_vertex.y has unexpected offset % instead of 2", ((cast(*void)(*instance.y)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_vertex.y)) == 2, "stbtt_vertex.y has unexpected size % instead of 2", size_of(type_of(stbtt_vertex.y)));
    assert(((cast(*void)(*instance.cx)) - cast(*void)(*instance)) == 4, "stbtt_vertex.cx has unexpected offset % instead of 4", ((cast(*void)(*instance.cx)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_vertex.cx)) == 2, "stbtt_vertex.cx has unexpected size % instead of 2", size_of(type_of(stbtt_vertex.cx)));
    assert(((cast(*void)(*instance.cy)) - cast(*void)(*instance)) == 6, "stbtt_vertex.cy has unexpected offset % instead of 6", ((cast(*void)(*instance.cy)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_vertex.cy)) == 2, "stbtt_vertex.cy has unexpected size % instead of 2", size_of(type_of(stbtt_vertex.cy)));
    assert(((cast(*void)(*instance.cx1)) - cast(*void)(*instance)) == 8, "stbtt_vertex.cx1 has unexpected offset % instead of 8", ((cast(*void)(*instance.cx1)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_vertex.cx1)) == 2, "stbtt_vertex.cx1 has unexpected size % instead of 2", size_of(type_of(stbtt_vertex.cx1)));
    assert(((cast(*void)(*instance.cy1)) - cast(*void)(*instance)) == 10, "stbtt_vertex.cy1 has unexpected offset % instead of 10", ((cast(*void)(*instance.cy1)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_vertex.cy1)) == 2, "stbtt_vertex.cy1 has unexpected size % instead of 2", size_of(type_of(stbtt_vertex.cy1)));
    assert(((cast(*void)(*instance.type)) - cast(*void)(*instance)) == 12, "stbtt_vertex.type has unexpected offset % instead of 12", ((cast(*void)(*instance.type)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_vertex.type)) == 1, "stbtt_vertex.type has unexpected size % instead of 1", size_of(type_of(stbtt_vertex.type)));
    assert(((cast(*void)(*instance.padding)) - cast(*void)(*instance)) == 13, "stbtt_vertex.padding has unexpected offset % instead of 13", ((cast(*void)(*instance.padding)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt_vertex.padding)) == 1, "stbtt_vertex.padding has unexpected size % instead of 1", size_of(type_of(stbtt_vertex.padding)));
    assert(size_of(stbtt_vertex) == 14, "stbtt_vertex has size % instead of 14", size_of(stbtt_vertex));
}

stbtt_IsGlyphEmpty :: (info: *stbtt_fontinfo, glyph_index: s32) -> s32 #foreign stbtruetype;

// returns non-zero if nothing is drawn for this glyph
stbtt_GetCodepointShape :: (info: *stbtt_fontinfo, unicode_codepoint: s32, vertices: **stbtt_vertex) -> s32 #foreign stbtruetype;
stbtt_GetGlyphShape :: (info: *stbtt_fontinfo, glyph_index: s32, vertices: **stbtt_vertex) -> s32 #foreign stbtruetype;

// returns # of vertices and fills *vertices with the pointer to them
//   these are expressed in "unscaled" coordinates
//
// The shape is a series of contours. Each one starts with
// a STBTT_moveto, then consists of a series of mixed
// STBTT_lineto and STBTT_curveto segments. A lineto
// draws a line from previous endpoint to its x,y; a curveto
// draws a quadratic bezier from previous endpoint to
// its x,y, using cx,cy as the bezier control point.
stbtt_FreeShape :: (info: *stbtt_fontinfo, vertices: *stbtt_vertex) -> void #foreign stbtruetype;

// frees the data allocated above
stbtt_FindSVGDoc :: (info: *stbtt_fontinfo, gl: s32) -> *u8 #foreign stbtruetype;
stbtt_GetCodepointSVG :: (info: *stbtt_fontinfo, unicode_codepoint: s32, svg: **u8) -> s32 #foreign stbtruetype;
stbtt_GetGlyphSVG :: (info: *stbtt_fontinfo, gl: s32, svg: **u8) -> s32 #foreign stbtruetype;

//////////////////////////////////////////////////////////////////////////////
//
// BITMAP RENDERING
//
stbtt_FreeBitmap :: (bitmap: *u8, userdata: *void) -> void #foreign stbtruetype;

// frees the bitmap allocated below
stbtt_GetCodepointBitmap :: (info: *stbtt_fontinfo, scale_x: float, scale_y: float, codepoint: s32, width: *s32, height: *s32, xoff: *s32, yoff: *s32) -> *u8 #foreign stbtruetype;

// allocates a large-enough single-channel 8bpp bitmap and renders the
// specified character/glyph at the specified scale into it, with
// antialiasing. 0 is no coverage (transparent), 255 is fully covered (opaque).
// *width & *height are filled out with the width & height of the bitmap,
// which is stored left-to-right, top-to-bottom.
//
// xoff/yoff are the offset it pixel space from the glyph origin to the top-left of the bitmap
stbtt_GetCodepointBitmapSubpixel :: (info: *stbtt_fontinfo, scale_x: float, scale_y: float, shift_x: float, shift_y: float, codepoint: s32, width: *s32, height: *s32, xoff: *s32, yoff: *s32) -> *u8 #foreign stbtruetype;

// the same as stbtt_GetCodepoitnBitmap, but you can specify a subpixel
// shift for the character
stbtt_MakeCodepointBitmap :: (info: *stbtt_fontinfo, output: *u8, out_w: s32, out_h: s32, out_stride: s32, scale_x: float, scale_y: float, codepoint: s32) -> void #foreign stbtruetype;

// the same as stbtt_GetCodepointBitmap, but you pass in storage for the bitmap
// in the form of 'output', with row spacing of 'out_stride' bytes. the bitmap
// is clipped to out_w/out_h bytes. Call stbtt_GetCodepointBitmapBox to get the
// width and height and positioning info for it first.
stbtt_MakeCodepointBitmapSubpixel :: (info: *stbtt_fontinfo, output: *u8, out_w: s32, out_h: s32, out_stride: s32, scale_x: float, scale_y: float, shift_x: float, shift_y: float, codepoint: s32) -> void #foreign stbtruetype;

// same as stbtt_MakeCodepointBitmap, but you can specify a subpixel
// shift for the character
stbtt_MakeCodepointBitmapSubpixelPrefilter :: (info: *stbtt_fontinfo, output: *u8, out_w: s32, out_h: s32, out_stride: s32, scale_x: float, scale_y: float, shift_x: float, shift_y: float, oversample_x: s32, oversample_y: s32, sub_x: *float, sub_y: *float, codepoint: s32) -> void #foreign stbtruetype;

// same as stbtt_MakeCodepointBitmapSubpixel, but prefiltering
// is performed (see stbtt_PackSetOversampling)
stbtt_GetCodepointBitmapBox :: (font: *stbtt_fontinfo, codepoint: s32, scale_x: float, scale_y: float, ix0: *s32, iy0: *s32, ix1: *s32, iy1: *s32) -> void #foreign stbtruetype;

// get the bbox of the bitmap centered around the glyph origin; so the
// bitmap width is ix1-ix0, height is iy1-iy0, and location to place
// the bitmap top left is (leftSideBearing*scale,iy0).
// (Note that the bitmap uses y-increases-down, but the shape uses
// y-increases-up, so CodepointBitmapBox and CodepointBox are inverted.)
stbtt_GetCodepointBitmapBoxSubpixel :: (font: *stbtt_fontinfo, codepoint: s32, scale_x: float, scale_y: float, shift_x: float, shift_y: float, ix0: *s32, iy0: *s32, ix1: *s32, iy1: *s32) -> void #foreign stbtruetype;

// the following functions are equivalent to the above functions, but operate
// on glyph indices instead of Unicode codepoints (for efficiency)
stbtt_GetGlyphBitmap :: (info: *stbtt_fontinfo, scale_x: float, scale_y: float, glyph: s32, width: *s32, height: *s32, xoff: *s32, yoff: *s32) -> *u8 #foreign stbtruetype;
stbtt_GetGlyphBitmapSubpixel :: (info: *stbtt_fontinfo, scale_x: float, scale_y: float, shift_x: float, shift_y: float, glyph: s32, width: *s32, height: *s32, xoff: *s32, yoff: *s32) -> *u8 #foreign stbtruetype;
stbtt_MakeGlyphBitmap :: (info: *stbtt_fontinfo, output: *u8, out_w: s32, out_h: s32, out_stride: s32, scale_x: float, scale_y: float, glyph: s32) -> void #foreign stbtruetype;
stbtt_MakeGlyphBitmapSubpixel :: (info: *stbtt_fontinfo, output: *u8, out_w: s32, out_h: s32, out_stride: s32, scale_x: float, scale_y: float, shift_x: float, shift_y: float, glyph: s32) -> void #foreign stbtruetype;
stbtt_MakeGlyphBitmapSubpixelPrefilter :: (info: *stbtt_fontinfo, output: *u8, out_w: s32, out_h: s32, out_stride: s32, scale_x: float, scale_y: float, shift_x: float, shift_y: float, oversample_x: s32, oversample_y: s32, sub_x: *float, sub_y: *float, glyph: s32) -> void #foreign stbtruetype;
stbtt_GetGlyphBitmapBox :: (font: *stbtt_fontinfo, glyph: s32, scale_x: float, scale_y: float, ix0: *s32, iy0: *s32, ix1: *s32, iy1: *s32) -> void #foreign stbtruetype;
stbtt_GetGlyphBitmapBoxSubpixel :: (font: *stbtt_fontinfo, glyph: s32, scale_x: float, scale_y: float, shift_x: float, shift_y: float, ix0: *s32, iy0: *s32, ix1: *s32, iy1: *s32) -> void #foreign stbtruetype;

// @TODO: don't expose this structure
stbtt__bitmap :: struct {
    w:      s32;
    h:      s32;
    stride: s32;
    pixels: *u8;
}
#run {
    instance: stbtt__bitmap;
    assert(((cast(*void)(*instance.w)) - cast(*void)(*instance)) == 0, "stbtt__bitmap.w has unexpected offset % instead of 0", ((cast(*void)(*instance.w)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt__bitmap.w)) == 4, "stbtt__bitmap.w has unexpected size % instead of 4", size_of(type_of(stbtt__bitmap.w)));
    assert(((cast(*void)(*instance.h)) - cast(*void)(*instance)) == 4, "stbtt__bitmap.h has unexpected offset % instead of 4", ((cast(*void)(*instance.h)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt__bitmap.h)) == 4, "stbtt__bitmap.h has unexpected size % instead of 4", size_of(type_of(stbtt__bitmap.h)));
    assert(((cast(*void)(*instance.stride)) - cast(*void)(*instance)) == 8, "stbtt__bitmap.stride has unexpected offset % instead of 8", ((cast(*void)(*instance.stride)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt__bitmap.stride)) == 4, "stbtt__bitmap.stride has unexpected size % instead of 4", size_of(type_of(stbtt__bitmap.stride)));
    assert(((cast(*void)(*instance.pixels)) - cast(*void)(*instance)) == 16, "stbtt__bitmap.pixels has unexpected offset % instead of 16", ((cast(*void)(*instance.pixels)) - cast(*void)(*instance)));
    assert(size_of(type_of(stbtt__bitmap.pixels)) == 8, "stbtt__bitmap.pixels has unexpected size % instead of 8", size_of(type_of(stbtt__bitmap.pixels)));
    assert(size_of(stbtt__bitmap) == 24, "stbtt__bitmap has size % instead of 24", size_of(stbtt__bitmap));
}

// rasterize a shape with quadratic beziers into a bitmap
stbtt_Rasterize :: (result: *stbtt__bitmap, flatness_in_pixels: float, vertices: *stbtt_vertex, num_verts: s32, scale_x: float, scale_y: float, shift_x: float, shift_y: float, x_off: s32, y_off: s32, invert: s32, userdata: *void) -> void #foreign stbtruetype;

//////////////////////////////////////////////////////////////////////////////
//
// Signed Distance Function (or Field) rendering
stbtt_FreeSDF :: (bitmap: *u8, userdata: *void) -> void #foreign stbtruetype;

// frees the SDF bitmap allocated below
stbtt_GetGlyphSDF :: (info: *stbtt_fontinfo, scale: float, glyph: s32, padding: s32, onedge_value: u8, pixel_dist_scale: float, width: *s32, height: *s32, xoff: *s32, yoff: *s32) -> *u8 #foreign stbtruetype;
stbtt_GetCodepointSDF :: (info: *stbtt_fontinfo, scale: float, codepoint: s32, padding: s32, onedge_value: u8, pixel_dist_scale: float, width: *s32, height: *s32, xoff: *s32, yoff: *s32) -> *u8 #foreign stbtruetype;

//////////////////////////////////////////////////////////////////////////////
//
// Finding the right font...
//
// You should really just solve this offline, keep your own tables
// of what font is what, and don't try to get it out of the .ttf file.
// That's because getting it out of the .ttf file is really hard, because
// the names in the file can appear in many possible encodings, in many
// possible languages, and e.g. if you need a case-insensitive comparison,
// the details of that depend on the encoding & language in a complex way
// (actually underspecified in truetype, but also gigantic).
//
// But you can use the provided functions in two possible ways:
//     stbtt_FindMatchingFont() will use *case-sensitive* comparisons on
//             unicode-encoded names to try to find the font you want;
//             you can run this before calling stbtt_InitFont()
//
//     stbtt_GetFontNameString() lets you get any of the various strings
//             from the file yourself and do your own comparisons on them.
//             You have to have called stbtt_InitFont() first.
stbtt_FindMatchingFont :: (fontdata: *u8, name: *u8, flags: s32) -> s32 #foreign stbtruetype;

stbtt_CompareUTF8toUTF16_bigendian :: (s1: *u8, len1: s32, s2: *u8, len2: s32) -> s32 #foreign stbtruetype;

// returns 1/0 whether the first string interpreted as utf8 is identical to
// the second string interpreted as big-endian utf16... useful for strings from next func
stbtt_GetFontNameString :: (font: *stbtt_fontinfo, length: *s32, platformID: s32, encodingID: s32, languageID: s32, nameID: s32) -> *u8 #foreign stbtruetype;

// returns the string (which may be big-endian double byte, e.g. for unicode)
// and puts the length in bytes in *length.
//
// some of the values for the IDs are below; for more see the truetype spec:
//     http://developer.apple.com/textfonts/TTRefMan/RM06/Chap6name.html
//     http://www.microsoft.com/typography/otspec/name.htm
STBTT_PLATFORM_ID :: enum s32 {
    UNICODE   :: 0;
    MAC       :: 1;
    ISO       :: 2;
    MICROSOFT :: 3;

    STBTT_PLATFORM_ID_UNICODE   :: UNICODE;
    STBTT_PLATFORM_ID_MAC       :: MAC;
    STBTT_PLATFORM_ID_ISO       :: ISO;
    STBTT_PLATFORM_ID_MICROSOFT :: MICROSOFT;
}

STBTT_UNICODE_EID :: enum s32 {
    UNICODE_1_0      :: 0;
    UNICODE_1_1      :: 1;
    ISO_10646        :: 2;
    UNICODE_2_0_BMP  :: 3;
    UNICODE_2_0_FULL :: 4;

    STBTT_UNICODE_EID_UNICODE_1_0      :: UNICODE_1_0;
    STBTT_UNICODE_EID_UNICODE_1_1      :: UNICODE_1_1;
    STBTT_UNICODE_EID_ISO_10646        :: ISO_10646;
    STBTT_UNICODE_EID_UNICODE_2_0_BMP  :: UNICODE_2_0_BMP;
    STBTT_UNICODE_EID_UNICODE_2_0_FULL :: UNICODE_2_0_FULL;
}

STBTT_MS_EID :: enum s32 {
    SYMBOL       :: 0;
    UNICODE_BMP  :: 1;
    SHIFTJIS     :: 2;
    UNICODE_FULL :: 10;

    STBTT_MS_EID_SYMBOL       :: SYMBOL;
    STBTT_MS_EID_UNICODE_BMP  :: UNICODE_BMP;
    STBTT_MS_EID_SHIFTJIS     :: SHIFTJIS;
    STBTT_MS_EID_UNICODE_FULL :: UNICODE_FULL;
}

STBTT_MAC_EID :: enum s32 {
    ROMAN        :: 0;
    ARABIC       :: 4;
    JAPANESE     :: 1;
    HEBREW       :: 5;
    CHINESE_TRAD :: 2;
    GREEK        :: 6;
    KOREAN       :: 3;
    RUSSIAN      :: 7;

    STBTT_MAC_EID_ROMAN        :: ROMAN;
    STBTT_MAC_EID_ARABIC       :: ARABIC;
    STBTT_MAC_EID_JAPANESE     :: JAPANESE;
    STBTT_MAC_EID_HEBREW       :: HEBREW;
    STBTT_MAC_EID_CHINESE_TRAD :: CHINESE_TRAD;
    STBTT_MAC_EID_GREEK        :: GREEK;
    STBTT_MAC_EID_KOREAN       :: KOREAN;
    STBTT_MAC_EID_RUSSIAN      :: RUSSIAN;
}

STBTT_MS_LANG :: enum s32 {
    ENGLISH  :: 1033;
    ITALIAN  :: 1040;
    CHINESE  :: 2052;
    JAPANESE :: 1041;
    DUTCH    :: 1043;
    KOREAN   :: 1042;
    FRENCH   :: 1036;
    RUSSIAN  :: 1049;
    GERMAN   :: 1031;
    SPANISH  :: 1033;
    HEBREW   :: 1037;
    SWEDISH  :: 1053;

    STBTT_MS_LANG_ENGLISH  :: ENGLISH;
    STBTT_MS_LANG_ITALIAN  :: ITALIAN;
    STBTT_MS_LANG_CHINESE  :: CHINESE;
    STBTT_MS_LANG_JAPANESE :: JAPANESE;
    STBTT_MS_LANG_DUTCH    :: DUTCH;
    STBTT_MS_LANG_KOREAN   :: KOREAN;
    STBTT_MS_LANG_FRENCH   :: FRENCH;
    STBTT_MS_LANG_RUSSIAN  :: RUSSIAN;
    STBTT_MS_LANG_GERMAN   :: GERMAN;
    STBTT_MS_LANG_SPANISH  :: SPANISH;
    STBTT_MS_LANG_HEBREW   :: HEBREW;
    STBTT_MS_LANG_SWEDISH  :: SWEDISH;
}

STBTT_MAC_LANG :: enum s32 {
    ENGLISH            :: 0;
    JAPANESE           :: 11;
    ARABIC             :: 12;
    KOREAN             :: 23;
    DUTCH              :: 4;
    RUSSIAN            :: 32;
    FRENCH             :: 1;
    SPANISH            :: 6;
    GERMAN             :: 2;
    SWEDISH            :: 5;
    HEBREW             :: 10;
    CHINESE_SIMPLIFIED :: 33;
    ITALIAN            :: 3;
    CHINESE_TRAD       :: 19;

    STBTT_MAC_LANG_ENGLISH            :: ENGLISH;
    STBTT_MAC_LANG_JAPANESE           :: JAPANESE;
    STBTT_MAC_LANG_ARABIC             :: ARABIC;
    STBTT_MAC_LANG_KOREAN             :: KOREAN;
    STBTT_MAC_LANG_DUTCH              :: DUTCH;
    STBTT_MAC_LANG_RUSSIAN            :: RUSSIAN;
    STBTT_MAC_LANG_FRENCH             :: FRENCH;
    STBTT_MAC_LANG_SPANISH            :: SPANISH;
    STBTT_MAC_LANG_GERMAN             :: GERMAN;
    STBTT_MAC_LANG_SWEDISH            :: SWEDISH;
    STBTT_MAC_LANG_HEBREW             :: HEBREW;
    STBTT_MAC_LANG_CHINESE_SIMPLIFIED :: CHINESE_SIMPLIFIED;
    STBTT_MAC_LANG_ITALIAN            :: ITALIAN;
    STBTT_MAC_LANG_CHINESE_TRAD       :: CHINESE_TRAD;
}

#scope_file

#import "Basic"; // For assert

stbtruetype :: #library,no_dll "./stbtruetype";
