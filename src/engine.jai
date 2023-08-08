Engine :: struct {

    window: *SDL_Window;
    renderer: Renderer;
    default_font: Font;

    draw_perf_overlay := true;
    frame_start : u64;
    frame_time: float;

    init :: () {
        log("Init engine");
        path := path_strip_filename(get_path_of_running_executable());
        set_working_directory(path);

        SDL_Init(SDL_INIT_EVERYTHING);

        w := 1280;
        h := 720;
        global_engine.window = SDL_CreateWindow("Demo", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, xx w, xx h, SDL_WINDOW_VULKAN | SDL_WINDOW_RESIZABLE);
        global_engine.renderer = Renderer.create(global_engine.window);
        global_engine.default_font = Font.from_data(default_font_data, 8);

        Console.init();
        Resources.init();
    }

    deinit :: () {
        Font.deinit(*global_engine.default_font);
        Resources.deinit();
        Console.deinit();
        Renderer.destroy(*global_engine.renderer);
        SDL_DestroyWindow(global_engine.window);
        SDL_Quit();
    }

    update :: (delta_time: float) {
        Input.update();
        Console.update(delta_time);
        Resources.update();
        update_tweens(delta_time);
    }

    draw :: () {
        Console.draw(*global_engine.default_font);
        if global_engine.draw_perf_overlay {
            draw_text(tprint("Frametime: %ms", global_engine.frame_time), 0, 8, *global_engine.default_font);
        }
    }

    window_dims :: () -> Vector2i {
        x: s32 = ---;
        y: s32 = ---;
        SDL_GetWindowSize(global_engine.window, *x, *y);
        return .{xx x, xx y};
    }
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
