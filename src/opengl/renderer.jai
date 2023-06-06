#scope_file


#scope_export

global_renderer : Renderer;

Vertex :: struct {
    pos: Vector3;
    normal: Vector3;
    uv: Vector2;
    color: Vector4;

    enable_attrib :: () {
        offset : *Vertex: null;
        stride : u32 = size_of(Vertex);

        loc : u32 = 0;
        glEnableVertexAttribArray(loc); // Position
        glVertexAttribPointer(loc, 3, GL_FLOAT, xx false, stride, *offset.pos);

        loc += 1;
        glEnableVertexAttribArray(loc); // Normal 
        glVertexAttribPointer(loc, 3, GL_FLOAT, xx false, stride, *offset.normal);

        loc += 1;
        glEnableVertexAttribArray(loc); // uv 
        glVertexAttribPointer(loc, 2, GL_FLOAT, xx false, stride, *offset.uv);

        loc += 1;
        glEnableVertexAttribArray(loc); // color 
        glVertexAttribPointer(loc, 4, GL_FLOAT, xx false, stride, *offset.color);
    }
}

Renderer :: struct {
    _gl_context: SDL_GLContext;
    window: *SDL_Window;

    vao: GLuint;
    vbo: GLuint;

    current_shader: Shader;

    standard_shader: Shader;
    screen_space_shader: Shader;
    shadowmap_shader: Shader;

    width: s32;
    height: s32;

    immediate_vertices: [..]Vertex;

    default_texture: Texture;
    shadowmap_target: Render_Texture;

    current_target: *Render_Texture;   

    projection: Matrix4; 
    light_matrix: Matrix4; 
}

renderer_init :: (window: *SDL_Window) -> Renderer {
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, xx SDL_GL_CONTEXT_PROFILE_CORE);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3);

    SDL_GL_SetAttribute(SDL_GL_MULTISAMPLEBUFFERS, 1);
    SDL_GL_SetAttribute(SDL_GL_MULTISAMPLESAMPLES, 4);

    global_renderer._gl_context = SDL_GL_CreateContext(window);
    assert(global_renderer._gl_context != null);
    gl_load(*gl);
    gl_enable_debug_output(break_on_error = true);

    glEnable(GL_MULTISAMPLE);

    glGenVertexArrays(1, *global_renderer.vao);
    glGenBuffers(1, *global_renderer.vbo);
    glBindVertexArray(global_renderer.vao);
    glBindBuffer(GL_ARRAY_BUFFER, global_renderer.vbo);
    Vertex.enable_attrib();

    global_renderer.default_texture = Texture.init();
    Texture.bind(global_renderer.default_texture);
    data := u8.[255, 255, 255, 255];
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 1, 1, 0, GL_RGBA, GL_UNSIGNED_BYTE, *data);

    global_renderer.standard_shader = Shader.load(STANDARD, "STANDARD");
    use_shader(global_renderer.standard_shader);
    Shader.set_uniform(*global_renderer.standard_shader, "Model", Matrix4_Identity);
    Shader.set_uniform(*global_renderer.standard_shader, "View", Matrix4_Identity);
    Shader.set_uniform(*global_renderer.standard_shader, "texture0", 0, true);
    Shader.set_uniform(*global_renderer.standard_shader, "shadow_map", 1, true);
    
    global_renderer.screen_space_shader = Shader.load(SCREEN_SPACE_SHADER, "SCREEN_SPACE_SHADER");
    global_renderer.shadowmap_shader = Shader.load(SHADOWMAP_SHADER, "SHADOWMAP_SHADER");

    update_window(window);
    render_to_window();
    use_default_texture();

    global_renderer.projection = make_projection_matrix(60 * PI / 180.0, cast(float)global_renderer.width / cast(float)global_renderer.height, 0.1, 1000);
    global_renderer.shadowmap_target = Render_Texture.init_depth(1024, 1024);
    global_renderer.light_matrix = make_look_at_matrix(.{0, 0, 0}, unit_vector(.{-1, -1, -1}), .{0, 1, 0}, false) * orthographic_projection_matrix(-50, 50, -50, 50, -50, 50);

    return global_renderer;
}

renderer_deinit :: () {
    using global_renderer;
    glDeleteVertexArrays(1, *vao);
    glDeleteBuffers(1, *vbo);
}

clear :: (color: Vector4) {
    glClearColor(color.x, color.y, color.z, color.w);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

update_window :: (window: *SDL_Window) {
    SDL_GetWindowSize(window, *global_renderer.width, *global_renderer.height);
    global_renderer.window = window;
}

get_window_dims :: () -> Vector2i {
    return .{global_renderer.width, global_renderer.height};
}

flush :: () {
    using global_renderer;
    if immediate_vertices.count == 0 then return; // Nothing to draw

    glBindVertexArray(vao);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);

    glBufferData(GL_ARRAY_BUFFER, immediate_vertices.count * size_of(Vertex), immediate_vertices.data, GL_STREAM_DRAW);
    glDrawArrays(GL_TRIANGLES, 0, xx immediate_vertices.count);

    immediate_vertices.count = 0;
}

end_drawing :: () {
    using global_renderer;
    flush();
    SDL_GL_SwapWindow(window);
}

render_to_texture :: (tex: *Render_Texture) {
    if global_renderer.current_target != null {
        Render_Texture.maybe_resolve(global_renderer.current_target);
    }
    global_renderer.current_target = tex;
    glBindFramebuffer(GL_FRAMEBUFFER, tex.framebuffer);
    glViewport(0, 0, xx tex.width, xx tex.height);
}

render_to_window :: () { 
    if global_renderer.current_target != null {
        Render_Texture.maybe_resolve(global_renderer.current_target);
    }
    global_renderer.current_target = null;
    glBindFramebuffer(GL_FRAMEBUFFER, 0);

    glViewport(0, 0, xx global_renderer.width, xx global_renderer.height);
}

begin_3d :: (view: Matrix4) {
    flush();  
    use_shader(*global_renderer.standard_shader);
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, global_renderer.shadowmap_target.texture.handle);
    glActiveTexture(GL_TEXTURE0);
    Shader.set_uniform(*global_renderer.standard_shader, "View", view);
    Shader.set_uniform(*global_renderer.standard_shader, "Projection", global_renderer.projection);
    Shader.set_uniform(*global_renderer.standard_shader, "Light", global_renderer.light_matrix);
    glDisable(GL_BLEND);
    glEnable(GL_DEPTH_TEST);
}

begin_shadowmap :: () {
    flush();
    use_shader(*global_renderer.shadowmap_shader);
    render_to_texture(*global_renderer.shadowmap_target);
    glClear(GL_DEPTH_BUFFER_BIT);
    Shader.set_uniform(*global_renderer.shadowmap_shader, "Light", global_renderer.light_matrix);
    glDisable(GL_BLEND);
    glEnable(GL_DEPTH_TEST);
}

end_shadowmap :: () {
    flush();
    render_to_window();
}

begin_2d :: () {
    flush();
    use_shader(*global_renderer.screen_space_shader);
    glEnable(GL_BLEND);
    glDisable(GL_DEPTH_TEST);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    if global_renderer.current_target == null {
        Shader.set_uniform(*global_renderer.screen_space_shader, "Projection", orthographic_projection_matrix(0, xx global_renderer.width, xx global_renderer.height, 0, -1, 1));
    } else {
        Shader.set_uniform(*global_renderer.screen_space_shader, "Projection", orthographic_projection_matrix(0, xx global_renderer.current_target.width, xx global_renderer.current_target.height, 0, -1, 1));
    }
}

use_shader :: (shader : Shader) {
    global_renderer.current_shader = shader;
    glUseProgram(shader.handle);
}

set_model_matrix :: (mat: Matrix4) {
    flush();
    Shader.set_uniform(global_renderer.current_shader, "Model", mat);
}

// --------
// Triangles 

push_vertex :: (vertex: Vertex) {
    array_add(*global_renderer.immediate_vertices, vertex);
}

draw_quad :: (p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3, normal: Vector3, color: Vector4 = .{1, 1, 1, 1}) {
    push_vertex(Vertex.{ p0, normal, Vector2.{0.0, 0.0}, color });
    push_vertex(Vertex.{ p1, normal, Vector2.{1.0, 0.0}, color });
    push_vertex(Vertex.{ p2, normal, Vector2.{1.0, 1.0}, color });
    push_vertex(Vertex.{ p0, normal, Vector2.{0.0, 0.0}, color });
    push_vertex(Vertex.{ p2, normal, Vector2.{1.0, 1.0}, color });
    push_vertex(Vertex.{ p3, normal, Vector2.{0.0, 1.0}, color });
}

// --------
// Text

draw_text :: (text: string, x: float, y: float, font: *Font, color: Vector4 = .{1, 1, 1, 1}) {
    Texture.bind(font.texture);
    i := 0;
    while(i < text.count) {
        it := text[i];
        
        q : stbtt_aligned_quad = ---;
        stbtt_GetPackedQuad(font.char_data.data, 512, 512, xx(it - font.first_char), *x, *y, *q, 0);
        push_vertex(Vertex.{ .{q.x0, q.y0, 0}, .{0.0, 0.0, 1.0}, Vector2.{q.s0, q.t0}, color });
        push_vertex(Vertex.{ .{q.x1, q.y0, 0}, .{0.0, 0.0, 1.0}, Vector2.{q.s1, q.t0}, color });
        push_vertex(Vertex.{ .{q.x1, q.y1, 0}, .{0.0, 0.0, 1.0}, Vector2.{q.s1, q.t1}, color });
        push_vertex(Vertex.{ .{q.x0, q.y0, 0}, .{0.0, 0.0, 1.0}, Vector2.{q.s0, q.t0}, color });
        push_vertex(Vertex.{ .{q.x1, q.y1, 0}, .{0.0, 0.0, 1.0}, Vector2.{q.s1, q.t1}, color });
        push_vertex(Vertex.{ .{q.x0, q.y1, 0}, .{0.0, 0.0, 1.0}, Vector2.{q.s0, q.t1}, color });
        i += 1;
    }
    flush();
}

size_text :: (text: string, font: *Font) -> float {
    // @Incomplete: This wont work for non monospaced fonts.
    return text.count * font.width;
}

draw_texture :: (texture: Texture, x: float, y: float, w: float, h: float) {
    Texture.bind(texture);
    push_quad(.{x, y, 0}, .{x + w, y, 0}, .{x + w, y + h, 0}, .{x, y + h, 0}, .{0, 0, 1});
    flush();
}

draw_2d_quad :: (x: float, y: float, w: float, h: float, color: Vector4 = .{1, 1, 1, 1}) {
    push_vertex(Vertex.{ .{x, y, 0},         .{0.0, 0.0, 1.0}, Vector2.{0, 0}, color });
    push_vertex(Vertex.{ .{x + w, y, 0},     .{0.0, 0.0, 1.0}, Vector2.{1, 0}, color });
    push_vertex(Vertex.{ .{x + w, y + h, 0}, .{0.0, 0.0, 1.0}, Vector2.{1, 1}, color });
    push_vertex(Vertex.{ .{x, y, 0},         .{0.0, 0.0, 1.0}, Vector2.{0, 0}, color });
    push_vertex(Vertex.{ .{x + w, y + h, 0}, .{0.0, 0.0, 1.0}, Vector2.{1, 1}, color });
    push_vertex(Vertex.{ .{x, y + h, 0},     .{0.0, 0.0, 1.0}, Vector2.{0, 1}, color });
    flush();
}

// -------
// Shapes

draw_plane :: (center: Vector3, size: Vector2) {
    plane := Quad.make(center, size);
    draw_quad(
        plane.v[0],
        plane.v[1],
        plane.v[2],
        plane.v[3],
        .{0, -1, 0});
    flush();
}

draw_cube :: (color: Vector4 = .{1, 1, 1, 1}) {
    draw_quad(xyz(-.5, -.5, -.5), xyz(.5, -.5, -.5), xyz(.5, -.5, .5), xyz(-.5, -.5, .5), UP, color); 
    draw_quad(xyz(-.5, .5, -.5), xyz(.5, .5, -.5), xyz(.5, .5, .5), xyz(-.5, .5, .5), DOWN, color);

    draw_quad(xyz(-.5, -.5, -.5), xyz(-.5, .5, -.5), xyz(-.5, .5, .5), xyz(-.5, -.5, .5), LEFT, color); 
    draw_quad(xyz(.5, -.5, -.5), xyz(.5, .5, -.5), xyz(.5, .5, .5), xyz(.5, -.5, .5), RIGHT, color); 

    draw_quad(xyz(-.5, -.5, -.5), xyz(-.5, .5, -.5), xyz(.5, .5, -.5), xyz(.5, -.5, -.5), BACK, color); 
    draw_quad(xyz(-.5, -.5, .5), xyz(-.5, .5, .5), xyz(.5, .5, .5), xyz(.5, -.5, .5), FORWARD, color); 
    flush();
}

draw_cylinder :: () {
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
        Renderer.push_quad(p0, xyz(x1, height, z1), xyz(x2, height, z2), p3, 
        normal = cross(normalize(p3 - p0), UP));
    }

    // Draw floor & ceiling as simple quad
    push_quad(xyz(-radius, 0, -radius), xyz(radius, 0, -radius), xyz(radius, 0, radius), xyz(-radius, 0, radius), UP); 
    push_quad(xyz(-radius, height, -radius), xyz(radius, height, -radius), xyz(radius, height, radius), xyz(-radius, height, radius), DOWN); 
    flush();
}

use_default_texture :: () {
    flush();
    glBindTexture(GL_TEXTURE_2D, global_renderer.default_texture.handle);
}

Texture :: struct {
    handle: GLuint;

    Filter :: enum {
        NEAREST :: GL_NEAREST;
        LINEAR :: GL_LINEAR;
    }

    WrapMode :: enum {
        REPEAT :: GL_REPEAT;
    }

    init :: () -> Texture {
        tex: Texture = ---;
        glCreateTextures(GL_TEXTURE_2D, 1, *tex.handle);
        return tex;
    }

    from_file :: (path: string) -> Texture {
        x : s32;
        y : s32;
        channels: s32;
        img := stbi_load(temp_c_string(path), *x, *y, *channels, 3);
        assert(img != null, "Unable to load %.", path);
        defer stbi_image_free(img);

        tex := init();
        glBindTexture(GL_TEXTURE_2D, tex.handle);
        glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, xx x, xx y, 0, GL_RGB, GL_UNSIGNED_BYTE, img);
        set_filter(.NEAREST);
        return tex;
    }

    deinit :: (tex: *Texture) {
        glDeleteTextures(1, *tex.handle);
    }

    bind :: (tex: Texture, unit : u32 = 0) {
        glActiveTexture(GL_TEXTURE0 + unit);
        glBindTexture(GL_TEXTURE_2D, tex.handle);
    }

    unbind :: () {
        glBindTexture(GL_TEXTURE_2D, 0);
    }

    set_filter :: (filter: Filter) {
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, xx filter);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, xx filter); 
    }

    set_wrap :: (wrap: WrapMode) {
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, xx wrap);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, xx wrap);
    }
}

Shader :: struct {
    handle: GLuint;
    name: string;

    load_from_file :: (path: string, name: string) -> Shader {
        contents := read_entire_file(path);
        return load(contents, name);
    }

    load :: (shader: string, name: string) -> Shader {
        build_shader_part :: (source: string, prefix: string, name: string, kind: GLenum) -> GLuint {
            result := glCreateShader(kind);

            shaders: [2] *u8;
            lengths: [2] s32;

            shaders[0] = prefix.data;
            shaders[1] = source.data;
            lengths[0] = xx prefix.count;
            lengths[1] = xx source.count;

            glShaderSource(result, 2, shaders.data, lengths.data);
            glCompileShader(result);
            
            success: GLint = ---;
            glGetShaderiv(result, GL_COMPILE_STATUS, *success);
            if success then return result;
            
            log_buf: [512]u8;
            glGetShaderInfoLog(result, log_buf.count, null, log_buf.data);
            stage := ifx kind == GL_VERTEX_SHADER then "Vertex" else ifx kind == GL_FRAGMENT_SHADER then "FRAGMENT" else "UNKNOWN";
            assert(false, "%: % - Compile error: %", name, stage, to_string(log_buf.data));
            return 0;
        }

        PREFIX_V :: #string END
        #version 330 core
        #define VERTEX_SHADER 1 
        END

        PREFIX_F :: #string END
        #version 330 core
        #define FRAGMENT_SHADER 1
        END

        vtx := build_shader_part(shader, PREFIX_V, name, GL_VERTEX_SHADER);
        defer glDeleteShader(vtx);
        frg := build_shader_part(shader, PREFIX_F, name, GL_FRAGMENT_SHADER);
        defer glDeleteShader(frg);

        program := glCreateProgram();
        glAttachShader(program, vtx);
        glAttachShader(program, frg);
        glLinkProgram(program);

        success: GLint = ---;
        glGetProgramiv(program, GL_LINK_STATUS, *success);
        if !success {
            log_buf: [512]u8;
            glGetProgramInfoLog(program, log_buf.count, null, log_buf.data);
            assert(false, "%: %", name, to_string(log_buf));
            return Shader.{0, ""};
        }
        nb_uniforms: GLint = ---;
        glGetProgramiv(program, GL_ACTIVE_UNIFORMS, *nb_uniforms); 
        log("%: Successfully linked program with % uniforms.", name, nb_uniforms);
        return Shader.{program, name};
    }

    get_uniform_location :: (shader: Shader, name: string, $check := false) -> GLint {
        loc := glGetUniformLocation(shader.handle, temp_c_string(name));
        #if check {
            if(loc != -1) {
                log("%: Unable to find uniform named %", shader.name, name, flags = .WARNING);
            }
        }
        return loc;
    }

    set_uniform :: (shader: Shader, name: string, value: $T, $check := false) {
        loc := get_uniform_location(shader, name, check);
        #if T == *Matrix4 {
            glUniformMatrix4fv(loc, 1, GL_TRUE, xx value);
        } else #if T == Matrix4 {
            glUniformMatrix4fv(loc, 1, GL_TRUE, xx *value);
        } else #if T == s64 {
            glUniform1i(loc, xx value);
        } else {
            #assert false;
        }
    }
}

Font :: struct {
    first_char : int;
    char_data : [437]stbtt_packedchar;
    texture: Texture;
    line_height : float;
    width : float;

    init :: (path: string, size: float) -> Font, bool {
        font_data, success := read_entire_file(path);
        if !success {
            assert(false, "Unable to load font from %", path);
            return .{}, false;
        }
        result, success2 := from_data(font_data, size);
        return result, success2;
    }

    from_data :: (font_data: string, size: float) -> Font, bool {   
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

        self.texture = Texture.init();
        Texture.bind(self.texture);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RED, 512, 512, 0, GL_RED, GL_UNSIGNED_BYTE, bitmap.data);
        Texture.set_filter(.NEAREST);
        swizzle := GLint.[GL_RED, GL_RED, GL_RED, GL_RED];
        glTexParameteriv(GL_TEXTURE_2D, GL_TEXTURE_SWIZZLE_RGBA, swizzle.data);

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

    deinit :: (font: *Font) {
        // Nothing to deinit
    }
}

// --------
// Shaders

STANDARD :: #string _GLSL
#ifdef VERTEX_SHADER
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aUv;
layout (location = 3) in vec4 aColor;

uniform mat4 Projection;
uniform mat4 View;
uniform mat4 Model;
uniform mat4 Light;

out vec3 Normal;
out vec2 TexCoords;
out vec3 FragPos;
out vec4 VertexColor;
out vec4 FragPosLightSpace;

void main() {
    Normal = aNormal;
    TexCoords = aUv;
    VertexColor = aColor;
    FragPos = vec3(Model * vec4(aPos, 1.0));
    FragPosLightSpace = Light * vec4(FragPos, 1.0);
    gl_Position = Projection * View * vec4(FragPos, 1.0);
    // gl_Position = Light * vec4(FragPos, 1.0);
}

#endif // VERTEX_SHADER

#ifdef FRAGMENT_SHADER
out vec4 FragColor;

in vec3 FragPos;
in vec3 Normal;
in vec2 TexCoords;
in vec4 VertexColor;
in vec4 FragPosLightSpace;

uniform sampler2D texture0;
uniform sampler2D shadow_map;

float constant = 1.0f;
float linear = 0.09f;
float quadratic = 0.002f;

vec3 light_dir = normalize(vec3(1, 1, -1));
vec3 ambient_color = vec3(0.529, 0.808, 0.922);

float Shadow(vec4 fragPosLightSpace) {
    vec3 projCoord = fragPosLightSpace.xyz / fragPosLightSpace.w;
    projCoord = projCoord * 0.5 + 0.5;
    float closest = texture(shadow_map, projCoord.xy).r;
    float current = projCoord.z;
    float shadow = current > closest ? 1.0 : 0.0;
    return shadow;
}

void main() {
    // vec3 light_pos = vec3(0, 2, 0);
    // float distance = length(light_pos - FragPos);
    // float attenuation = 1.0 / (constant + linear * distance + quadratic * (distance * distance));
    // vec4 color_tex = 
    // FragColor = attenuation * VertexColor;
    vec3 base_color = texture(texture0, TexCoords).rgb * VertexColor.rgb;
    float NdotL = max(dot(Normal, -light_dir), 0.0);
    vec3 diffuse = NdotL * vec3(1, 1, 1);
    vec3 ambient = ambient_color * .1;
    float shadow = Shadow(FragPosLightSpace);
    FragColor = vec4((ambient + (1.0 - shadow) * diffuse) * base_color, 1);
} 

#endif // FRAGMENT_SHADER
_GLSL;

SCREEN_SPACE_SHADER :: #string _GLSL
#ifdef VERTEX_SHADER
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aUv;
layout (location = 3) in vec4 aColor;

out vec2 TexCoords;
out vec4 VertexColor;

uniform mat4 Projection;

void main() {
    gl_Position = Projection * vec4(aPos.xy, 0.0, 1.0); 
    TexCoords = aUv;
    VertexColor = aColor;
}  
#endif // VERTEX_SHADER
#ifdef FRAGMENT_SHADER

out vec4 FragColor;
  
in vec2 TexCoords;
in vec4 VertexColor;

uniform sampler2D texture0;

void main() { 

    vec4 tex = texture(texture0, TexCoords);
    FragColor = vec4(VertexColor.xyz, tex.a * VertexColor.a);
}

#endif // FRAGMENT_SHADER
_GLSL;

SHADOWMAP_SHADER :: #string _GLSL
#ifdef VERTEX_SHADER
layout (location = 0) in vec3 aPos;

uniform mat4 Light;
uniform mat4 Model;

void main() {
    gl_Position = Light * Model * vec4(aPos, 1.0);
}

#endif
#ifdef FRAGMENT_SHADER
void main() {

}

#endif

_GLSL

#import "GL";
