Input :: struct {
    previous_keyboard: [512]u8;
    keyboard: [512]u8;
    mouse_rel_state : u32;
    mouse_rel_position : Vector2;
    mouse_state : u32;
    mouse_position : Vector2;
    // controller: *SDL_Gamepad;
    // controller_id: u32;
}

Mouse_Button :: enum {
    LEFT :: SDL_BUTTON_LEFT;
    MIDDLE :: SDL_BUTTON_MIDDLE;
    RIGHT :: SDL_BUTTON_RIGHT;
}

// Call once per frame 
input_update :: () {
    memcpy(input.previous_keyboard.data, input.keyboard.data, input.keyboard.count * size_of(u8));
    kb := SDL_GetKeyboardState(null);
    memcpy(input.keyboard.data, kb, input.keyboard.count * size_of(u8));
    x: float = ---;
    y: float = ---;
    input.mouse_rel_state = SDL_GetRelativeMouseState(*x, *y);
    input.mouse_rel_position.x = x;
    input.mouse_rel_position.y = y;

    input.mouse_state = SDL_GetMouseState(*x, *y);
    input.mouse_position.x = x;
    input.mouse_position.y = y;
    // open_controller();
}

input_handle_event :: (event: *SDL_Event) {
    // if event.type == {
    //     case .SDL_EVENT_GAMEPAD_ADDED; open_controller();
    //     case .SDL_EVENT_GAMEPAD_REMOVED; {
    //         e := event.cdevice;
    //         if e.which == input.controller_id {
    //             SDL_CloseGamepad(input.controller);
    //             input.controller = null;
    //             log("Controller disconnected");
    //         }
    //     }
    //     case .SDL_EVENT_GAMEPAD_BUTTON_DOWN; {
    //         ctrl_ev := event.gbutton;
    //         if ctrl_ev.which == input.controller_id {
    //             log("%: %", ctrl_ev.button, ifx ctrl_ev.down == false then "RELEASED" else "PRESSED");
    //         }
    //     }
    // }
}

mouse_left_just_pressed :: () -> bool {
    return (input.mouse_rel_state & SDL_BUTTON(SDL_BUTTON_LEFT)) != 0;
}

mouse_middle_just_pressed :: () -> bool {
    return (input.mouse_rel_state & SDL_BUTTON(SDL_BUTTON_MIDDLE)) != 0;
}

mouse_down :: (button: Mouse_Button) -> bool {
    return (input.mouse_state & SDL_BUTTON(xx button)) != 0;
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

mouse_delta_x :: () -> float { return input.mouse_rel_position.x;};
mouse_delta_y :: () -> float { return input.mouse_rel_position.y;};

mouse_position :: () -> Vector2 {
    return input.mouse_position;
}

// Controller stuff

// open_controller :: () {
//     for 0..SDL_NumJoysticks() - 1 {
//         log("Found hoystick %", to_string(cast(*u8)SDL_JoystickNameForIndex(it)));
//         if !SDL_IsGameController(it) then continue;
//         input.controller = SDL_GameControllerOpen(it);
//         input.controller_id = it;
//         log("Opened controller: %", to_string(cast(*u8)SDL_GameControllerNameForIndex(0)));
//         return;
//     }
// }

#scope_file
input: Input;
