Console :: struct {
    current_message: string;
    message_timer: float;

    lines: [NB_LINES]string;
    last_line: int;

    console_y_position: int;
    console_y_target: int;

    NB_LINES :: 16;
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

    if key_just_pressed(.SDL_SCANCODE_GRAVE) {
        console_y_target = ifx console_y_target == 0 then lines.count * 8 else 0;
        log("Show console!");
    }

    if console_y_position < console_y_target {
        console_y_position += 16;
    } else if console_y_position > console_y_target {
        console_y_position -= 16;
    }
}

console_draw :: (immediate: *Immediate, font: *Font) {
    using global_console;

    // Message
    if message_timer > 0 {
        text_w := size_text(current_message, font);
        alpha := ifx message_timer < 1 then message_timer else 1;
        draw_text(immediate, current_message, window_dims().x / 2 - text_w / 2, 16, font, .{1, 1, 1, alpha});
    }

    if console_y_position > 0 {
        win := window_dims();

        immediate_default_texture(immediate);
        draw_2d_rect(immediate, .{0, 0}, .{ xx win.x, xx console_y_position }, .{0, 0, 0, 0.75});

        immediate_bind_font(immediate, font);
        // y : float = xx (console_y_position - last_line * font.line_height + 8);
        y : float = xx console_y_position;
        i := last_line - 1;
        while i > 0 {
            draw_text(immediate, lines[i], 0, xx y, font, bind = false);
            y -= font.line_height;
            i -= 1;
        }
        // for lines {
        //     new_x:, y = draw_text(immediate, it, 0, xx y, font, bind = false);
        // }
    }

}

console_message :: (msg: string, args: .. Any) {
    if global_console.current_message { // @Speed
        free(global_console.current_message);
    }
    global_console.current_message = sprint(msg, args,, context.default_allocator);
    global_console.message_timer = 2;
}

console_clear_message :: () {
    global_console.message_timer = 0;
}

console_print :: (msg: string, args: .. Any) {
    using global_console;
    if last_line >= lines.count {
        last_line = lines.count - 1;
        
        free(lines[0].data,, context.default_allocator);
        for i : 0..lines.count-2 {
            lines[i] = lines[i+1];
        }
    }
    builder : String_Builder;
    // builder.allocator = context.default_allocator;
    print_to_builder(*builder, msg, ..args);
    lines[last_line] = builder_to_string(*builder,, context.default_allocator);

    last_line += 1;
}

console_log :: (message: string, data: *void, info: Log_Info) {
    if !message then return;
    
    console_print(message);
    runtime_support_default_logger(message, data, info);
}

#scope_file
global_console: Console;


// I ran into something and I don't quite know what to think about it:
// I have a custom logger that redirects output to a console. This works fairly simply, I override `context.logger` with my own function, that copies the string to a list to be displayed. 
// Now sometimes I want to load files, only for a frame. `read_entire_file` doesn't take an allocator as param so I `push_context` with the temp allocator. If the file doesn't exists, `read_entire_file` will log it so it will make an allocation with the current allocator. `default_logger` is my console so I catch it there and basically have to force reallocate it everytime in case the current allocator is temp... 
