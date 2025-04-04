Engine :: struct {

    window: *SDL_Window;
    renderer: *Renderer;
    default_font: Font;

    draw_perf_overlay := true;
    frame_start : u64;
    frame_time: float;
}

// Single call that calls funcs automagically and handles the program loop
engine_run :: (init_fn : (*$T), input_fn: (*T, SDL_Event), update_fn: (*T, float), draw_fn: (*T, Frame_Data), destroy_fn: (*T)) {
    engine_create();
    defer engine_destroy();

    game_state: T;
    init_fn(*game_state);
    defer destroy_fn(*game_state);

    delta_time : float = 0;
    running := true;
    focused := true;
    while running {
        global_engine.frame_start = SDL_GetPerformanceCounter();

        event: SDL_Event;
        while SDL_PollEvent(*event) {
            if event.type == {
                case .QUIT; running = false;
                case .WINDOW_RESIZED; {
                    // Renderer.update_window(window); @TODO Migration
                }
                case .WINDOW_FOCUS_LOST; {
                    SDL_SetWindowRelativeMouseMode(global_engine.window, false);
                    focused = false;
                }
                case .WINDOW_FOCUS_GAINED; {
                    SDL_GetRelativeMouseState(null, null); // Read to flush what was happening when unfocused
                    SDL_SetWindowRelativeMouseMode(global_engine.window, true);
                    focused = true;
                }
                case; input_fn(*game_state, event);
            }
        }
        
        // if key_just_pressed(.SDL_SCANCODE_LALT) {
        //     mode := SDL_GetWindowRelativeMouseMode(global_engine.window).(bool);
        //     if mode {
        //         x : s32; y : s32;
        //         SDL_GetWindowSize(global_engine.window, *x, *y);
        //         SDL_WarpMouseInWindow(global_engine.window, 0.5 * x, 0.5 * y);
        //     }
        //     SDL_SetWindowRelativeMouseMode(global_engine.window, !mode);
        // }   

        if focused { 
            input_update();
        }
        engine_update(delta_time);
        update_fn(*game_state, delta_time);

        render, frame_data := begin_frame();
        if render {
            draw_fn(*game_state, frame_data);
            engine_draw(*frame_data);
            end_frame(frame_data);
        }
        reset_temporary_storage();
        
        frame_end := SDL_GetPerformanceCounter();
        delta_time = cast(float)(frame_end - global_engine.frame_start) / cast(float)SDL_GetPerformanceFrequency();
        global_engine.frame_time = delta_time;
    }
    SDL_WaitForGPUIdle(global_renderer.device);
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
    console_update(delta_time);
    Resources.update();
    update_tweens(delta_time);
}

engine_draw :: (frame_data: Frame_Data) {
    imm := immediate_begin(frame_data);
    defer immediate_end(*imm);
    console_draw(*imm, *global_engine.default_font);
    if global_engine.draw_perf_overlay {
        ms := global_engine.frame_time * 1000;
        draw_text(*imm, tprint("Frametime: %ms (%fps)", FormatFloat.{ value = ms, trailing_width = 3}, roundf(1 / ms)), 0, 8, *global_engine.default_font);
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
