Engine :: struct {

    window: *SDL_Window;
    renderer: *Renderer;
    default_font: Font;

    draw_perf_overlay := true;
    frame_start : u64;
    frame_time: float;
}

engine_create :: () {
    log("Init engine");
    path := path_strip_filename(get_path_of_running_executable(,, temp));
    set_working_directory(path);

    console_create();
    SDL_Init(SDL_INIT_VIDEO | SDL_INIT_GAMEPAD );

    w := 1280;
    h := 720;
    flags := SDL_WINDOW_RESIZABLE;
    flags |= SDL_WINDOW_VULKAN;
    global_engine.window = SDL_CreateWindow("Demo", xx w, xx h, xx flags);
    global_engine.renderer = renderer_create(global_engine.window);
    global_engine.default_font = font_from_data(default_font_data, 8, "default_font");

    Resources.create();
}

engine_destroy :: () {
    destroy(*global_engine.default_font);
    Resources.destroy();
    console_destroy();
    destroy(global_engine.renderer);
    SDL_DestroyWindow(global_engine.window);
    SDL_Quit();
}

engine_update :: (delta_time: float) {
    input_update();
    console_update(delta_time);
    Resources.update();
    update_tweens(delta_time);
}

engine_draw :: (frame_data: Frame_Data) {
    imm := immediate_begin(frame_data);
    defer immediate_end(*imm);
    console_draw(*imm, *global_engine.default_font);
    if global_engine.draw_perf_overlay {
        draw_text(*imm, tprint("Frametime: %ms (%fps)", FormatFloat.{ value = global_engine.frame_time, trailing_width = 3}, roundf(1 / global_engine.frame_time)), 0, 8, *global_engine.default_font);
    }

}

window_dims :: () -> Vector2i {
    x: s32 = ---;
    y: s32 = ---;
    SDL_GetWindowSize(global_engine.window, *x, *y);
    return .{xx x, xx y};
}

global_engine: Engine;

#scope_file

load_default_font :: () -> string {
    path := path_strip_filename(#file);
    joined := join(path, "../font.ttf");
    file, success := read_entire_file(joined);
    assert(success);
    return file;
}

default_font_data := #run load_default_font();
