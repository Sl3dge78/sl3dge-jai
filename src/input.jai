Input :: struct {
    previous_keyboard: [512]u8;
    keyboard: [512]u8;
    mouse : struct {
        buttons : u32;
        xrel: s32;
        yrel: s32;
    };
}

// Call once per frame 
input_update :: () {
    memcpy(input.previous_keyboard.data, input.keyboard.data, input.keyboard.count * size_of(u8));
    kb := SDL_GetKeyboardState(null);
    memcpy(input.keyboard.data, kb, input.keyboard.count * size_of(u8));
    input.mouse.buttons = SDL_GetRelativeMouseState(*input.mouse.xrel, *input.mouse.yrel);
}

mouse_left :: () -> bool {
    return (input.mouse.buttons & SDL_BUTTON(SDL_BUTTON_LEFT)) != 0;
}

mouse_middle :: () -> bool {
    return (input.mouse.buttons & SDL_BUTTON(SDL_BUTTON_MIDDLE)) != 0;
}

key_down :: (scancode: SDL_Scancode) -> bool {
    return input.keyboard[scancode] != 0;
}

key_just_pressed :: (scancode: SDL_Scancode) -> bool {
    a := input.keyboard[scancode];
    b := input.previous_keyboard[scancode];
    return a && !b;
}

key_just_released :: (scancode: SDL_Scancode) -> bool {
    a := input.keyboard[scancode];
    b := input.previous_keyboard[scancode];
    return !a && b;
}

mouse_delta_x :: () -> s32 { return input.mouse.xrel;};
mouse_delta_y :: () -> s32 { return input.mouse.yrel;};

#scope_file
input: Input;