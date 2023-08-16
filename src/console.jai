Console :: struct {
    current_message: string;
    message_timer: float;

    console: [20]string;
    console_pos: int;

    init :: () {
        context.logger = Console.log;
    }

    deinit :: () {
        context.logger = Context.default_logger;
        for global_console.console {
            free(it);
        }
        free(global_console.current_message);
    }

    update :: (delta_time: float) {
        using global_console;
        if message_timer >= 0 {
            message_timer -= delta_time;
        }
    }

    draw :: (font: *Font) {
        using global_console;

        // Message
        if message_timer > 0 {
            text_w := size_text(current_message, font);
            alpha := ifx message_timer < 1 then message_timer else 1;
            draw_text(current_message, Renderer.get_window_dims().x / 2 - text_w / 2, 16, font, .{1, 1, 1, alpha});
        }

        y := Renderer.get_window_dims().y - font.line_height * 20;
        for console {
            draw_text(it, 0, y, font);
            y += font.line_height;
        }
    }

    message :: (msg: string, args: .. Any) {
        if global_console.current_message { // @Speed
            free(global_console.current_message);
        }
        global_console.current_message = sprint(msg, args);
        global_console.message_timer = 2;
    }

    clear_message :: () {
        global_console.message_timer = 0;
    }

    print :: (msg: string, args: .. Any) {
        using global_console;
        if console_pos >= console.count {
            console_pos = console.count - 1;
         
            free(console[0].data);
            for i : 0..console.count-2 {
                console[i] = console[i+1];
            }
        }
        console[console_pos] = sprint(msg, .. args);
        console_pos += 1;
    }

    log :: (message: string, data: *void, info: Log_Info) {
        if !message then return;
        
        print(message);
        context.default_logger(message, data, info);
    }
}

#scope_file
global_console: Console;
