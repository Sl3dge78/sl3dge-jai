Engine :: struct {

    window: *SDL_Window;
    renderer: Renderer;
    delta_time: float = 0;
    default_font: Font;

    init :: () {
        log("Init engine");
        path := path_strip_filename(get_path_of_running_executable());
        set_working_directory(path);

        SDL_Init(SDL_INIT_EVERYTHING);
        
        context.logger = Console.log;

        w := 1280;
        h := 720;
        global_engine.window = SDL_CreateWindow("Demo", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, xx w, xx h, SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE);
        global_engine.renderer = renderer_init(global_engine.window);
        global_engine.default_font = Font.from_data(default_font_data, 8);

        Resources.init();
    }

    deinit :: () {
        Resources.deinit();
        renderer_deinit();
        SDL_DestroyWindow(global_engine.window);
        SDL_Quit();
    }

    update :: (delta_time: float) {
        Input.update();
        Console.update(delta_time);
        Resources.update();
    }

    draw :: () {
        Console.draw(*global_engine.default_font);
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
