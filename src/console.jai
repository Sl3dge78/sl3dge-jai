Console :: struct {
    current_message: string;
    message_timer: float;

    console: [20]string;
    console_pos: int;
}

console_create :: () {
    context.logger = console_log;
}

console_destroy :: () {
    context.logger = Context.default_logger;
    for global_console.console {
        free(it);
    }
    free(global_console.current_message);
}

console_update :: (delta_time: float) {
    using global_console;
    if message_timer >= 0 {
        message_timer -= delta_time;
    }
}

console_draw :: (font: *Font) {
    using global_console;

    win := window_dims();

    y := win.y - font.line_height * 20;

    immediate_2d_rect(.{0, y - font.line_height}, .{ win.x / 2.0, xx win.y}, .{0, 0, 0, 0.75});

    // Message
    if message_timer > 0 {
        text_w := size_text(current_message, font);
        alpha := ifx message_timer < 1 then message_timer else 1;
        draw_text(current_message, window_dims().x / 2 - text_w / 2, 16, font, .{1, 1, 1, alpha});
    }

    for console {
        draw_text(it, 0, y, font);
        y += font.line_height;
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

console_log :: (message: string, data: *void, info: Log_Info) {
    if !message then return;
    
    print(message);
    context.default_logger(message, data, info);
}

#scope_file
global_console: Console;
