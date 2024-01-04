Console :: struct {
    current_message: string;
    message_timer: float;

    lines: [32]string;
    last_line: int;

    console_y_position: int;
    console_y_target: int;
}

console_create :: () {
    context.logger = console_log;
}

console_destroy :: () {
    context.logger = runtime_support_default_logger;
    for global_console.lines {
        free(it);
    }
    free(global_console.current_message);
}

console_update :: (delta_time: float) {
    using global_console;

    if message_timer >= 0 {
        message_timer -= delta_time;
    }

    if key_just_pressed(SDL_SCANCODE_GRAVE) {
        console_y_target = ifx console_y_target == 0 then 200 else 0;
        log("Show console!");
    }

    if console_y_position < console_y_target {
        console_y_position += 20;
    } else if console_y_position > console_y_target {
        console_y_position -= 20;
    }
}

console_draw :: (immediate: *Immediate, font: *Font) {
    using global_console;

    if console_y_position > 0 {
        win := window_dims();

        draw_2d_rect(immediate, .{0, 0}, .{ xx win.x, xx console_y_position }, .{0, 0, 0, 0.75});

        // Message
        if message_timer > 0 {
            text_w := size_text(current_message, font);
            alpha := ifx message_timer < 1 then message_timer else 1;
            draw_text(immediate, current_message, window_dims().x / 2 - text_w / 2, 16, font, .{1, 1, 1, alpha});
        }

        y : float = xx (console_y_position - last_line * font.line_height);
        for lines {
            new_x:, y = draw_wrapped_text(immediate, it, 0, xx win.x, xx y, font);
        }
    }
}

console_message :: (msg: string, args: .. Any) {
    if global_console.current_message { // @Speed
        free(global_console.current_message);
    }
    global_console.current_message = sprint(msg, args);
    global_console.message_timer = 2;
}

console_clear_message :: () {
    global_console.message_timer = 0;
}

console_print :: (msg: string, args: .. Any) {
    using global_console;
    if last_line >= lines.count {
        last_line = lines.count - 1;
        
        free(lines[0].data);
        for i : 0..lines.count-2 {
            lines[i] = lines[i+1];
        }
    }
    lines[last_line] = sprint(msg, .. args);
    last_line += 1;
}

console_log :: (message: string, data: *void, info: Log_Info) {
    if !message then return;
    
    console_print(message);
    runtime_support_default_logger(message, data, info);
}

#scope_file
global_console: Console;
