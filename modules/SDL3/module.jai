//
// This file was auto-generated using the following command:
//
// jai generate.jai
//

#scope_export

SDL_Check :: (result: bool) #expand {
    if(!result) {
        SDL_LogError(.SDL_LOG_CATEGORY_ERROR, to_string(SDL_GetError()));
        assert(false);
    }
}

SDL_NullCheck :: (value: *$T) -> *T #expand {
    if(!value) {
        SDL_LogError(.SDL_LOG_CATEGORY_ERROR, to_string(SDL_GetError()));
        assert(false);
    }
    return value;
}


SDL_BUTTON :: (x:int) -> int { return (1 << ((x)-1)); }
SDL_WINDOW_FULLSCREEN ::            0x0000000000000001;
SDL_WINDOW_OPENGL ::                0x0000000000000002;
SDL_WINDOW_OCCLUDED ::              0x0000000000000004;
SDL_WINDOW_HIDDEN ::                0x0000000000000008;
SDL_WINDOW_BORDERLESS ::            0x0000000000000010;
SDL_WINDOW_RESIZABLE ::             0x0000000000000020;
SDL_WINDOW_MINIMIZED ::             0x0000000000000040;
SDL_WINDOW_MAXIMIZED ::             0x0000000000000080;
SDL_WINDOW_MOUSE_GRABBED ::         0x0000000000000100;
SDL_WINDOW_INPUT_FOCUS ::           0x0000000000000200;
SDL_WINDOW_MOUSE_FOCUS ::           0x0000000000000400;
SDL_WINDOW_EXTERNAL ::              0x0000000000000800;
SDL_WINDOW_MODAL ::                 0x0000000000001000;
SDL_WINDOW_HIGH_PIXEL_DENSITY ::    0x0000000000002000;
SDL_WINDOW_MOUSE_CAPTURE ::         0x0000000000004000;
SDL_WINDOW_MOUSE_RELATIVE_MODE ::   0x0000000000008000;
SDL_WINDOW_ALWAYS_ON_TOP ::         0x0000000000010000;
SDL_WINDOW_UTILITY ::               0x0000000000020000;
SDL_WINDOW_TOOLTIP ::               0x0000000000040000;
SDL_WINDOW_POPUP_MENU ::            0x0000000000080000;
SDL_WINDOW_KEYBOARD_GRABBED ::      0x0000000000100000;
SDL_WINDOW_VULKAN ::                0x0000000010000000;
SDL_WINDOW_METAL ::                 0x0000000020000000;
SDL_WINDOW_TRANSPARENT ::           0x0000000040000000;
SDL_WINDOW_NOT_FOCUSABLE ::         0x0000000080000000;

SDL_WINDOWPOS_UNDEFINED_DISPLAY :: (x: s32) -> s32 { return (SDL_WINDOWPOS_UNDEFINED_MASK|x); }
SDL_WINDOWPOS_UNDEFINED :s32: 0x1FFF0000; // SDL_WINDOWPOS_UNDEFINED_DISPLAY(0);
SDL_WINDOWPOS_CENTERED_DISPLAY :: (x: s32) -> s32 { return (SDL_WINDOWPOS_CENTERED_MASK|x); }
SDL_WINDOWPOS_CENTERED :s32: 0x2FFF0000; // SDL_WINDOWPOS_CENTERED_DISPLAY(0);

SDL_PLATFORM_LINUX :: 1;
SDL_PLATFORM_UNIX :: 1;
SDL_MAX_SINT8 :: cast(Sint8) 0x7F;
SDL_MIN_SINT8 :: cast,trunc(Sint8) (~0x7F);
SDL_MAX_UINT8 :: cast(Uint8) 0xFF;
SDL_MIN_UINT8 :: cast(Uint8) 0x00;
SDL_MAX_SINT16 :: cast(Sint16) 0x7FFF;
SDL_MIN_SINT16 :: cast,trunc(Sint16) (~0x7FFF);
SDL_MAX_UINT16 :: cast(Uint16) 0xFFFF;
SDL_MIN_UINT16 :: cast(Uint16) 0x0000;
SDL_MAX_SINT32 :: cast(Sint32) 0x7FFFFFFF;
SDL_MIN_SINT32 :: cast,trunc(Sint32) (~0x7FFFFFFF);
SDL_MAX_UINT32 :: cast(Uint32) 0xFFFFFFFF;
SDL_MIN_UINT32 :: cast(Uint32) 0x00000000;
SDL_FLT_EPSILON :: 1.1920928955078125e-07;
SDL_PRIs64 :: "ld";
SDL_PRILL_PREFIX :: "ll";
SDL_INVALID_UNICODE_CODEPOINT :: 0xFFFD;
SDL_PI_D :: 3.141592653589793238462643383279502884;
SDL_PI_F :: 3.141592653589793238462643383279502884;
SDL_ICONV_ERROR :: cast,trunc(u64) -1;
SDL_ICONV_E2BIG :: cast,trunc(u64) -2;
SDL_ICONV_EILSEQ :: cast,trunc(u64) -3;
SDL_ICONV_EINVAL :: cast,trunc(u64) -4;
SDL_ASSERT_LEVEL :: 2;
SDL_NULL_WHILE_LOOP_CONDITION :: 0;
SDL_LIL_ENDIAN :: 1234;
SDL_BIG_ENDIAN :: 4321;
SDL_PROP_THREAD_CREATE_ENTRY_FUNCTION_POINTER :: "SDL.thread.create.entry_function";
SDL_PROP_THREAD_CREATE_NAME_STRING :: "SDL.thread.create.name";
SDL_PROP_THREAD_CREATE_USERDATA_POINTER :: "SDL.thread.create.userdata";
SDL_PROP_THREAD_CREATE_STACKSIZE_NUMBER :: "SDL.thread.create.stacksize";
SDL_PROP_IOSTREAM_WINDOWS_HANDLE_POINTER :: "SDL.iostream.windows.handle";
SDL_PROP_IOSTREAM_STDIO_FILE_POINTER :: "SDL.iostream.stdio.file";
SDL_PROP_IOSTREAM_FILE_DESCRIPTOR_NUMBER :: "SDL.iostream.file_descriptor";
SDL_PROP_IOSTREAM_ANDROID_AASSET_POINTER :: "SDL.iostream.android.aasset";
SDL_PROP_IOSTREAM_MEMORY_POINTER :: "SDL.iostream.memory.base";
SDL_PROP_IOSTREAM_MEMORY_SIZE_NUMBER :: "SDL.iostream.memory.size";
SDL_PROP_IOSTREAM_DYNAMIC_MEMORY_POINTER :: "SDL.iostream.dynamic.memory";
SDL_PROP_IOSTREAM_DYNAMIC_CHUNKSIZE_NUMBER :: "SDL.iostream.dynamic.chunksize";
SDL_AUDIO_MASK_BITSIZE :: 0xFF;
SDL_AUDIO_MASK_FLOAT :: 1<<8;
SDL_AUDIO_MASK_BIG_ENDIAN :: 1<<12;
SDL_AUDIO_MASK_SIGNED :: 1<<15;
SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK :: cast(SDL_AudioDeviceID) 0xFFFFFFFF;
SDL_AUDIO_DEVICE_DEFAULT_RECORDING :: cast(SDL_AudioDeviceID) 0xFFFFFFFE;
SDL_BLENDMODE_NONE :: 0x00000000;
SDL_BLENDMODE_BLEND :: 0x00000001;
SDL_BLENDMODE_BLEND_PREMULTIPLIED :: 0x00000010;
SDL_BLENDMODE_ADD :: 0x00000002;
SDL_BLENDMODE_ADD_PREMULTIPLIED :: 0x00000020;
SDL_BLENDMODE_MOD :: 0x00000004;
SDL_BLENDMODE_MUL :: 0x00000008;
SDL_BLENDMODE_INVALID :: 0x7FFFFFFF;
SDL_ALPHA_OPAQUE :: 255;
SDL_ALPHA_OPAQUE_FLOAT :: 1.0;
SDL_ALPHA_TRANSPARENT :: 0;
SDL_ALPHA_TRANSPARENT_FLOAT :: 0.0;
SDL_SURFACE_PREALLOCATED :: 0x00000001;
SDL_SURFACE_LOCK_NEEDED :: 0x00000002;
SDL_SURFACE_LOCKED :: 0x00000004;
SDL_SURFACE_SIMD_ALIGNED :: 0x00000008;
SDL_PROP_SURFACE_SDR_WHITE_POINT_FLOAT :: "SDL.surface.SDR_white_point";
SDL_PROP_SURFACE_HDR_HEADROOM_FLOAT :: "SDL.surface.HDR_headroom";
SDL_PROP_SURFACE_TONEMAP_OPERATOR_STRING :: "SDL.surface.tonemap";
SDL_CACHELINE_SIZE :: 128;
SDL_PROP_GLOBAL_VIDEO_WAYLAND_WL_DISPLAY_POINTER :: "SDL.video.wayland.wl_display";
SDL_WINDOWPOS_UNDEFINED_MASK :: 0x1FFF0000;
SDL_WINDOWPOS_CENTERED_MASK :: 0x2FFF0000;
SDL_GL_CONTEXT_PROFILE_CORE :: 0x0001;
SDL_GL_CONTEXT_PROFILE_COMPATIBILITY :: 0x0002;
SDL_GL_CONTEXT_PROFILE_ES :: 0x0004;
SDL_GL_CONTEXT_DEBUG_FLAG :: 0x0001;
SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG :: 0x0002;
SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG :: 0x0004;
SDL_GL_CONTEXT_RESET_ISOLATION_FLAG :: 0x0008;
SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE :: 0x0000;
SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH :: 0x0001;
SDL_GL_CONTEXT_RESET_NO_NOTIFICATION :: 0x0000;
SDL_GL_CONTEXT_RESET_LOSE_CONTEXT :: 0x0001;
SDL_PROP_DISPLAY_HDR_ENABLED_BOOLEAN :: "SDL.display.HDR_enabled";
SDL_PROP_DISPLAY_KMSDRM_PANEL_ORIENTATION_NUMBER :: "SDL.display.KMSDRM.panel_orientation";
SDL_PROP_WINDOW_CREATE_ALWAYS_ON_TOP_BOOLEAN :: "SDL.window.create.always_on_top";
SDL_PROP_WINDOW_CREATE_BORDERLESS_BOOLEAN :: "SDL.window.create.borderless";
SDL_PROP_WINDOW_CREATE_FOCUSABLE_BOOLEAN :: "SDL.window.create.focusable";
SDL_PROP_WINDOW_CREATE_EXTERNAL_GRAPHICS_CONTEXT_BOOLEAN :: "SDL.window.create.external_graphics_context";
SDL_PROP_WINDOW_CREATE_FLAGS_NUMBER :: "SDL.window.create.flags";
SDL_PROP_WINDOW_CREATE_FULLSCREEN_BOOLEAN :: "SDL.window.create.fullscreen";
SDL_PROP_WINDOW_CREATE_HEIGHT_NUMBER :: "SDL.window.create.height";
SDL_PROP_WINDOW_CREATE_HIDDEN_BOOLEAN :: "SDL.window.create.hidden";
SDL_PROP_WINDOW_CREATE_HIGH_PIXEL_DENSITY_BOOLEAN :: "SDL.window.create.high_pixel_density";
SDL_PROP_WINDOW_CREATE_MAXIMIZED_BOOLEAN :: "SDL.window.create.maximized";
SDL_PROP_WINDOW_CREATE_MENU_BOOLEAN :: "SDL.window.create.menu";
SDL_PROP_WINDOW_CREATE_METAL_BOOLEAN :: "SDL.window.create.metal";
SDL_PROP_WINDOW_CREATE_MINIMIZED_BOOLEAN :: "SDL.window.create.minimized";
SDL_PROP_WINDOW_CREATE_MODAL_BOOLEAN :: "SDL.window.create.modal";
SDL_PROP_WINDOW_CREATE_MOUSE_GRABBED_BOOLEAN :: "SDL.window.create.mouse_grabbed";
SDL_PROP_WINDOW_CREATE_OPENGL_BOOLEAN :: "SDL.window.create.opengl";
SDL_PROP_WINDOW_CREATE_PARENT_POINTER :: "SDL.window.create.parent";
SDL_PROP_WINDOW_CREATE_RESIZABLE_BOOLEAN :: "SDL.window.create.resizable";
SDL_PROP_WINDOW_CREATE_TITLE_STRING :: "SDL.window.create.title";
SDL_PROP_WINDOW_CREATE_TRANSPARENT_BOOLEAN :: "SDL.window.create.transparent";
SDL_PROP_WINDOW_CREATE_TOOLTIP_BOOLEAN :: "SDL.window.create.tooltip";
SDL_PROP_WINDOW_CREATE_UTILITY_BOOLEAN :: "SDL.window.create.utility";
SDL_PROP_WINDOW_CREATE_VULKAN_BOOLEAN :: "SDL.window.create.vulkan";
SDL_PROP_WINDOW_CREATE_WIDTH_NUMBER :: "SDL.window.create.width";
SDL_PROP_WINDOW_CREATE_X_NUMBER :: "SDL.window.create.x";
SDL_PROP_WINDOW_CREATE_Y_NUMBER :: "SDL.window.create.y";
SDL_PROP_WINDOW_CREATE_COCOA_WINDOW_POINTER :: "SDL.window.create.cocoa.window";
SDL_PROP_WINDOW_CREATE_COCOA_VIEW_POINTER :: "SDL.window.create.cocoa.view";
SDL_PROP_WINDOW_CREATE_WAYLAND_SURFACE_ROLE_CUSTOM_BOOLEAN :: "SDL.window.create.wayland.surface_role_custom";
SDL_PROP_WINDOW_CREATE_WAYLAND_CREATE_EGL_WINDOW_BOOLEAN :: "SDL.window.create.wayland.create_egl_window";
SDL_PROP_WINDOW_CREATE_WAYLAND_WL_SURFACE_POINTER :: "SDL.window.create.wayland.wl_surface";
SDL_PROP_WINDOW_CREATE_WIN32_HWND_POINTER :: "SDL.window.create.win32.hwnd";
SDL_PROP_WINDOW_CREATE_WIN32_PIXEL_FORMAT_HWND_POINTER :: "SDL.window.create.win32.pixel_format_hwnd";
SDL_PROP_WINDOW_CREATE_X11_WINDOW_NUMBER :: "SDL.window.create.x11.window";
SDL_PROP_WINDOW_SHAPE_POINTER :: "SDL.window.shape";
SDL_PROP_WINDOW_HDR_ENABLED_BOOLEAN :: "SDL.window.HDR_enabled";
SDL_PROP_WINDOW_SDR_WHITE_LEVEL_FLOAT :: "SDL.window.SDR_white_level";
SDL_PROP_WINDOW_HDR_HEADROOM_FLOAT :: "SDL.window.HDR_headroom";
SDL_PROP_WINDOW_ANDROID_WINDOW_POINTER :: "SDL.window.android.window";
SDL_PROP_WINDOW_ANDROID_SURFACE_POINTER :: "SDL.window.android.surface";
SDL_PROP_WINDOW_UIKIT_WINDOW_POINTER :: "SDL.window.uikit.window";
SDL_PROP_WINDOW_UIKIT_METAL_VIEW_TAG_NUMBER :: "SDL.window.uikit.metal_view_tag";
SDL_PROP_WINDOW_UIKIT_OPENGL_FRAMEBUFFER_NUMBER :: "SDL.window.uikit.opengl.framebuffer";
SDL_PROP_WINDOW_UIKIT_OPENGL_RENDERBUFFER_NUMBER :: "SDL.window.uikit.opengl.renderbuffer";
SDL_PROP_WINDOW_UIKIT_OPENGL_RESOLVE_FRAMEBUFFER_NUMBER :: "SDL.window.uikit.opengl.resolve_framebuffer";
SDL_PROP_WINDOW_KMSDRM_DEVICE_INDEX_NUMBER :: "SDL.window.kmsdrm.dev_index";
SDL_PROP_WINDOW_KMSDRM_DRM_FD_NUMBER :: "SDL.window.kmsdrm.drm_fd";
SDL_PROP_WINDOW_KMSDRM_GBM_DEVICE_POINTER :: "SDL.window.kmsdrm.gbm_dev";
SDL_PROP_WINDOW_COCOA_WINDOW_POINTER :: "SDL.window.cocoa.window";
SDL_PROP_WINDOW_COCOA_METAL_VIEW_TAG_NUMBER :: "SDL.window.cocoa.metal_view_tag";
SDL_PROP_WINDOW_OPENVR_OVERLAY_ID :: "SDL.window.openvr.overlay_id";
SDL_PROP_WINDOW_VIVANTE_DISPLAY_POINTER :: "SDL.window.vivante.display";
SDL_PROP_WINDOW_VIVANTE_WINDOW_POINTER :: "SDL.window.vivante.window";
SDL_PROP_WINDOW_VIVANTE_SURFACE_POINTER :: "SDL.window.vivante.surface";
SDL_PROP_WINDOW_WIN32_HWND_POINTER :: "SDL.window.win32.hwnd";
SDL_PROP_WINDOW_WIN32_HDC_POINTER :: "SDL.window.win32.hdc";
SDL_PROP_WINDOW_WIN32_INSTANCE_POINTER :: "SDL.window.win32.instance";
SDL_PROP_WINDOW_WAYLAND_DISPLAY_POINTER :: "SDL.window.wayland.display";
SDL_PROP_WINDOW_WAYLAND_SURFACE_POINTER :: "SDL.window.wayland.surface";
SDL_PROP_WINDOW_WAYLAND_EGL_WINDOW_POINTER :: "SDL.window.wayland.egl_window";
SDL_PROP_WINDOW_WAYLAND_XDG_SURFACE_POINTER :: "SDL.window.wayland.xdg_surface";
SDL_PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_POINTER :: "SDL.window.wayland.xdg_toplevel";
SDL_PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_EXPORT_HANDLE_STRING :: "SDL.window.wayland.xdg_toplevel_export_handle";
SDL_PROP_WINDOW_WAYLAND_XDG_POPUP_POINTER :: "SDL.window.wayland.xdg_popup";
SDL_PROP_WINDOW_WAYLAND_XDG_POSITIONER_POINTER :: "SDL.window.wayland.xdg_positioner";
SDL_PROP_WINDOW_X11_DISPLAY_POINTER :: "SDL.window.x11.display";
SDL_PROP_WINDOW_X11_SCREEN_NUMBER :: "SDL.window.x11.screen";
SDL_PROP_WINDOW_X11_WINDOW_NUMBER :: "SDL.window.x11.window";
SDL_WINDOW_SURFACE_VSYNC_DISABLED :: 0;
SDL_WINDOW_SURFACE_VSYNC_ADAPTIVE :: -1;
SDL_STANDARD_GRAVITY :: 9.80665;
SDL_JOYSTICK_AXIS_MAX :: 32767;
SDL_JOYSTICK_AXIS_MIN :: -32768;
SDL_PROP_JOYSTICK_CAP_MONO_LED_BOOLEAN :: "SDL.joystick.cap.mono_led";
SDL_PROP_JOYSTICK_CAP_RGB_LED_BOOLEAN :: "SDL.joystick.cap.rgb_led";
SDL_PROP_JOYSTICK_CAP_PLAYER_LED_BOOLEAN :: "SDL.joystick.cap.player_led";
SDL_PROP_JOYSTICK_CAP_RUMBLE_BOOLEAN :: "SDL.joystick.cap.rumble";
SDL_PROP_JOYSTICK_CAP_TRIGGER_RUMBLE_BOOLEAN :: "SDL.joystick.cap.trigger_rumble";
SDL_HAT_CENTERED :: 0x00;
SDL_HAT_UP :: 0x01;
SDL_HAT_RIGHT :: 0x02;
SDL_HAT_DOWN :: 0x04;
SDL_HAT_LEFT :: 0x08;
SDL_HAT_RIGHTUP :: SDL_HAT_RIGHT|SDL_HAT_UP;
SDL_HAT_RIGHTDOWN :: SDL_HAT_RIGHT|SDL_HAT_DOWN;
SDL_HAT_LEFTUP :: SDL_HAT_LEFT|SDL_HAT_UP;
SDL_HAT_LEFTDOWN :: SDL_HAT_LEFT|SDL_HAT_DOWN;
SDL_PROP_GAMEPAD_CAP_MONO_LED_BOOLEAN :: SDL_PROP_JOYSTICK_CAP_MONO_LED_BOOLEAN;
SDL_PROP_GAMEPAD_CAP_RGB_LED_BOOLEAN :: SDL_PROP_JOYSTICK_CAP_RGB_LED_BOOLEAN;
SDL_PROP_GAMEPAD_CAP_PLAYER_LED_BOOLEAN :: SDL_PROP_JOYSTICK_CAP_PLAYER_LED_BOOLEAN;
SDL_PROP_GAMEPAD_CAP_RUMBLE_BOOLEAN :: SDL_PROP_JOYSTICK_CAP_RUMBLE_BOOLEAN;
SDL_PROP_GAMEPAD_CAP_TRIGGER_RUMBLE_BOOLEAN :: SDL_PROP_JOYSTICK_CAP_TRIGGER_RUMBLE_BOOLEAN;
SDLK_SCANCODE_MASK :: 1<<30;
SDLK_UNKNOWN :: 0x00000000;
SDLK_RETURN :: 0x0000000d;
SDLK_ESCAPE :: 0x0000001b;
SDLK_BACKSPACE :: 0x00000008;
SDLK_TAB :: 0x00000009;
SDLK_SPACE :: 0x00000020;
SDLK_EXCLAIM :: 0x00000021;
SDLK_DBLAPOSTROPHE :: 0x00000022;
SDLK_HASH :: 0x00000023;
SDLK_DOLLAR :: 0x00000024;
SDLK_PERCENT :: 0x00000025;
SDLK_AMPERSAND :: 0x00000026;
SDLK_APOSTROPHE :: 0x00000027;
SDLK_LEFTPAREN :: 0x00000028;
SDLK_RIGHTPAREN :: 0x00000029;
SDLK_ASTERISK :: 0x0000002a;
SDLK_PLUS :: 0x0000002b;
SDLK_COMMA :: 0x0000002c;
SDLK_MINUS :: 0x0000002d;
SDLK_PERIOD :: 0x0000002e;
SDLK_SLASH :: 0x0000002f;
SDLK_0 :: 0x00000030;
SDLK_1 :: 0x00000031;
SDLK_2 :: 0x00000032;
SDLK_3 :: 0x00000033;
SDLK_4 :: 0x00000034;
SDLK_5 :: 0x00000035;
SDLK_6 :: 0x00000036;
SDLK_7 :: 0x00000037;
SDLK_8 :: 0x00000038;
SDLK_9 :: 0x00000039;
SDLK_COLON :: 0x0000003a;
SDLK_SEMICOLON :: 0x0000003b;
SDLK_LESS :: 0x0000003c;
SDLK_EQUALS :: 0x0000003d;
SDLK_GREATER :: 0x0000003e;
SDLK_QUESTION :: 0x0000003f;
SDLK_AT :: 0x00000040;
SDLK_LEFTBRACKET :: 0x0000005b;
SDLK_BACKSLASH :: 0x0000005c;
SDLK_RIGHTBRACKET :: 0x0000005d;
SDLK_CARET :: 0x0000005e;
SDLK_UNDERSCORE :: 0x0000005f;
SDLK_GRAVE :: 0x00000060;
SDLK_A :: 0x00000061;
SDLK_B :: 0x00000062;
SDLK_C :: 0x00000063;
SDLK_D :: 0x00000064;
SDLK_E :: 0x00000065;
SDLK_F :: 0x00000066;
SDLK_G :: 0x00000067;
SDLK_H :: 0x00000068;
SDLK_I :: 0x00000069;
SDLK_J :: 0x0000006a;
SDLK_K :: 0x0000006b;
SDLK_L :: 0x0000006c;
SDLK_M :: 0x0000006d;
SDLK_N :: 0x0000006e;
SDLK_O :: 0x0000006f;
SDLK_P :: 0x00000070;
SDLK_Q :: 0x00000071;
SDLK_R :: 0x00000072;
SDLK_S :: 0x00000073;
SDLK_T :: 0x00000074;
SDLK_U :: 0x00000075;
SDLK_V :: 0x00000076;
SDLK_W :: 0x00000077;
SDLK_X :: 0x00000078;
SDLK_Y :: 0x00000079;
SDLK_Z :: 0x0000007a;
SDLK_LEFTBRACE :: 0x0000007b;
SDLK_PIPE :: 0x0000007c;
SDLK_RIGHTBRACE :: 0x0000007d;
SDLK_TILDE :: 0x0000007e;
SDLK_DELETE :: 0x0000007f;
SDLK_PLUSMINUS :: 0x000000b1;
SDLK_CAPSLOCK :: 0x40000039;
SDLK_F1 :: 0x4000003a;
SDLK_F2 :: 0x4000003b;
SDLK_F3 :: 0x4000003c;
SDLK_F4 :: 0x4000003d;
SDLK_F5 :: 0x4000003e;
SDLK_F6 :: 0x4000003f;
SDLK_F7 :: 0x40000040;
SDLK_F8 :: 0x40000041;
SDLK_F9 :: 0x40000042;
SDLK_F10 :: 0x40000043;
SDLK_F11 :: 0x40000044;
SDLK_F12 :: 0x40000045;
SDLK_PRINTSCREEN :: 0x40000046;
SDLK_SCROLLLOCK :: 0x40000047;
SDLK_PAUSE :: 0x40000048;
SDLK_INSERT :: 0x40000049;
SDLK_HOME :: 0x4000004a;
SDLK_PAGEUP :: 0x4000004b;
SDLK_END :: 0x4000004d;
SDLK_PAGEDOWN :: 0x4000004e;
SDLK_RIGHT :: 0x4000004f;
SDLK_LEFT :: 0x40000050;
SDLK_DOWN :: 0x40000051;
SDLK_UP :: 0x40000052;
SDLK_NUMLOCKCLEAR :: 0x40000053;
SDLK_KP_DIVIDE :: 0x40000054;
SDLK_KP_MULTIPLY :: 0x40000055;
SDLK_KP_MINUS :: 0x40000056;
SDLK_KP_PLUS :: 0x40000057;
SDLK_KP_ENTER :: 0x40000058;
SDLK_KP_1 :: 0x40000059;
SDLK_KP_2 :: 0x4000005a;
SDLK_KP_3 :: 0x4000005b;
SDLK_KP_4 :: 0x4000005c;
SDLK_KP_5 :: 0x4000005d;
SDLK_KP_6 :: 0x4000005e;
SDLK_KP_7 :: 0x4000005f;
SDLK_KP_8 :: 0x40000060;
SDLK_KP_9 :: 0x40000061;
SDLK_KP_0 :: 0x40000062;
SDLK_KP_PERIOD :: 0x40000063;
SDLK_APPLICATION :: 0x40000065;
SDLK_POWER :: 0x40000066;
SDLK_KP_EQUALS :: 0x40000067;
SDLK_F13 :: 0x40000068;
SDLK_F14 :: 0x40000069;
SDLK_F15 :: 0x4000006a;
SDLK_F16 :: 0x4000006b;
SDLK_F17 :: 0x4000006c;
SDLK_F18 :: 0x4000006d;
SDLK_F19 :: 0x4000006e;
SDLK_F20 :: 0x4000006f;
SDLK_F21 :: 0x40000070;
SDLK_F22 :: 0x40000071;
SDLK_F23 :: 0x40000072;
SDLK_F24 :: 0x40000073;
SDLK_EXECUTE :: 0x40000074;
SDLK_HELP :: 0x40000075;
SDLK_MENU :: 0x40000076;
SDLK_SELECT :: 0x40000077;
SDLK_STOP :: 0x40000078;
SDLK_AGAIN :: 0x40000079;
SDLK_UNDO :: 0x4000007a;
SDLK_CUT :: 0x4000007b;
SDLK_COPY :: 0x4000007c;
SDLK_PASTE :: 0x4000007d;
SDLK_FIND :: 0x4000007e;
SDLK_MUTE :: 0x4000007f;
SDLK_VOLUMEUP :: 0x40000080;
SDLK_VOLUMEDOWN :: 0x40000081;
SDLK_KP_COMMA :: 0x40000085;
SDLK_KP_EQUALSAS400 :: 0x40000086;
SDLK_ALTERASE :: 0x40000099;
SDLK_SYSREQ :: 0x4000009a;
SDLK_CANCEL :: 0x4000009b;
SDLK_CLEAR :: 0x4000009c;
SDLK_PRIOR :: 0x4000009d;
SDLK_RETURN2 :: 0x4000009e;
SDLK_SEPARATOR :: 0x4000009f;
SDLK_OUT :: 0x400000a0;
SDLK_OPER :: 0x400000a1;
SDLK_CLEARAGAIN :: 0x400000a2;
SDLK_CRSEL :: 0x400000a3;
SDLK_EXSEL :: 0x400000a4;
SDLK_KP_00 :: 0x400000b0;
SDLK_KP_000 :: 0x400000b1;
SDLK_THOUSANDSSEPARATOR :: 0x400000b2;
SDLK_DECIMALSEPARATOR :: 0x400000b3;
SDLK_CURRENCYUNIT :: 0x400000b4;
SDLK_CURRENCYSUBUNIT :: 0x400000b5;
SDLK_KP_LEFTPAREN :: 0x400000b6;
SDLK_KP_RIGHTPAREN :: 0x400000b7;
SDLK_KP_LEFTBRACE :: 0x400000b8;
SDLK_KP_RIGHTBRACE :: 0x400000b9;
SDLK_KP_TAB :: 0x400000ba;
SDLK_KP_BACKSPACE :: 0x400000bb;
SDLK_KP_A :: 0x400000bc;
SDLK_KP_B :: 0x400000bd;
SDLK_KP_C :: 0x400000be;
SDLK_KP_D :: 0x400000bf;
SDLK_KP_E :: 0x400000c0;
SDLK_KP_F :: 0x400000c1;
SDLK_KP_XOR :: 0x400000c2;
SDLK_KP_POWER :: 0x400000c3;
SDLK_KP_PERCENT :: 0x400000c4;
SDLK_KP_LESS :: 0x400000c5;
SDLK_KP_GREATER :: 0x400000c6;
SDLK_KP_AMPERSAND :: 0x400000c7;
SDLK_KP_DBLAMPERSAND :: 0x400000c8;
SDLK_KP_VERTICALBAR :: 0x400000c9;
SDLK_KP_DBLVERTICALBAR :: 0x400000ca;
SDLK_KP_COLON :: 0x400000cb;
SDLK_KP_HASH :: 0x400000cc;
SDLK_KP_SPACE :: 0x400000cd;
SDLK_KP_AT :: 0x400000ce;
SDLK_KP_EXCLAM :: 0x400000cf;
SDLK_KP_MEMSTORE :: 0x400000d0;
SDLK_KP_MEMRECALL :: 0x400000d1;
SDLK_KP_MEMCLEAR :: 0x400000d2;
SDLK_KP_MEMADD :: 0x400000d3;
SDLK_KP_MEMSUBTRACT :: 0x400000d4;
SDLK_KP_MEMMULTIPLY :: 0x400000d5;
SDLK_KP_MEMDIVIDE :: 0x400000d6;
SDLK_KP_PLUSMINUS :: 0x400000d7;
SDLK_KP_CLEAR :: 0x400000d8;
SDLK_KP_CLEARENTRY :: 0x400000d9;
SDLK_KP_BINARY :: 0x400000da;
SDLK_KP_OCTAL :: 0x400000db;
SDLK_KP_DECIMAL :: 0x400000dc;
SDLK_KP_HEXADECIMAL :: 0x400000dd;
SDLK_LCTRL :: 0x400000e0;
SDLK_LSHIFT :: 0x400000e1;
SDLK_LALT :: 0x400000e2;
SDLK_LGUI :: 0x400000e3;
SDLK_RCTRL :: 0x400000e4;
SDLK_RSHIFT :: 0x400000e5;
SDLK_RALT :: 0x400000e6;
SDLK_RGUI :: 0x400000e7;
SDLK_MODE :: 0x40000101;
SDLK_SLEEP :: 0x40000102;
SDLK_WAKE :: 0x40000103;
SDLK_CHANNEL_INCREMENT :: 0x40000104;
SDLK_CHANNEL_DECREMENT :: 0x40000105;
SDLK_MEDIA_PLAY :: 0x40000106;
SDLK_MEDIA_PAUSE :: 0x40000107;
SDLK_MEDIA_RECORD :: 0x40000108;
SDLK_MEDIA_FAST_FORWARD :: 0x40000109;
SDLK_MEDIA_REWIND :: 0x4000010a;
SDLK_MEDIA_NEXT_TRACK :: 0x4000010b;
SDLK_MEDIA_PREVIOUS_TRACK :: 0x4000010c;
SDLK_MEDIA_STOP :: 0x4000010d;
SDLK_MEDIA_EJECT :: 0x4000010e;
SDLK_MEDIA_PLAY_PAUSE :: 0x4000010f;
SDLK_MEDIA_SELECT :: 0x40000110;
SDLK_AC_NEW :: 0x40000111;
SDLK_AC_OPEN :: 0x40000112;
SDLK_AC_CLOSE :: 0x40000113;
SDLK_AC_EXIT :: 0x40000114;
SDLK_AC_SAVE :: 0x40000115;
SDLK_AC_PRINT :: 0x40000116;
SDLK_AC_PROPERTIES :: 0x40000117;
SDLK_AC_SEARCH :: 0x40000118;
SDLK_AC_HOME :: 0x40000119;
SDLK_AC_BACK :: 0x4000011a;
SDLK_AC_FORWARD :: 0x4000011b;
SDLK_AC_STOP :: 0x4000011c;
SDLK_AC_REFRESH :: 0x4000011d;
SDLK_AC_BOOKMARKS :: 0x4000011e;
SDLK_SOFTLEFT :: 0x4000011f;
SDLK_SOFTRIGHT :: 0x40000120;
SDLK_CALL :: 0x40000121;
SDLK_ENDCALL :: 0x40000122;
SDL_KMOD_NONE :: 0x0000;
SDL_KMOD_LSHIFT :: 0x0001;
SDL_KMOD_RSHIFT :: 0x0002;
SDL_KMOD_LCTRL :: 0x0040;
SDL_KMOD_RCTRL :: 0x0080;
SDL_KMOD_LALT :: 0x0100;
SDL_KMOD_RALT :: 0x0200;
SDL_KMOD_LGUI :: 0x0400;
SDL_KMOD_RGUI :: 0x0800;
SDL_KMOD_NUM :: 0x1000;
SDL_KMOD_CAPS :: 0x2000;
SDL_KMOD_MODE :: 0x4000;
SDL_KMOD_SCROLL :: 0x8000;
SDL_KMOD_CTRL :: SDL_KMOD_LCTRL | SDL_KMOD_RCTRL;
SDL_KMOD_SHIFT :: SDL_KMOD_LSHIFT | SDL_KMOD_RSHIFT;
SDL_KMOD_ALT :: SDL_KMOD_LALT | SDL_KMOD_RALT;
SDL_KMOD_GUI :: SDL_KMOD_LGUI | SDL_KMOD_RGUI;
SDL_PROP_TEXTINPUT_TYPE_NUMBER :: "SDL.textinput.type";
SDL_PROP_TEXTINPUT_CAPITALIZATION_NUMBER :: "SDL.textinput.capitalization";
SDL_PROP_TEXTINPUT_AUTOCORRECT_BOOLEAN :: "SDL.textinput.autocorrect";
SDL_PROP_TEXTINPUT_MULTILINE_BOOLEAN :: "SDL.textinput.multiline";
SDL_PROP_TEXTINPUT_ANDROID_INPUTTYPE_NUMBER :: "SDL.textinput.android.inputtype";
SDL_BUTTON_LEFT :: 1;
SDL_BUTTON_MIDDLE :: 2;
SDL_BUTTON_RIGHT :: 3;
SDL_BUTTON_X1 :: 4;
SDL_BUTTON_X2 :: 5;
SDL_PEN_INPUT_DOWN :: 1 << 0;
SDL_PEN_INPUT_BUTTON_1 :: 1 << 1;
SDL_PEN_INPUT_BUTTON_2 :: 1 << 2;
SDL_PEN_INPUT_BUTTON_3 :: 1 << 3;
SDL_PEN_INPUT_BUTTON_4 :: 1 << 4;
SDL_PEN_INPUT_BUTTON_5 :: 1 << 5;
SDL_PEN_INPUT_ERASER_TIP :: 1 << 30;
SDL_TOUCH_MOUSEID :: cast,trunc(SDL_MouseID) -1;
SDL_MOUSE_TOUCHID :: cast,trunc(SDL_TouchID) -1;
SDL_GLOB_CASEINSENSITIVE :: 1 << 0;
SDL_GPU_TEXTUREUSAGE_SAMPLER :: 1 << 0;
SDL_GPU_TEXTUREUSAGE_COLOR_TARGET :: 1 << 1;
SDL_GPU_TEXTUREUSAGE_DEPTH_STENCIL_TARGET :: 1 << 2;
SDL_GPU_TEXTUREUSAGE_GRAPHICS_STORAGE_READ :: 1 << 3;
SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_READ :: 1 << 4;
SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_WRITE :: 1 << 5;
SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE :: 1 << 6;
SDL_GPU_BUFFERUSAGE_VERTEX :: 1 << 0;
SDL_GPU_BUFFERUSAGE_INDEX :: 1 << 1;
SDL_GPU_BUFFERUSAGE_INDIRECT :: 1 << 2;
SDL_GPU_BUFFERUSAGE_GRAPHICS_STORAGE_READ :: 1 << 3;
SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_READ :: 1 << 4;
SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_WRITE :: 1 << 5;
SDL_GPU_SHADERFORMAT_INVALID :: 0;
SDL_GPU_SHADERFORMAT_PRIVATE :: 1 << 0;
SDL_GPU_SHADERFORMAT_SPIRV :: 1 << 1;
SDL_GPU_SHADERFORMAT_DXBC :: 1 << 2;
SDL_GPU_SHADERFORMAT_DXIL :: 1 << 3;
SDL_GPU_SHADERFORMAT_MSL :: 1 << 4;
SDL_GPU_SHADERFORMAT_METALLIB :: 1 << 5;
SDL_GPU_COLORCOMPONENT_R :: 1 << 0;
SDL_GPU_COLORCOMPONENT_G :: 1 << 1;
SDL_GPU_COLORCOMPONENT_B :: 1 << 2;
SDL_GPU_COLORCOMPONENT_A :: 1 << 3;
SDL_PROP_GPU_CREATETEXTURE_D3D12_CLEAR_R_FLOAT :: "SDL.gpu.createtexture.d3d12.clear.r";
SDL_PROP_GPU_CREATETEXTURE_D3D12_CLEAR_G_FLOAT :: "SDL.gpu.createtexture.d3d12.clear.g";
SDL_PROP_GPU_CREATETEXTURE_D3D12_CLEAR_B_FLOAT :: "SDL.gpu.createtexture.d3d12.clear.b";
SDL_PROP_GPU_CREATETEXTURE_D3D12_CLEAR_A_FLOAT :: "SDL.gpu.createtexture.d3d12.clear.a";
SDL_PROP_GPU_CREATETEXTURE_D3D12_CLEAR_DEPTH_FLOAT :: "SDL.gpu.createtexture.d3d12.clear.depth";
SDL_PROP_GPU_CREATETEXTURE_D3D12_CLEAR_STENCIL_UINT8 :: "SDL.gpu.createtexture.d3d12.clear.stencil";
SDL_PROP_GPU_DEVICE_CREATE_DEBUGMODE_BOOLEAN :: "SDL.gpu.device.create.debugmode";
SDL_PROP_GPU_DEVICE_CREATE_PREFERLOWPOWER_BOOLEAN :: "SDL.gpu.device.create.preferlowpower";
SDL_PROP_GPU_DEVICE_CREATE_NAME_STRING :: "SDL.gpu.device.create.name";
SDL_PROP_GPU_DEVICE_CREATE_SHADERS_PRIVATE_BOOLEAN :: "SDL.gpu.device.create.shaders.private";
SDL_PROP_GPU_DEVICE_CREATE_SHADERS_SPIRV_BOOLEAN :: "SDL.gpu.device.create.shaders.spirv";
SDL_PROP_GPU_DEVICE_CREATE_SHADERS_DXBC_BOOLEAN :: "SDL.gpu.device.create.shaders.dxbc";
SDL_PROP_GPU_DEVICE_CREATE_SHADERS_DXIL_BOOLEAN :: "SDL.gpu.device.create.shaders.dxil";
SDL_PROP_GPU_DEVICE_CREATE_SHADERS_MSL_BOOLEAN :: "SDL.gpu.device.create.shaders.msl";
SDL_PROP_GPU_DEVICE_CREATE_SHADERS_METALLIB_BOOLEAN :: "SDL.gpu.device.create.shaders.metallib";
SDL_PROP_GPU_DEVICE_CREATE_D3D12_SEMANTIC_NAME_STRING :: "SDL.gpu.device.create.d3d12.semantic";
SDL_INIT_AUDIO :: 0x00000010;
SDL_INIT_VIDEO :: 0x00000020;
SDL_INIT_JOYSTICK :: 0x00000200;
SDL_INIT_HAPTIC :: 0x00001000;
SDL_INIT_GAMEPAD :: 0x00002000;
SDL_INIT_EVENTS :: 0x00004000;
SDL_INIT_SENSOR :: 0x00008000;
SDL_INIT_CAMERA :: 0x00010000;
SDL_PROP_APP_METADATA_NAME_STRING :: "SDL.app.metadata.name";
SDL_PROP_APP_METADATA_VERSION_STRING :: "SDL.app.metadata.version";
SDL_PROP_APP_METADATA_IDENTIFIER_STRING :: "SDL.app.metadata.identifier";
SDL_PROP_APP_METADATA_CREATOR_STRING :: "SDL.app.metadata.creator";
SDL_PROP_APP_METADATA_COPYRIGHT_STRING :: "SDL.app.metadata.copyright";
SDL_PROP_APP_METADATA_URL_STRING :: "SDL.app.metadata.url";
SDL_PROP_APP_METADATA_TYPE_STRING :: "SDL.app.metadata.type";
SDL_MESSAGEBOX_ERROR :: 0x00000010;
SDL_MESSAGEBOX_WARNING :: 0x00000020;
SDL_MESSAGEBOX_INFORMATION :: 0x00000040;
SDL_MESSAGEBOX_BUTTONS_LEFT_TO_RIGHT :: 0x00000080;
SDL_MESSAGEBOX_BUTTONS_RIGHT_TO_LEFT :: 0x00000100;
SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT :: 0x00000001;
SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT :: 0x00000002;
SDL_PROP_PROCESS_CREATE_ARGS_POINTER :: "SDL.process.create.args";
SDL_PROP_PROCESS_CREATE_ENVIRONMENT_POINTER :: "SDL.process.create.environment";
SDL_PROP_PROCESS_CREATE_STDIN_NUMBER :: "SDL.process.create.stdin_option";
SDL_PROP_PROCESS_CREATE_STDIN_POINTER :: "SDL.process.create.stdin_source";
SDL_PROP_PROCESS_CREATE_STDOUT_NUMBER :: "SDL.process.create.stdout_option";
SDL_PROP_PROCESS_CREATE_STDOUT_POINTER :: "SDL.process.create.stdout_source";
SDL_PROP_PROCESS_CREATE_STDERR_NUMBER :: "SDL.process.create.stderr_option";
SDL_PROP_PROCESS_CREATE_STDERR_POINTER :: "SDL.process.create.stderr_source";
SDL_PROP_PROCESS_CREATE_STDERR_TO_STDOUT_BOOLEAN :: "SDL.process.create.stderr_to_stdout";
SDL_PROP_PROCESS_CREATE_BACKGROUND_BOOLEAN :: "SDL.process.create.background";
SDL_PROP_PROCESS_PID_NUMBER :: "SDL.process.pid";
SDL_PROP_PROCESS_STDIN_POINTER :: "SDL.process.stdin";
SDL_PROP_PROCESS_STDOUT_POINTER :: "SDL.process.stdout";
SDL_PROP_PROCESS_STDERR_POINTER :: "SDL.process.stderr";
SDL_PROP_PROCESS_BACKGROUND_BOOLEAN :: "SDL.process.background";
SDL_SOFTWARE_RENDERER :: "software";
SDL_PROP_RENDERER_CREATE_NAME_STRING :: "SDL.renderer.create.name";
SDL_PROP_RENDERER_CREATE_WINDOW_POINTER :: "SDL.renderer.create.window";
SDL_PROP_RENDERER_CREATE_SURFACE_POINTER :: "SDL.renderer.create.surface";
SDL_PROP_RENDERER_CREATE_OUTPUT_COLORSPACE_NUMBER :: "SDL.renderer.create.output_colorspace";
SDL_PROP_RENDERER_CREATE_PRESENT_VSYNC_NUMBER :: "SDL.renderer.create.present_vsync";
SDL_PROP_RENDERER_CREATE_VULKAN_INSTANCE_POINTER :: "SDL.renderer.create.vulkan.instance";
SDL_PROP_RENDERER_CREATE_VULKAN_SURFACE_NUMBER :: "SDL.renderer.create.vulkan.surface";
SDL_PROP_RENDERER_CREATE_VULKAN_PHYSICAL_DEVICE_POINTER :: "SDL.renderer.create.vulkan.physical_device";
SDL_PROP_RENDERER_CREATE_VULKAN_DEVICE_POINTER :: "SDL.renderer.create.vulkan.device";
SDL_PROP_RENDERER_CREATE_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER :: "SDL.renderer.create.vulkan.graphics_queue_family_index";
SDL_PROP_RENDERER_CREATE_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER :: "SDL.renderer.create.vulkan.present_queue_family_index";
SDL_PROP_RENDERER_NAME_STRING :: "SDL.renderer.name";
SDL_PROP_RENDERER_WINDOW_POINTER :: "SDL.renderer.window";
SDL_PROP_RENDERER_SURFACE_POINTER :: "SDL.renderer.surface";
SDL_PROP_RENDERER_VSYNC_NUMBER :: "SDL.renderer.vsync";
SDL_PROP_RENDERER_MAX_TEXTURE_SIZE_NUMBER :: "SDL.renderer.max_texture_size";
SDL_PROP_RENDERER_TEXTURE_FORMATS_POINTER :: "SDL.renderer.texture_formats";
SDL_PROP_RENDERER_OUTPUT_COLORSPACE_NUMBER :: "SDL.renderer.output_colorspace";
SDL_PROP_RENDERER_HDR_ENABLED_BOOLEAN :: "SDL.renderer.HDR_enabled";
SDL_PROP_RENDERER_SDR_WHITE_POINT_FLOAT :: "SDL.renderer.SDR_white_point";
SDL_PROP_RENDERER_HDR_HEADROOM_FLOAT :: "SDL.renderer.HDR_headroom";
SDL_PROP_RENDERER_D3D9_DEVICE_POINTER :: "SDL.renderer.d3d9.device";
SDL_PROP_RENDERER_D3D11_DEVICE_POINTER :: "SDL.renderer.d3d11.device";
SDL_PROP_RENDERER_D3D11_SWAPCHAIN_POINTER :: "SDL.renderer.d3d11.swap_chain";
SDL_PROP_RENDERER_D3D12_DEVICE_POINTER :: "SDL.renderer.d3d12.device";
SDL_PROP_RENDERER_D3D12_SWAPCHAIN_POINTER :: "SDL.renderer.d3d12.swap_chain";
SDL_PROP_RENDERER_D3D12_COMMAND_QUEUE_POINTER :: "SDL.renderer.d3d12.command_queue";
SDL_PROP_RENDERER_VULKAN_INSTANCE_POINTER :: "SDL.renderer.vulkan.instance";
SDL_PROP_RENDERER_VULKAN_SURFACE_NUMBER :: "SDL.renderer.vulkan.surface";
SDL_PROP_RENDERER_VULKAN_PHYSICAL_DEVICE_POINTER :: "SDL.renderer.vulkan.physical_device";
SDL_PROP_RENDERER_VULKAN_DEVICE_POINTER :: "SDL.renderer.vulkan.device";
SDL_PROP_RENDERER_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER :: "SDL.renderer.vulkan.graphics_queue_family_index";
SDL_PROP_RENDERER_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER :: "SDL.renderer.vulkan.present_queue_family_index";
SDL_PROP_RENDERER_VULKAN_SWAPCHAIN_IMAGE_COUNT_NUMBER :: "SDL.renderer.vulkan.swapchain_image_count";
SDL_PROP_TEXTURE_CREATE_COLORSPACE_NUMBER :: "SDL.texture.create.colorspace";
SDL_PROP_TEXTURE_CREATE_FORMAT_NUMBER :: "SDL.texture.create.format";
SDL_PROP_TEXTURE_CREATE_ACCESS_NUMBER :: "SDL.texture.create.access";
SDL_PROP_TEXTURE_CREATE_WIDTH_NUMBER :: "SDL.texture.create.width";
SDL_PROP_TEXTURE_CREATE_HEIGHT_NUMBER :: "SDL.texture.create.height";
SDL_PROP_TEXTURE_CREATE_SDR_WHITE_POINT_FLOAT :: "SDL.texture.create.SDR_white_point";
SDL_PROP_TEXTURE_CREATE_HDR_HEADROOM_FLOAT :: "SDL.texture.create.HDR_headroom";
SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_POINTER :: "SDL.texture.create.d3d11.texture";
SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_U_POINTER :: "SDL.texture.create.d3d11.texture_u";
SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_V_POINTER :: "SDL.texture.create.d3d11.texture_v";
SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_POINTER :: "SDL.texture.create.d3d12.texture";
SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_U_POINTER :: "SDL.texture.create.d3d12.texture_u";
SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_V_POINTER :: "SDL.texture.create.d3d12.texture_v";
SDL_PROP_TEXTURE_CREATE_METAL_PIXELBUFFER_POINTER :: "SDL.texture.create.metal.pixelbuffer";
SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_NUMBER :: "SDL.texture.create.opengl.texture";
SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_UV_NUMBER :: "SDL.texture.create.opengl.texture_uv";
SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_U_NUMBER :: "SDL.texture.create.opengl.texture_u";
SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_V_NUMBER :: "SDL.texture.create.opengl.texture_v";
SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_NUMBER :: "SDL.texture.create.opengles2.texture";
SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_UV_NUMBER :: "SDL.texture.create.opengles2.texture_uv";
SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_U_NUMBER :: "SDL.texture.create.opengles2.texture_u";
SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_V_NUMBER :: "SDL.texture.create.opengles2.texture_v";
SDL_PROP_TEXTURE_CREATE_VULKAN_TEXTURE_NUMBER :: "SDL.texture.create.vulkan.texture";
SDL_PROP_TEXTURE_COLORSPACE_NUMBER :: "SDL.texture.colorspace";
SDL_PROP_TEXTURE_FORMAT_NUMBER :: "SDL.texture.format";
SDL_PROP_TEXTURE_ACCESS_NUMBER :: "SDL.texture.access";
SDL_PROP_TEXTURE_WIDTH_NUMBER :: "SDL.texture.width";
SDL_PROP_TEXTURE_HEIGHT_NUMBER :: "SDL.texture.height";
SDL_PROP_TEXTURE_SDR_WHITE_POINT_FLOAT :: "SDL.texture.SDR_white_point";
SDL_PROP_TEXTURE_HDR_HEADROOM_FLOAT :: "SDL.texture.HDR_headroom";
SDL_PROP_TEXTURE_D3D11_TEXTURE_POINTER :: "SDL.texture.d3d11.texture";
SDL_PROP_TEXTURE_D3D11_TEXTURE_U_POINTER :: "SDL.texture.d3d11.texture_u";
SDL_PROP_TEXTURE_D3D11_TEXTURE_V_POINTER :: "SDL.texture.d3d11.texture_v";
SDL_PROP_TEXTURE_D3D12_TEXTURE_POINTER :: "SDL.texture.d3d12.texture";
SDL_PROP_TEXTURE_D3D12_TEXTURE_U_POINTER :: "SDL.texture.d3d12.texture_u";
SDL_PROP_TEXTURE_D3D12_TEXTURE_V_POINTER :: "SDL.texture.d3d12.texture_v";
SDL_PROP_TEXTURE_OPENGL_TEXTURE_NUMBER :: "SDL.texture.opengl.texture";
SDL_PROP_TEXTURE_OPENGL_TEXTURE_UV_NUMBER :: "SDL.texture.opengl.texture_uv";
SDL_PROP_TEXTURE_OPENGL_TEXTURE_U_NUMBER :: "SDL.texture.opengl.texture_u";
SDL_PROP_TEXTURE_OPENGL_TEXTURE_V_NUMBER :: "SDL.texture.opengl.texture_v";
SDL_PROP_TEXTURE_OPENGL_TEXTURE_TARGET_NUMBER :: "SDL.texture.opengl.target";
SDL_PROP_TEXTURE_OPENGL_TEX_W_FLOAT :: "SDL.texture.opengl.tex_w";
SDL_PROP_TEXTURE_OPENGL_TEX_H_FLOAT :: "SDL.texture.opengl.tex_h";
SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_NUMBER :: "SDL.texture.opengles2.texture";
SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_UV_NUMBER :: "SDL.texture.opengles2.texture_uv";
SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_U_NUMBER :: "SDL.texture.opengles2.texture_u";
SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_V_NUMBER :: "SDL.texture.opengles2.texture_v";
SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_TARGET_NUMBER :: "SDL.texture.opengles2.target";
SDL_PROP_TEXTURE_VULKAN_TEXTURE_NUMBER :: "SDL.texture.vulkan.texture";
SDL_RENDERER_VSYNC_DISABLED :: 0;
SDL_RENDERER_VSYNC_ADAPTIVE :: -1;
SDL_DEBUG_TEXT_FONT_CHARACTER_SIZE :: 8;
SDL_REVISION :: "preview-3.1.6-0-g78cc5c173";
SDL_MS_PER_SECOND :: 1000;
SDL_US_PER_SECOND :: 1000000;
SDL_NS_PER_SECOND :: 1000000000;
SDL_NS_PER_MS :: 1000000;
SDL_NS_PER_US :: 1000;
SDL_MAJOR_VERSION :: 3;
SDL_MINOR_VERSION :: 1;
SDL_MICRO_VERSION :: 6;
Sint8 :: s8;
Uint8 :: u8;
Sint16 :: s16;
Uint16 :: u16;
Sint32 :: s32;
Uint32 :: u32;
Sint64 :: s64;
Uint64 :: u64;
SDL_Time :: Sint64;
SDL_alignment_test :: struct {
    a: Uint8;
    b: *void;
}
SDL_DUMMY_ENUM :: enum u32 {
    DUMMY_ENUM_VALUE :: 0;
}
SDL_malloc :: (size: u64) -> *void #foreign sdl3;
SDL_calloc :: (nmemb: u64, size: u64) -> *void #foreign sdl3;
SDL_realloc :: (mem: *void, size: u64) -> *void #foreign sdl3;
SDL_free :: (mem: *void) -> void #foreign sdl3;
SDL_malloc_func :: #type (size: u64) -> *void #c_call;
SDL_calloc_func :: #type (nmemb: u64, size: u64) -> *void #c_call;
SDL_realloc_func :: #type (mem: *void, size: u64) -> *void #c_call;
SDL_free_func :: #type (mem: *void) -> void #c_call;
SDL_GetOriginalMemoryFunctions :: (malloc_func: *SDL_malloc_func, calloc_func: *SDL_calloc_func, realloc_func: *SDL_realloc_func, free_func: *SDL_free_func) -> void #foreign sdl3;
SDL_GetMemoryFunctions :: (malloc_func: *SDL_malloc_func, calloc_func: *SDL_calloc_func, realloc_func: *SDL_realloc_func, free_func: *SDL_free_func) -> void #foreign sdl3;
SDL_SetMemoryFunctions :: (malloc_func: SDL_malloc_func, calloc_func: SDL_calloc_func, realloc_func: SDL_realloc_func, free_func: SDL_free_func) -> bool #foreign sdl3;
SDL_aligned_alloc :: (alignment: u64, size: u64) -> *void #foreign sdl3;
SDL_aligned_free :: (mem: *void) -> void #foreign sdl3;
SDL_GetNumAllocations :: () -> s32 #foreign sdl3;
SDL_Environment :: struct {}
SDL_GetEnvironment :: () -> *SDL_Environment #foreign sdl3;
SDL_CreateEnvironment :: (populated: bool) -> *SDL_Environment #foreign sdl3;
SDL_GetEnvironmentVariable :: (env: *SDL_Environment, name: *u8) -> *u8 #foreign sdl3;
SDL_GetEnvironmentVariables :: (env: *SDL_Environment) -> **u8 #foreign sdl3;
SDL_SetEnvironmentVariable :: (env: *SDL_Environment, name: *u8, value: *u8, overwrite: bool) -> bool #foreign sdl3;
SDL_UnsetEnvironmentVariable :: (env: *SDL_Environment, name: *u8) -> bool #foreign sdl3;
SDL_DestroyEnvironment :: (env: *SDL_Environment) -> void #foreign sdl3;
SDL_getenv :: (name: *u8) -> *u8 #foreign sdl3;
SDL_getenv_unsafe :: (name: *u8) -> *u8 #foreign sdl3;
SDL_setenv_unsafe :: (name: *u8, value: *u8, overwrite: s32) -> s32 #foreign sdl3;
SDL_unsetenv_unsafe :: (name: *u8) -> s32 #foreign sdl3;
SDL_CompareCallback :: #type (a: *void, b: *void) -> s32 #c_call;
SDL_qsort :: (base: *void, nmemb: u64, size: u64, compare: SDL_CompareCallback) -> void #foreign sdl3;
SDL_bsearch :: (key: *void, base: *void, nmemb: u64, size: u64, compare: SDL_CompareCallback) -> *void #foreign sdl3;
SDL_CompareCallback_r :: #type (userdata: *void, a: *void, b: *void) -> s32 #c_call;
SDL_qsort_r :: (base: *void, nmemb: u64, size: u64, compare: SDL_CompareCallback_r, userdata: *void) -> void #foreign sdl3;
SDL_bsearch_r :: (key: *void, base: *void, nmemb: u64, size: u64, compare: SDL_CompareCallback_r, userdata: *void) -> *void #foreign sdl3;
SDL_abs :: (x: s32) -> s32 #foreign sdl3;
SDL_isalpha :: (x: s32) -> s32 #foreign sdl3;
SDL_isalnum :: (x: s32) -> s32 #foreign sdl3;
SDL_isblank :: (x: s32) -> s32 #foreign sdl3;
SDL_iscntrl :: (x: s32) -> s32 #foreign sdl3;
SDL_isdigit :: (x: s32) -> s32 #foreign sdl3;
SDL_isxdigit :: (x: s32) -> s32 #foreign sdl3;
SDL_ispunct :: (x: s32) -> s32 #foreign sdl3;
SDL_isspace :: (x: s32) -> s32 #foreign sdl3;
SDL_isupper :: (x: s32) -> s32 #foreign sdl3;
SDL_islower :: (x: s32) -> s32 #foreign sdl3;
SDL_isprint :: (x: s32) -> s32 #foreign sdl3;
SDL_isgraph :: (x: s32) -> s32 #foreign sdl3;
SDL_toupper :: (x: s32) -> s32 #foreign sdl3;
SDL_tolower :: (x: s32) -> s32 #foreign sdl3;
SDL_crc16 :: (crc: Uint16, data: *void, len: u64) -> Uint16 #foreign sdl3;
SDL_crc32 :: (crc: Uint32, data: *void, len: u64) -> Uint32 #foreign sdl3;
SDL_murmur3_32 :: (data: *void, len: u64, seed: Uint32) -> Uint32 #foreign sdl3;
SDL_memcpy :: (dst: *void, src: *void, len: u64) -> *void #foreign sdl3;
SDL_memmove :: (dst: *void, src: *void, len: u64) -> *void #foreign sdl3;
SDL_memset :: (dst: *void, c: s32, len: u64) -> *void #foreign sdl3;
SDL_memset4 :: (dst: *void, val: Uint32, dwords: u64) -> *void #foreign sdl3;
SDL_memcmp :: (s1: *void, s2: *void, len: u64) -> s32 #foreign sdl3;
SDL_wcslen :: (wstr: *s32) -> u64 #foreign sdl3;
SDL_wcsnlen :: (wstr: *s32, maxlen: u64) -> u64 #foreign sdl3;
SDL_wcslcpy :: (dst: *s32, src: *s32, maxlen: u64) -> u64 #foreign sdl3;
SDL_wcslcat :: (dst: *s32, src: *s32, maxlen: u64) -> u64 #foreign sdl3;
SDL_wcsdup :: (wstr: *s32) -> *s32 #foreign sdl3;
SDL_wcsstr :: (haystack: *s32, needle: *s32) -> *s32 #foreign sdl3;
SDL_wcsnstr :: (haystack: *s32, needle: *s32, maxlen: u64) -> *s32 #foreign sdl3;
SDL_wcscmp :: (str1: *s32, str2: *s32) -> s32 #foreign sdl3;
SDL_wcsncmp :: (str1: *s32, str2: *s32, maxlen: u64) -> s32 #foreign sdl3;
SDL_wcscasecmp :: (str1: *s32, str2: *s32) -> s32 #foreign sdl3;
SDL_wcsncasecmp :: (str1: *s32, str2: *s32, maxlen: u64) -> s32 #foreign sdl3;
SDL_wcstol :: (str: *s32, endp: **s32, base: s32) -> s64 #foreign sdl3;
SDL_strlen :: (str: *u8) -> u64 #foreign sdl3;
SDL_strnlen :: (str: *u8, maxlen: u64) -> u64 #foreign sdl3;
SDL_strlcpy :: (dst: *u8, src: *u8, maxlen: u64) -> u64 #foreign sdl3;
SDL_utf8strlcpy :: (dst: *u8, src: *u8, dst_bytes: u64) -> u64 #foreign sdl3;
SDL_strlcat :: (dst: *u8, src: *u8, maxlen: u64) -> u64 #foreign sdl3;
SDL_strdup :: (str: *u8) -> *u8 #foreign sdl3;
SDL_strndup :: (str: *u8, maxlen: u64) -> *u8 #foreign sdl3;
SDL_strrev :: (str: *u8) -> *u8 #foreign sdl3;
SDL_strupr :: (str: *u8) -> *u8 #foreign sdl3;
SDL_strlwr :: (str: *u8) -> *u8 #foreign sdl3;
SDL_strchr :: (str: *u8, c: s32) -> *u8 #foreign sdl3;
SDL_strrchr :: (str: *u8, c: s32) -> *u8 #foreign sdl3;
SDL_strstr :: (haystack: *u8, needle: *u8) -> *u8 #foreign sdl3;
SDL_strnstr :: (haystack: *u8, needle: *u8, maxlen: u64) -> *u8 #foreign sdl3;
SDL_strcasestr :: (haystack: *u8, needle: *u8) -> *u8 #foreign sdl3;
SDL_strtok_r :: (s1: *u8, s2: *u8, saveptr: **u8) -> *u8 #foreign sdl3;
SDL_utf8strlen :: (str: *u8) -> u64 #foreign sdl3;
SDL_utf8strnlen :: (str: *u8, bytes: u64) -> u64 #foreign sdl3;
SDL_itoa :: (value: s32, str: *u8, radix: s32) -> *u8 #foreign sdl3;
SDL_uitoa :: (value: u32, str: *u8, radix: s32) -> *u8 #foreign sdl3;
SDL_ltoa :: (value: s64, str: *u8, radix: s32) -> *u8 #foreign sdl3;
SDL_ultoa :: (value: u64, str: *u8, radix: s32) -> *u8 #foreign sdl3;
SDL_lltoa :: (value: s64, str: *u8, radix: s32) -> *u8 #foreign sdl3;
SDL_ulltoa :: (value: u64, str: *u8, radix: s32) -> *u8 #foreign sdl3;
SDL_atoi :: (str: *u8) -> s32 #foreign sdl3;
SDL_atof :: (str: *u8) -> float64 #foreign sdl3;
SDL_strtol :: (str: *u8, endp: **u8, base: s32) -> s64 #foreign sdl3;
SDL_strtoul :: (str: *u8, endp: **u8, base: s32) -> u64 #foreign sdl3;
SDL_strtoll :: (str: *u8, endp: **u8, base: s32) -> s64 #foreign sdl3;
SDL_strtoull :: (str: *u8, endp: **u8, base: s32) -> u64 #foreign sdl3;
SDL_strtod :: (str: *u8, endp: **u8) -> float64 #foreign sdl3;
SDL_strcmp :: (str1: *u8, str2: *u8) -> s32 #foreign sdl3;
SDL_strncmp :: (str1: *u8, str2: *u8, maxlen: u64) -> s32 #foreign sdl3;
SDL_strcasecmp :: (str1: *u8, str2: *u8) -> s32 #foreign sdl3;
SDL_strncasecmp :: (str1: *u8, str2: *u8, maxlen: u64) -> s32 #foreign sdl3;
SDL_strpbrk :: (str: *u8, breakset: *u8) -> *u8 #foreign sdl3;
SDL_StepUTF8 :: (pstr: **u8, pslen: *u64) -> Uint32 #foreign sdl3;
SDL_StepBackUTF8 :: (start: *u8, pstr: **u8) -> Uint32 #foreign sdl3;
SDL_UCS4ToUTF8 :: (codepoint: Uint32, dst: *u8) -> *u8 #foreign sdl3;
SDL_sscanf_CFormat :: (text: *u8, fmt: *u8, __args: ..Any) -> s32 #foreign sdl3 "SDL_sscanf";
SDL_sscanf :: (text: *u8, fmt: string, __args: ..Any) -> s32 {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    return SDL_sscanf_CFormat(text, "%s", formatted_text.data);
} @PrintLike
SDL_snprintf_CFormat :: (text: *u8, maxlen: u64, fmt: *u8, __args: ..Any) -> s32 #foreign sdl3 "SDL_snprintf";
SDL_snprintf :: (text: *u8, maxlen: u64, fmt: string, __args: ..Any) -> s32 {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    return SDL_snprintf_CFormat(text, maxlen, "%s", formatted_text.data);
} @PrintLike
SDL_swprintf :: (text: *s32, maxlen: u64, fmt: *s32, __args: ..Any) -> s32 #foreign sdl3;
SDL_asprintf_CFormat :: (strp: **u8, fmt: *u8, __args: ..Any) -> s32 #foreign sdl3 "SDL_asprintf";
SDL_asprintf :: (strp: **u8, fmt: string, __args: ..Any) -> s32 {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    return SDL_asprintf_CFormat(strp, "%s", formatted_text.data);
} @PrintLike
SDL_srand :: (seed: Uint64) -> void #foreign sdl3;
SDL_rand :: (n: Sint32) -> Sint32 #foreign sdl3;
SDL_randf :: () -> float #foreign sdl3;
SDL_rand_bits :: () -> Uint32 #foreign sdl3;
SDL_rand_r :: (state: *Uint64, n: Sint32) -> Sint32 #foreign sdl3;
SDL_randf_r :: (state: *Uint64) -> float #foreign sdl3;
SDL_rand_bits_r :: (state: *Uint64) -> Uint32 #foreign sdl3;
SDL_acos :: (x: float64) -> float64 #foreign sdl3;
SDL_acosf :: (x: float) -> float #foreign sdl3;
SDL_asin :: (x: float64) -> float64 #foreign sdl3;
SDL_asinf :: (x: float) -> float #foreign sdl3;
SDL_atan :: (x: float64) -> float64 #foreign sdl3;
SDL_atanf :: (x: float) -> float #foreign sdl3;
SDL_atan2 :: (y: float64, x: float64) -> float64 #foreign sdl3;
SDL_atan2f :: (y: float, x: float) -> float #foreign sdl3;
SDL_ceil :: (x: float64) -> float64 #foreign sdl3;
SDL_ceilf :: (x: float) -> float #foreign sdl3;
SDL_copysign :: (x: float64, y: float64) -> float64 #foreign sdl3;
SDL_copysignf :: (x: float, y: float) -> float #foreign sdl3;
SDL_cos :: (x: float64) -> float64 #foreign sdl3;
SDL_cosf :: (x: float) -> float #foreign sdl3;
SDL_exp :: (x: float64) -> float64 #foreign sdl3;
SDL_expf :: (x: float) -> float #foreign sdl3;
SDL_fabs :: (x: float64) -> float64 #foreign sdl3;
SDL_fabsf :: (x: float) -> float #foreign sdl3;
SDL_floor :: (x: float64) -> float64 #foreign sdl3;
SDL_floorf :: (x: float) -> float #foreign sdl3;
SDL_trunc :: (x: float64) -> float64 #foreign sdl3;
SDL_truncf :: (x: float) -> float #foreign sdl3;
SDL_fmod :: (x: float64, y: float64) -> float64 #foreign sdl3;
SDL_fmodf :: (x: float, y: float) -> float #foreign sdl3;
SDL_isinf :: (x: float64) -> s32 #foreign sdl3;
SDL_isinff :: (x: float) -> s32 #foreign sdl3;
SDL_isnan :: (x: float64) -> s32 #foreign sdl3;
SDL_isnanf :: (x: float) -> s32 #foreign sdl3;
SDL_log :: (x: float64) -> float64 #foreign sdl3;
SDL_logf :: (x: float) -> float #foreign sdl3;
SDL_log10 :: (x: float64) -> float64 #foreign sdl3;
SDL_log10f :: (x: float) -> float #foreign sdl3;
SDL_modf :: (x: float64, y: *float64) -> float64 #foreign sdl3;
SDL_modff :: (x: float, y: *float) -> float #foreign sdl3;
SDL_pow :: (x: float64, y: float64) -> float64 #foreign sdl3;
SDL_powf :: (x: float, y: float) -> float #foreign sdl3;
SDL_round :: (x: float64) -> float64 #foreign sdl3;
SDL_roundf :: (x: float) -> float #foreign sdl3;
SDL_lround :: (x: float64) -> s64 #foreign sdl3;
SDL_lroundf :: (x: float) -> s64 #foreign sdl3;
SDL_scalbn :: (x: float64, n: s32) -> float64 #foreign sdl3;
SDL_scalbnf :: (x: float, n: s32) -> float #foreign sdl3;
SDL_sin :: (x: float64) -> float64 #foreign sdl3;
SDL_sinf :: (x: float) -> float #foreign sdl3;
SDL_sqrt :: (x: float64) -> float64 #foreign sdl3;
SDL_sqrtf :: (x: float) -> float #foreign sdl3;
SDL_tan :: (x: float64) -> float64 #foreign sdl3;
SDL_tanf :: (x: float) -> float #foreign sdl3;
SDL_iconv_data_t :: struct {}
SDL_iconv_t :: *SDL_iconv_data_t;
SDL_iconv_open :: (tocode: *u8, fromcode: *u8) -> SDL_iconv_t #foreign sdl3;
SDL_iconv_close :: (cd: SDL_iconv_t) -> s32 #foreign sdl3;
SDL_iconv :: (cd: SDL_iconv_t, inbuf: **u8, inbytesleft: *u64, outbuf: **u8, outbytesleft: *u64) -> u64 #foreign sdl3;
SDL_iconv_string :: (tocode: *u8, fromcode: *u8, inbuf: *u8, inbytesleft: u64) -> *u8 #foreign sdl3;
SDL_FunctionPointer :: #type () -> void #c_call;
SDL_AssertState :: enum u32 {
    RETRY         :: 0;
    BREAK         :: 1;
    ABORT         :: 2;
    IGNORE        :: 3;
    ALWAYS_IGNORE :: 4;

    SDL_ASSERTION_RETRY         :: RETRY;
    SDL_ASSERTION_BREAK         :: BREAK;
    SDL_ASSERTION_ABORT         :: ABORT;
    SDL_ASSERTION_IGNORE        :: IGNORE;
    SDL_ASSERTION_ALWAYS_IGNORE :: ALWAYS_IGNORE;
}
SDL_AssertData :: struct {
    always_ignore: bool;
    trigger_count: u32;
    condition:     *u8;
    filename:      *u8;
    linenum:       s32;
    function:      *u8;
    next:          *SDL_AssertData;
}
SDL_ReportAssertion :: (data: *SDL_AssertData, func: *u8, file: *u8, line: s32) -> SDL_AssertState #foreign sdl3;
SDL_AssertionHandler :: #type (data: *SDL_AssertData, userdata: *void) -> SDL_AssertState #c_call;
SDL_SetAssertionHandler :: (handler: SDL_AssertionHandler, userdata: *void) -> void #foreign sdl3;
SDL_GetDefaultAssertionHandler :: () -> SDL_AssertionHandler #foreign sdl3;
SDL_GetAssertionHandler :: (puserdata: **void) -> SDL_AssertionHandler #foreign sdl3;
SDL_GetAssertionReport :: () -> *SDL_AssertData #foreign sdl3;
SDL_ResetAssertionReport :: () -> void #foreign sdl3;
SDL_SpinLock :: s32;
SDL_TryLockSpinlock :: (lock: *SDL_SpinLock) -> bool #foreign sdl3;
SDL_LockSpinlock :: (lock: *SDL_SpinLock) -> void #foreign sdl3;
SDL_UnlockSpinlock :: (lock: *SDL_SpinLock) -> void #foreign sdl3;
SDL_MemoryBarrierReleaseFunction :: () -> void #foreign sdl3;
SDL_MemoryBarrierAcquireFunction :: () -> void #foreign sdl3;
SDL_AtomicInt :: struct {
    value: s32;
}
SDL_CompareAndSwapAtomicInt :: (a: *SDL_AtomicInt, oldval: s32, newval: s32) -> bool #foreign sdl3;
SDL_SetAtomicInt :: (a: *SDL_AtomicInt, v: s32) -> s32 #foreign sdl3;
SDL_GetAtomicInt :: (a: *SDL_AtomicInt) -> s32 #foreign sdl3;
SDL_AddAtomicInt :: (a: *SDL_AtomicInt, v: s32) -> s32 #foreign sdl3;
SDL_AtomicU32 :: struct {
    value: Uint32;
}
SDL_CompareAndSwapAtomicU32 :: (a: *SDL_AtomicU32, oldval: Uint32, newval: Uint32) -> bool #foreign sdl3;
SDL_SetAtomicU32 :: (a: *SDL_AtomicU32, v: Uint32) -> Uint32 #foreign sdl3;
SDL_GetAtomicU32 :: (a: *SDL_AtomicU32) -> Uint32 #foreign sdl3;
SDL_CompareAndSwapAtomicPointer :: (a: **void, oldval: *void, newval: *void) -> bool #foreign sdl3;
SDL_SetAtomicPointer :: (a: **void, v: *void) -> *void #foreign sdl3;
SDL_GetAtomicPointer :: (a: **void) -> *void #foreign sdl3;
SDL_SetError_CFormat :: (fmt: *u8, __args: ..Any) -> bool #foreign sdl3 "SDL_SetError";
SDL_SetError :: (fmt: string, __args: ..Any) -> bool {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    return SDL_SetError_CFormat("%s", formatted_text.data);
} @PrintLike
SDL_OutOfMemory :: () -> bool #foreign sdl3;
SDL_GetError :: () -> *u8 #foreign sdl3;
SDL_ClearError :: () -> bool #foreign sdl3;
SDL_PropertiesID :: Uint32;
SDL_PropertyType :: enum u32 {
    INVALID :: 0;
    POINTER :: 1;
    STRING  :: 2;
    NUMBER  :: 3;
    FLOAT   :: 4;
    BOOLEAN :: 5;

    SDL_PROPERTY_TYPE_INVALID :: INVALID;
    SDL_PROPERTY_TYPE_POINTER :: POINTER;
    SDL_PROPERTY_TYPE_STRING  :: STRING;
    SDL_PROPERTY_TYPE_NUMBER  :: NUMBER;
    SDL_PROPERTY_TYPE_FLOAT   :: FLOAT;
    SDL_PROPERTY_TYPE_BOOLEAN :: BOOLEAN;
}
SDL_GetGlobalProperties :: () -> SDL_PropertiesID #foreign sdl3;
SDL_CreateProperties :: () -> SDL_PropertiesID #foreign sdl3;
SDL_CopyProperties :: (src: SDL_PropertiesID, dst: SDL_PropertiesID) -> bool #foreign sdl3;
SDL_LockProperties :: (props: SDL_PropertiesID) -> bool #foreign sdl3;
SDL_UnlockProperties :: (props: SDL_PropertiesID) -> void #foreign sdl3;
SDL_CleanupPropertyCallback :: #type (userdata: *void, value: *void) -> void #c_call;
SDL_SetPointerPropertyWithCleanup :: (props: SDL_PropertiesID, name: *u8, value: *void, cleanup: SDL_CleanupPropertyCallback, userdata: *void) -> bool #foreign sdl3;
SDL_SetPointerProperty :: (props: SDL_PropertiesID, name: *u8, value: *void) -> bool #foreign sdl3;
SDL_SetStringProperty :: (props: SDL_PropertiesID, name: *u8, value: *u8) -> bool #foreign sdl3;
SDL_SetNumberProperty :: (props: SDL_PropertiesID, name: *u8, value: Sint64) -> bool #foreign sdl3;
SDL_SetFloatProperty :: (props: SDL_PropertiesID, name: *u8, value: float) -> bool #foreign sdl3;
SDL_SetBooleanProperty :: (props: SDL_PropertiesID, name: *u8, value: bool) -> bool #foreign sdl3;
SDL_HasProperty :: (props: SDL_PropertiesID, name: *u8) -> bool #foreign sdl3;
SDL_GetPropertyType :: (props: SDL_PropertiesID, name: *u8) -> SDL_PropertyType #foreign sdl3;
SDL_GetPointerProperty :: (props: SDL_PropertiesID, name: *u8, default_value: *void) -> *void #foreign sdl3;
SDL_GetStringProperty :: (props: SDL_PropertiesID, name: *u8, default_value: *u8) -> *u8 #foreign sdl3;
SDL_GetNumberProperty :: (props: SDL_PropertiesID, name: *u8, default_value: Sint64) -> Sint64 #foreign sdl3;
SDL_GetFloatProperty :: (props: SDL_PropertiesID, name: *u8, default_value: float) -> float #foreign sdl3;
SDL_GetBooleanProperty :: (props: SDL_PropertiesID, name: *u8, default_value: bool) -> bool #foreign sdl3;
SDL_ClearProperty :: (props: SDL_PropertiesID, name: *u8) -> bool #foreign sdl3;
SDL_EnumeratePropertiesCallback :: #type (userdata: *void, props: SDL_PropertiesID, name: *u8) -> void #c_call;
SDL_EnumerateProperties :: (props: SDL_PropertiesID, callback: SDL_EnumeratePropertiesCallback, userdata: *void) -> bool #foreign sdl3;
SDL_DestroyProperties :: (props: SDL_PropertiesID) -> void #foreign sdl3;
SDL_Thread :: struct {}
SDL_ThreadID :: Uint64;
SDL_TLSID :: SDL_AtomicInt;
SDL_ThreadPriority :: enum u32 {
    LOW           :: 0;
    NORMAL        :: 1;
    HIGH          :: 2;
    TIME_CRITICAL :: 3;

    SDL_THREAD_PRIORITY_LOW           :: LOW;
    SDL_THREAD_PRIORITY_NORMAL        :: NORMAL;
    SDL_THREAD_PRIORITY_HIGH          :: HIGH;
    SDL_THREAD_PRIORITY_TIME_CRITICAL :: TIME_CRITICAL;
}
SDL_ThreadFunction :: #type (data: *void) -> s32 #c_call;
SDL_CreateThreadRuntime :: (fn: SDL_ThreadFunction, name: *u8, data: *void, pfnBeginThread: SDL_FunctionPointer, pfnEndThread: SDL_FunctionPointer) -> *SDL_Thread #foreign sdl3;
SDL_CreateThreadWithPropertiesRuntime :: (props: SDL_PropertiesID, pfnBeginThread: SDL_FunctionPointer, pfnEndThread: SDL_FunctionPointer) -> *SDL_Thread #foreign sdl3;
SDL_GetThreadName :: (thread: *SDL_Thread) -> *u8 #foreign sdl3;
SDL_GetCurrentThreadID :: () -> SDL_ThreadID #foreign sdl3;
SDL_GetThreadID :: (thread: *SDL_Thread) -> SDL_ThreadID #foreign sdl3;
SDL_SetCurrentThreadPriority :: (priority: SDL_ThreadPriority) -> bool #foreign sdl3;
SDL_WaitThread :: (thread: *SDL_Thread, status: *s32) -> void #foreign sdl3;
SDL_DetachThread :: (thread: *SDL_Thread) -> void #foreign sdl3;
SDL_GetTLS :: (id: *SDL_TLSID) -> *void #foreign sdl3;
SDL_TLSDestructorCallback :: #type (value: *void) -> void #c_call;
SDL_SetTLS :: (id: *SDL_TLSID, value: *void, destructor: SDL_TLSDestructorCallback) -> bool #foreign sdl3;
SDL_CleanupTLS :: () -> void #foreign sdl3;
SDL_Mutex :: struct {}
SDL_CreateMutex :: () -> *SDL_Mutex #foreign sdl3;
SDL_LockMutex :: (mutex: *SDL_Mutex) -> void #foreign sdl3;
SDL_TryLockMutex :: (mutex: *SDL_Mutex) -> bool #foreign sdl3;
SDL_UnlockMutex :: (mutex: *SDL_Mutex) -> void #foreign sdl3;
SDL_DestroyMutex :: (mutex: *SDL_Mutex) -> void #foreign sdl3;
SDL_RWLock :: struct {}
SDL_CreateRWLock :: () -> *SDL_RWLock #foreign sdl3;
SDL_LockRWLockForReading :: (rwlock: *SDL_RWLock) -> void #foreign sdl3;
SDL_LockRWLockForWriting :: (rwlock: *SDL_RWLock) -> void #foreign sdl3;
SDL_TryLockRWLockForReading :: (rwlock: *SDL_RWLock) -> bool #foreign sdl3;
SDL_TryLockRWLockForWriting :: (rwlock: *SDL_RWLock) -> bool #foreign sdl3;
SDL_UnlockRWLock :: (rwlock: *SDL_RWLock) -> void #foreign sdl3;
SDL_DestroyRWLock :: (rwlock: *SDL_RWLock) -> void #foreign sdl3;
SDL_Semaphore :: struct {}
SDL_CreateSemaphore :: (initial_value: Uint32) -> *SDL_Semaphore #foreign sdl3;
SDL_DestroySemaphore :: (sem: *SDL_Semaphore) -> void #foreign sdl3;
SDL_WaitSemaphore :: (sem: *SDL_Semaphore) -> void #foreign sdl3;
SDL_TryWaitSemaphore :: (sem: *SDL_Semaphore) -> bool #foreign sdl3;
SDL_WaitSemaphoreTimeout :: (sem: *SDL_Semaphore, timeoutMS: Sint32) -> bool #foreign sdl3;
SDL_SignalSemaphore :: (sem: *SDL_Semaphore) -> void #foreign sdl3;
SDL_GetSemaphoreValue :: (sem: *SDL_Semaphore) -> Uint32 #foreign sdl3;
SDL_Condition :: struct {}
SDL_CreateCondition :: () -> *SDL_Condition #foreign sdl3;
SDL_DestroyCondition :: (cond: *SDL_Condition) -> void #foreign sdl3;
SDL_SignalCondition :: (cond: *SDL_Condition) -> void #foreign sdl3;
SDL_BroadcastCondition :: (cond: *SDL_Condition) -> void #foreign sdl3;
SDL_WaitCondition :: (cond: *SDL_Condition, mutex: *SDL_Mutex) -> void #foreign sdl3;
SDL_WaitConditionTimeout :: (cond: *SDL_Condition, mutex: *SDL_Mutex, timeoutMS: Sint32) -> bool #foreign sdl3;
SDL_InitStatus :: enum u32 {
    UNINITIALIZED  :: 0;
    INITIALIZING   :: 1;
    INITIALIZED    :: 2;
    UNINITIALIZING :: 3;

    SDL_INIT_STATUS_UNINITIALIZED  :: UNINITIALIZED;
    SDL_INIT_STATUS_INITIALIZING   :: INITIALIZING;
    SDL_INIT_STATUS_INITIALIZED    :: INITIALIZED;
    SDL_INIT_STATUS_UNINITIALIZING :: UNINITIALIZING;
}
SDL_InitState :: struct {
    status:   SDL_AtomicInt;
    thread:   SDL_ThreadID;
    reserved: *void;
}
SDL_ShouldInit :: (state: *SDL_InitState) -> bool #foreign sdl3;
SDL_ShouldQuit :: (state: *SDL_InitState) -> bool #foreign sdl3;
SDL_SetInitialized :: (state: *SDL_InitState, initialized: bool) -> void #foreign sdl3;
SDL_IOStatus :: enum u32 {
    READY     :: 0;
    ERROR     :: 1;
    EOF       :: 2;
    NOT_READY :: 3;
    READONLY  :: 4;
    WRITEONLY :: 5;

    SDL_IO_STATUS_READY     :: READY;
    SDL_IO_STATUS_ERROR     :: ERROR;
    SDL_IO_STATUS_EOF       :: EOF;
    SDL_IO_STATUS_NOT_READY :: NOT_READY;
    SDL_IO_STATUS_READONLY  :: READONLY;
    SDL_IO_STATUS_WRITEONLY :: WRITEONLY;
}
SDL_IOWhence :: enum u32 {
    SET :: 0;
    CUR :: 1;
    END :: 2;

    SDL_IO_SEEK_SET :: SET;
    SDL_IO_SEEK_CUR :: CUR;
    SDL_IO_SEEK_END :: END;
}
SDL_IOStreamInterface :: struct {
    version: Uint32;
    size:    #type (userdata: *void) -> Sint64 #c_call;
    seek:    #type (userdata: *void, offset: Sint64, whence: SDL_IOWhence) -> Sint64 #c_call;
    read:    #type (userdata: *void, ptr: *void, size: u64, status: *SDL_IOStatus) -> u64 #c_call;
    write:   #type (userdata: *void, ptr: *void, size: u64, status: *SDL_IOStatus) -> u64 #c_call;
    flush:   #type (userdata: *void, status: *SDL_IOStatus) -> bool #c_call;
    close:   #type (userdata: *void) -> bool #c_call;
}
SDL_IOStream :: struct {}
SDL_IOFromFile :: (file: *u8, mode: *u8) -> *SDL_IOStream #foreign sdl3;
SDL_IOFromMem :: (mem: *void, size: u64) -> *SDL_IOStream #foreign sdl3;
SDL_IOFromConstMem :: (mem: *void, size: u64) -> *SDL_IOStream #foreign sdl3;
SDL_IOFromDynamicMem :: () -> *SDL_IOStream #foreign sdl3;
SDL_OpenIO :: (iface: *SDL_IOStreamInterface, userdata: *void) -> *SDL_IOStream #foreign sdl3;
SDL_CloseIO :: (_context: *SDL_IOStream) -> bool #foreign sdl3;
SDL_GetIOProperties :: (_context: *SDL_IOStream) -> SDL_PropertiesID #foreign sdl3;
SDL_GetIOStatus :: (_context: *SDL_IOStream) -> SDL_IOStatus #foreign sdl3;
SDL_GetIOSize :: (_context: *SDL_IOStream) -> Sint64 #foreign sdl3;
SDL_SeekIO :: (_context: *SDL_IOStream, offset: Sint64, whence: SDL_IOWhence) -> Sint64 #foreign sdl3;
SDL_TellIO :: (_context: *SDL_IOStream) -> Sint64 #foreign sdl3;
SDL_ReadIO :: (_context: *SDL_IOStream, ptr: *void, size: u64) -> u64 #foreign sdl3;
SDL_WriteIO :: (_context: *SDL_IOStream, ptr: *void, size: u64) -> u64 #foreign sdl3;
SDL_IOprintf_CFormat :: (_context: *SDL_IOStream, fmt: *u8, __args: ..Any) -> u64 #foreign sdl3 "SDL_IOprintf";
SDL_IOprintf :: (_context: *SDL_IOStream, fmt: string, __args: ..Any) -> u64 {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    return SDL_IOprintf_CFormat(_context, "%s", formatted_text.data);
} @PrintLike
SDL_FlushIO :: (_context: *SDL_IOStream) -> bool #foreign sdl3;
SDL_LoadFile_IO :: (src: *SDL_IOStream, datasize: *u64, closeio: bool) -> *void #foreign sdl3;
SDL_LoadFile :: (file: *u8, datasize: *u64) -> *void #foreign sdl3;
SDL_ReadU8 :: (src: *SDL_IOStream, value: *Uint8) -> bool #foreign sdl3;
SDL_ReadS8 :: (src: *SDL_IOStream, value: *Sint8) -> bool #foreign sdl3;
SDL_ReadU16LE :: (src: *SDL_IOStream, value: *Uint16) -> bool #foreign sdl3;
SDL_ReadS16LE :: (src: *SDL_IOStream, value: *Sint16) -> bool #foreign sdl3;
SDL_ReadU16BE :: (src: *SDL_IOStream, value: *Uint16) -> bool #foreign sdl3;
SDL_ReadS16BE :: (src: *SDL_IOStream, value: *Sint16) -> bool #foreign sdl3;
SDL_ReadU32LE :: (src: *SDL_IOStream, value: *Uint32) -> bool #foreign sdl3;
SDL_ReadS32LE :: (src: *SDL_IOStream, value: *Sint32) -> bool #foreign sdl3;
SDL_ReadU32BE :: (src: *SDL_IOStream, value: *Uint32) -> bool #foreign sdl3;
SDL_ReadS32BE :: (src: *SDL_IOStream, value: *Sint32) -> bool #foreign sdl3;
SDL_ReadU64LE :: (src: *SDL_IOStream, value: *Uint64) -> bool #foreign sdl3;
SDL_ReadS64LE :: (src: *SDL_IOStream, value: *Sint64) -> bool #foreign sdl3;
SDL_ReadU64BE :: (src: *SDL_IOStream, value: *Uint64) -> bool #foreign sdl3;
SDL_ReadS64BE :: (src: *SDL_IOStream, value: *Sint64) -> bool #foreign sdl3;
SDL_WriteU8 :: (dst: *SDL_IOStream, value: Uint8) -> bool #foreign sdl3;
SDL_WriteS8 :: (dst: *SDL_IOStream, value: Sint8) -> bool #foreign sdl3;
SDL_WriteU16LE :: (dst: *SDL_IOStream, value: Uint16) -> bool #foreign sdl3;
SDL_WriteS16LE :: (dst: *SDL_IOStream, value: Sint16) -> bool #foreign sdl3;
SDL_WriteU16BE :: (dst: *SDL_IOStream, value: Uint16) -> bool #foreign sdl3;
SDL_WriteS16BE :: (dst: *SDL_IOStream, value: Sint16) -> bool #foreign sdl3;
SDL_WriteU32LE :: (dst: *SDL_IOStream, value: Uint32) -> bool #foreign sdl3;
SDL_WriteS32LE :: (dst: *SDL_IOStream, value: Sint32) -> bool #foreign sdl3;
SDL_WriteU32BE :: (dst: *SDL_IOStream, value: Uint32) -> bool #foreign sdl3;
SDL_WriteS32BE :: (dst: *SDL_IOStream, value: Sint32) -> bool #foreign sdl3;
SDL_WriteU64LE :: (dst: *SDL_IOStream, value: Uint64) -> bool #foreign sdl3;
SDL_WriteS64LE :: (dst: *SDL_IOStream, value: Sint64) -> bool #foreign sdl3;
SDL_WriteU64BE :: (dst: *SDL_IOStream, value: Uint64) -> bool #foreign sdl3;
SDL_WriteS64BE :: (dst: *SDL_IOStream, value: Sint64) -> bool #foreign sdl3;
SDL_AudioFormat :: enum u32 {
    UNKNOWN :: 0;
    U8      :: 8;
    S8      :: 32776;
    S16LE   :: 32784;
    S16BE   :: 36880;
    S32LE   :: 32800;
    S32BE   :: 36896;
    F32LE   :: 33056;
    F32BE   :: 37152;
    S16     :: 32784;
    S32     :: 32800;
    F32     :: 33056;

    SDL_AUDIO_UNKNOWN :: UNKNOWN;
    SDL_AUDIO_U8      :: U8;
    SDL_AUDIO_S8      :: S8;
    SDL_AUDIO_S16LE   :: S16LE;
    SDL_AUDIO_S16BE   :: S16BE;
    SDL_AUDIO_S32LE   :: S32LE;
    SDL_AUDIO_S32BE   :: S32BE;
    SDL_AUDIO_F32LE   :: F32LE;
    SDL_AUDIO_F32BE   :: F32BE;
    SDL_AUDIO_S16     :: S16;
    SDL_AUDIO_S32     :: S32;
    SDL_AUDIO_F32     :: F32;
}
SDL_AudioDeviceID :: Uint32;
SDL_AudioSpec :: struct {
    format:   SDL_AudioFormat;
    channels: s32;
    freq:     s32;
}
SDL_AudioStream :: struct {}
SDL_GetNumAudioDrivers :: () -> s32 #foreign sdl3;
SDL_GetAudioDriver :: (index: s32) -> *u8 #foreign sdl3;
SDL_GetCurrentAudioDriver :: () -> *u8 #foreign sdl3;
SDL_GetAudioPlaybackDevices :: (count: *s32) -> *SDL_AudioDeviceID #foreign sdl3;
SDL_GetAudioRecordingDevices :: (count: *s32) -> *SDL_AudioDeviceID #foreign sdl3;
SDL_GetAudioDeviceName :: (devid: SDL_AudioDeviceID) -> *u8 #foreign sdl3;
SDL_GetAudioDeviceFormat :: (devid: SDL_AudioDeviceID, spec: *SDL_AudioSpec, sample_frames: *s32) -> bool #foreign sdl3;
SDL_GetAudioDeviceChannelMap :: (devid: SDL_AudioDeviceID, count: *s32) -> *s32 #foreign sdl3;
SDL_OpenAudioDevice :: (devid: SDL_AudioDeviceID, spec: *SDL_AudioSpec) -> SDL_AudioDeviceID #foreign sdl3;
SDL_PauseAudioDevice :: (dev: SDL_AudioDeviceID) -> bool #foreign sdl3;
SDL_ResumeAudioDevice :: (dev: SDL_AudioDeviceID) -> bool #foreign sdl3;
SDL_AudioDevicePaused :: (dev: SDL_AudioDeviceID) -> bool #foreign sdl3;
SDL_GetAudioDeviceGain :: (devid: SDL_AudioDeviceID) -> float #foreign sdl3;
SDL_SetAudioDeviceGain :: (devid: SDL_AudioDeviceID, gain: float) -> bool #foreign sdl3;
SDL_CloseAudioDevice :: (devid: SDL_AudioDeviceID) -> void #foreign sdl3;
SDL_BindAudioStreams :: (devid: SDL_AudioDeviceID, streams: **SDL_AudioStream, num_streams: s32) -> bool #foreign sdl3;
SDL_BindAudioStream :: (devid: SDL_AudioDeviceID, stream: *SDL_AudioStream) -> bool #foreign sdl3;
SDL_UnbindAudioStreams :: (streams: **SDL_AudioStream, num_streams: s32) -> void #foreign sdl3;
SDL_UnbindAudioStream :: (stream: *SDL_AudioStream) -> void #foreign sdl3;
SDL_GetAudioStreamDevice :: (stream: *SDL_AudioStream) -> SDL_AudioDeviceID #foreign sdl3;
SDL_CreateAudioStream :: (src_spec: *SDL_AudioSpec, dst_spec: *SDL_AudioSpec) -> *SDL_AudioStream #foreign sdl3;
SDL_GetAudioStreamProperties :: (stream: *SDL_AudioStream) -> SDL_PropertiesID #foreign sdl3;
SDL_GetAudioStreamFormat :: (stream: *SDL_AudioStream, src_spec: *SDL_AudioSpec, dst_spec: *SDL_AudioSpec) -> bool #foreign sdl3;
SDL_SetAudioStreamFormat :: (stream: *SDL_AudioStream, src_spec: *SDL_AudioSpec, dst_spec: *SDL_AudioSpec) -> bool #foreign sdl3;
SDL_GetAudioStreamFrequencyRatio :: (stream: *SDL_AudioStream) -> float #foreign sdl3;
SDL_SetAudioStreamFrequencyRatio :: (stream: *SDL_AudioStream, ratio: float) -> bool #foreign sdl3;
SDL_GetAudioStreamGain :: (stream: *SDL_AudioStream) -> float #foreign sdl3;
SDL_SetAudioStreamGain :: (stream: *SDL_AudioStream, gain: float) -> bool #foreign sdl3;
SDL_GetAudioStreamInputChannelMap :: (stream: *SDL_AudioStream, count: *s32) -> *s32 #foreign sdl3;
SDL_GetAudioStreamOutputChannelMap :: (stream: *SDL_AudioStream, count: *s32) -> *s32 #foreign sdl3;
SDL_SetAudioStreamInputChannelMap :: (stream: *SDL_AudioStream, chmap: *s32, count: s32) -> bool #foreign sdl3;
SDL_SetAudioStreamOutputChannelMap :: (stream: *SDL_AudioStream, chmap: *s32, count: s32) -> bool #foreign sdl3;
SDL_PutAudioStreamData :: (stream: *SDL_AudioStream, buf: *void, len: s32) -> bool #foreign sdl3;
SDL_GetAudioStreamData :: (stream: *SDL_AudioStream, buf: *void, len: s32) -> s32 #foreign sdl3;
SDL_GetAudioStreamAvailable :: (stream: *SDL_AudioStream) -> s32 #foreign sdl3;
SDL_GetAudioStreamQueued :: (stream: *SDL_AudioStream) -> s32 #foreign sdl3;
SDL_FlushAudioStream :: (stream: *SDL_AudioStream) -> bool #foreign sdl3;
SDL_ClearAudioStream :: (stream: *SDL_AudioStream) -> bool #foreign sdl3;
SDL_PauseAudioStreamDevice :: (stream: *SDL_AudioStream) -> bool #foreign sdl3;
SDL_ResumeAudioStreamDevice :: (stream: *SDL_AudioStream) -> bool #foreign sdl3;
SDL_LockAudioStream :: (stream: *SDL_AudioStream) -> bool #foreign sdl3;
SDL_UnlockAudioStream :: (stream: *SDL_AudioStream) -> bool #foreign sdl3;
SDL_AudioStreamCallback :: #type (userdata: *void, stream: *SDL_AudioStream, additional_amount: s32, total_amount: s32) -> void #c_call;
SDL_SetAudioStreamGetCallback :: (stream: *SDL_AudioStream, callback: SDL_AudioStreamCallback, userdata: *void) -> bool #foreign sdl3;
SDL_SetAudioStreamPutCallback :: (stream: *SDL_AudioStream, callback: SDL_AudioStreamCallback, userdata: *void) -> bool #foreign sdl3;
SDL_DestroyAudioStream :: (stream: *SDL_AudioStream) -> void #foreign sdl3;
SDL_OpenAudioDeviceStream :: (devid: SDL_AudioDeviceID, spec: *SDL_AudioSpec, callback: SDL_AudioStreamCallback, userdata: *void) -> *SDL_AudioStream #foreign sdl3;
SDL_AudioPostmixCallback :: #type (userdata: *void, spec: *SDL_AudioSpec, buffer: *float, buflen: s32) -> void #c_call;
SDL_SetAudioPostmixCallback :: (devid: SDL_AudioDeviceID, callback: SDL_AudioPostmixCallback, userdata: *void) -> bool #foreign sdl3;
SDL_LoadWAV_IO :: (src: *SDL_IOStream, closeio: bool, spec: *SDL_AudioSpec, audio_buf: **Uint8, audio_len: *Uint32) -> bool #foreign sdl3;
SDL_LoadWAV :: (path: *u8, spec: *SDL_AudioSpec, audio_buf: **Uint8, audio_len: *Uint32) -> bool #foreign sdl3;
SDL_MixAudio :: (dst: *Uint8, src: *Uint8, format: SDL_AudioFormat, len: Uint32, volume: float) -> bool #foreign sdl3;
SDL_ConvertAudioSamples :: (src_spec: *SDL_AudioSpec, src_data: *Uint8, src_len: s32, dst_spec: *SDL_AudioSpec, dst_data: **Uint8, dst_len: *s32) -> bool #foreign sdl3;
SDL_GetAudioFormatName :: (format: SDL_AudioFormat) -> *u8 #foreign sdl3;
SDL_GetSilenceValueForFormat :: (format: SDL_AudioFormat) -> s32 #foreign sdl3;
SDL_BlendMode :: Uint32;
SDL_BlendOperation :: enum u32 {
    ADD          :: 1;
    SUBTRACT     :: 2;
    REV_SUBTRACT :: 3;
    MINIMUM      :: 4;
    MAXIMUM      :: 5;

    SDL_BLENDOPERATION_ADD          :: ADD;
    SDL_BLENDOPERATION_SUBTRACT     :: SUBTRACT;
    SDL_BLENDOPERATION_REV_SUBTRACT :: REV_SUBTRACT;
    SDL_BLENDOPERATION_MINIMUM      :: MINIMUM;
    SDL_BLENDOPERATION_MAXIMUM      :: MAXIMUM;
}
SDL_BlendFactor :: enum u32 {
    ZERO                :: 1;
    ONE                 :: 2;
    SRC_COLOR           :: 3;
    ONE_MINUS_SRC_COLOR :: 4;
    SRC_ALPHA           :: 5;
    ONE_MINUS_SRC_ALPHA :: 6;
    DST_COLOR           :: 7;
    ONE_MINUS_DST_COLOR :: 8;
    DST_ALPHA           :: 9;
    ONE_MINUS_DST_ALPHA :: 10;

    SDL_BLENDFACTOR_ZERO                :: ZERO;
    SDL_BLENDFACTOR_ONE                 :: ONE;
    SDL_BLENDFACTOR_SRC_COLOR           :: SRC_COLOR;
    SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR :: ONE_MINUS_SRC_COLOR;
    SDL_BLENDFACTOR_SRC_ALPHA           :: SRC_ALPHA;
    SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA :: ONE_MINUS_SRC_ALPHA;
    SDL_BLENDFACTOR_DST_COLOR           :: DST_COLOR;
    SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR :: ONE_MINUS_DST_COLOR;
    SDL_BLENDFACTOR_DST_ALPHA           :: DST_ALPHA;
    SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA :: ONE_MINUS_DST_ALPHA;
}
SDL_ComposeCustomBlendMode :: (srcColorFactor: SDL_BlendFactor, dstColorFactor: SDL_BlendFactor, colorOperation: SDL_BlendOperation, srcAlphaFactor: SDL_BlendFactor, dstAlphaFactor: SDL_BlendFactor, alphaOperation: SDL_BlendOperation) -> SDL_BlendMode #foreign sdl3;
SDL_PixelType :: enum u32 {
    UNKNOWN  :: 0;
    INDEX1   :: 1;
    INDEX4   :: 2;
    INDEX8   :: 3;
    PACKED8  :: 4;
    PACKED16 :: 5;
    PACKED32 :: 6;
    ARRAYU8  :: 7;
    ARRAYU16 :: 8;
    ARRAYU32 :: 9;
    ARRAYF16 :: 10;
    ARRAYF32 :: 11;
    INDEX2   :: 12;

    SDL_PIXELTYPE_UNKNOWN  :: UNKNOWN;
    SDL_PIXELTYPE_INDEX1   :: INDEX1;
    SDL_PIXELTYPE_INDEX4   :: INDEX4;
    SDL_PIXELTYPE_INDEX8   :: INDEX8;
    SDL_PIXELTYPE_PACKED8  :: PACKED8;
    SDL_PIXELTYPE_PACKED16 :: PACKED16;
    SDL_PIXELTYPE_PACKED32 :: PACKED32;
    SDL_PIXELTYPE_ARRAYU8  :: ARRAYU8;
    SDL_PIXELTYPE_ARRAYU16 :: ARRAYU16;
    SDL_PIXELTYPE_ARRAYU32 :: ARRAYU32;
    SDL_PIXELTYPE_ARRAYF16 :: ARRAYF16;
    SDL_PIXELTYPE_ARRAYF32 :: ARRAYF32;
    SDL_PIXELTYPE_INDEX2   :: INDEX2;
}
SDL_BitmapOrder :: enum u32 {
    NONE  :: 0;
    _4321 :: 1;
    _1234 :: 2;

    SDL_BITMAPORDER_NONE :: NONE;
    SDL_BITMAPORDER_4321 :: _4321;
    SDL_BITMAPORDER_1234 :: _1234;
}
SDL_PackedOrder :: enum u32 {
    NONE :: 0;
    XRGB :: 1;
    RGBX :: 2;
    ARGB :: 3;
    RGBA :: 4;
    XBGR :: 5;
    BGRX :: 6;
    ABGR :: 7;
    BGRA :: 8;

    SDL_PACKEDORDER_NONE :: NONE;
    SDL_PACKEDORDER_XRGB :: XRGB;
    SDL_PACKEDORDER_RGBX :: RGBX;
    SDL_PACKEDORDER_ARGB :: ARGB;
    SDL_PACKEDORDER_RGBA :: RGBA;
    SDL_PACKEDORDER_XBGR :: XBGR;
    SDL_PACKEDORDER_BGRX :: BGRX;
    SDL_PACKEDORDER_ABGR :: ABGR;
    SDL_PACKEDORDER_BGRA :: BGRA;
}
SDL_ArrayOrder :: enum u32 {
    NONE :: 0;
    RGB  :: 1;
    RGBA :: 2;
    ARGB :: 3;
    BGR  :: 4;
    BGRA :: 5;
    ABGR :: 6;

    SDL_ARRAYORDER_NONE :: NONE;
    SDL_ARRAYORDER_RGB  :: RGB;
    SDL_ARRAYORDER_RGBA :: RGBA;
    SDL_ARRAYORDER_ARGB :: ARGB;
    SDL_ARRAYORDER_BGR  :: BGR;
    SDL_ARRAYORDER_BGRA :: BGRA;
    SDL_ARRAYORDER_ABGR :: ABGR;
}
SDL_PackedLayout :: enum u32 {
    NONE     :: 0;
    _332     :: 1;
    _4444    :: 2;
    _1555    :: 3;
    _5551    :: 4;
    _565     :: 5;
    _8888    :: 6;
    _2101010 :: 7;
    _1010102 :: 8;

    SDL_PACKEDLAYOUT_NONE    :: NONE;
    SDL_PACKEDLAYOUT_332     :: _332;
    SDL_PACKEDLAYOUT_4444    :: _4444;
    SDL_PACKEDLAYOUT_1555    :: _1555;
    SDL_PACKEDLAYOUT_5551    :: _5551;
    SDL_PACKEDLAYOUT_565     :: _565;
    SDL_PACKEDLAYOUT_8888    :: _8888;
    SDL_PACKEDLAYOUT_2101010 :: _2101010;
    SDL_PACKEDLAYOUT_1010102 :: _1010102;
}
SDL_PixelFormat :: enum u32 {
    UNKNOWN       :: 0;
    INDEX1LSB     :: 286261504;
    INDEX1MSB     :: 287310080;
    INDEX2LSB     :: 470811136;
    INDEX2MSB     :: 471859712;
    INDEX4LSB     :: 303039488;
    INDEX4MSB     :: 304088064;
    INDEX8        :: 318769153;
    RGB332        :: 336660481;
    XRGB4444      :: 353504258;
    XBGR4444      :: 357698562;
    XRGB1555      :: 353570562;
    XBGR1555      :: 357764866;
    ARGB4444      :: 355602434;
    RGBA4444      :: 356651010;
    ABGR4444      :: 359796738;
    BGRA4444      :: 360845314;
    ARGB1555      :: 355667970;
    RGBA5551      :: 356782082;
    ABGR1555      :: 359862274;
    BGRA5551      :: 360976386;
    RGB565        :: 353701890;
    BGR565        :: 357896194;
    RGB24         :: 386930691;
    BGR24         :: 390076419;
    XRGB8888      :: 370546692;
    RGBX8888      :: 371595268;
    XBGR8888      :: 374740996;
    BGRX8888      :: 375789572;
    ARGB8888      :: 372645892;
    RGBA8888      :: 373694468;
    ABGR8888      :: 376840196;
    BGRA8888      :: 377888772;
    XRGB2101010   :: 370614276;
    XBGR2101010   :: 374808580;
    ARGB2101010   :: 372711428;
    ABGR2101010   :: 376905732;
    RGB48         :: 403714054;
    BGR48         :: 406859782;
    RGBA64        :: 404766728;
    ARGB64        :: 405815304;
    BGRA64        :: 407912456;
    ABGR64        :: 408961032;
    RGB48_FLOAT   :: 437268486;
    BGR48_FLOAT   :: 440414214;
    RGBA64_FLOAT  :: 438321160;
    ARGB64_FLOAT  :: 439369736;
    BGRA64_FLOAT  :: 441466888;
    ABGR64_FLOAT  :: 442515464;
    RGB96_FLOAT   :: 454057996;
    BGR96_FLOAT   :: 457203724;
    RGBA128_FLOAT :: 455114768;
    ARGB128_FLOAT :: 456163344;
    BGRA128_FLOAT :: 458260496;
    ABGR128_FLOAT :: 459309072;
    YV12          :: 842094169;
    IYUV          :: 1448433993;
    YUY2          :: 844715353;
    UYVY          :: 1498831189;
    YVYU          :: 1431918169;
    NV12          :: 842094158;
    NV21          :: 825382478;
    P010          :: 808530000;
    EXTERNAL_OES  :: 542328143;
    RGBA32        :: 376840196;
    ARGB32        :: 377888772;
    BGRA32        :: 372645892;
    ABGR32        :: 373694468;
    RGBX32        :: 374740996;
    XRGB32        :: 375789572;
    BGRX32        :: 370546692;
    XBGR32        :: 371595268;

    SDL_PIXELFORMAT_UNKNOWN       :: UNKNOWN;
    SDL_PIXELFORMAT_INDEX1LSB     :: INDEX1LSB;
    SDL_PIXELFORMAT_INDEX1MSB     :: INDEX1MSB;
    SDL_PIXELFORMAT_INDEX2LSB     :: INDEX2LSB;
    SDL_PIXELFORMAT_INDEX2MSB     :: INDEX2MSB;
    SDL_PIXELFORMAT_INDEX4LSB     :: INDEX4LSB;
    SDL_PIXELFORMAT_INDEX4MSB     :: INDEX4MSB;
    SDL_PIXELFORMAT_INDEX8        :: INDEX8;
    SDL_PIXELFORMAT_RGB332        :: RGB332;
    SDL_PIXELFORMAT_XRGB4444      :: XRGB4444;
    SDL_PIXELFORMAT_XBGR4444      :: XBGR4444;
    SDL_PIXELFORMAT_XRGB1555      :: XRGB1555;
    SDL_PIXELFORMAT_XBGR1555      :: XBGR1555;
    SDL_PIXELFORMAT_ARGB4444      :: ARGB4444;
    SDL_PIXELFORMAT_RGBA4444      :: RGBA4444;
    SDL_PIXELFORMAT_ABGR4444      :: ABGR4444;
    SDL_PIXELFORMAT_BGRA4444      :: BGRA4444;
    SDL_PIXELFORMAT_ARGB1555      :: ARGB1555;
    SDL_PIXELFORMAT_RGBA5551      :: RGBA5551;
    SDL_PIXELFORMAT_ABGR1555      :: ABGR1555;
    SDL_PIXELFORMAT_BGRA5551      :: BGRA5551;
    SDL_PIXELFORMAT_RGB565        :: RGB565;
    SDL_PIXELFORMAT_BGR565        :: BGR565;
    SDL_PIXELFORMAT_RGB24         :: RGB24;
    SDL_PIXELFORMAT_BGR24         :: BGR24;
    SDL_PIXELFORMAT_XRGB8888      :: XRGB8888;
    SDL_PIXELFORMAT_RGBX8888      :: RGBX8888;
    SDL_PIXELFORMAT_XBGR8888      :: XBGR8888;
    SDL_PIXELFORMAT_BGRX8888      :: BGRX8888;
    SDL_PIXELFORMAT_ARGB8888      :: ARGB8888;
    SDL_PIXELFORMAT_RGBA8888      :: RGBA8888;
    SDL_PIXELFORMAT_ABGR8888      :: ABGR8888;
    SDL_PIXELFORMAT_BGRA8888      :: BGRA8888;
    SDL_PIXELFORMAT_XRGB2101010   :: XRGB2101010;
    SDL_PIXELFORMAT_XBGR2101010   :: XBGR2101010;
    SDL_PIXELFORMAT_ARGB2101010   :: ARGB2101010;
    SDL_PIXELFORMAT_ABGR2101010   :: ABGR2101010;
    SDL_PIXELFORMAT_RGB48         :: RGB48;
    SDL_PIXELFORMAT_BGR48         :: BGR48;
    SDL_PIXELFORMAT_RGBA64        :: RGBA64;
    SDL_PIXELFORMAT_ARGB64        :: ARGB64;
    SDL_PIXELFORMAT_BGRA64        :: BGRA64;
    SDL_PIXELFORMAT_ABGR64        :: ABGR64;
    SDL_PIXELFORMAT_RGB48_FLOAT   :: RGB48_FLOAT;
    SDL_PIXELFORMAT_BGR48_FLOAT   :: BGR48_FLOAT;
    SDL_PIXELFORMAT_RGBA64_FLOAT  :: RGBA64_FLOAT;
    SDL_PIXELFORMAT_ARGB64_FLOAT  :: ARGB64_FLOAT;
    SDL_PIXELFORMAT_BGRA64_FLOAT  :: BGRA64_FLOAT;
    SDL_PIXELFORMAT_ABGR64_FLOAT  :: ABGR64_FLOAT;
    SDL_PIXELFORMAT_RGB96_FLOAT   :: RGB96_FLOAT;
    SDL_PIXELFORMAT_BGR96_FLOAT   :: BGR96_FLOAT;
    SDL_PIXELFORMAT_RGBA128_FLOAT :: RGBA128_FLOAT;
    SDL_PIXELFORMAT_ARGB128_FLOAT :: ARGB128_FLOAT;
    SDL_PIXELFORMAT_BGRA128_FLOAT :: BGRA128_FLOAT;
    SDL_PIXELFORMAT_ABGR128_FLOAT :: ABGR128_FLOAT;
    SDL_PIXELFORMAT_YV12          :: YV12;
    SDL_PIXELFORMAT_IYUV          :: IYUV;
    SDL_PIXELFORMAT_YUY2          :: YUY2;
    SDL_PIXELFORMAT_UYVY          :: UYVY;
    SDL_PIXELFORMAT_YVYU          :: YVYU;
    SDL_PIXELFORMAT_NV12          :: NV12;
    SDL_PIXELFORMAT_NV21          :: NV21;
    SDL_PIXELFORMAT_P010          :: P010;
    SDL_PIXELFORMAT_EXTERNAL_OES  :: EXTERNAL_OES;
    SDL_PIXELFORMAT_RGBA32        :: RGBA32;
    SDL_PIXELFORMAT_ARGB32        :: ARGB32;
    SDL_PIXELFORMAT_BGRA32        :: BGRA32;
    SDL_PIXELFORMAT_ABGR32        :: ABGR32;
    SDL_PIXELFORMAT_RGBX32        :: RGBX32;
    SDL_PIXELFORMAT_XRGB32        :: XRGB32;
    SDL_PIXELFORMAT_BGRX32        :: BGRX32;
    SDL_PIXELFORMAT_XBGR32        :: XBGR32;
}
SDL_ColorType :: enum u32 {
    UNKNOWN :: 0;
    RGB     :: 1;
    YCBCR   :: 2;

    SDL_COLOR_TYPE_UNKNOWN :: UNKNOWN;
    SDL_COLOR_TYPE_RGB     :: RGB;
    SDL_COLOR_TYPE_YCBCR   :: YCBCR;
}
SDL_ColorRange :: enum u32 {
    UNKNOWN :: 0;
    LIMITED :: 1;
    FULL    :: 2;

    SDL_COLOR_RANGE_UNKNOWN :: UNKNOWN;
    SDL_COLOR_RANGE_LIMITED :: LIMITED;
    SDL_COLOR_RANGE_FULL    :: FULL;
}
SDL_ColorPrimaries :: enum u32 {
    UNKNOWN      :: 0;
    BT709        :: 1;
    UNSPECIFIED  :: 2;
    BT470M       :: 4;
    BT470BG      :: 5;
    BT601        :: 6;
    SMPTE240     :: 7;
    GENERIC_FILM :: 8;
    BT2020       :: 9;
    XYZ          :: 10;
    SMPTE431     :: 11;
    SMPTE432     :: 12;
    EBU3213      :: 22;
    CUSTOM       :: 31;

    SDL_COLOR_PRIMARIES_UNKNOWN      :: UNKNOWN;
    SDL_COLOR_PRIMARIES_BT709        :: BT709;
    SDL_COLOR_PRIMARIES_UNSPECIFIED  :: UNSPECIFIED;
    SDL_COLOR_PRIMARIES_BT470M       :: BT470M;
    SDL_COLOR_PRIMARIES_BT470BG      :: BT470BG;
    SDL_COLOR_PRIMARIES_BT601        :: BT601;
    SDL_COLOR_PRIMARIES_SMPTE240     :: SMPTE240;
    SDL_COLOR_PRIMARIES_GENERIC_FILM :: GENERIC_FILM;
    SDL_COLOR_PRIMARIES_BT2020       :: BT2020;
    SDL_COLOR_PRIMARIES_XYZ          :: XYZ;
    SDL_COLOR_PRIMARIES_SMPTE431     :: SMPTE431;
    SDL_COLOR_PRIMARIES_SMPTE432     :: SMPTE432;
    SDL_COLOR_PRIMARIES_EBU3213      :: EBU3213;
    SDL_COLOR_PRIMARIES_CUSTOM       :: CUSTOM;
}
SDL_TransferCharacteristics :: enum u32 {
    UNKNOWN       :: 0;
    BT709         :: 1;
    UNSPECIFIED   :: 2;
    GAMMA22       :: 4;
    GAMMA28       :: 5;
    BT601         :: 6;
    SMPTE240      :: 7;
    LINEAR        :: 8;
    LOG100        :: 9;
    LOG100_SQRT10 :: 10;
    IEC61966      :: 11;
    BT1361        :: 12;
    SRGB          :: 13;
    BT2020_10BIT  :: 14;
    BT2020_12BIT  :: 15;
    PQ            :: 16;
    SMPTE428      :: 17;
    HLG           :: 18;
    CUSTOM        :: 31;

    SDL_TRANSFER_CHARACTERISTICS_UNKNOWN       :: UNKNOWN;
    SDL_TRANSFER_CHARACTERISTICS_BT709         :: BT709;
    SDL_TRANSFER_CHARACTERISTICS_UNSPECIFIED   :: UNSPECIFIED;
    SDL_TRANSFER_CHARACTERISTICS_GAMMA22       :: GAMMA22;
    SDL_TRANSFER_CHARACTERISTICS_GAMMA28       :: GAMMA28;
    SDL_TRANSFER_CHARACTERISTICS_BT601         :: BT601;
    SDL_TRANSFER_CHARACTERISTICS_SMPTE240      :: SMPTE240;
    SDL_TRANSFER_CHARACTERISTICS_LINEAR        :: LINEAR;
    SDL_TRANSFER_CHARACTERISTICS_LOG100        :: LOG100;
    SDL_TRANSFER_CHARACTERISTICS_LOG100_SQRT10 :: LOG100_SQRT10;
    SDL_TRANSFER_CHARACTERISTICS_IEC61966      :: IEC61966;
    SDL_TRANSFER_CHARACTERISTICS_BT1361        :: BT1361;
    SDL_TRANSFER_CHARACTERISTICS_SRGB          :: SRGB;
    SDL_TRANSFER_CHARACTERISTICS_BT2020_10BIT  :: BT2020_10BIT;
    SDL_TRANSFER_CHARACTERISTICS_BT2020_12BIT  :: BT2020_12BIT;
    SDL_TRANSFER_CHARACTERISTICS_PQ            :: PQ;
    SDL_TRANSFER_CHARACTERISTICS_SMPTE428      :: SMPTE428;
    SDL_TRANSFER_CHARACTERISTICS_HLG           :: HLG;
    SDL_TRANSFER_CHARACTERISTICS_CUSTOM        :: CUSTOM;
}
SDL_MatrixCoefficients :: enum u32 {
    IDENTITY           :: 0;
    BT709              :: 1;
    UNSPECIFIED        :: 2;
    FCC                :: 4;
    BT470BG            :: 5;
    BT601              :: 6;
    SMPTE240           :: 7;
    YCGCO              :: 8;
    BT2020_NCL         :: 9;
    BT2020_CL          :: 10;
    SMPTE2085          :: 11;
    CHROMA_DERIVED_NCL :: 12;
    CHROMA_DERIVED_CL  :: 13;
    ICTCP              :: 14;
    CUSTOM             :: 31;

    SDL_MATRIX_COEFFICIENTS_IDENTITY           :: IDENTITY;
    SDL_MATRIX_COEFFICIENTS_BT709              :: BT709;
    SDL_MATRIX_COEFFICIENTS_UNSPECIFIED        :: UNSPECIFIED;
    SDL_MATRIX_COEFFICIENTS_FCC                :: FCC;
    SDL_MATRIX_COEFFICIENTS_BT470BG            :: BT470BG;
    SDL_MATRIX_COEFFICIENTS_BT601              :: BT601;
    SDL_MATRIX_COEFFICIENTS_SMPTE240           :: SMPTE240;
    SDL_MATRIX_COEFFICIENTS_YCGCO              :: YCGCO;
    SDL_MATRIX_COEFFICIENTS_BT2020_NCL         :: BT2020_NCL;
    SDL_MATRIX_COEFFICIENTS_BT2020_CL          :: BT2020_CL;
    SDL_MATRIX_COEFFICIENTS_SMPTE2085          :: SMPTE2085;
    SDL_MATRIX_COEFFICIENTS_CHROMA_DERIVED_NCL :: CHROMA_DERIVED_NCL;
    SDL_MATRIX_COEFFICIENTS_CHROMA_DERIVED_CL  :: CHROMA_DERIVED_CL;
    SDL_MATRIX_COEFFICIENTS_ICTCP              :: ICTCP;
    SDL_MATRIX_COEFFICIENTS_CUSTOM             :: CUSTOM;
}
SDL_ChromaLocation :: enum u32 {
    NONE    :: 0;
    LEFT    :: 1;
    CENTER  :: 2;
    TOPLEFT :: 3;

    SDL_CHROMA_LOCATION_NONE    :: NONE;
    SDL_CHROMA_LOCATION_LEFT    :: LEFT;
    SDL_CHROMA_LOCATION_CENTER  :: CENTER;
    SDL_CHROMA_LOCATION_TOPLEFT :: TOPLEFT;
}
SDL_Colorspace :: enum u32 {
    UNKNOWN        :: 0;
    SRGB           :: 301991328;
    SRGB_LINEAR    :: 301991168;
    HDR10          :: 301999616;
    JPEG           :: 570426566;
    BT601_LIMITED  :: 554703046;
    BT601_FULL     :: 571480262;
    BT709_LIMITED  :: 554697761;
    BT709_FULL     :: 571474977;
    BT2020_LIMITED :: 554706441;
    BT2020_FULL    :: 571483657;
    RGB_DEFAULT    :: 301991328;
    YUV_DEFAULT    :: 570426566;

    SDL_COLORSPACE_UNKNOWN        :: UNKNOWN;
    SDL_COLORSPACE_SRGB           :: SRGB;
    SDL_COLORSPACE_SRGB_LINEAR    :: SRGB_LINEAR;
    SDL_COLORSPACE_HDR10          :: HDR10;
    SDL_COLORSPACE_JPEG           :: JPEG;
    SDL_COLORSPACE_BT601_LIMITED  :: BT601_LIMITED;
    SDL_COLORSPACE_BT601_FULL     :: BT601_FULL;
    SDL_COLORSPACE_BT709_LIMITED  :: BT709_LIMITED;
    SDL_COLORSPACE_BT709_FULL     :: BT709_FULL;
    SDL_COLORSPACE_BT2020_LIMITED :: BT2020_LIMITED;
    SDL_COLORSPACE_BT2020_FULL    :: BT2020_FULL;
    SDL_COLORSPACE_RGB_DEFAULT    :: RGB_DEFAULT;
    SDL_COLORSPACE_YUV_DEFAULT    :: YUV_DEFAULT;
}
SDL_Color :: struct {
    r: Uint8;
    g: Uint8;
    b: Uint8;
    a: Uint8;
}
SDL_FColor :: struct {
    r: float;
    g: float;
    b: float;
    a: float;
}
SDL_Palette :: struct {
    ncolors:  s32;
    colors:   *SDL_Color;
    version:  Uint32;
    refcount: s32;
}
SDL_PixelFormatDetails :: struct {
    format:          SDL_PixelFormat;
    bits_per_pixel:  Uint8;
    bytes_per_pixel: Uint8;
    padding:         [2] Uint8;
    Rmask:           Uint32;
    Gmask:           Uint32;
    Bmask:           Uint32;
    Amask:           Uint32;
    Rbits:           Uint8;
    Gbits:           Uint8;
    Bbits:           Uint8;
    Abits:           Uint8;
    Rshift:          Uint8;
    Gshift:          Uint8;
    Bshift:          Uint8;
    Ashift:          Uint8;
}
SDL_GetPixelFormatName :: (format: SDL_PixelFormat) -> *u8 #foreign sdl3;
SDL_GetMasksForPixelFormat :: (format: SDL_PixelFormat, bpp: *s32, Rmask: *Uint32, Gmask: *Uint32, Bmask: *Uint32, Amask: *Uint32) -> bool #foreign sdl3;
SDL_GetPixelFormatForMasks :: (bpp: s32, Rmask: Uint32, Gmask: Uint32, Bmask: Uint32, Amask: Uint32) -> SDL_PixelFormat #foreign sdl3;
SDL_GetPixelFormatDetails :: (format: SDL_PixelFormat) -> *SDL_PixelFormatDetails #foreign sdl3;
SDL_CreatePalette :: (ncolors: s32) -> *SDL_Palette #foreign sdl3;
SDL_SetPaletteColors :: (palette: *SDL_Palette, colors: *SDL_Color, firstcolor: s32, ncolors: s32) -> bool #foreign sdl3;
SDL_DestroyPalette :: (palette: *SDL_Palette) -> void #foreign sdl3;
SDL_MapRGB :: (format: *SDL_PixelFormatDetails, palette: *SDL_Palette, r: Uint8, g: Uint8, b: Uint8) -> Uint32 #foreign sdl3;
SDL_MapRGBA :: (format: *SDL_PixelFormatDetails, palette: *SDL_Palette, r: Uint8, g: Uint8, b: Uint8, a: Uint8) -> Uint32 #foreign sdl3;
SDL_GetRGB :: (pixel: Uint32, format: *SDL_PixelFormatDetails, palette: *SDL_Palette, r: *Uint8, g: *Uint8, b: *Uint8) -> void #foreign sdl3;
SDL_GetRGBA :: (pixel: Uint32, format: *SDL_PixelFormatDetails, palette: *SDL_Palette, r: *Uint8, g: *Uint8, b: *Uint8, a: *Uint8) -> void #foreign sdl3;
SDL_Point :: struct {
    x: s32;
    y: s32;
}
SDL_FPoint :: struct {
    x: float;
    y: float;
}
SDL_Rect :: struct {
    x: s32;
    y: s32;
    w: s32;
    h: s32;
}
SDL_FRect :: struct {
    x: float;
    y: float;
    w: float;
    h: float;
}
SDL_HasRectIntersection :: (A: *SDL_Rect, B: *SDL_Rect) -> bool #foreign sdl3;
SDL_GetRectIntersection :: (A: *SDL_Rect, B: *SDL_Rect, result: *SDL_Rect) -> bool #foreign sdl3;
SDL_GetRectUnion :: (A: *SDL_Rect, B: *SDL_Rect, result: *SDL_Rect) -> bool #foreign sdl3;
SDL_GetRectEnclosingPoints :: (points: *SDL_Point, count: s32, clip: *SDL_Rect, result: *SDL_Rect) -> bool #foreign sdl3;
SDL_GetRectAndLineIntersection :: (rect: *SDL_Rect, X1: *s32, Y1: *s32, X2: *s32, Y2: *s32) -> bool #foreign sdl3;
SDL_HasRectIntersectionFloat :: (A: *SDL_FRect, B: *SDL_FRect) -> bool #foreign sdl3;
SDL_GetRectIntersectionFloat :: (A: *SDL_FRect, B: *SDL_FRect, result: *SDL_FRect) -> bool #foreign sdl3;
SDL_GetRectUnionFloat :: (A: *SDL_FRect, B: *SDL_FRect, result: *SDL_FRect) -> bool #foreign sdl3;
SDL_GetRectEnclosingPointsFloat :: (points: *SDL_FPoint, count: s32, clip: *SDL_FRect, result: *SDL_FRect) -> bool #foreign sdl3;
SDL_GetRectAndLineIntersectionFloat :: (rect: *SDL_FRect, X1: *float, Y1: *float, X2: *float, Y2: *float) -> bool #foreign sdl3;
SDL_SurfaceFlags :: Uint32;
SDL_ScaleMode :: enum u32 {
    NEAREST :: 0;
    LINEAR  :: 1;

    SDL_SCALEMODE_NEAREST :: NEAREST;
    SDL_SCALEMODE_LINEAR  :: LINEAR;
}
SDL_FlipMode :: enum u32 {
    NONE       :: 0;
    HORIZONTAL :: 1;
    VERTICAL   :: 2;

    SDL_FLIP_NONE       :: NONE;
    SDL_FLIP_HORIZONTAL :: HORIZONTAL;
    SDL_FLIP_VERTICAL   :: VERTICAL;
}
SDL_Surface :: struct {
    flags:    SDL_SurfaceFlags;
    format:   SDL_PixelFormat;
    w:        s32;
    h:        s32;
    pitch:    s32;
    pixels:   *void;
    refcount: s32;
    reserved: *void;
}
SDL_CreateSurface :: (width: s32, height: s32, format: SDL_PixelFormat) -> *SDL_Surface #foreign sdl3;
SDL_CreateSurfaceFrom :: (width: s32, height: s32, format: SDL_PixelFormat, pixels: *void, pitch: s32) -> *SDL_Surface #foreign sdl3;
SDL_DestroySurface :: (surface: *SDL_Surface) -> void #foreign sdl3;
SDL_GetSurfaceProperties :: (surface: *SDL_Surface) -> SDL_PropertiesID #foreign sdl3;
SDL_SetSurfaceColorspace :: (surface: *SDL_Surface, colorspace: SDL_Colorspace) -> bool #foreign sdl3;
SDL_GetSurfaceColorspace :: (surface: *SDL_Surface) -> SDL_Colorspace #foreign sdl3;
SDL_CreateSurfacePalette :: (surface: *SDL_Surface) -> *SDL_Palette #foreign sdl3;
SDL_SetSurfacePalette :: (surface: *SDL_Surface, palette: *SDL_Palette) -> bool #foreign sdl3;
SDL_GetSurfacePalette :: (surface: *SDL_Surface) -> *SDL_Palette #foreign sdl3;
SDL_AddSurfaceAlternateImage :: (surface: *SDL_Surface, image: *SDL_Surface) -> bool #foreign sdl3;
SDL_SurfaceHasAlternateImages :: (surface: *SDL_Surface) -> bool #foreign sdl3;
SDL_GetSurfaceImages :: (surface: *SDL_Surface, count: *s32) -> **SDL_Surface #foreign sdl3;
SDL_RemoveSurfaceAlternateImages :: (surface: *SDL_Surface) -> void #foreign sdl3;
SDL_LockSurface :: (surface: *SDL_Surface) -> bool #foreign sdl3;
SDL_UnlockSurface :: (surface: *SDL_Surface) -> void #foreign sdl3;
SDL_LoadBMP_IO :: (src: *SDL_IOStream, closeio: bool) -> *SDL_Surface #foreign sdl3;
SDL_LoadBMP :: (file: *u8) -> *SDL_Surface #foreign sdl3;
SDL_SaveBMP_IO :: (surface: *SDL_Surface, dst: *SDL_IOStream, closeio: bool) -> bool #foreign sdl3;
SDL_SaveBMP :: (surface: *SDL_Surface, file: *u8) -> bool #foreign sdl3;
SDL_SetSurfaceRLE :: (surface: *SDL_Surface, enabled: bool) -> bool #foreign sdl3;
SDL_SurfaceHasRLE :: (surface: *SDL_Surface) -> bool #foreign sdl3;
SDL_SetSurfaceColorKey :: (surface: *SDL_Surface, enabled: bool, key: Uint32) -> bool #foreign sdl3;
SDL_SurfaceHasColorKey :: (surface: *SDL_Surface) -> bool #foreign sdl3;
SDL_GetSurfaceColorKey :: (surface: *SDL_Surface, key: *Uint32) -> bool #foreign sdl3;
SDL_SetSurfaceColorMod :: (surface: *SDL_Surface, r: Uint8, g: Uint8, b: Uint8) -> bool #foreign sdl3;
SDL_GetSurfaceColorMod :: (surface: *SDL_Surface, r: *Uint8, g: *Uint8, b: *Uint8) -> bool #foreign sdl3;
SDL_SetSurfaceAlphaMod :: (surface: *SDL_Surface, alpha: Uint8) -> bool #foreign sdl3;
SDL_GetSurfaceAlphaMod :: (surface: *SDL_Surface, alpha: *Uint8) -> bool #foreign sdl3;
SDL_SetSurfaceBlendMode :: (surface: *SDL_Surface, blendMode: SDL_BlendMode) -> bool #foreign sdl3;
SDL_GetSurfaceBlendMode :: (surface: *SDL_Surface, blendMode: *SDL_BlendMode) -> bool #foreign sdl3;
SDL_SetSurfaceClipRect :: (surface: *SDL_Surface, rect: *SDL_Rect) -> bool #foreign sdl3;
SDL_GetSurfaceClipRect :: (surface: *SDL_Surface, rect: *SDL_Rect) -> bool #foreign sdl3;
SDL_FlipSurface :: (surface: *SDL_Surface, flip: SDL_FlipMode) -> bool #foreign sdl3;
SDL_DuplicateSurface :: (surface: *SDL_Surface) -> *SDL_Surface #foreign sdl3;
SDL_ScaleSurface :: (surface: *SDL_Surface, width: s32, height: s32, scaleMode: SDL_ScaleMode) -> *SDL_Surface #foreign sdl3;
SDL_ConvertSurface :: (surface: *SDL_Surface, format: SDL_PixelFormat) -> *SDL_Surface #foreign sdl3;
SDL_ConvertSurfaceAndColorspace :: (surface: *SDL_Surface, format: SDL_PixelFormat, palette: *SDL_Palette, colorspace: SDL_Colorspace, props: SDL_PropertiesID) -> *SDL_Surface #foreign sdl3;
SDL_ConvertPixels :: (width: s32, height: s32, src_format: SDL_PixelFormat, src: *void, src_pitch: s32, dst_format: SDL_PixelFormat, dst: *void, dst_pitch: s32) -> bool #foreign sdl3;
SDL_ConvertPixelsAndColorspace :: (width: s32, height: s32, src_format: SDL_PixelFormat, src_colorspace: SDL_Colorspace, src_properties: SDL_PropertiesID, src: *void, src_pitch: s32, dst_format: SDL_PixelFormat, dst_colorspace: SDL_Colorspace, dst_properties: SDL_PropertiesID, dst: *void, dst_pitch: s32) -> bool #foreign sdl3;
SDL_PremultiplyAlpha :: (width: s32, height: s32, src_format: SDL_PixelFormat, src: *void, src_pitch: s32, dst_format: SDL_PixelFormat, dst: *void, dst_pitch: s32, linear: bool) -> bool #foreign sdl3;
SDL_PremultiplySurfaceAlpha :: (surface: *SDL_Surface, linear: bool) -> bool #foreign sdl3;
SDL_ClearSurface :: (surface: *SDL_Surface, r: float, g: float, b: float, a: float) -> bool #foreign sdl3;
SDL_FillSurfaceRect :: (dst: *SDL_Surface, rect: *SDL_Rect, color: Uint32) -> bool #foreign sdl3;
SDL_FillSurfaceRects :: (dst: *SDL_Surface, rects: *SDL_Rect, count: s32, color: Uint32) -> bool #foreign sdl3;
SDL_BlitSurface :: (src: *SDL_Surface, srcrect: *SDL_Rect, dst: *SDL_Surface, dstrect: *SDL_Rect) -> bool #foreign sdl3;
SDL_BlitSurfaceUnchecked :: (src: *SDL_Surface, srcrect: *SDL_Rect, dst: *SDL_Surface, dstrect: *SDL_Rect) -> bool #foreign sdl3;
SDL_BlitSurfaceScaled :: (src: *SDL_Surface, srcrect: *SDL_Rect, dst: *SDL_Surface, dstrect: *SDL_Rect, scaleMode: SDL_ScaleMode) -> bool #foreign sdl3;
SDL_BlitSurfaceUncheckedScaled :: (src: *SDL_Surface, srcrect: *SDL_Rect, dst: *SDL_Surface, dstrect: *SDL_Rect, scaleMode: SDL_ScaleMode) -> bool #foreign sdl3;
SDL_BlitSurfaceTiled :: (src: *SDL_Surface, srcrect: *SDL_Rect, dst: *SDL_Surface, dstrect: *SDL_Rect) -> bool #foreign sdl3;
SDL_BlitSurfaceTiledWithScale :: (src: *SDL_Surface, srcrect: *SDL_Rect, scale: float, scaleMode: SDL_ScaleMode, dst: *SDL_Surface, dstrect: *SDL_Rect) -> bool #foreign sdl3;
SDL_BlitSurface9Grid :: (src: *SDL_Surface, srcrect: *SDL_Rect, left_width: s32, right_width: s32, top_height: s32, bottom_height: s32, scale: float, scaleMode: SDL_ScaleMode, dst: *SDL_Surface, dstrect: *SDL_Rect) -> bool #foreign sdl3;
SDL_MapSurfaceRGB :: (surface: *SDL_Surface, r: Uint8, g: Uint8, b: Uint8) -> Uint32 #foreign sdl3;
SDL_MapSurfaceRGBA :: (surface: *SDL_Surface, r: Uint8, g: Uint8, b: Uint8, a: Uint8) -> Uint32 #foreign sdl3;
SDL_ReadSurfacePixel :: (surface: *SDL_Surface, x: s32, y: s32, r: *Uint8, g: *Uint8, b: *Uint8, a: *Uint8) -> bool #foreign sdl3;
SDL_ReadSurfacePixelFloat :: (surface: *SDL_Surface, x: s32, y: s32, r: *float, g: *float, b: *float, a: *float) -> bool #foreign sdl3;
SDL_WriteSurfacePixel :: (surface: *SDL_Surface, x: s32, y: s32, r: Uint8, g: Uint8, b: Uint8, a: Uint8) -> bool #foreign sdl3;
SDL_WriteSurfacePixelFloat :: (surface: *SDL_Surface, x: s32, y: s32, r: float, g: float, b: float, a: float) -> bool #foreign sdl3;
SDL_CameraID :: Uint32;
SDL_Camera :: struct {}
SDL_CameraSpec :: struct {
    format:                SDL_PixelFormat;
    colorspace:            SDL_Colorspace;
    width:                 s32;
    height:                s32;
    framerate_numerator:   s32;
    framerate_denominator: s32;
}
SDL_CameraPosition :: enum u32 {
    UNKNOWN      :: 0;
    FRONT_FACING :: 1;
    BACK_FACING  :: 2;

    SDL_CAMERA_POSITION_UNKNOWN      :: UNKNOWN;
    SDL_CAMERA_POSITION_FRONT_FACING :: FRONT_FACING;
    SDL_CAMERA_POSITION_BACK_FACING  :: BACK_FACING;
}
SDL_GetNumCameraDrivers :: () -> s32 #foreign sdl3;
SDL_GetCameraDriver :: (index: s32) -> *u8 #foreign sdl3;
SDL_GetCurrentCameraDriver :: () -> *u8 #foreign sdl3;
SDL_GetCameras :: (count: *s32) -> *SDL_CameraID #foreign sdl3;
SDL_GetCameraSupportedFormats :: (devid: SDL_CameraID, count: *s32) -> **SDL_CameraSpec #foreign sdl3;
SDL_GetCameraName :: (instance_id: SDL_CameraID) -> *u8 #foreign sdl3;
SDL_GetCameraPosition :: (instance_id: SDL_CameraID) -> SDL_CameraPosition #foreign sdl3;
SDL_OpenCamera :: (instance_id: SDL_CameraID, spec: *SDL_CameraSpec) -> *SDL_Camera #foreign sdl3;
SDL_GetCameraPermissionState :: (camera: *SDL_Camera) -> s32 #foreign sdl3;
SDL_GetCameraID :: (camera: *SDL_Camera) -> SDL_CameraID #foreign sdl3;
SDL_GetCameraProperties :: (camera: *SDL_Camera) -> SDL_PropertiesID #foreign sdl3;
SDL_GetCameraFormat :: (camera: *SDL_Camera, spec: *SDL_CameraSpec) -> bool #foreign sdl3;
SDL_AcquireCameraFrame :: (camera: *SDL_Camera, timestampNS: *Uint64) -> *SDL_Surface #foreign sdl3;
SDL_ReleaseCameraFrame :: (camera: *SDL_Camera, frame: *SDL_Surface) -> void #foreign sdl3;
SDL_CloseCamera :: (camera: *SDL_Camera) -> void #foreign sdl3;
SDL_SetClipboardText :: (text: *u8) -> bool #foreign sdl3;
SDL_GetClipboardText :: () -> *u8 #foreign sdl3;
SDL_HasClipboardText :: () -> bool #foreign sdl3;
SDL_SetPrimarySelectionText :: (text: *u8) -> bool #foreign sdl3;
SDL_GetPrimarySelectionText :: () -> *u8 #foreign sdl3;
SDL_HasPrimarySelectionText :: () -> bool #foreign sdl3;
SDL_ClipboardDataCallback :: #type (userdata: *void, mime_type: *u8, size: *u64) -> *void #c_call;
SDL_ClipboardCleanupCallback :: #type (userdata: *void) -> void #c_call;
SDL_SetClipboardData :: (callback: SDL_ClipboardDataCallback, cleanup: SDL_ClipboardCleanupCallback, userdata: *void, mime_types: **u8, num_mime_types: u64) -> bool #foreign sdl3;
SDL_ClearClipboardData :: () -> bool #foreign sdl3;
SDL_GetClipboardData :: (mime_type: *u8, size: *u64) -> *void #foreign sdl3;
SDL_HasClipboardData :: (mime_type: *u8) -> bool #foreign sdl3;
SDL_GetClipboardMimeTypes :: (num_mime_types: *u64) -> **u8 #foreign sdl3;
SDL_GetNumLogicalCPUCores :: () -> s32 #foreign sdl3;
SDL_GetCPUCacheLineSize :: () -> s32 #foreign sdl3;
SDL_HasAltiVec :: () -> bool #foreign sdl3;
SDL_HasMMX :: () -> bool #foreign sdl3;
SDL_HasSSE :: () -> bool #foreign sdl3;
SDL_HasSSE2 :: () -> bool #foreign sdl3;
SDL_HasSSE3 :: () -> bool #foreign sdl3;
SDL_HasSSE41 :: () -> bool #foreign sdl3;
SDL_HasSSE42 :: () -> bool #foreign sdl3;
SDL_HasAVX :: () -> bool #foreign sdl3;
SDL_HasAVX2 :: () -> bool #foreign sdl3;
SDL_HasAVX512F :: () -> bool #foreign sdl3;
SDL_HasARMSIMD :: () -> bool #foreign sdl3;
SDL_HasNEON :: () -> bool #foreign sdl3;
SDL_HasLSX :: () -> bool #foreign sdl3;
SDL_HasLASX :: () -> bool #foreign sdl3;
SDL_GetSystemRAM :: () -> s32 #foreign sdl3;
SDL_GetSIMDAlignment :: () -> u64 #foreign sdl3;
SDL_DisplayID :: Uint32;
SDL_WindowID :: Uint32;
SDL_SystemTheme :: enum u32 {
    UNKNOWN :: 0;
    LIGHT   :: 1;
    DARK    :: 2;

    SDL_SYSTEM_THEME_UNKNOWN :: UNKNOWN;
    SDL_SYSTEM_THEME_LIGHT   :: LIGHT;
    SDL_SYSTEM_THEME_DARK    :: DARK;
}
SDL_DisplayModeData :: struct {}
SDL_DisplayMode :: struct {
    displayID:                SDL_DisplayID;
    format:                   SDL_PixelFormat;
    w:                        s32;
    h:                        s32;
    pixel_density:            float;
    refresh_rate:             float;
    refresh_rate_numerator:   s32;
    refresh_rate_denominator: s32;
    internal:                 *SDL_DisplayModeData;
}
SDL_DisplayOrientation :: enum u32 {
    UNKNOWN           :: 0;
    LANDSCAPE         :: 1;
    LANDSCAPE_FLIPPED :: 2;
    PORTRAIT          :: 3;
    PORTRAIT_FLIPPED  :: 4;

    SDL_ORIENTATION_UNKNOWN           :: UNKNOWN;
    SDL_ORIENTATION_LANDSCAPE         :: LANDSCAPE;
    SDL_ORIENTATION_LANDSCAPE_FLIPPED :: LANDSCAPE_FLIPPED;
    SDL_ORIENTATION_PORTRAIT          :: PORTRAIT;
    SDL_ORIENTATION_PORTRAIT_FLIPPED  :: PORTRAIT_FLIPPED;
}
SDL_Window :: struct {}
SDL_WindowFlags :: Uint64;
SDL_FlashOperation :: enum u32 {
    CANCEL        :: 0;
    BRIEFLY       :: 1;
    UNTIL_FOCUSED :: 2;

    SDL_FLASH_CANCEL        :: CANCEL;
    SDL_FLASH_BRIEFLY       :: BRIEFLY;
    SDL_FLASH_UNTIL_FOCUSED :: UNTIL_FOCUSED;
}
SDL_GLContextState :: struct {}
SDL_GLContext :: *SDL_GLContextState;
SDL_EGLDisplay :: *void;
SDL_EGLConfig :: *void;
SDL_EGLSurface :: *void;
SDL_EGLAttrib :: s64;
SDL_EGLint :: s32;
SDL_EGLAttribArrayCallback :: #type (userdata: *void) -> *SDL_EGLAttrib #c_call;
SDL_EGLIntArrayCallback :: #type (userdata: *void, display: SDL_EGLDisplay, config: SDL_EGLConfig) -> *SDL_EGLint #c_call;
SDL_GLAttr :: enum u32 {
    RED_SIZE                   :: 0;
    GREEN_SIZE                 :: 1;
    BLUE_SIZE                  :: 2;
    ALPHA_SIZE                 :: 3;
    BUFFER_SIZE                :: 4;
    DOUBLEBUFFER               :: 5;
    DEPTH_SIZE                 :: 6;
    STENCIL_SIZE               :: 7;
    ACCUM_RED_SIZE             :: 8;
    ACCUM_GREEN_SIZE           :: 9;
    ACCUM_BLUE_SIZE            :: 10;
    ACCUM_ALPHA_SIZE           :: 11;
    STEREO                     :: 12;
    MULTISAMPLEBUFFERS         :: 13;
    MULTISAMPLESAMPLES         :: 14;
    ACCELERATED_VISUAL         :: 15;
    RETAINED_BACKING           :: 16;
    CONTEXT_MAJOR_VERSION      :: 17;
    CONTEXT_MINOR_VERSION      :: 18;
    CONTEXT_FLAGS              :: 19;
    CONTEXT_PROFILE_MASK       :: 20;
    SHARE_WITH_CURRENT_CONTEXT :: 21;
    FRAMEBUFFER_SRGB_CAPABLE   :: 22;
    CONTEXT_RELEASE_BEHAVIOR   :: 23;
    CONTEXT_RESET_NOTIFICATION :: 24;
    CONTEXT_NO_ERROR           :: 25;
    FLOATBUFFERS               :: 26;
    EGL_PLATFORM               :: 27;

    SDL_GL_RED_SIZE                   :: RED_SIZE;
    SDL_GL_GREEN_SIZE                 :: GREEN_SIZE;
    SDL_GL_BLUE_SIZE                  :: BLUE_SIZE;
    SDL_GL_ALPHA_SIZE                 :: ALPHA_SIZE;
    SDL_GL_BUFFER_SIZE                :: BUFFER_SIZE;
    SDL_GL_DOUBLEBUFFER               :: DOUBLEBUFFER;
    SDL_GL_DEPTH_SIZE                 :: DEPTH_SIZE;
    SDL_GL_STENCIL_SIZE               :: STENCIL_SIZE;
    SDL_GL_ACCUM_RED_SIZE             :: ACCUM_RED_SIZE;
    SDL_GL_ACCUM_GREEN_SIZE           :: ACCUM_GREEN_SIZE;
    SDL_GL_ACCUM_BLUE_SIZE            :: ACCUM_BLUE_SIZE;
    SDL_GL_ACCUM_ALPHA_SIZE           :: ACCUM_ALPHA_SIZE;
    SDL_GL_STEREO                     :: STEREO;
    SDL_GL_MULTISAMPLEBUFFERS         :: MULTISAMPLEBUFFERS;
    SDL_GL_MULTISAMPLESAMPLES         :: MULTISAMPLESAMPLES;
    SDL_GL_ACCELERATED_VISUAL         :: ACCELERATED_VISUAL;
    SDL_GL_RETAINED_BACKING           :: RETAINED_BACKING;
    SDL_GL_CONTEXT_MAJOR_VERSION      :: CONTEXT_MAJOR_VERSION;
    SDL_GL_CONTEXT_MINOR_VERSION      :: CONTEXT_MINOR_VERSION;
    SDL_GL_CONTEXT_FLAGS              :: CONTEXT_FLAGS;
    SDL_GL_CONTEXT_PROFILE_MASK       :: CONTEXT_PROFILE_MASK;
    SDL_GL_SHARE_WITH_CURRENT_CONTEXT :: SHARE_WITH_CURRENT_CONTEXT;
    SDL_GL_FRAMEBUFFER_SRGB_CAPABLE   :: FRAMEBUFFER_SRGB_CAPABLE;
    SDL_GL_CONTEXT_RELEASE_BEHAVIOR   :: CONTEXT_RELEASE_BEHAVIOR;
    SDL_GL_CONTEXT_RESET_NOTIFICATION :: CONTEXT_RESET_NOTIFICATION;
    SDL_GL_CONTEXT_NO_ERROR           :: CONTEXT_NO_ERROR;
    SDL_GL_FLOATBUFFERS               :: FLOATBUFFERS;
    SDL_GL_EGL_PLATFORM               :: EGL_PLATFORM;
}
SDL_GLProfile :: Uint32;
SDL_GLContextFlag :: Uint32;
SDL_GLContextReleaseFlag :: Uint32;
SDL_GLContextResetNotification :: Uint32;
SDL_GetNumVideoDrivers :: () -> s32 #foreign sdl3;
SDL_GetVideoDriver :: (index: s32) -> *u8 #foreign sdl3;
SDL_GetCurrentVideoDriver :: () -> *u8 #foreign sdl3;
SDL_GetSystemTheme :: () -> SDL_SystemTheme #foreign sdl3;
SDL_GetDisplays :: (count: *s32) -> *SDL_DisplayID #foreign sdl3;
SDL_GetPrimaryDisplay :: () -> SDL_DisplayID #foreign sdl3;
SDL_GetDisplayProperties :: (displayID: SDL_DisplayID) -> SDL_PropertiesID #foreign sdl3;
SDL_GetDisplayName :: (displayID: SDL_DisplayID) -> *u8 #foreign sdl3;
SDL_GetDisplayBounds :: (displayID: SDL_DisplayID, rect: *SDL_Rect) -> bool #foreign sdl3;
SDL_GetDisplayUsableBounds :: (displayID: SDL_DisplayID, rect: *SDL_Rect) -> bool #foreign sdl3;
SDL_GetNaturalDisplayOrientation :: (displayID: SDL_DisplayID) -> SDL_DisplayOrientation #foreign sdl3;
SDL_GetCurrentDisplayOrientation :: (displayID: SDL_DisplayID) -> SDL_DisplayOrientation #foreign sdl3;
SDL_GetDisplayContentScale :: (displayID: SDL_DisplayID) -> float #foreign sdl3;
SDL_GetFullscreenDisplayModes :: (displayID: SDL_DisplayID, count: *s32) -> **SDL_DisplayMode #foreign sdl3;
SDL_GetClosestFullscreenDisplayMode :: (displayID: SDL_DisplayID, w: s32, h: s32, refresh_rate: float, include_high_density_modes: bool, mode: *SDL_DisplayMode) -> bool #foreign sdl3;
SDL_GetDesktopDisplayMode :: (displayID: SDL_DisplayID) -> *SDL_DisplayMode #foreign sdl3;
SDL_GetCurrentDisplayMode :: (displayID: SDL_DisplayID) -> *SDL_DisplayMode #foreign sdl3;
SDL_GetDisplayForPoint :: (point: *SDL_Point) -> SDL_DisplayID #foreign sdl3;
SDL_GetDisplayForRect :: (rect: *SDL_Rect) -> SDL_DisplayID #foreign sdl3;
SDL_GetDisplayForWindow :: (window: *SDL_Window) -> SDL_DisplayID #foreign sdl3;
SDL_GetWindowPixelDensity :: (window: *SDL_Window) -> float #foreign sdl3;
SDL_GetWindowDisplayScale :: (window: *SDL_Window) -> float #foreign sdl3;
SDL_SetWindowFullscreenMode :: (window: *SDL_Window, mode: *SDL_DisplayMode) -> bool #foreign sdl3;
SDL_GetWindowFullscreenMode :: (window: *SDL_Window) -> *SDL_DisplayMode #foreign sdl3;
SDL_GetWindowICCProfile :: (window: *SDL_Window, size: *u64) -> *void #foreign sdl3;
SDL_GetWindowPixelFormat :: (window: *SDL_Window) -> SDL_PixelFormat #foreign sdl3;
SDL_GetWindows :: (count: *s32) -> **SDL_Window #foreign sdl3;
SDL_CreateWindow :: (title: *u8, w: s32, h: s32, flags: SDL_WindowFlags) -> *SDL_Window #foreign sdl3;
SDL_CreatePopupWindow :: (parent: *SDL_Window, offset_x: s32, offset_y: s32, w: s32, h: s32, flags: SDL_WindowFlags) -> *SDL_Window #foreign sdl3;
SDL_CreateWindowWithProperties :: (props: SDL_PropertiesID) -> *SDL_Window #foreign sdl3;
SDL_GetWindowID :: (window: *SDL_Window) -> SDL_WindowID #foreign sdl3;
SDL_GetWindowFromID :: (id: SDL_WindowID) -> *SDL_Window #foreign sdl3;
SDL_GetWindowParent :: (window: *SDL_Window) -> *SDL_Window #foreign sdl3;
SDL_GetWindowProperties :: (window: *SDL_Window) -> SDL_PropertiesID #foreign sdl3;
SDL_GetWindowFlags :: (window: *SDL_Window) -> SDL_WindowFlags #foreign sdl3;
SDL_SetWindowTitle :: (window: *SDL_Window, title: *u8) -> bool #foreign sdl3;
SDL_GetWindowTitle :: (window: *SDL_Window) -> *u8 #foreign sdl3;
SDL_SetWindowIcon :: (window: *SDL_Window, icon: *SDL_Surface) -> bool #foreign sdl3;
SDL_SetWindowPosition :: (window: *SDL_Window, x: s32, y: s32) -> bool #foreign sdl3;
SDL_GetWindowPosition :: (window: *SDL_Window, x: *s32, y: *s32) -> bool #foreign sdl3;
SDL_SetWindowSize :: (window: *SDL_Window, w: s32, h: s32) -> bool #foreign sdl3;
SDL_GetWindowSize :: (window: *SDL_Window, w: *s32, h: *s32) -> bool #foreign sdl3;
SDL_GetWindowSafeArea :: (window: *SDL_Window, rect: *SDL_Rect) -> bool #foreign sdl3;
SDL_SetWindowAspectRatio :: (window: *SDL_Window, min_aspect: float, max_aspect: float) -> bool #foreign sdl3;
SDL_GetWindowAspectRatio :: (window: *SDL_Window, min_aspect: *float, max_aspect: *float) -> bool #foreign sdl3;
SDL_GetWindowBordersSize :: (window: *SDL_Window, top: *s32, left: *s32, bottom: *s32, right: *s32) -> bool #foreign sdl3;
SDL_GetWindowSizeInPixels :: (window: *SDL_Window, w: *s32, h: *s32) -> bool #foreign sdl3;
SDL_SetWindowMinimumSize :: (window: *SDL_Window, min_w: s32, min_h: s32) -> bool #foreign sdl3;
SDL_GetWindowMinimumSize :: (window: *SDL_Window, w: *s32, h: *s32) -> bool #foreign sdl3;
SDL_SetWindowMaximumSize :: (window: *SDL_Window, max_w: s32, max_h: s32) -> bool #foreign sdl3;
SDL_GetWindowMaximumSize :: (window: *SDL_Window, w: *s32, h: *s32) -> bool #foreign sdl3;
SDL_SetWindowBordered :: (window: *SDL_Window, bordered: bool) -> bool #foreign sdl3;
SDL_SetWindowResizable :: (window: *SDL_Window, resizable: bool) -> bool #foreign sdl3;
SDL_SetWindowAlwaysOnTop :: (window: *SDL_Window, on_top: bool) -> bool #foreign sdl3;
SDL_ShowWindow :: (window: *SDL_Window) -> bool #foreign sdl3;
SDL_HideWindow :: (window: *SDL_Window) -> bool #foreign sdl3;
SDL_RaiseWindow :: (window: *SDL_Window) -> bool #foreign sdl3;
SDL_MaximizeWindow :: (window: *SDL_Window) -> bool #foreign sdl3;
SDL_MinimizeWindow :: (window: *SDL_Window) -> bool #foreign sdl3;
SDL_RestoreWindow :: (window: *SDL_Window) -> bool #foreign sdl3;
SDL_SetWindowFullscreen :: (window: *SDL_Window, fullscreen: bool) -> bool #foreign sdl3;
SDL_SyncWindow :: (window: *SDL_Window) -> bool #foreign sdl3;
SDL_WindowHasSurface :: (window: *SDL_Window) -> bool #foreign sdl3;
SDL_GetWindowSurface :: (window: *SDL_Window) -> *SDL_Surface #foreign sdl3;
SDL_SetWindowSurfaceVSync :: (window: *SDL_Window, vsync: s32) -> bool #foreign sdl3;
SDL_GetWindowSurfaceVSync :: (window: *SDL_Window, vsync: *s32) -> bool #foreign sdl3;
SDL_UpdateWindowSurface :: (window: *SDL_Window) -> bool #foreign sdl3;
SDL_UpdateWindowSurfaceRects :: (window: *SDL_Window, rects: *SDL_Rect, numrects: s32) -> bool #foreign sdl3;
SDL_DestroyWindowSurface :: (window: *SDL_Window) -> bool #foreign sdl3;
SDL_SetWindowKeyboardGrab :: (window: *SDL_Window, grabbed: bool) -> bool #foreign sdl3;
SDL_SetWindowMouseGrab :: (window: *SDL_Window, grabbed: bool) -> bool #foreign sdl3;
SDL_GetWindowKeyboardGrab :: (window: *SDL_Window) -> bool #foreign sdl3;
SDL_GetWindowMouseGrab :: (window: *SDL_Window) -> bool #foreign sdl3;
SDL_GetGrabbedWindow :: () -> *SDL_Window #foreign sdl3;
SDL_SetWindowMouseRect :: (window: *SDL_Window, rect: *SDL_Rect) -> bool #foreign sdl3;
SDL_GetWindowMouseRect :: (window: *SDL_Window) -> *SDL_Rect #foreign sdl3;
SDL_SetWindowOpacity :: (window: *SDL_Window, opacity: float) -> bool #foreign sdl3;
SDL_GetWindowOpacity :: (window: *SDL_Window) -> float #foreign sdl3;
SDL_SetWindowParent :: (window: *SDL_Window, parent: *SDL_Window) -> bool #foreign sdl3;
SDL_SetWindowModal :: (window: *SDL_Window, modal: bool) -> bool #foreign sdl3;
SDL_SetWindowFocusable :: (window: *SDL_Window, focusable: bool) -> bool #foreign sdl3;
SDL_ShowWindowSystemMenu :: (window: *SDL_Window, x: s32, y: s32) -> bool #foreign sdl3;
SDL_HitTestResult :: enum u32 {
    NORMAL             :: 0;
    DRAGGABLE          :: 1;
    RESIZE_TOPLEFT     :: 2;
    RESIZE_TOP         :: 3;
    RESIZE_TOPRIGHT    :: 4;
    RESIZE_RIGHT       :: 5;
    RESIZE_BOTTOMRIGHT :: 6;
    RESIZE_BOTTOM      :: 7;
    RESIZE_BOTTOMLEFT  :: 8;
    RESIZE_LEFT        :: 9;

    SDL_HITTEST_NORMAL             :: NORMAL;
    SDL_HITTEST_DRAGGABLE          :: DRAGGABLE;
    SDL_HITTEST_RESIZE_TOPLEFT     :: RESIZE_TOPLEFT;
    SDL_HITTEST_RESIZE_TOP         :: RESIZE_TOP;
    SDL_HITTEST_RESIZE_TOPRIGHT    :: RESIZE_TOPRIGHT;
    SDL_HITTEST_RESIZE_RIGHT       :: RESIZE_RIGHT;
    SDL_HITTEST_RESIZE_BOTTOMRIGHT :: RESIZE_BOTTOMRIGHT;
    SDL_HITTEST_RESIZE_BOTTOM      :: RESIZE_BOTTOM;
    SDL_HITTEST_RESIZE_BOTTOMLEFT  :: RESIZE_BOTTOMLEFT;
    SDL_HITTEST_RESIZE_LEFT        :: RESIZE_LEFT;
}
SDL_HitTest :: #type (win: *SDL_Window, area: *SDL_Point, data: *void) -> SDL_HitTestResult #c_call;
SDL_SetWindowHitTest :: (window: *SDL_Window, callback: SDL_HitTest, callback_data: *void) -> bool #foreign sdl3;
SDL_SetWindowShape :: (window: *SDL_Window, shape: *SDL_Surface) -> bool #foreign sdl3;
SDL_FlashWindow :: (window: *SDL_Window, operation: SDL_FlashOperation) -> bool #foreign sdl3;
SDL_DestroyWindow :: (window: *SDL_Window) -> void #foreign sdl3;
SDL_ScreenSaverEnabled :: () -> bool #foreign sdl3;
SDL_EnableScreenSaver :: () -> bool #foreign sdl3;
SDL_DisableScreenSaver :: () -> bool #foreign sdl3;
SDL_GL_LoadLibrary :: (path: *u8) -> bool #foreign sdl3;
SDL_GL_GetProcAddress :: (proc: *u8) -> SDL_FunctionPointer #foreign sdl3;
SDL_EGL_GetProcAddress :: (proc: *u8) -> SDL_FunctionPointer #foreign sdl3;
SDL_GL_UnloadLibrary :: () -> void #foreign sdl3;
SDL_GL_ExtensionSupported :: (extension: *u8) -> bool #foreign sdl3;
SDL_GL_ResetAttributes :: () -> void #foreign sdl3;
SDL_GL_SetAttribute :: (attr: SDL_GLAttr, value: s32) -> bool #foreign sdl3;
SDL_GL_GetAttribute :: (attr: SDL_GLAttr, value: *s32) -> bool #foreign sdl3;
SDL_GL_CreateContext :: (window: *SDL_Window) -> SDL_GLContext #foreign sdl3;
SDL_GL_MakeCurrent :: (window: *SDL_Window, _context: SDL_GLContext) -> bool #foreign sdl3;
SDL_GL_GetCurrentWindow :: () -> *SDL_Window #foreign sdl3;
SDL_GL_GetCurrentContext :: () -> SDL_GLContext #foreign sdl3;
SDL_EGL_GetCurrentDisplay :: () -> SDL_EGLDisplay #foreign sdl3;
SDL_EGL_GetCurrentConfig :: () -> SDL_EGLConfig #foreign sdl3;
SDL_EGL_GetWindowSurface :: (window: *SDL_Window) -> SDL_EGLSurface #foreign sdl3;
SDL_EGL_SetAttributeCallbacks :: (platformAttribCallback: SDL_EGLAttribArrayCallback, surfaceAttribCallback: SDL_EGLIntArrayCallback, contextAttribCallback: SDL_EGLIntArrayCallback, userdata: *void) -> void #foreign sdl3;
SDL_GL_SetSwapInterval :: (interval: s32) -> bool #foreign sdl3;
SDL_GL_GetSwapInterval :: (interval: *s32) -> bool #foreign sdl3;
SDL_GL_SwapWindow :: (window: *SDL_Window) -> bool #foreign sdl3;
SDL_GL_DestroyContext :: (_context: SDL_GLContext) -> bool #foreign sdl3;
SDL_DialogFileFilter :: struct {
    name:    *u8;
    pattern: *u8;
}
SDL_DialogFileCallback :: #type (userdata: *void, filelist: **u8, filter: s32) -> void #c_call;
SDL_ShowOpenFileDialog :: (callback: SDL_DialogFileCallback, userdata: *void, window: *SDL_Window, filters: *SDL_DialogFileFilter, nfilters: s32, default_location: *u8, allow_many: bool) -> void #foreign sdl3;
SDL_ShowSaveFileDialog :: (callback: SDL_DialogFileCallback, userdata: *void, window: *SDL_Window, filters: *SDL_DialogFileFilter, nfilters: s32, default_location: *u8) -> void #foreign sdl3;
SDL_ShowOpenFolderDialog :: (callback: SDL_DialogFileCallback, userdata: *void, window: *SDL_Window, default_location: *u8, allow_many: bool) -> void #foreign sdl3;
SDL_GUID :: struct {
    data: [16] Uint8;
}
SDL_GUIDToString :: (guid: SDL_GUID, pszGUID: *u8, cbGUID: s32) -> void #foreign sdl3;
SDL_StringToGUID :: (pchGUID: *u8) -> SDL_GUID #foreign sdl3;
SDL_PowerState :: enum s32 {
    ERROR      :: -1;
    UNKNOWN    :: 0;
    ON_BATTERY :: 1;
    NO_BATTERY :: 2;
    CHARGING   :: 3;
    CHARGED    :: 4;

    SDL_POWERSTATE_ERROR      :: ERROR;
    SDL_POWERSTATE_UNKNOWN    :: UNKNOWN;
    SDL_POWERSTATE_ON_BATTERY :: ON_BATTERY;
    SDL_POWERSTATE_NO_BATTERY :: NO_BATTERY;
    SDL_POWERSTATE_CHARGING   :: CHARGING;
    SDL_POWERSTATE_CHARGED    :: CHARGED;
}
SDL_GetPowerInfo :: (seconds: *s32, percent: *s32) -> SDL_PowerState #foreign sdl3;
SDL_Sensor :: struct {}
SDL_SensorID :: Uint32;
SDL_SensorType :: enum s32 {
    INVALID :: -1;
    UNKNOWN :: 0;
    ACCEL   :: 1;
    GYRO    :: 2;
    ACCEL_L :: 3;
    GYRO_L  :: 4;
    ACCEL_R :: 5;
    GYRO_R  :: 6;

    SDL_SENSOR_INVALID :: INVALID;
    SDL_SENSOR_UNKNOWN :: UNKNOWN;
    SDL_SENSOR_ACCEL   :: ACCEL;
    SDL_SENSOR_GYRO    :: GYRO;
    SDL_SENSOR_ACCEL_L :: ACCEL_L;
    SDL_SENSOR_GYRO_L  :: GYRO_L;
    SDL_SENSOR_ACCEL_R :: ACCEL_R;
    SDL_SENSOR_GYRO_R  :: GYRO_R;
}
SDL_GetSensors :: (count: *s32) -> *SDL_SensorID #foreign sdl3;
SDL_GetSensorNameForID :: (instance_id: SDL_SensorID) -> *u8 #foreign sdl3;
SDL_GetSensorTypeForID :: (instance_id: SDL_SensorID) -> SDL_SensorType #foreign sdl3;
SDL_GetSensorNonPortableTypeForID :: (instance_id: SDL_SensorID) -> s32 #foreign sdl3;
SDL_OpenSensor :: (instance_id: SDL_SensorID) -> *SDL_Sensor #foreign sdl3;
SDL_GetSensorFromID :: (instance_id: SDL_SensorID) -> *SDL_Sensor #foreign sdl3;
SDL_GetSensorProperties :: (sensor: *SDL_Sensor) -> SDL_PropertiesID #foreign sdl3;
SDL_GetSensorName :: (sensor: *SDL_Sensor) -> *u8 #foreign sdl3;
SDL_GetSensorType :: (sensor: *SDL_Sensor) -> SDL_SensorType #foreign sdl3;
SDL_GetSensorNonPortableType :: (sensor: *SDL_Sensor) -> s32 #foreign sdl3;
SDL_GetSensorID :: (sensor: *SDL_Sensor) -> SDL_SensorID #foreign sdl3;
SDL_GetSensorData :: (sensor: *SDL_Sensor, data: *float, num_values: s32) -> bool #foreign sdl3;
SDL_CloseSensor :: (sensor: *SDL_Sensor) -> void #foreign sdl3;
SDL_UpdateSensors :: () -> void #foreign sdl3;
SDL_Joystick :: struct {}
SDL_JoystickID :: Uint32;
SDL_JoystickType :: enum u32 {
    UNKNOWN      :: 0;
    GAMEPAD      :: 1;
    WHEEL        :: 2;
    ARCADE_STICK :: 3;
    FLIGHT_STICK :: 4;
    DANCE_PAD    :: 5;
    GUITAR       :: 6;
    DRUM_KIT     :: 7;
    ARCADE_PAD   :: 8;
    THROTTLE     :: 9;
    COUNT        :: 10;

    SDL_JOYSTICK_TYPE_UNKNOWN      :: UNKNOWN;
    SDL_JOYSTICK_TYPE_GAMEPAD      :: GAMEPAD;
    SDL_JOYSTICK_TYPE_WHEEL        :: WHEEL;
    SDL_JOYSTICK_TYPE_ARCADE_STICK :: ARCADE_STICK;
    SDL_JOYSTICK_TYPE_FLIGHT_STICK :: FLIGHT_STICK;
    SDL_JOYSTICK_TYPE_DANCE_PAD    :: DANCE_PAD;
    SDL_JOYSTICK_TYPE_GUITAR       :: GUITAR;
    SDL_JOYSTICK_TYPE_DRUM_KIT     :: DRUM_KIT;
    SDL_JOYSTICK_TYPE_ARCADE_PAD   :: ARCADE_PAD;
    SDL_JOYSTICK_TYPE_THROTTLE     :: THROTTLE;
    SDL_JOYSTICK_TYPE_COUNT        :: COUNT;
}
SDL_JoystickConnectionState :: enum s32 {
    INVALID  :: -1;
    UNKNOWN  :: 0;
    WIRED    :: 1;
    WIRELESS :: 2;

    SDL_JOYSTICK_CONNECTION_INVALID  :: INVALID;
    SDL_JOYSTICK_CONNECTION_UNKNOWN  :: UNKNOWN;
    SDL_JOYSTICK_CONNECTION_WIRED    :: WIRED;
    SDL_JOYSTICK_CONNECTION_WIRELESS :: WIRELESS;
}
SDL_LockJoysticks :: () -> void #foreign sdl3;
SDL_UnlockJoysticks :: () -> void #foreign sdl3;
SDL_HasJoystick :: () -> bool #foreign sdl3;
SDL_GetJoysticks :: (count: *s32) -> *SDL_JoystickID #foreign sdl3;
SDL_GetJoystickNameForID :: (instance_id: SDL_JoystickID) -> *u8 #foreign sdl3;
SDL_GetJoystickPathForID :: (instance_id: SDL_JoystickID) -> *u8 #foreign sdl3;
SDL_GetJoystickPlayerIndexForID :: (instance_id: SDL_JoystickID) -> s32 #foreign sdl3;
SDL_GetJoystickGUIDForID :: (instance_id: SDL_JoystickID) -> SDL_GUID #foreign sdl3;
SDL_GetJoystickVendorForID :: (instance_id: SDL_JoystickID) -> Uint16 #foreign sdl3;
SDL_GetJoystickProductForID :: (instance_id: SDL_JoystickID) -> Uint16 #foreign sdl3;
SDL_GetJoystickProductVersionForID :: (instance_id: SDL_JoystickID) -> Uint16 #foreign sdl3;
SDL_GetJoystickTypeForID :: (instance_id: SDL_JoystickID) -> SDL_JoystickType #foreign sdl3;
SDL_OpenJoystick :: (instance_id: SDL_JoystickID) -> *SDL_Joystick #foreign sdl3;
SDL_GetJoystickFromID :: (instance_id: SDL_JoystickID) -> *SDL_Joystick #foreign sdl3;
SDL_GetJoystickFromPlayerIndex :: (player_index: s32) -> *SDL_Joystick #foreign sdl3;
SDL_VirtualJoystickTouchpadDesc :: struct {
    nfingers: Uint16;
    padding:  [3] Uint16;
}
SDL_VirtualJoystickSensorDesc :: struct {
    type: SDL_SensorType;
    rate: float;
}
SDL_VirtualJoystickDesc :: struct {
    version:           Uint32;
    type:              Uint16;
    padding:           Uint16;
    vendor_id:         Uint16;
    product_id:        Uint16;
    naxes:             Uint16;
    nbuttons:          Uint16;
    nballs:            Uint16;
    nhats:             Uint16;
    ntouchpads:        Uint16;
    nsensors:          Uint16;
    padding2:          [2] Uint16;
    button_mask:       Uint32;
    axis_mask:         Uint32;
    name:              *u8;
    touchpads:         *SDL_VirtualJoystickTouchpadDesc;
    sensors:           *SDL_VirtualJoystickSensorDesc;
    userdata:          *void;
    Update:            #type (userdata: *void) -> void #c_call;
    SetPlayerIndex:    #type (userdata: *void, player_index: s32) -> void #c_call;
    Rumble:            #type (userdata: *void, low_frequency_rumble: Uint16, high_frequency_rumble: Uint16) -> bool #c_call;
    RumbleTriggers:    #type (userdata: *void, left_rumble: Uint16, right_rumble: Uint16) -> bool #c_call;
    SetLED:            #type (userdata: *void, red: Uint8, green: Uint8, blue: Uint8) -> bool #c_call;
    SendEffect:        #type (userdata: *void, data: *void, size: s32) -> bool #c_call;
    SetSensorsEnabled: #type (userdata: *void, enabled: bool) -> bool #c_call;
    Cleanup:           #type (userdata: *void) -> void #c_call;
}
SDL_AttachVirtualJoystick :: (desc: *SDL_VirtualJoystickDesc) -> SDL_JoystickID #foreign sdl3;
SDL_DetachVirtualJoystick :: (instance_id: SDL_JoystickID) -> bool #foreign sdl3;
SDL_IsJoystickVirtual :: (instance_id: SDL_JoystickID) -> bool #foreign sdl3;
SDL_SetJoystickVirtualAxis :: (joystick: *SDL_Joystick, axis: s32, value: Sint16) -> bool #foreign sdl3;
SDL_SetJoystickVirtualBall :: (joystick: *SDL_Joystick, ball: s32, xrel: Sint16, yrel: Sint16) -> bool #foreign sdl3;
SDL_SetJoystickVirtualButton :: (joystick: *SDL_Joystick, button: s32, down: bool) -> bool #foreign sdl3;
SDL_SetJoystickVirtualHat :: (joystick: *SDL_Joystick, hat: s32, value: Uint8) -> bool #foreign sdl3;
SDL_SetJoystickVirtualTouchpad :: (joystick: *SDL_Joystick, touchpad: s32, finger: s32, down: bool, x: float, y: float, pressure: float) -> bool #foreign sdl3;
SDL_SendJoystickVirtualSensorData :: (joystick: *SDL_Joystick, type: SDL_SensorType, sensor_timestamp: Uint64, data: *float, num_values: s32) -> bool #foreign sdl3;
SDL_GetJoystickProperties :: (joystick: *SDL_Joystick) -> SDL_PropertiesID #foreign sdl3;
SDL_GetJoystickName :: (joystick: *SDL_Joystick) -> *u8 #foreign sdl3;
SDL_GetJoystickPath :: (joystick: *SDL_Joystick) -> *u8 #foreign sdl3;
SDL_GetJoystickPlayerIndex :: (joystick: *SDL_Joystick) -> s32 #foreign sdl3;
SDL_SetJoystickPlayerIndex :: (joystick: *SDL_Joystick, player_index: s32) -> bool #foreign sdl3;
SDL_GetJoystickGUID :: (joystick: *SDL_Joystick) -> SDL_GUID #foreign sdl3;
SDL_GetJoystickVendor :: (joystick: *SDL_Joystick) -> Uint16 #foreign sdl3;
SDL_GetJoystickProduct :: (joystick: *SDL_Joystick) -> Uint16 #foreign sdl3;
SDL_GetJoystickProductVersion :: (joystick: *SDL_Joystick) -> Uint16 #foreign sdl3;
SDL_GetJoystickFirmwareVersion :: (joystick: *SDL_Joystick) -> Uint16 #foreign sdl3;
SDL_GetJoystickSerial :: (joystick: *SDL_Joystick) -> *u8 #foreign sdl3;
SDL_GetJoystickType :: (joystick: *SDL_Joystick) -> SDL_JoystickType #foreign sdl3;
SDL_GetJoystickGUIDInfo :: (guid: SDL_GUID, vendor: *Uint16, product: *Uint16, version: *Uint16, crc16: *Uint16) -> void #foreign sdl3;
SDL_JoystickConnected :: (joystick: *SDL_Joystick) -> bool #foreign sdl3;
SDL_GetJoystickID :: (joystick: *SDL_Joystick) -> SDL_JoystickID #foreign sdl3;
SDL_GetNumJoystickAxes :: (joystick: *SDL_Joystick) -> s32 #foreign sdl3;
SDL_GetNumJoystickBalls :: (joystick: *SDL_Joystick) -> s32 #foreign sdl3;
SDL_GetNumJoystickHats :: (joystick: *SDL_Joystick) -> s32 #foreign sdl3;
SDL_GetNumJoystickButtons :: (joystick: *SDL_Joystick) -> s32 #foreign sdl3;
SDL_SetJoystickEventsEnabled :: (enabled: bool) -> void #foreign sdl3;
SDL_JoystickEventsEnabled :: () -> bool #foreign sdl3;
SDL_UpdateJoysticks :: () -> void #foreign sdl3;
SDL_GetJoystickAxis :: (joystick: *SDL_Joystick, axis: s32) -> Sint16 #foreign sdl3;
SDL_GetJoystickAxisInitialState :: (joystick: *SDL_Joystick, axis: s32, state: *Sint16) -> bool #foreign sdl3;
SDL_GetJoystickBall :: (joystick: *SDL_Joystick, ball: s32, dx: *s32, dy: *s32) -> bool #foreign sdl3;
SDL_GetJoystickHat :: (joystick: *SDL_Joystick, hat: s32) -> Uint8 #foreign sdl3;
SDL_GetJoystickButton :: (joystick: *SDL_Joystick, button: s32) -> bool #foreign sdl3;
SDL_RumbleJoystick :: (joystick: *SDL_Joystick, low_frequency_rumble: Uint16, high_frequency_rumble: Uint16, duration_ms: Uint32) -> bool #foreign sdl3;
SDL_RumbleJoystickTriggers :: (joystick: *SDL_Joystick, left_rumble: Uint16, right_rumble: Uint16, duration_ms: Uint32) -> bool #foreign sdl3;
SDL_SetJoystickLED :: (joystick: *SDL_Joystick, red: Uint8, green: Uint8, blue: Uint8) -> bool #foreign sdl3;
SDL_SendJoystickEffect :: (joystick: *SDL_Joystick, data: *void, size: s32) -> bool #foreign sdl3;
SDL_CloseJoystick :: (joystick: *SDL_Joystick) -> void #foreign sdl3;
SDL_GetJoystickConnectionState :: (joystick: *SDL_Joystick) -> SDL_JoystickConnectionState #foreign sdl3;
SDL_GetJoystickPowerInfo :: (joystick: *SDL_Joystick, percent: *s32) -> SDL_PowerState #foreign sdl3;
SDL_Gamepad :: struct {}
SDL_GamepadType :: enum u32 {
    UNKNOWN                      :: 0;
    STANDARD                     :: 1;
    XBOX360                      :: 2;
    XBOXONE                      :: 3;
    PS3                          :: 4;
    PS4                          :: 5;
    PS5                          :: 6;
    NINTENDO_SWITCH_PRO          :: 7;
    NINTENDO_SWITCH_JOYCON_LEFT  :: 8;
    NINTENDO_SWITCH_JOYCON_RIGHT :: 9;
    NINTENDO_SWITCH_JOYCON_PAIR  :: 10;
    COUNT                        :: 11;

    SDL_GAMEPAD_TYPE_UNKNOWN                      :: UNKNOWN;
    SDL_GAMEPAD_TYPE_STANDARD                     :: STANDARD;
    SDL_GAMEPAD_TYPE_XBOX360                      :: XBOX360;
    SDL_GAMEPAD_TYPE_XBOXONE                      :: XBOXONE;
    SDL_GAMEPAD_TYPE_PS3                          :: PS3;
    SDL_GAMEPAD_TYPE_PS4                          :: PS4;
    SDL_GAMEPAD_TYPE_PS5                          :: PS5;
    SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_PRO          :: NINTENDO_SWITCH_PRO;
    SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_LEFT  :: NINTENDO_SWITCH_JOYCON_LEFT;
    SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_RIGHT :: NINTENDO_SWITCH_JOYCON_RIGHT;
    SDL_GAMEPAD_TYPE_NINTENDO_SWITCH_JOYCON_PAIR  :: NINTENDO_SWITCH_JOYCON_PAIR;
    SDL_GAMEPAD_TYPE_COUNT                        :: COUNT;
}
SDL_GamepadButton :: enum s32 {
    INVALID        :: -1;
    SOUTH          :: 0;
    EAST           :: 1;
    WEST           :: 2;
    NORTH          :: 3;
    BACK           :: 4;
    GUIDE          :: 5;
    START          :: 6;
    LEFT_STICK     :: 7;
    RIGHT_STICK    :: 8;
    LEFT_SHOULDER  :: 9;
    RIGHT_SHOULDER :: 10;
    DPAD_UP        :: 11;
    DPAD_DOWN      :: 12;
    DPAD_LEFT      :: 13;
    DPAD_RIGHT     :: 14;
    MISC1          :: 15;
    RIGHT_PADDLE1  :: 16;
    LEFT_PADDLE1   :: 17;
    RIGHT_PADDLE2  :: 18;
    LEFT_PADDLE2   :: 19;
    TOUCHPAD       :: 20;
    MISC2          :: 21;
    MISC3          :: 22;
    MISC4          :: 23;
    MISC5          :: 24;
    MISC6          :: 25;
    COUNT          :: 26;

    SDL_GAMEPAD_BUTTON_INVALID        :: INVALID;
    SDL_GAMEPAD_BUTTON_SOUTH          :: SOUTH;
    SDL_GAMEPAD_BUTTON_EAST           :: EAST;
    SDL_GAMEPAD_BUTTON_WEST           :: WEST;
    SDL_GAMEPAD_BUTTON_NORTH          :: NORTH;
    SDL_GAMEPAD_BUTTON_BACK           :: BACK;
    SDL_GAMEPAD_BUTTON_GUIDE          :: GUIDE;
    SDL_GAMEPAD_BUTTON_START          :: START;
    SDL_GAMEPAD_BUTTON_LEFT_STICK     :: LEFT_STICK;
    SDL_GAMEPAD_BUTTON_RIGHT_STICK    :: RIGHT_STICK;
    SDL_GAMEPAD_BUTTON_LEFT_SHOULDER  :: LEFT_SHOULDER;
    SDL_GAMEPAD_BUTTON_RIGHT_SHOULDER :: RIGHT_SHOULDER;
    SDL_GAMEPAD_BUTTON_DPAD_UP        :: DPAD_UP;
    SDL_GAMEPAD_BUTTON_DPAD_DOWN      :: DPAD_DOWN;
    SDL_GAMEPAD_BUTTON_DPAD_LEFT      :: DPAD_LEFT;
    SDL_GAMEPAD_BUTTON_DPAD_RIGHT     :: DPAD_RIGHT;
    SDL_GAMEPAD_BUTTON_MISC1          :: MISC1;
    SDL_GAMEPAD_BUTTON_RIGHT_PADDLE1  :: RIGHT_PADDLE1;
    SDL_GAMEPAD_BUTTON_LEFT_PADDLE1   :: LEFT_PADDLE1;
    SDL_GAMEPAD_BUTTON_RIGHT_PADDLE2  :: RIGHT_PADDLE2;
    SDL_GAMEPAD_BUTTON_LEFT_PADDLE2   :: LEFT_PADDLE2;
    SDL_GAMEPAD_BUTTON_TOUCHPAD       :: TOUCHPAD;
    SDL_GAMEPAD_BUTTON_MISC2          :: MISC2;
    SDL_GAMEPAD_BUTTON_MISC3          :: MISC3;
    SDL_GAMEPAD_BUTTON_MISC4          :: MISC4;
    SDL_GAMEPAD_BUTTON_MISC5          :: MISC5;
    SDL_GAMEPAD_BUTTON_MISC6          :: MISC6;
    SDL_GAMEPAD_BUTTON_COUNT          :: COUNT;
}
SDL_GamepadButtonLabel :: enum u32 {
    UNKNOWN  :: 0;
    A        :: 1;
    B        :: 2;
    X        :: 3;
    Y        :: 4;
    CROSS    :: 5;
    CIRCLE   :: 6;
    SQUARE   :: 7;
    TRIANGLE :: 8;

    SDL_GAMEPAD_BUTTON_LABEL_UNKNOWN  :: UNKNOWN;
    SDL_GAMEPAD_BUTTON_LABEL_A        :: A;
    SDL_GAMEPAD_BUTTON_LABEL_B        :: B;
    SDL_GAMEPAD_BUTTON_LABEL_X        :: X;
    SDL_GAMEPAD_BUTTON_LABEL_Y        :: Y;
    SDL_GAMEPAD_BUTTON_LABEL_CROSS    :: CROSS;
    SDL_GAMEPAD_BUTTON_LABEL_CIRCLE   :: CIRCLE;
    SDL_GAMEPAD_BUTTON_LABEL_SQUARE   :: SQUARE;
    SDL_GAMEPAD_BUTTON_LABEL_TRIANGLE :: TRIANGLE;
}
SDL_GamepadAxis :: enum s32 {
    INVALID       :: -1;
    LEFTX         :: 0;
    LEFTY         :: 1;
    RIGHTX        :: 2;
    RIGHTY        :: 3;
    LEFT_TRIGGER  :: 4;
    RIGHT_TRIGGER :: 5;
    COUNT         :: 6;

    SDL_GAMEPAD_AXIS_INVALID       :: INVALID;
    SDL_GAMEPAD_AXIS_LEFTX         :: LEFTX;
    SDL_GAMEPAD_AXIS_LEFTY         :: LEFTY;
    SDL_GAMEPAD_AXIS_RIGHTX        :: RIGHTX;
    SDL_GAMEPAD_AXIS_RIGHTY        :: RIGHTY;
    SDL_GAMEPAD_AXIS_LEFT_TRIGGER  :: LEFT_TRIGGER;
    SDL_GAMEPAD_AXIS_RIGHT_TRIGGER :: RIGHT_TRIGGER;
    SDL_GAMEPAD_AXIS_COUNT         :: COUNT;
}
SDL_GamepadBindingType :: enum u32 {
    NONE   :: 0;
    BUTTON :: 1;
    AXIS   :: 2;
    HAT    :: 3;

    SDL_GAMEPAD_BINDTYPE_NONE   :: NONE;
    SDL_GAMEPAD_BINDTYPE_BUTTON :: BUTTON;
    SDL_GAMEPAD_BINDTYPE_AXIS   :: AXIS;
    SDL_GAMEPAD_BINDTYPE_HAT    :: HAT;
}
SDL_GamepadBinding :: struct {
    input_type:  SDL_GamepadBindingType;
    input:       union {
        button: s32;
        axis:   struct {
            axis:     s32;
            axis_min: s32;
            axis_max: s32;
        };
        hat:    struct {
            hat:      s32;
            hat_mask: s32;
        };
    };
    output_type: SDL_GamepadBindingType;
    output:      union {
        button: SDL_GamepadButton;
        axis:   struct {
            axis:     SDL_GamepadAxis;
            axis_min: s32;
            axis_max: s32;
        };
    };
}
SDL_AddGamepadMapping :: (mapping: *u8) -> s32 #foreign sdl3;
SDL_AddGamepadMappingsFromIO :: (src: *SDL_IOStream, closeio: bool) -> s32 #foreign sdl3;
SDL_AddGamepadMappingsFromFile :: (file: *u8) -> s32 #foreign sdl3;
SDL_ReloadGamepadMappings :: () -> bool #foreign sdl3;
SDL_GetGamepadMappings :: (count: *s32) -> **u8 #foreign sdl3;
SDL_GetGamepadMappingForGUID :: (guid: SDL_GUID) -> *u8 #foreign sdl3;
SDL_GetGamepadMapping :: (gamepad: *SDL_Gamepad) -> *u8 #foreign sdl3;
SDL_SetGamepadMapping :: (instance_id: SDL_JoystickID, mapping: *u8) -> bool #foreign sdl3;
SDL_HasGamepad :: () -> bool #foreign sdl3;
SDL_GetGamepads :: (count: *s32) -> *SDL_JoystickID #foreign sdl3;
SDL_IsGamepad :: (instance_id: SDL_JoystickID) -> bool #foreign sdl3;
SDL_GetGamepadNameForID :: (instance_id: SDL_JoystickID) -> *u8 #foreign sdl3;
SDL_GetGamepadPathForID :: (instance_id: SDL_JoystickID) -> *u8 #foreign sdl3;
SDL_GetGamepadPlayerIndexForID :: (instance_id: SDL_JoystickID) -> s32 #foreign sdl3;
SDL_GetGamepadGUIDForID :: (instance_id: SDL_JoystickID) -> SDL_GUID #foreign sdl3;
SDL_GetGamepadVendorForID :: (instance_id: SDL_JoystickID) -> Uint16 #foreign sdl3;
SDL_GetGamepadProductForID :: (instance_id: SDL_JoystickID) -> Uint16 #foreign sdl3;
SDL_GetGamepadProductVersionForID :: (instance_id: SDL_JoystickID) -> Uint16 #foreign sdl3;
SDL_GetGamepadTypeForID :: (instance_id: SDL_JoystickID) -> SDL_GamepadType #foreign sdl3;
SDL_GetRealGamepadTypeForID :: (instance_id: SDL_JoystickID) -> SDL_GamepadType #foreign sdl3;
SDL_GetGamepadMappingForID :: (instance_id: SDL_JoystickID) -> *u8 #foreign sdl3;
SDL_OpenGamepad :: (instance_id: SDL_JoystickID) -> *SDL_Gamepad #foreign sdl3;
SDL_GetGamepadFromID :: (instance_id: SDL_JoystickID) -> *SDL_Gamepad #foreign sdl3;
SDL_GetGamepadFromPlayerIndex :: (player_index: s32) -> *SDL_Gamepad #foreign sdl3;
SDL_GetGamepadProperties :: (gamepad: *SDL_Gamepad) -> SDL_PropertiesID #foreign sdl3;
SDL_GetGamepadID :: (gamepad: *SDL_Gamepad) -> SDL_JoystickID #foreign sdl3;
SDL_GetGamepadName :: (gamepad: *SDL_Gamepad) -> *u8 #foreign sdl3;
SDL_GetGamepadPath :: (gamepad: *SDL_Gamepad) -> *u8 #foreign sdl3;
SDL_GetGamepadType :: (gamepad: *SDL_Gamepad) -> SDL_GamepadType #foreign sdl3;
SDL_GetRealGamepadType :: (gamepad: *SDL_Gamepad) -> SDL_GamepadType #foreign sdl3;
SDL_GetGamepadPlayerIndex :: (gamepad: *SDL_Gamepad) -> s32 #foreign sdl3;
SDL_SetGamepadPlayerIndex :: (gamepad: *SDL_Gamepad, player_index: s32) -> bool #foreign sdl3;
SDL_GetGamepadVendor :: (gamepad: *SDL_Gamepad) -> Uint16 #foreign sdl3;
SDL_GetGamepadProduct :: (gamepad: *SDL_Gamepad) -> Uint16 #foreign sdl3;
SDL_GetGamepadProductVersion :: (gamepad: *SDL_Gamepad) -> Uint16 #foreign sdl3;
SDL_GetGamepadFirmwareVersion :: (gamepad: *SDL_Gamepad) -> Uint16 #foreign sdl3;
SDL_GetGamepadSerial :: (gamepad: *SDL_Gamepad) -> *u8 #foreign sdl3;
SDL_GetGamepadSteamHandle :: (gamepad: *SDL_Gamepad) -> Uint64 #foreign sdl3;
SDL_GetGamepadConnectionState :: (gamepad: *SDL_Gamepad) -> SDL_JoystickConnectionState #foreign sdl3;
SDL_GetGamepadPowerInfo :: (gamepad: *SDL_Gamepad, percent: *s32) -> SDL_PowerState #foreign sdl3;
SDL_GamepadConnected :: (gamepad: *SDL_Gamepad) -> bool #foreign sdl3;
SDL_GetGamepadJoystick :: (gamepad: *SDL_Gamepad) -> *SDL_Joystick #foreign sdl3;
SDL_SetGamepadEventsEnabled :: (enabled: bool) -> void #foreign sdl3;
SDL_GamepadEventsEnabled :: () -> bool #foreign sdl3;
SDL_GetGamepadBindings :: (gamepad: *SDL_Gamepad, count: *s32) -> **SDL_GamepadBinding #foreign sdl3;
SDL_UpdateGamepads :: () -> void #foreign sdl3;
SDL_GetGamepadTypeFromString :: (str: *u8) -> SDL_GamepadType #foreign sdl3;
SDL_GetGamepadStringForType :: (type: SDL_GamepadType) -> *u8 #foreign sdl3;
SDL_GetGamepadAxisFromString :: (str: *u8) -> SDL_GamepadAxis #foreign sdl3;
SDL_GetGamepadStringForAxis :: (axis: SDL_GamepadAxis) -> *u8 #foreign sdl3;
SDL_GamepadHasAxis :: (gamepad: *SDL_Gamepad, axis: SDL_GamepadAxis) -> bool #foreign sdl3;
SDL_GetGamepadAxis :: (gamepad: *SDL_Gamepad, axis: SDL_GamepadAxis) -> Sint16 #foreign sdl3;
SDL_GetGamepadButtonFromString :: (str: *u8) -> SDL_GamepadButton #foreign sdl3;
SDL_GetGamepadStringForButton :: (button: SDL_GamepadButton) -> *u8 #foreign sdl3;
SDL_GamepadHasButton :: (gamepad: *SDL_Gamepad, button: SDL_GamepadButton) -> bool #foreign sdl3;
SDL_GetGamepadButton :: (gamepad: *SDL_Gamepad, button: SDL_GamepadButton) -> bool #foreign sdl3;
SDL_GetGamepadButtonLabelForType :: (type: SDL_GamepadType, button: SDL_GamepadButton) -> SDL_GamepadButtonLabel #foreign sdl3;
SDL_GetGamepadButtonLabel :: (gamepad: *SDL_Gamepad, button: SDL_GamepadButton) -> SDL_GamepadButtonLabel #foreign sdl3;
SDL_GetNumGamepadTouchpads :: (gamepad: *SDL_Gamepad) -> s32 #foreign sdl3;
SDL_GetNumGamepadTouchpadFingers :: (gamepad: *SDL_Gamepad, touchpad: s32) -> s32 #foreign sdl3;
SDL_GetGamepadTouchpadFinger :: (gamepad: *SDL_Gamepad, touchpad: s32, finger: s32, down: *bool, x: *float, y: *float, pressure: *float) -> bool #foreign sdl3;
SDL_GamepadHasSensor :: (gamepad: *SDL_Gamepad, type: SDL_SensorType) -> bool #foreign sdl3;
SDL_SetGamepadSensorEnabled :: (gamepad: *SDL_Gamepad, type: SDL_SensorType, enabled: bool) -> bool #foreign sdl3;
SDL_GamepadSensorEnabled :: (gamepad: *SDL_Gamepad, type: SDL_SensorType) -> bool #foreign sdl3;
SDL_GetGamepadSensorDataRate :: (gamepad: *SDL_Gamepad, type: SDL_SensorType) -> float #foreign sdl3;
SDL_GetGamepadSensorData :: (gamepad: *SDL_Gamepad, type: SDL_SensorType, data: *float, num_values: s32) -> bool #foreign sdl3;
SDL_RumbleGamepad :: (gamepad: *SDL_Gamepad, low_frequency_rumble: Uint16, high_frequency_rumble: Uint16, duration_ms: Uint32) -> bool #foreign sdl3;
SDL_RumbleGamepadTriggers :: (gamepad: *SDL_Gamepad, left_rumble: Uint16, right_rumble: Uint16, duration_ms: Uint32) -> bool #foreign sdl3;
SDL_SetGamepadLED :: (gamepad: *SDL_Gamepad, red: Uint8, green: Uint8, blue: Uint8) -> bool #foreign sdl3;
SDL_SendGamepadEffect :: (gamepad: *SDL_Gamepad, data: *void, size: s32) -> bool #foreign sdl3;
SDL_CloseGamepad :: (gamepad: *SDL_Gamepad) -> void #foreign sdl3;
SDL_GetGamepadAppleSFSymbolsNameForButton :: (gamepad: *SDL_Gamepad, button: SDL_GamepadButton) -> *u8 #foreign sdl3;
SDL_GetGamepadAppleSFSymbolsNameForAxis :: (gamepad: *SDL_Gamepad, axis: SDL_GamepadAxis) -> *u8 #foreign sdl3;
SDL_Scancode :: enum u32 {
    UNKNOWN              :: 0;
    A                    :: 4;
    B                    :: 5;
    C                    :: 6;
    D                    :: 7;
    E                    :: 8;
    F                    :: 9;
    G                    :: 10;
    H                    :: 11;
    I                    :: 12;
    J                    :: 13;
    K                    :: 14;
    L                    :: 15;
    M                    :: 16;
    N                    :: 17;
    O                    :: 18;
    P                    :: 19;
    Q                    :: 20;
    R                    :: 21;
    S                    :: 22;
    T                    :: 23;
    U                    :: 24;
    V                    :: 25;
    W                    :: 26;
    X                    :: 27;
    Y                    :: 28;
    Z                    :: 29;
    _1                   :: 30;
    _2                   :: 31;
    _3                   :: 32;
    _4                   :: 33;
    _5                   :: 34;
    _6                   :: 35;
    _7                   :: 36;
    _8                   :: 37;
    _9                   :: 38;
    _0                   :: 39;
    RETURN               :: 40;
    ESCAPE               :: 41;
    BACKSPACE            :: 42;
    TAB                  :: 43;
    SPACE                :: 44;
    MINUS                :: 45;
    EQUALS               :: 46;
    LEFTBRACKET          :: 47;
    RIGHTBRACKET         :: 48;
    BACKSLASH            :: 49;
    NONUSHASH            :: 50;
    SEMICOLON            :: 51;
    APOSTROPHE           :: 52;
    GRAVE                :: 53;
    COMMA                :: 54;
    PERIOD               :: 55;
    SLASH                :: 56;
    CAPSLOCK             :: 57;
    F1                   :: 58;
    F2                   :: 59;
    F3                   :: 60;
    F4                   :: 61;
    F5                   :: 62;
    F6                   :: 63;
    F7                   :: 64;
    F8                   :: 65;
    F9                   :: 66;
    F10                  :: 67;
    F11                  :: 68;
    F12                  :: 69;
    PRINTSCREEN          :: 70;
    SCROLLLOCK           :: 71;
    PAUSE                :: 72;
    INSERT               :: 73;
    HOME                 :: 74;
    PAGEUP               :: 75;
    DELETE               :: 76;
    END                  :: 77;
    PAGEDOWN             :: 78;
    RIGHT                :: 79;
    LEFT                 :: 80;
    DOWN                 :: 81;
    UP                   :: 82;
    NUMLOCKCLEAR         :: 83;
    KP_DIVIDE            :: 84;
    KP_MULTIPLY          :: 85;
    KP_MINUS             :: 86;
    KP_PLUS              :: 87;
    KP_ENTER             :: 88;
    KP_1                 :: 89;
    KP_2                 :: 90;
    KP_3                 :: 91;
    KP_4                 :: 92;
    KP_5                 :: 93;
    KP_6                 :: 94;
    KP_7                 :: 95;
    KP_8                 :: 96;
    KP_9                 :: 97;
    KP_0                 :: 98;
    KP_PERIOD            :: 99;
    NONUSBACKSLASH       :: 100;
    APPLICATION          :: 101;
    POWER                :: 102;
    KP_EQUALS            :: 103;
    F13                  :: 104;
    F14                  :: 105;
    F15                  :: 106;
    F16                  :: 107;
    F17                  :: 108;
    F18                  :: 109;
    F19                  :: 110;
    F20                  :: 111;
    F21                  :: 112;
    F22                  :: 113;
    F23                  :: 114;
    F24                  :: 115;
    EXECUTE              :: 116;
    HELP                 :: 117;
    MENU                 :: 118;
    SELECT               :: 119;
    STOP                 :: 120;
    AGAIN                :: 121;
    UNDO                 :: 122;
    CUT                  :: 123;
    COPY                 :: 124;
    PASTE                :: 125;
    FIND                 :: 126;
    MUTE                 :: 127;
    VOLUMEUP             :: 128;
    VOLUMEDOWN           :: 129;
    KP_COMMA             :: 133;
    KP_EQUALSAS400       :: 134;
    INTERNATIONAL1       :: 135;
    INTERNATIONAL2       :: 136;
    INTERNATIONAL3       :: 137;
    INTERNATIONAL4       :: 138;
    INTERNATIONAL5       :: 139;
    INTERNATIONAL6       :: 140;
    INTERNATIONAL7       :: 141;
    INTERNATIONAL8       :: 142;
    INTERNATIONAL9       :: 143;
    LANG1                :: 144;
    LANG2                :: 145;
    LANG3                :: 146;
    LANG4                :: 147;
    LANG5                :: 148;
    LANG6                :: 149;
    LANG7                :: 150;
    LANG8                :: 151;
    LANG9                :: 152;
    ALTERASE             :: 153;
    SYSREQ               :: 154;
    CANCEL               :: 155;
    CLEAR                :: 156;
    PRIOR                :: 157;
    RETURN2              :: 158;
    SEPARATOR            :: 159;
    OUT                  :: 160;
    OPER                 :: 161;
    CLEARAGAIN           :: 162;
    CRSEL                :: 163;
    EXSEL                :: 164;
    KP_00                :: 176;
    KP_000               :: 177;
    THOUSANDSSEPARATOR   :: 178;
    DECIMALSEPARATOR     :: 179;
    CURRENCYUNIT         :: 180;
    CURRENCYSUBUNIT      :: 181;
    KP_LEFTPAREN         :: 182;
    KP_RIGHTPAREN        :: 183;
    KP_LEFTBRACE         :: 184;
    KP_RIGHTBRACE        :: 185;
    KP_TAB               :: 186;
    KP_BACKSPACE         :: 187;
    KP_A                 :: 188;
    KP_B                 :: 189;
    KP_C                 :: 190;
    KP_D                 :: 191;
    KP_E                 :: 192;
    KP_F                 :: 193;
    KP_XOR               :: 194;
    KP_POWER             :: 195;
    KP_PERCENT           :: 196;
    KP_LESS              :: 197;
    KP_GREATER           :: 198;
    KP_AMPERSAND         :: 199;
    KP_DBLAMPERSAND      :: 200;
    KP_VERTICALBAR       :: 201;
    KP_DBLVERTICALBAR    :: 202;
    KP_COLON             :: 203;
    KP_HASH              :: 204;
    KP_SPACE             :: 205;
    KP_AT                :: 206;
    KP_EXCLAM            :: 207;
    KP_MEMSTORE          :: 208;
    KP_MEMRECALL         :: 209;
    KP_MEMCLEAR          :: 210;
    KP_MEMADD            :: 211;
    KP_MEMSUBTRACT       :: 212;
    KP_MEMMULTIPLY       :: 213;
    KP_MEMDIVIDE         :: 214;
    KP_PLUSMINUS         :: 215;
    KP_CLEAR             :: 216;
    KP_CLEARENTRY        :: 217;
    KP_BINARY            :: 218;
    KP_OCTAL             :: 219;
    KP_DECIMAL           :: 220;
    KP_HEXADECIMAL       :: 221;
    LCTRL                :: 224;
    LSHIFT               :: 225;
    LALT                 :: 226;
    LGUI                 :: 227;
    RCTRL                :: 228;
    RSHIFT               :: 229;
    RALT                 :: 230;
    RGUI                 :: 231;
    MODE                 :: 257;
    SLEEP                :: 258;
    WAKE                 :: 259;
    CHANNEL_INCREMENT    :: 260;
    CHANNEL_DECREMENT    :: 261;
    MEDIA_PLAY           :: 262;
    MEDIA_PAUSE          :: 263;
    MEDIA_RECORD         :: 264;
    MEDIA_FAST_FORWARD   :: 265;
    MEDIA_REWIND         :: 266;
    MEDIA_NEXT_TRACK     :: 267;
    MEDIA_PREVIOUS_TRACK :: 268;
    MEDIA_STOP           :: 269;
    MEDIA_EJECT          :: 270;
    MEDIA_PLAY_PAUSE     :: 271;
    MEDIA_SELECT         :: 272;
    AC_NEW               :: 273;
    AC_OPEN              :: 274;
    AC_CLOSE             :: 275;
    AC_EXIT              :: 276;
    AC_SAVE              :: 277;
    AC_PRINT             :: 278;
    AC_PROPERTIES        :: 279;
    AC_SEARCH            :: 280;
    AC_HOME              :: 281;
    AC_BACK              :: 282;
    AC_FORWARD           :: 283;
    AC_STOP              :: 284;
    AC_REFRESH           :: 285;
    AC_BOOKMARKS         :: 286;
    SOFTLEFT             :: 287;
    SOFTRIGHT            :: 288;
    CALL                 :: 289;
    ENDCALL              :: 290;
    RESERVED             :: 400;
    COUNT                :: 512;

    SDL_SCANCODE_UNKNOWN              :: UNKNOWN;
    SDL_SCANCODE_A                    :: A;
    SDL_SCANCODE_B                    :: B;
    SDL_SCANCODE_C                    :: C;
    SDL_SCANCODE_D                    :: D;
    SDL_SCANCODE_E                    :: E;
    SDL_SCANCODE_F                    :: F;
    SDL_SCANCODE_G                    :: G;
    SDL_SCANCODE_H                    :: H;
    SDL_SCANCODE_I                    :: I;
    SDL_SCANCODE_J                    :: J;
    SDL_SCANCODE_K                    :: K;
    SDL_SCANCODE_L                    :: L;
    SDL_SCANCODE_M                    :: M;
    SDL_SCANCODE_N                    :: N;
    SDL_SCANCODE_O                    :: O;
    SDL_SCANCODE_P                    :: P;
    SDL_SCANCODE_Q                    :: Q;
    SDL_SCANCODE_R                    :: R;
    SDL_SCANCODE_S                    :: S;
    SDL_SCANCODE_T                    :: T;
    SDL_SCANCODE_U                    :: U;
    SDL_SCANCODE_V                    :: V;
    SDL_SCANCODE_W                    :: W;
    SDL_SCANCODE_X                    :: X;
    SDL_SCANCODE_Y                    :: Y;
    SDL_SCANCODE_Z                    :: Z;
    SDL_SCANCODE_1                    :: _1;
    SDL_SCANCODE_2                    :: _2;
    SDL_SCANCODE_3                    :: _3;
    SDL_SCANCODE_4                    :: _4;
    SDL_SCANCODE_5                    :: _5;
    SDL_SCANCODE_6                    :: _6;
    SDL_SCANCODE_7                    :: _7;
    SDL_SCANCODE_8                    :: _8;
    SDL_SCANCODE_9                    :: _9;
    SDL_SCANCODE_0                    :: _0;
    SDL_SCANCODE_RETURN               :: RETURN;
    SDL_SCANCODE_ESCAPE               :: ESCAPE;
    SDL_SCANCODE_BACKSPACE            :: BACKSPACE;
    SDL_SCANCODE_TAB                  :: TAB;
    SDL_SCANCODE_SPACE                :: SPACE;
    SDL_SCANCODE_MINUS                :: MINUS;
    SDL_SCANCODE_EQUALS               :: EQUALS;
    SDL_SCANCODE_LEFTBRACKET          :: LEFTBRACKET;
    SDL_SCANCODE_RIGHTBRACKET         :: RIGHTBRACKET;
    SDL_SCANCODE_BACKSLASH            :: BACKSLASH;
    SDL_SCANCODE_NONUSHASH            :: NONUSHASH;
    SDL_SCANCODE_SEMICOLON            :: SEMICOLON;
    SDL_SCANCODE_APOSTROPHE           :: APOSTROPHE;
    SDL_SCANCODE_GRAVE                :: GRAVE;
    SDL_SCANCODE_COMMA                :: COMMA;
    SDL_SCANCODE_PERIOD               :: PERIOD;
    SDL_SCANCODE_SLASH                :: SLASH;
    SDL_SCANCODE_CAPSLOCK             :: CAPSLOCK;
    SDL_SCANCODE_F1                   :: F1;
    SDL_SCANCODE_F2                   :: F2;
    SDL_SCANCODE_F3                   :: F3;
    SDL_SCANCODE_F4                   :: F4;
    SDL_SCANCODE_F5                   :: F5;
    SDL_SCANCODE_F6                   :: F6;
    SDL_SCANCODE_F7                   :: F7;
    SDL_SCANCODE_F8                   :: F8;
    SDL_SCANCODE_F9                   :: F9;
    SDL_SCANCODE_F10                  :: F10;
    SDL_SCANCODE_F11                  :: F11;
    SDL_SCANCODE_F12                  :: F12;
    SDL_SCANCODE_PRINTSCREEN          :: PRINTSCREEN;
    SDL_SCANCODE_SCROLLLOCK           :: SCROLLLOCK;
    SDL_SCANCODE_PAUSE                :: PAUSE;
    SDL_SCANCODE_INSERT               :: INSERT;
    SDL_SCANCODE_HOME                 :: HOME;
    SDL_SCANCODE_PAGEUP               :: PAGEUP;
    SDL_SCANCODE_DELETE               :: DELETE;
    SDL_SCANCODE_END                  :: END;
    SDL_SCANCODE_PAGEDOWN             :: PAGEDOWN;
    SDL_SCANCODE_RIGHT                :: RIGHT;
    SDL_SCANCODE_LEFT                 :: LEFT;
    SDL_SCANCODE_DOWN                 :: DOWN;
    SDL_SCANCODE_UP                   :: UP;
    SDL_SCANCODE_NUMLOCKCLEAR         :: NUMLOCKCLEAR;
    SDL_SCANCODE_KP_DIVIDE            :: KP_DIVIDE;
    SDL_SCANCODE_KP_MULTIPLY          :: KP_MULTIPLY;
    SDL_SCANCODE_KP_MINUS             :: KP_MINUS;
    SDL_SCANCODE_KP_PLUS              :: KP_PLUS;
    SDL_SCANCODE_KP_ENTER             :: KP_ENTER;
    SDL_SCANCODE_KP_1                 :: KP_1;
    SDL_SCANCODE_KP_2                 :: KP_2;
    SDL_SCANCODE_KP_3                 :: KP_3;
    SDL_SCANCODE_KP_4                 :: KP_4;
    SDL_SCANCODE_KP_5                 :: KP_5;
    SDL_SCANCODE_KP_6                 :: KP_6;
    SDL_SCANCODE_KP_7                 :: KP_7;
    SDL_SCANCODE_KP_8                 :: KP_8;
    SDL_SCANCODE_KP_9                 :: KP_9;
    SDL_SCANCODE_KP_0                 :: KP_0;
    SDL_SCANCODE_KP_PERIOD            :: KP_PERIOD;
    SDL_SCANCODE_NONUSBACKSLASH       :: NONUSBACKSLASH;
    SDL_SCANCODE_APPLICATION          :: APPLICATION;
    SDL_SCANCODE_POWER                :: POWER;
    SDL_SCANCODE_KP_EQUALS            :: KP_EQUALS;
    SDL_SCANCODE_F13                  :: F13;
    SDL_SCANCODE_F14                  :: F14;
    SDL_SCANCODE_F15                  :: F15;
    SDL_SCANCODE_F16                  :: F16;
    SDL_SCANCODE_F17                  :: F17;
    SDL_SCANCODE_F18                  :: F18;
    SDL_SCANCODE_F19                  :: F19;
    SDL_SCANCODE_F20                  :: F20;
    SDL_SCANCODE_F21                  :: F21;
    SDL_SCANCODE_F22                  :: F22;
    SDL_SCANCODE_F23                  :: F23;
    SDL_SCANCODE_F24                  :: F24;
    SDL_SCANCODE_EXECUTE              :: EXECUTE;
    SDL_SCANCODE_HELP                 :: HELP;
    SDL_SCANCODE_MENU                 :: MENU;
    SDL_SCANCODE_SELECT               :: SELECT;
    SDL_SCANCODE_STOP                 :: STOP;
    SDL_SCANCODE_AGAIN                :: AGAIN;
    SDL_SCANCODE_UNDO                 :: UNDO;
    SDL_SCANCODE_CUT                  :: CUT;
    SDL_SCANCODE_COPY                 :: COPY;
    SDL_SCANCODE_PASTE                :: PASTE;
    SDL_SCANCODE_FIND                 :: FIND;
    SDL_SCANCODE_MUTE                 :: MUTE;
    SDL_SCANCODE_VOLUMEUP             :: VOLUMEUP;
    SDL_SCANCODE_VOLUMEDOWN           :: VOLUMEDOWN;
    SDL_SCANCODE_KP_COMMA             :: KP_COMMA;
    SDL_SCANCODE_KP_EQUALSAS400       :: KP_EQUALSAS400;
    SDL_SCANCODE_INTERNATIONAL1       :: INTERNATIONAL1;
    SDL_SCANCODE_INTERNATIONAL2       :: INTERNATIONAL2;
    SDL_SCANCODE_INTERNATIONAL3       :: INTERNATIONAL3;
    SDL_SCANCODE_INTERNATIONAL4       :: INTERNATIONAL4;
    SDL_SCANCODE_INTERNATIONAL5       :: INTERNATIONAL5;
    SDL_SCANCODE_INTERNATIONAL6       :: INTERNATIONAL6;
    SDL_SCANCODE_INTERNATIONAL7       :: INTERNATIONAL7;
    SDL_SCANCODE_INTERNATIONAL8       :: INTERNATIONAL8;
    SDL_SCANCODE_INTERNATIONAL9       :: INTERNATIONAL9;
    SDL_SCANCODE_LANG1                :: LANG1;
    SDL_SCANCODE_LANG2                :: LANG2;
    SDL_SCANCODE_LANG3                :: LANG3;
    SDL_SCANCODE_LANG4                :: LANG4;
    SDL_SCANCODE_LANG5                :: LANG5;
    SDL_SCANCODE_LANG6                :: LANG6;
    SDL_SCANCODE_LANG7                :: LANG7;
    SDL_SCANCODE_LANG8                :: LANG8;
    SDL_SCANCODE_LANG9                :: LANG9;
    SDL_SCANCODE_ALTERASE             :: ALTERASE;
    SDL_SCANCODE_SYSREQ               :: SYSREQ;
    SDL_SCANCODE_CANCEL               :: CANCEL;
    SDL_SCANCODE_CLEAR                :: CLEAR;
    SDL_SCANCODE_PRIOR                :: PRIOR;
    SDL_SCANCODE_RETURN2              :: RETURN2;
    SDL_SCANCODE_SEPARATOR            :: SEPARATOR;
    SDL_SCANCODE_OUT                  :: OUT;
    SDL_SCANCODE_OPER                 :: OPER;
    SDL_SCANCODE_CLEARAGAIN           :: CLEARAGAIN;
    SDL_SCANCODE_CRSEL                :: CRSEL;
    SDL_SCANCODE_EXSEL                :: EXSEL;
    SDL_SCANCODE_KP_00                :: KP_00;
    SDL_SCANCODE_KP_000               :: KP_000;
    SDL_SCANCODE_THOUSANDSSEPARATOR   :: THOUSANDSSEPARATOR;
    SDL_SCANCODE_DECIMALSEPARATOR     :: DECIMALSEPARATOR;
    SDL_SCANCODE_CURRENCYUNIT         :: CURRENCYUNIT;
    SDL_SCANCODE_CURRENCYSUBUNIT      :: CURRENCYSUBUNIT;
    SDL_SCANCODE_KP_LEFTPAREN         :: KP_LEFTPAREN;
    SDL_SCANCODE_KP_RIGHTPAREN        :: KP_RIGHTPAREN;
    SDL_SCANCODE_KP_LEFTBRACE         :: KP_LEFTBRACE;
    SDL_SCANCODE_KP_RIGHTBRACE        :: KP_RIGHTBRACE;
    SDL_SCANCODE_KP_TAB               :: KP_TAB;
    SDL_SCANCODE_KP_BACKSPACE         :: KP_BACKSPACE;
    SDL_SCANCODE_KP_A                 :: KP_A;
    SDL_SCANCODE_KP_B                 :: KP_B;
    SDL_SCANCODE_KP_C                 :: KP_C;
    SDL_SCANCODE_KP_D                 :: KP_D;
    SDL_SCANCODE_KP_E                 :: KP_E;
    SDL_SCANCODE_KP_F                 :: KP_F;
    SDL_SCANCODE_KP_XOR               :: KP_XOR;
    SDL_SCANCODE_KP_POWER             :: KP_POWER;
    SDL_SCANCODE_KP_PERCENT           :: KP_PERCENT;
    SDL_SCANCODE_KP_LESS              :: KP_LESS;
    SDL_SCANCODE_KP_GREATER           :: KP_GREATER;
    SDL_SCANCODE_KP_AMPERSAND         :: KP_AMPERSAND;
    SDL_SCANCODE_KP_DBLAMPERSAND      :: KP_DBLAMPERSAND;
    SDL_SCANCODE_KP_VERTICALBAR       :: KP_VERTICALBAR;
    SDL_SCANCODE_KP_DBLVERTICALBAR    :: KP_DBLVERTICALBAR;
    SDL_SCANCODE_KP_COLON             :: KP_COLON;
    SDL_SCANCODE_KP_HASH              :: KP_HASH;
    SDL_SCANCODE_KP_SPACE             :: KP_SPACE;
    SDL_SCANCODE_KP_AT                :: KP_AT;
    SDL_SCANCODE_KP_EXCLAM            :: KP_EXCLAM;
    SDL_SCANCODE_KP_MEMSTORE          :: KP_MEMSTORE;
    SDL_SCANCODE_KP_MEMRECALL         :: KP_MEMRECALL;
    SDL_SCANCODE_KP_MEMCLEAR          :: KP_MEMCLEAR;
    SDL_SCANCODE_KP_MEMADD            :: KP_MEMADD;
    SDL_SCANCODE_KP_MEMSUBTRACT       :: KP_MEMSUBTRACT;
    SDL_SCANCODE_KP_MEMMULTIPLY       :: KP_MEMMULTIPLY;
    SDL_SCANCODE_KP_MEMDIVIDE         :: KP_MEMDIVIDE;
    SDL_SCANCODE_KP_PLUSMINUS         :: KP_PLUSMINUS;
    SDL_SCANCODE_KP_CLEAR             :: KP_CLEAR;
    SDL_SCANCODE_KP_CLEARENTRY        :: KP_CLEARENTRY;
    SDL_SCANCODE_KP_BINARY            :: KP_BINARY;
    SDL_SCANCODE_KP_OCTAL             :: KP_OCTAL;
    SDL_SCANCODE_KP_DECIMAL           :: KP_DECIMAL;
    SDL_SCANCODE_KP_HEXADECIMAL       :: KP_HEXADECIMAL;
    SDL_SCANCODE_LCTRL                :: LCTRL;
    SDL_SCANCODE_LSHIFT               :: LSHIFT;
    SDL_SCANCODE_LALT                 :: LALT;
    SDL_SCANCODE_LGUI                 :: LGUI;
    SDL_SCANCODE_RCTRL                :: RCTRL;
    SDL_SCANCODE_RSHIFT               :: RSHIFT;
    SDL_SCANCODE_RALT                 :: RALT;
    SDL_SCANCODE_RGUI                 :: RGUI;
    SDL_SCANCODE_MODE                 :: MODE;
    SDL_SCANCODE_SLEEP                :: SLEEP;
    SDL_SCANCODE_WAKE                 :: WAKE;
    SDL_SCANCODE_CHANNEL_INCREMENT    :: CHANNEL_INCREMENT;
    SDL_SCANCODE_CHANNEL_DECREMENT    :: CHANNEL_DECREMENT;
    SDL_SCANCODE_MEDIA_PLAY           :: MEDIA_PLAY;
    SDL_SCANCODE_MEDIA_PAUSE          :: MEDIA_PAUSE;
    SDL_SCANCODE_MEDIA_RECORD         :: MEDIA_RECORD;
    SDL_SCANCODE_MEDIA_FAST_FORWARD   :: MEDIA_FAST_FORWARD;
    SDL_SCANCODE_MEDIA_REWIND         :: MEDIA_REWIND;
    SDL_SCANCODE_MEDIA_NEXT_TRACK     :: MEDIA_NEXT_TRACK;
    SDL_SCANCODE_MEDIA_PREVIOUS_TRACK :: MEDIA_PREVIOUS_TRACK;
    SDL_SCANCODE_MEDIA_STOP           :: MEDIA_STOP;
    SDL_SCANCODE_MEDIA_EJECT          :: MEDIA_EJECT;
    SDL_SCANCODE_MEDIA_PLAY_PAUSE     :: MEDIA_PLAY_PAUSE;
    SDL_SCANCODE_MEDIA_SELECT         :: MEDIA_SELECT;
    SDL_SCANCODE_AC_NEW               :: AC_NEW;
    SDL_SCANCODE_AC_OPEN              :: AC_OPEN;
    SDL_SCANCODE_AC_CLOSE             :: AC_CLOSE;
    SDL_SCANCODE_AC_EXIT              :: AC_EXIT;
    SDL_SCANCODE_AC_SAVE              :: AC_SAVE;
    SDL_SCANCODE_AC_PRINT             :: AC_PRINT;
    SDL_SCANCODE_AC_PROPERTIES        :: AC_PROPERTIES;
    SDL_SCANCODE_AC_SEARCH            :: AC_SEARCH;
    SDL_SCANCODE_AC_HOME              :: AC_HOME;
    SDL_SCANCODE_AC_BACK              :: AC_BACK;
    SDL_SCANCODE_AC_FORWARD           :: AC_FORWARD;
    SDL_SCANCODE_AC_STOP              :: AC_STOP;
    SDL_SCANCODE_AC_REFRESH           :: AC_REFRESH;
    SDL_SCANCODE_AC_BOOKMARKS         :: AC_BOOKMARKS;
    SDL_SCANCODE_SOFTLEFT             :: SOFTLEFT;
    SDL_SCANCODE_SOFTRIGHT            :: SOFTRIGHT;
    SDL_SCANCODE_CALL                 :: CALL;
    SDL_SCANCODE_ENDCALL              :: ENDCALL;
    SDL_SCANCODE_RESERVED             :: RESERVED;
    SDL_SCANCODE_COUNT                :: COUNT;
}
SDL_Keycode :: Uint32;
SDL_Keymod :: Uint16;
SDL_KeyboardID :: Uint32;
SDL_HasKeyboard :: () -> bool #foreign sdl3;
SDL_GetKeyboards :: (count: *s32) -> *SDL_KeyboardID #foreign sdl3;
SDL_GetKeyboardNameForID :: (instance_id: SDL_KeyboardID) -> *u8 #foreign sdl3;
SDL_GetKeyboardFocus :: () -> *SDL_Window #foreign sdl3;
SDL_GetKeyboardState :: (numkeys: *s32) -> *bool #foreign sdl3;
SDL_ResetKeyboard :: () -> void #foreign sdl3;
SDL_GetModState :: () -> SDL_Keymod #foreign sdl3;
SDL_SetModState :: (modstate: SDL_Keymod) -> void #foreign sdl3;
SDL_GetKeyFromScancode :: (scancode: SDL_Scancode, modstate: SDL_Keymod, key_event: bool) -> SDL_Keycode #foreign sdl3;
SDL_GetScancodeFromKey :: (key: SDL_Keycode, modstate: *SDL_Keymod) -> SDL_Scancode #foreign sdl3;
SDL_SetScancodeName :: (scancode: SDL_Scancode, name: *u8) -> bool #foreign sdl3;
SDL_GetScancodeName :: (scancode: SDL_Scancode) -> *u8 #foreign sdl3;
SDL_GetScancodeFromName :: (name: *u8) -> SDL_Scancode #foreign sdl3;
SDL_GetKeyName :: (key: SDL_Keycode) -> *u8 #foreign sdl3;
SDL_GetKeyFromName :: (name: *u8) -> SDL_Keycode #foreign sdl3;
SDL_StartTextInput :: (window: *SDL_Window) -> bool #foreign sdl3;
SDL_TextInputType :: enum u32 {
    TEXT                    :: 0;
    TEXT_NAME               :: 1;
    TEXT_EMAIL              :: 2;
    TEXT_USERNAME           :: 3;
    TEXT_PASSWORD_HIDDEN    :: 4;
    TEXT_PASSWORD_VISIBLE   :: 5;
    NUMBER                  :: 6;
    NUMBER_PASSWORD_HIDDEN  :: 7;
    NUMBER_PASSWORD_VISIBLE :: 8;

    SDL_TEXTINPUT_TYPE_TEXT                    :: TEXT;
    SDL_TEXTINPUT_TYPE_TEXT_NAME               :: TEXT_NAME;
    SDL_TEXTINPUT_TYPE_TEXT_EMAIL              :: TEXT_EMAIL;
    SDL_TEXTINPUT_TYPE_TEXT_USERNAME           :: TEXT_USERNAME;
    SDL_TEXTINPUT_TYPE_TEXT_PASSWORD_HIDDEN    :: TEXT_PASSWORD_HIDDEN;
    SDL_TEXTINPUT_TYPE_TEXT_PASSWORD_VISIBLE   :: TEXT_PASSWORD_VISIBLE;
    SDL_TEXTINPUT_TYPE_NUMBER                  :: NUMBER;
    SDL_TEXTINPUT_TYPE_NUMBER_PASSWORD_HIDDEN  :: NUMBER_PASSWORD_HIDDEN;
    SDL_TEXTINPUT_TYPE_NUMBER_PASSWORD_VISIBLE :: NUMBER_PASSWORD_VISIBLE;
}
SDL_Capitalization :: enum u32 {
    NONE      :: 0;
    SENTENCES :: 1;
    WORDS     :: 2;
    LETTERS   :: 3;

    SDL_CAPITALIZE_NONE      :: NONE;
    SDL_CAPITALIZE_SENTENCES :: SENTENCES;
    SDL_CAPITALIZE_WORDS     :: WORDS;
    SDL_CAPITALIZE_LETTERS   :: LETTERS;
}
SDL_StartTextInputWithProperties :: (window: *SDL_Window, props: SDL_PropertiesID) -> bool #foreign sdl3;
SDL_TextInputActive :: (window: *SDL_Window) -> bool #foreign sdl3;
SDL_StopTextInput :: (window: *SDL_Window) -> bool #foreign sdl3;
SDL_ClearComposition :: (window: *SDL_Window) -> bool #foreign sdl3;
SDL_SetTextInputArea :: (window: *SDL_Window, rect: *SDL_Rect, cursor: s32) -> bool #foreign sdl3;
SDL_GetTextInputArea :: (window: *SDL_Window, rect: *SDL_Rect, cursor: *s32) -> bool #foreign sdl3;
SDL_HasScreenKeyboardSupport :: () -> bool #foreign sdl3;
SDL_ScreenKeyboardShown :: (window: *SDL_Window) -> bool #foreign sdl3;
SDL_MouseID :: Uint32;
SDL_Cursor :: struct {}
SDL_SystemCursor :: enum u32 {
    DEFAULT     :: 0;
    TEXT        :: 1;
    WAIT        :: 2;
    CROSSHAIR   :: 3;
    PROGRESS    :: 4;
    NWSE_RESIZE :: 5;
    NESW_RESIZE :: 6;
    EW_RESIZE   :: 7;
    NS_RESIZE   :: 8;
    MOVE        :: 9;
    NOT_ALLOWED :: 10;
    POINTER     :: 11;
    NW_RESIZE   :: 12;
    N_RESIZE    :: 13;
    NE_RESIZE   :: 14;
    E_RESIZE    :: 15;
    SE_RESIZE   :: 16;
    S_RESIZE    :: 17;
    SW_RESIZE   :: 18;
    W_RESIZE    :: 19;
    COUNT       :: 20;

    SDL_SYSTEM_CURSOR_DEFAULT     :: DEFAULT;
    SDL_SYSTEM_CURSOR_TEXT        :: TEXT;
    SDL_SYSTEM_CURSOR_WAIT        :: WAIT;
    SDL_SYSTEM_CURSOR_CROSSHAIR   :: CROSSHAIR;
    SDL_SYSTEM_CURSOR_PROGRESS    :: PROGRESS;
    SDL_SYSTEM_CURSOR_NWSE_RESIZE :: NWSE_RESIZE;
    SDL_SYSTEM_CURSOR_NESW_RESIZE :: NESW_RESIZE;
    SDL_SYSTEM_CURSOR_EW_RESIZE   :: EW_RESIZE;
    SDL_SYSTEM_CURSOR_NS_RESIZE   :: NS_RESIZE;
    SDL_SYSTEM_CURSOR_MOVE        :: MOVE;
    SDL_SYSTEM_CURSOR_NOT_ALLOWED :: NOT_ALLOWED;
    SDL_SYSTEM_CURSOR_POINTER     :: POINTER;
    SDL_SYSTEM_CURSOR_NW_RESIZE   :: NW_RESIZE;
    SDL_SYSTEM_CURSOR_N_RESIZE    :: N_RESIZE;
    SDL_SYSTEM_CURSOR_NE_RESIZE   :: NE_RESIZE;
    SDL_SYSTEM_CURSOR_E_RESIZE    :: E_RESIZE;
    SDL_SYSTEM_CURSOR_SE_RESIZE   :: SE_RESIZE;
    SDL_SYSTEM_CURSOR_S_RESIZE    :: S_RESIZE;
    SDL_SYSTEM_CURSOR_SW_RESIZE   :: SW_RESIZE;
    SDL_SYSTEM_CURSOR_W_RESIZE    :: W_RESIZE;
    SDL_SYSTEM_CURSOR_COUNT       :: COUNT;
}
SDL_MouseWheelDirection :: enum u32 {
    NORMAL  :: 0;
    FLIPPED :: 1;

    SDL_MOUSEWHEEL_NORMAL  :: NORMAL;
    SDL_MOUSEWHEEL_FLIPPED :: FLIPPED;
}
SDL_MouseButtonFlags :: Uint32;
SDL_HasMouse :: () -> bool #foreign sdl3;
SDL_GetMice :: (count: *s32) -> *SDL_MouseID #foreign sdl3;
SDL_GetMouseNameForID :: (instance_id: SDL_MouseID) -> *u8 #foreign sdl3;
SDL_GetMouseFocus :: () -> *SDL_Window #foreign sdl3;
SDL_GetMouseState :: (x: *float, y: *float) -> SDL_MouseButtonFlags #foreign sdl3;
SDL_GetGlobalMouseState :: (x: *float, y: *float) -> SDL_MouseButtonFlags #foreign sdl3;
SDL_GetRelativeMouseState :: (x: *float, y: *float) -> SDL_MouseButtonFlags #foreign sdl3;
SDL_WarpMouseInWindow :: (window: *SDL_Window, x: float, y: float) -> void #foreign sdl3;
SDL_WarpMouseGlobal :: (x: float, y: float) -> bool #foreign sdl3;
SDL_SetWindowRelativeMouseMode :: (window: *SDL_Window, enabled: bool) -> bool #foreign sdl3;
SDL_GetWindowRelativeMouseMode :: (window: *SDL_Window) -> bool #foreign sdl3;
SDL_CaptureMouse :: (enabled: bool) -> bool #foreign sdl3;
SDL_CreateCursor :: (data: *Uint8, mask: *Uint8, w: s32, h: s32, hot_x: s32, hot_y: s32) -> *SDL_Cursor #foreign sdl3;
SDL_CreateColorCursor :: (surface: *SDL_Surface, hot_x: s32, hot_y: s32) -> *SDL_Cursor #foreign sdl3;
SDL_CreateSystemCursor :: (id: SDL_SystemCursor) -> *SDL_Cursor #foreign sdl3;
SDL_SetCursor :: (cursor: *SDL_Cursor) -> bool #foreign sdl3;
SDL_GetCursor :: () -> *SDL_Cursor #foreign sdl3;
SDL_GetDefaultCursor :: () -> *SDL_Cursor #foreign sdl3;
SDL_DestroyCursor :: (cursor: *SDL_Cursor) -> void #foreign sdl3;
SDL_ShowCursor :: () -> bool #foreign sdl3;
SDL_HideCursor :: () -> bool #foreign sdl3;
SDL_CursorVisible :: () -> bool #foreign sdl3;
SDL_PenID :: Uint32;
SDL_PenInputFlags :: Uint32;
SDL_PenAxis :: enum u32 {
    PRESSURE            :: 0;
    XTILT               :: 1;
    YTILT               :: 2;
    DISTANCE            :: 3;
    ROTATION            :: 4;
    SLIDER              :: 5;
    TANGENTIAL_PRESSURE :: 6;
    COUNT               :: 7;

    SDL_PEN_AXIS_PRESSURE            :: PRESSURE;
    SDL_PEN_AXIS_XTILT               :: XTILT;
    SDL_PEN_AXIS_YTILT               :: YTILT;
    SDL_PEN_AXIS_DISTANCE            :: DISTANCE;
    SDL_PEN_AXIS_ROTATION            :: ROTATION;
    SDL_PEN_AXIS_SLIDER              :: SLIDER;
    SDL_PEN_AXIS_TANGENTIAL_PRESSURE :: TANGENTIAL_PRESSURE;
    SDL_PEN_AXIS_COUNT               :: COUNT;
}
SDL_TouchID :: Uint64;
SDL_FingerID :: Uint64;
SDL_TouchDeviceType :: enum s32 {
    INVALID           :: -1;
    DIRECT            :: 0;
    INDIRECT_ABSOLUTE :: 1;
    INDIRECT_RELATIVE :: 2;

    SDL_TOUCH_DEVICE_INVALID           :: INVALID;
    SDL_TOUCH_DEVICE_DIRECT            :: DIRECT;
    SDL_TOUCH_DEVICE_INDIRECT_ABSOLUTE :: INDIRECT_ABSOLUTE;
    SDL_TOUCH_DEVICE_INDIRECT_RELATIVE :: INDIRECT_RELATIVE;
}
SDL_Finger :: struct {
    id:       SDL_FingerID;
    x:        float;
    y:        float;
    pressure: float;
}
SDL_GetTouchDevices :: (count: *s32) -> *SDL_TouchID #foreign sdl3;
SDL_GetTouchDeviceName :: (touchID: SDL_TouchID) -> *u8 #foreign sdl3;
SDL_GetTouchDeviceType :: (touchID: SDL_TouchID) -> SDL_TouchDeviceType #foreign sdl3;
SDL_GetTouchFingers :: (touchID: SDL_TouchID, count: *s32) -> **SDL_Finger #foreign sdl3;
SDL_EventType :: enum u32 {
    FIRST                         :: 0;
    QUIT                          :: 256;
    TERMINATING                   :: 257;
    LOW_MEMORY                    :: 258;
    WILL_ENTER_BACKGROUND         :: 259;
    DID_ENTER_BACKGROUND          :: 260;
    WILL_ENTER_FOREGROUND         :: 261;
    DID_ENTER_FOREGROUND          :: 262;
    LOCALE_CHANGED                :: 263;
    SYSTEM_THEME_CHANGED          :: 264;
    DISPLAY_ORIENTATION           :: 337;
    DISPLAY_ADDED                 :: 338;
    DISPLAY_REMOVED               :: 339;
    DISPLAY_MOVED                 :: 340;
    DISPLAY_DESKTOP_MODE_CHANGED  :: 341;
    DISPLAY_CURRENT_MODE_CHANGED  :: 342;
    DISPLAY_CONTENT_SCALE_CHANGED :: 343;
    DISPLAY_FIRST                 :: 337;
    DISPLAY_LAST                  :: 343;
    WINDOW_SHOWN                  :: 514;
    WINDOW_HIDDEN                 :: 515;
    WINDOW_EXPOSED                :: 516;
    WINDOW_MOVED                  :: 517;
    WINDOW_RESIZED                :: 518;
    WINDOW_PIXEL_SIZE_CHANGED     :: 519;
    WINDOW_METAL_VIEW_RESIZED     :: 520;
    WINDOW_MINIMIZED              :: 521;
    WINDOW_MAXIMIZED              :: 522;
    WINDOW_RESTORED               :: 523;
    WINDOW_MOUSE_ENTER            :: 524;
    WINDOW_MOUSE_LEAVE            :: 525;
    WINDOW_FOCUS_GAINED           :: 526;
    WINDOW_FOCUS_LOST             :: 527;
    WINDOW_CLOSE_REQUESTED        :: 528;
    WINDOW_HIT_TEST               :: 529;
    WINDOW_ICCPROF_CHANGED        :: 530;
    WINDOW_DISPLAY_CHANGED        :: 531;
    WINDOW_DISPLAY_SCALE_CHANGED  :: 532;
    WINDOW_SAFE_AREA_CHANGED      :: 533;
    WINDOW_OCCLUDED               :: 534;
    WINDOW_ENTER_FULLSCREEN       :: 535;
    WINDOW_LEAVE_FULLSCREEN       :: 536;
    WINDOW_DESTROYED              :: 537;
    WINDOW_HDR_STATE_CHANGED      :: 538;
    WINDOW_FIRST                  :: 514;
    WINDOW_LAST                   :: 538;
    KEY_DOWN                      :: 768;
    KEY_UP                        :: 769;
    TEXT_EDITING                  :: 770;
    TEXT_INPUT                    :: 771;
    KEYMAP_CHANGED                :: 772;
    KEYBOARD_ADDED                :: 773;
    KEYBOARD_REMOVED              :: 774;
    TEXT_EDITING_CANDIDATES       :: 775;
    MOUSE_MOTION                  :: 1024;
    MOUSE_BUTTON_DOWN             :: 1025;
    MOUSE_BUTTON_UP               :: 1026;
    MOUSE_WHEEL                   :: 1027;
    MOUSE_ADDED                   :: 1028;
    MOUSE_REMOVED                 :: 1029;
    JOYSTICK_AXIS_MOTION          :: 1536;
    JOYSTICK_BALL_MOTION          :: 1537;
    JOYSTICK_HAT_MOTION           :: 1538;
    JOYSTICK_BUTTON_DOWN          :: 1539;
    JOYSTICK_BUTTON_UP            :: 1540;
    JOYSTICK_ADDED                :: 1541;
    JOYSTICK_REMOVED              :: 1542;
    JOYSTICK_BATTERY_UPDATED      :: 1543;
    JOYSTICK_UPDATE_COMPLETE      :: 1544;
    GAMEPAD_AXIS_MOTION           :: 1616;
    GAMEPAD_BUTTON_DOWN           :: 1617;
    GAMEPAD_BUTTON_UP             :: 1618;
    GAMEPAD_ADDED                 :: 1619;
    GAMEPAD_REMOVED               :: 1620;
    GAMEPAD_REMAPPED              :: 1621;
    GAMEPAD_TOUCHPAD_DOWN         :: 1622;
    GAMEPAD_TOUCHPAD_MOTION       :: 1623;
    GAMEPAD_TOUCHPAD_UP           :: 1624;
    GAMEPAD_SENSOR_UPDATE         :: 1625;
    GAMEPAD_UPDATE_COMPLETE       :: 1626;
    GAMEPAD_STEAM_HANDLE_UPDATED  :: 1627;
    FINGER_DOWN                   :: 1792;
    FINGER_UP                     :: 1793;
    FINGER_MOTION                 :: 1794;
    CLIPBOARD_UPDATE              :: 2304;
    DROP_FILE                     :: 4096;
    DROP_TEXT                     :: 4097;
    DROP_BEGIN                    :: 4098;
    DROP_COMPLETE                 :: 4099;
    DROP_POSITION                 :: 4100;
    AUDIO_DEVICE_ADDED            :: 4352;
    AUDIO_DEVICE_REMOVED          :: 4353;
    AUDIO_DEVICE_FORMAT_CHANGED   :: 4354;
    SENSOR_UPDATE                 :: 4608;
    PEN_PROXIMITY_IN              :: 4864;
    PEN_PROXIMITY_OUT             :: 4865;
    PEN_DOWN                      :: 4866;
    PEN_UP                        :: 4867;
    PEN_BUTTON_DOWN               :: 4868;
    PEN_BUTTON_UP                 :: 4869;
    PEN_MOTION                    :: 4870;
    PEN_AXIS                      :: 4871;
    CAMERA_DEVICE_ADDED           :: 5120;
    CAMERA_DEVICE_REMOVED         :: 5121;
    CAMERA_DEVICE_APPROVED        :: 5122;
    CAMERA_DEVICE_DENIED          :: 5123;
    RENDER_TARGETS_RESET          :: 8192;
    RENDER_DEVICE_RESET           :: 8193;
    RENDER_DEVICE_LOST            :: 8194;
    PRIVATE0                      :: 16384;
    PRIVATE1                      :: 16385;
    PRIVATE2                      :: 16386;
    PRIVATE3                      :: 16387;
    POLL_SENTINEL                 :: 32512;
    USER                          :: 32768;
    LAST                          :: 65535;
    ENUM_PADDING                  :: 2147483647;

    SDL_EVENT_FIRST                         :: FIRST;
    SDL_EVENT_QUIT                          :: QUIT;
    SDL_EVENT_TERMINATING                   :: TERMINATING;
    SDL_EVENT_LOW_MEMORY                    :: LOW_MEMORY;
    SDL_EVENT_WILL_ENTER_BACKGROUND         :: WILL_ENTER_BACKGROUND;
    SDL_EVENT_DID_ENTER_BACKGROUND          :: DID_ENTER_BACKGROUND;
    SDL_EVENT_WILL_ENTER_FOREGROUND         :: WILL_ENTER_FOREGROUND;
    SDL_EVENT_DID_ENTER_FOREGROUND          :: DID_ENTER_FOREGROUND;
    SDL_EVENT_LOCALE_CHANGED                :: LOCALE_CHANGED;
    SDL_EVENT_SYSTEM_THEME_CHANGED          :: SYSTEM_THEME_CHANGED;
    SDL_EVENT_DISPLAY_ORIENTATION           :: DISPLAY_ORIENTATION;
    SDL_EVENT_DISPLAY_ADDED                 :: DISPLAY_ADDED;
    SDL_EVENT_DISPLAY_REMOVED               :: DISPLAY_REMOVED;
    SDL_EVENT_DISPLAY_MOVED                 :: DISPLAY_MOVED;
    SDL_EVENT_DISPLAY_DESKTOP_MODE_CHANGED  :: DISPLAY_DESKTOP_MODE_CHANGED;
    SDL_EVENT_DISPLAY_CURRENT_MODE_CHANGED  :: DISPLAY_CURRENT_MODE_CHANGED;
    SDL_EVENT_DISPLAY_CONTENT_SCALE_CHANGED :: DISPLAY_CONTENT_SCALE_CHANGED;
    SDL_EVENT_DISPLAY_FIRST                 :: DISPLAY_FIRST;
    SDL_EVENT_DISPLAY_LAST                  :: DISPLAY_LAST;
    SDL_EVENT_WINDOW_SHOWN                  :: WINDOW_SHOWN;
    SDL_EVENT_WINDOW_HIDDEN                 :: WINDOW_HIDDEN;
    SDL_EVENT_WINDOW_EXPOSED                :: WINDOW_EXPOSED;
    SDL_EVENT_WINDOW_MOVED                  :: WINDOW_MOVED;
    SDL_EVENT_WINDOW_RESIZED                :: WINDOW_RESIZED;
    SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED     :: WINDOW_PIXEL_SIZE_CHANGED;
    SDL_EVENT_WINDOW_METAL_VIEW_RESIZED     :: WINDOW_METAL_VIEW_RESIZED;
    SDL_EVENT_WINDOW_MINIMIZED              :: WINDOW_MINIMIZED;
    SDL_EVENT_WINDOW_MAXIMIZED              :: WINDOW_MAXIMIZED;
    SDL_EVENT_WINDOW_RESTORED               :: WINDOW_RESTORED;
    SDL_EVENT_WINDOW_MOUSE_ENTER            :: WINDOW_MOUSE_ENTER;
    SDL_EVENT_WINDOW_MOUSE_LEAVE            :: WINDOW_MOUSE_LEAVE;
    SDL_EVENT_WINDOW_FOCUS_GAINED           :: WINDOW_FOCUS_GAINED;
    SDL_EVENT_WINDOW_FOCUS_LOST             :: WINDOW_FOCUS_LOST;
    SDL_EVENT_WINDOW_CLOSE_REQUESTED        :: WINDOW_CLOSE_REQUESTED;
    SDL_EVENT_WINDOW_HIT_TEST               :: WINDOW_HIT_TEST;
    SDL_EVENT_WINDOW_ICCPROF_CHANGED        :: WINDOW_ICCPROF_CHANGED;
    SDL_EVENT_WINDOW_DISPLAY_CHANGED        :: WINDOW_DISPLAY_CHANGED;
    SDL_EVENT_WINDOW_DISPLAY_SCALE_CHANGED  :: WINDOW_DISPLAY_SCALE_CHANGED;
    SDL_EVENT_WINDOW_SAFE_AREA_CHANGED      :: WINDOW_SAFE_AREA_CHANGED;
    SDL_EVENT_WINDOW_OCCLUDED               :: WINDOW_OCCLUDED;
    SDL_EVENT_WINDOW_ENTER_FULLSCREEN       :: WINDOW_ENTER_FULLSCREEN;
    SDL_EVENT_WINDOW_LEAVE_FULLSCREEN       :: WINDOW_LEAVE_FULLSCREEN;
    SDL_EVENT_WINDOW_DESTROYED              :: WINDOW_DESTROYED;
    SDL_EVENT_WINDOW_HDR_STATE_CHANGED      :: WINDOW_HDR_STATE_CHANGED;
    SDL_EVENT_WINDOW_FIRST                  :: WINDOW_FIRST;
    SDL_EVENT_WINDOW_LAST                   :: WINDOW_LAST;
    SDL_EVENT_KEY_DOWN                      :: KEY_DOWN;
    SDL_EVENT_KEY_UP                        :: KEY_UP;
    SDL_EVENT_TEXT_EDITING                  :: TEXT_EDITING;
    SDL_EVENT_TEXT_INPUT                    :: TEXT_INPUT;
    SDL_EVENT_KEYMAP_CHANGED                :: KEYMAP_CHANGED;
    SDL_EVENT_KEYBOARD_ADDED                :: KEYBOARD_ADDED;
    SDL_EVENT_KEYBOARD_REMOVED              :: KEYBOARD_REMOVED;
    SDL_EVENT_TEXT_EDITING_CANDIDATES       :: TEXT_EDITING_CANDIDATES;
    SDL_EVENT_MOUSE_MOTION                  :: MOUSE_MOTION;
    SDL_EVENT_MOUSE_BUTTON_DOWN             :: MOUSE_BUTTON_DOWN;
    SDL_EVENT_MOUSE_BUTTON_UP               :: MOUSE_BUTTON_UP;
    SDL_EVENT_MOUSE_WHEEL                   :: MOUSE_WHEEL;
    SDL_EVENT_MOUSE_ADDED                   :: MOUSE_ADDED;
    SDL_EVENT_MOUSE_REMOVED                 :: MOUSE_REMOVED;
    SDL_EVENT_JOYSTICK_AXIS_MOTION          :: JOYSTICK_AXIS_MOTION;
    SDL_EVENT_JOYSTICK_BALL_MOTION          :: JOYSTICK_BALL_MOTION;
    SDL_EVENT_JOYSTICK_HAT_MOTION           :: JOYSTICK_HAT_MOTION;
    SDL_EVENT_JOYSTICK_BUTTON_DOWN          :: JOYSTICK_BUTTON_DOWN;
    SDL_EVENT_JOYSTICK_BUTTON_UP            :: JOYSTICK_BUTTON_UP;
    SDL_EVENT_JOYSTICK_ADDED                :: JOYSTICK_ADDED;
    SDL_EVENT_JOYSTICK_REMOVED              :: JOYSTICK_REMOVED;
    SDL_EVENT_JOYSTICK_BATTERY_UPDATED      :: JOYSTICK_BATTERY_UPDATED;
    SDL_EVENT_JOYSTICK_UPDATE_COMPLETE      :: JOYSTICK_UPDATE_COMPLETE;
    SDL_EVENT_GAMEPAD_AXIS_MOTION           :: GAMEPAD_AXIS_MOTION;
    SDL_EVENT_GAMEPAD_BUTTON_DOWN           :: GAMEPAD_BUTTON_DOWN;
    SDL_EVENT_GAMEPAD_BUTTON_UP             :: GAMEPAD_BUTTON_UP;
    SDL_EVENT_GAMEPAD_ADDED                 :: GAMEPAD_ADDED;
    SDL_EVENT_GAMEPAD_REMOVED               :: GAMEPAD_REMOVED;
    SDL_EVENT_GAMEPAD_REMAPPED              :: GAMEPAD_REMAPPED;
    SDL_EVENT_GAMEPAD_TOUCHPAD_DOWN         :: GAMEPAD_TOUCHPAD_DOWN;
    SDL_EVENT_GAMEPAD_TOUCHPAD_MOTION       :: GAMEPAD_TOUCHPAD_MOTION;
    SDL_EVENT_GAMEPAD_TOUCHPAD_UP           :: GAMEPAD_TOUCHPAD_UP;
    SDL_EVENT_GAMEPAD_SENSOR_UPDATE         :: GAMEPAD_SENSOR_UPDATE;
    SDL_EVENT_GAMEPAD_UPDATE_COMPLETE       :: GAMEPAD_UPDATE_COMPLETE;
    SDL_EVENT_GAMEPAD_STEAM_HANDLE_UPDATED  :: GAMEPAD_STEAM_HANDLE_UPDATED;
    SDL_EVENT_FINGER_DOWN                   :: FINGER_DOWN;
    SDL_EVENT_FINGER_UP                     :: FINGER_UP;
    SDL_EVENT_FINGER_MOTION                 :: FINGER_MOTION;
    SDL_EVENT_CLIPBOARD_UPDATE              :: CLIPBOARD_UPDATE;
    SDL_EVENT_DROP_FILE                     :: DROP_FILE;
    SDL_EVENT_DROP_TEXT                     :: DROP_TEXT;
    SDL_EVENT_DROP_BEGIN                    :: DROP_BEGIN;
    SDL_EVENT_DROP_COMPLETE                 :: DROP_COMPLETE;
    SDL_EVENT_DROP_POSITION                 :: DROP_POSITION;
    SDL_EVENT_AUDIO_DEVICE_ADDED            :: AUDIO_DEVICE_ADDED;
    SDL_EVENT_AUDIO_DEVICE_REMOVED          :: AUDIO_DEVICE_REMOVED;
    SDL_EVENT_AUDIO_DEVICE_FORMAT_CHANGED   :: AUDIO_DEVICE_FORMAT_CHANGED;
    SDL_EVENT_SENSOR_UPDATE                 :: SENSOR_UPDATE;
    SDL_EVENT_PEN_PROXIMITY_IN              :: PEN_PROXIMITY_IN;
    SDL_EVENT_PEN_PROXIMITY_OUT             :: PEN_PROXIMITY_OUT;
    SDL_EVENT_PEN_DOWN                      :: PEN_DOWN;
    SDL_EVENT_PEN_UP                        :: PEN_UP;
    SDL_EVENT_PEN_BUTTON_DOWN               :: PEN_BUTTON_DOWN;
    SDL_EVENT_PEN_BUTTON_UP                 :: PEN_BUTTON_UP;
    SDL_EVENT_PEN_MOTION                    :: PEN_MOTION;
    SDL_EVENT_PEN_AXIS                      :: PEN_AXIS;
    SDL_EVENT_CAMERA_DEVICE_ADDED           :: CAMERA_DEVICE_ADDED;
    SDL_EVENT_CAMERA_DEVICE_REMOVED         :: CAMERA_DEVICE_REMOVED;
    SDL_EVENT_CAMERA_DEVICE_APPROVED        :: CAMERA_DEVICE_APPROVED;
    SDL_EVENT_CAMERA_DEVICE_DENIED          :: CAMERA_DEVICE_DENIED;
    SDL_EVENT_RENDER_TARGETS_RESET          :: RENDER_TARGETS_RESET;
    SDL_EVENT_RENDER_DEVICE_RESET           :: RENDER_DEVICE_RESET;
    SDL_EVENT_RENDER_DEVICE_LOST            :: RENDER_DEVICE_LOST;
    SDL_EVENT_PRIVATE0                      :: PRIVATE0;
    SDL_EVENT_PRIVATE1                      :: PRIVATE1;
    SDL_EVENT_PRIVATE2                      :: PRIVATE2;
    SDL_EVENT_PRIVATE3                      :: PRIVATE3;
    SDL_EVENT_POLL_SENTINEL                 :: POLL_SENTINEL;
    SDL_EVENT_USER                          :: USER;
    SDL_EVENT_LAST                          :: LAST;
    SDL_EVENT_ENUM_PADDING                  :: ENUM_PADDING;
}
SDL_CommonEvent :: struct {
    type:      Uint32;
    reserved:  Uint32;
    timestamp: Uint64;
}
SDL_DisplayEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    displayID: SDL_DisplayID;
    data1:     Sint32;
    data2:     Sint32;
}
SDL_WindowEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    data1:     Sint32;
    data2:     Sint32;
}
SDL_KeyboardDeviceEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_KeyboardID;
}
SDL_KeyboardEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    which:     SDL_KeyboardID;
    scancode:  SDL_Scancode;
    key:       SDL_Keycode;
    mod:       SDL_Keymod;
    raw:       Uint16;
    down:      bool;
    repeat:    bool;
}
SDL_TextEditingEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    text:      *u8;
    start:     Sint32;
    length:    Sint32;
}
SDL_TextEditingCandidatesEvent :: struct {
    type:               SDL_EventType;
    reserved:           Uint32;
    timestamp:          Uint64;
    windowID:           SDL_WindowID;
    candidates:         **u8;
    num_candidates:     Sint32;
    selected_candidate: Sint32;
    horizontal:         bool;
    padding1:           Uint8;
    padding2:           Uint8;
    padding3:           Uint8;
}
SDL_TextInputEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    text:      *u8;
}
SDL_MouseDeviceEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_MouseID;
}
SDL_MouseMotionEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    which:     SDL_MouseID;
    state:     SDL_MouseButtonFlags;
    x:         float;
    y:         float;
    xrel:      float;
    yrel:      float;
}
SDL_MouseButtonEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    which:     SDL_MouseID;
    button:    Uint8;
    down:      bool;
    clicks:    Uint8;
    padding:   Uint8;
    x:         float;
    y:         float;
}
SDL_MouseWheelEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    which:     SDL_MouseID;
    x:         float;
    y:         float;
    direction: SDL_MouseWheelDirection;
    mouse_x:   float;
    mouse_y:   float;
}
SDL_JoyAxisEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_JoystickID;
    axis:      Uint8;
    padding1:  Uint8;
    padding2:  Uint8;
    padding3:  Uint8;
    value:     Sint16;
    padding4:  Uint16;
}
SDL_JoyBallEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_JoystickID;
    ball:      Uint8;
    padding1:  Uint8;
    padding2:  Uint8;
    padding3:  Uint8;
    xrel:      Sint16;
    yrel:      Sint16;
}
SDL_JoyHatEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_JoystickID;
    hat:       Uint8;
    value:     Uint8;
    padding1:  Uint8;
    padding2:  Uint8;
}
SDL_JoyButtonEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_JoystickID;
    button:    Uint8;
    down:      bool;
    padding1:  Uint8;
    padding2:  Uint8;
}
SDL_JoyDeviceEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_JoystickID;
}
SDL_JoyBatteryEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_JoystickID;
    state:     SDL_PowerState;
    percent:   s32;
}
SDL_GamepadAxisEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_JoystickID;
    axis:      Uint8;
    padding1:  Uint8;
    padding2:  Uint8;
    padding3:  Uint8;
    value:     Sint16;
    padding4:  Uint16;
}
SDL_GamepadButtonEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_JoystickID;
    button:    Uint8;
    down:      bool;
    padding1:  Uint8;
    padding2:  Uint8;
}
SDL_GamepadDeviceEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_JoystickID;
}
SDL_GamepadTouchpadEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_JoystickID;
    touchpad:  Sint32;
    finger:    Sint32;
    x:         float;
    y:         float;
    pressure:  float;
}
SDL_GamepadSensorEvent :: struct {
    type:             SDL_EventType;
    reserved:         Uint32;
    timestamp:        Uint64;
    which:            SDL_JoystickID;
    sensor:           Sint32;
    data:             [3] float;
    sensor_timestamp: Uint64;
}
SDL_AudioDeviceEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_AudioDeviceID;
    recording: bool;
    padding1:  Uint8;
    padding2:  Uint8;
    padding3:  Uint8;
}
SDL_CameraDeviceEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_CameraID;
}
SDL_TouchFingerEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    touchID:   SDL_TouchID;
    fingerID:  SDL_FingerID;
    x:         float;
    y:         float;
    dx:        float;
    dy:        float;
    pressure:  float;
    windowID:  SDL_WindowID;
}
SDL_PenProximityEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    which:     SDL_PenID;
}
SDL_PenMotionEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    which:     SDL_PenID;
    pen_state: SDL_PenInputFlags;
    x:         float;
    y:         float;
}
SDL_PenTouchEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    which:     SDL_PenID;
    pen_state: SDL_PenInputFlags;
    x:         float;
    y:         float;
    eraser:    bool;
    down:      bool;
}
SDL_PenButtonEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    which:     SDL_PenID;
    pen_state: SDL_PenInputFlags;
    x:         float;
    y:         float;
    button:    Uint8;
    down:      bool;
}
SDL_PenAxisEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    which:     SDL_PenID;
    pen_state: SDL_PenInputFlags;
    x:         float;
    y:         float;
    axis:      SDL_PenAxis;
    value:     float;
}
SDL_DropEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    x:         float;
    y:         float;
    source:    *u8;
    data:      *u8;
}
SDL_ClipboardEvent :: struct {
    type:         SDL_EventType;
    reserved:     Uint32;
    timestamp:    Uint64;
    owner:        bool;
    n_mime_types: Sint32;
    mime_types:   **u8;
}
SDL_SensorEvent :: struct {
    type:             SDL_EventType;
    reserved:         Uint32;
    timestamp:        Uint64;
    which:            SDL_SensorID;
    data:             [6] float;
    sensor_timestamp: Uint64;
}
SDL_QuitEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
}
SDL_UserEvent :: struct {
    type:      Uint32;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    code:      Sint32;
    data1:     *void;
    data2:     *void;
}
SDL_Event :: union {
    type:            SDL_EventType;
    common:          SDL_CommonEvent;
    display:         SDL_DisplayEvent;
    window:          SDL_WindowEvent;
    kdevice:         SDL_KeyboardDeviceEvent;
    key:             SDL_KeyboardEvent;
    edit:            SDL_TextEditingEvent;
    edit_candidates: SDL_TextEditingCandidatesEvent;
    text:            SDL_TextInputEvent;
    mdevice:         SDL_MouseDeviceEvent;
    motion:          SDL_MouseMotionEvent;
    button:          SDL_MouseButtonEvent;
    wheel:           SDL_MouseWheelEvent;
    jdevice:         SDL_JoyDeviceEvent;
    jaxis:           SDL_JoyAxisEvent;
    jball:           SDL_JoyBallEvent;
    jhat:            SDL_JoyHatEvent;
    jbutton:         SDL_JoyButtonEvent;
    jbattery:        SDL_JoyBatteryEvent;
    gdevice:         SDL_GamepadDeviceEvent;
    gaxis:           SDL_GamepadAxisEvent;
    gbutton:         SDL_GamepadButtonEvent;
    gtouchpad:       SDL_GamepadTouchpadEvent;
    gsensor:         SDL_GamepadSensorEvent;
    adevice:         SDL_AudioDeviceEvent;
    cdevice:         SDL_CameraDeviceEvent;
    sensor:          SDL_SensorEvent;
    quit:            SDL_QuitEvent;
    user:            SDL_UserEvent;
    tfinger:         SDL_TouchFingerEvent;
    pproximity:      SDL_PenProximityEvent;
    ptouch:          SDL_PenTouchEvent;
    pmotion:         SDL_PenMotionEvent;
    pbutton:         SDL_PenButtonEvent;
    paxis:           SDL_PenAxisEvent;
    drop:            SDL_DropEvent;
    clipboard:       SDL_ClipboardEvent;
    padding:         [128] Uint8;
}
SDL_PumpEvents :: () -> void #foreign sdl3;
SDL_EventAction :: enum u32 {
    ADDEVENT  :: 0;
    PEEKEVENT :: 1;
    GETEVENT  :: 2;

    SDL_ADDEVENT  :: ADDEVENT;
    SDL_PEEKEVENT :: PEEKEVENT;
    SDL_GETEVENT  :: GETEVENT;
}
SDL_PeepEvents :: (events: *SDL_Event, numevents: s32, action: SDL_EventAction, minType: Uint32, maxType: Uint32) -> s32 #foreign sdl3;
SDL_HasEvent :: (type: Uint32) -> bool #foreign sdl3;
SDL_HasEvents :: (minType: Uint32, maxType: Uint32) -> bool #foreign sdl3;
SDL_FlushEvent :: (type: Uint32) -> void #foreign sdl3;
SDL_FlushEvents :: (minType: Uint32, maxType: Uint32) -> void #foreign sdl3;
SDL_PollEvent :: (event: *SDL_Event) -> bool #foreign sdl3;
SDL_WaitEvent :: (event: *SDL_Event) -> bool #foreign sdl3;
SDL_WaitEventTimeout :: (event: *SDL_Event, timeoutMS: Sint32) -> bool #foreign sdl3;
SDL_PushEvent :: (event: *SDL_Event) -> bool #foreign sdl3;
SDL_EventFilter :: #type (userdata: *void, event: *SDL_Event) -> bool #c_call;
SDL_SetEventFilter :: (filter: SDL_EventFilter, userdata: *void) -> void #foreign sdl3;
SDL_GetEventFilter :: (filter: *SDL_EventFilter, userdata: **void) -> bool #foreign sdl3;
SDL_AddEventWatch :: (filter: SDL_EventFilter, userdata: *void) -> bool #foreign sdl3;
SDL_RemoveEventWatch :: (filter: SDL_EventFilter, userdata: *void) -> void #foreign sdl3;
SDL_FilterEvents :: (filter: SDL_EventFilter, userdata: *void) -> void #foreign sdl3;
SDL_SetEventEnabled :: (type: Uint32, enabled: bool) -> void #foreign sdl3;
SDL_EventEnabled :: (type: Uint32) -> bool #foreign sdl3;
SDL_RegisterEvents :: (numevents: s32) -> Uint32 #foreign sdl3;
SDL_GetWindowFromEvent :: (event: *SDL_Event) -> *SDL_Window #foreign sdl3;
SDL_GetBasePath :: () -> *u8 #foreign sdl3;
SDL_GetPrefPath :: (org: *u8, app: *u8) -> *u8 #foreign sdl3;
SDL_Folder :: enum u32 {
    HOME        :: 0;
    DESKTOP     :: 1;
    DOCUMENTS   :: 2;
    DOWNLOADS   :: 3;
    MUSIC       :: 4;
    PICTURES    :: 5;
    PUBLICSHARE :: 6;
    SAVEDGAMES  :: 7;
    SCREENSHOTS :: 8;
    TEMPLATES   :: 9;
    VIDEOS      :: 10;
    COUNT       :: 11;

    SDL_FOLDER_HOME        :: HOME;
    SDL_FOLDER_DESKTOP     :: DESKTOP;
    SDL_FOLDER_DOCUMENTS   :: DOCUMENTS;
    SDL_FOLDER_DOWNLOADS   :: DOWNLOADS;
    SDL_FOLDER_MUSIC       :: MUSIC;
    SDL_FOLDER_PICTURES    :: PICTURES;
    SDL_FOLDER_PUBLICSHARE :: PUBLICSHARE;
    SDL_FOLDER_SAVEDGAMES  :: SAVEDGAMES;
    SDL_FOLDER_SCREENSHOTS :: SCREENSHOTS;
    SDL_FOLDER_TEMPLATES   :: TEMPLATES;
    SDL_FOLDER_VIDEOS      :: VIDEOS;
    SDL_FOLDER_COUNT       :: COUNT;
}
SDL_GetUserFolder :: (folder: SDL_Folder) -> *u8 #foreign sdl3;
SDL_PathType :: enum u32 {
    NONE      :: 0;
    FILE      :: 1;
    DIRECTORY :: 2;
    OTHER     :: 3;

    SDL_PATHTYPE_NONE      :: NONE;
    SDL_PATHTYPE_FILE      :: FILE;
    SDL_PATHTYPE_DIRECTORY :: DIRECTORY;
    SDL_PATHTYPE_OTHER     :: OTHER;
}
SDL_PathInfo :: struct {
    type:        SDL_PathType;
    size:        Uint64;
    create_time: SDL_Time;
    modify_time: SDL_Time;
    access_time: SDL_Time;
}
SDL_GlobFlags :: Uint32;
SDL_CreateDirectory :: (path: *u8) -> bool #foreign sdl3;
SDL_EnumerationResult :: enum u32 {
    CONTINUE :: 0;
    SUCCESS  :: 1;
    FAILURE  :: 2;

    SDL_ENUM_CONTINUE :: CONTINUE;
    SDL_ENUM_SUCCESS  :: SUCCESS;
    SDL_ENUM_FAILURE  :: FAILURE;
}
SDL_EnumerateDirectoryCallback :: #type (userdata: *void, dirname: *u8, fname: *u8) -> SDL_EnumerationResult #c_call;
SDL_EnumerateDirectory :: (path: *u8, callback: SDL_EnumerateDirectoryCallback, userdata: *void) -> bool #foreign sdl3;
SDL_RemovePath :: (path: *u8) -> bool #foreign sdl3;
SDL_RenamePath :: (oldpath: *u8, newpath: *u8) -> bool #foreign sdl3;
SDL_CopyFile :: (oldpath: *u8, newpath: *u8) -> bool #foreign sdl3;
SDL_GetPathInfo :: (path: *u8, info: *SDL_PathInfo) -> bool #foreign sdl3;
SDL_GlobDirectory :: (path: *u8, pattern: *u8, flags: SDL_GlobFlags, count: *s32) -> **u8 #foreign sdl3;
SDL_GPUDevice :: struct {}
SDL_GPUBuffer :: struct {}
SDL_GPUTransferBuffer :: struct {}
SDL_GPUTexture :: struct {}
SDL_GPUSampler :: struct {}
SDL_GPUShader :: struct {}
SDL_GPUComputePipeline :: struct {}
SDL_GPUGraphicsPipeline :: struct {}
SDL_GPUCommandBuffer :: struct {}
SDL_GPURenderPass :: struct {}
SDL_GPUComputePass :: struct {}
SDL_GPUCopyPass :: struct {}
SDL_GPUFence :: struct {}
SDL_GPUPrimitiveType :: enum u32 {
    TRIANGLELIST  :: 0;
    TRIANGLESTRIP :: 1;
    LINELIST      :: 2;
    LINESTRIP     :: 3;
    POINTLIST     :: 4;

    SDL_GPU_PRIMITIVETYPE_TRIANGLELIST  :: TRIANGLELIST;
    SDL_GPU_PRIMITIVETYPE_TRIANGLESTRIP :: TRIANGLESTRIP;
    SDL_GPU_PRIMITIVETYPE_LINELIST      :: LINELIST;
    SDL_GPU_PRIMITIVETYPE_LINESTRIP     :: LINESTRIP;
    SDL_GPU_PRIMITIVETYPE_POINTLIST     :: POINTLIST;
}
SDL_GPULoadOp :: enum u32 {
    LOAD      :: 0;
    CLEAR     :: 1;
    DONT_CARE :: 2;

    SDL_GPU_LOADOP_LOAD      :: LOAD;
    SDL_GPU_LOADOP_CLEAR     :: CLEAR;
    SDL_GPU_LOADOP_DONT_CARE :: DONT_CARE;
}
SDL_GPUStoreOp :: enum u32 {
    STORE             :: 0;
    DONT_CARE         :: 1;
    RESOLVE           :: 2;
    RESOLVE_AND_STORE :: 3;

    SDL_GPU_STOREOP_STORE             :: STORE;
    SDL_GPU_STOREOP_DONT_CARE         :: DONT_CARE;
    SDL_GPU_STOREOP_RESOLVE           :: RESOLVE;
    SDL_GPU_STOREOP_RESOLVE_AND_STORE :: RESOLVE_AND_STORE;
}
SDL_GPUIndexElementSize :: enum u32 {
    _16BIT :: 0;
    _32BIT :: 1;

    SDL_GPU_INDEXELEMENTSIZE_16BIT :: _16BIT;
    SDL_GPU_INDEXELEMENTSIZE_32BIT :: _32BIT;
}
SDL_GPUTextureFormat :: enum u32 {
    INVALID               :: 0;
    A8_UNORM              :: 1;
    R8_UNORM              :: 2;
    R8G8_UNORM            :: 3;
    R8G8B8A8_UNORM        :: 4;
    R16_UNORM             :: 5;
    R16G16_UNORM          :: 6;
    R16G16B16A16_UNORM    :: 7;
    R10G10B10A2_UNORM     :: 8;
    B5G6R5_UNORM          :: 9;
    B5G5R5A1_UNORM        :: 10;
    B4G4R4A4_UNORM        :: 11;
    B8G8R8A8_UNORM        :: 12;
    BC1_RGBA_UNORM        :: 13;
    BC2_RGBA_UNORM        :: 14;
    BC3_RGBA_UNORM        :: 15;
    BC4_R_UNORM           :: 16;
    BC5_RG_UNORM          :: 17;
    BC7_RGBA_UNORM        :: 18;
    BC6H_RGB_FLOAT        :: 19;
    BC6H_RGB_UFLOAT       :: 20;
    R8_SNORM              :: 21;
    R8G8_SNORM            :: 22;
    R8G8B8A8_SNORM        :: 23;
    R16_SNORM             :: 24;
    R16G16_SNORM          :: 25;
    R16G16B16A16_SNORM    :: 26;
    R16_FLOAT             :: 27;
    R16G16_FLOAT          :: 28;
    R16G16B16A16_FLOAT    :: 29;
    R32_FLOAT             :: 30;
    R32G32_FLOAT          :: 31;
    R32G32B32A32_FLOAT    :: 32;
    R11G11B10_UFLOAT      :: 33;
    R8_UINT               :: 34;
    R8G8_UINT             :: 35;
    R8G8B8A8_UINT         :: 36;
    R16_UINT              :: 37;
    R16G16_UINT           :: 38;
    R16G16B16A16_UINT     :: 39;
    R32_UINT              :: 40;
    R32G32_UINT           :: 41;
    R32G32B32A32_UINT     :: 42;
    R8_INT                :: 43;
    R8G8_INT              :: 44;
    R8G8B8A8_INT          :: 45;
    R16_INT               :: 46;
    R16G16_INT            :: 47;
    R16G16B16A16_INT      :: 48;
    R32_INT               :: 49;
    R32G32_INT            :: 50;
    R32G32B32A32_INT      :: 51;
    R8G8B8A8_UNORM_SRGB   :: 52;
    B8G8R8A8_UNORM_SRGB   :: 53;
    BC1_RGBA_UNORM_SRGB   :: 54;
    BC2_RGBA_UNORM_SRGB   :: 55;
    BC3_RGBA_UNORM_SRGB   :: 56;
    BC7_RGBA_UNORM_SRGB   :: 57;
    D16_UNORM             :: 58;
    D24_UNORM             :: 59;
    D32_FLOAT             :: 60;
    D24_UNORM_S8_UINT     :: 61;
    D32_FLOAT_S8_UINT     :: 62;
    ASTC_4x4_UNORM        :: 63;
    ASTC_5x4_UNORM        :: 64;
    ASTC_5x5_UNORM        :: 65;
    ASTC_6x5_UNORM        :: 66;
    ASTC_6x6_UNORM        :: 67;
    ASTC_8x5_UNORM        :: 68;
    ASTC_8x6_UNORM        :: 69;
    ASTC_8x8_UNORM        :: 70;
    ASTC_10x5_UNORM       :: 71;
    ASTC_10x6_UNORM       :: 72;
    ASTC_10x8_UNORM       :: 73;
    ASTC_10x10_UNORM      :: 74;
    ASTC_12x10_UNORM      :: 75;
    ASTC_12x12_UNORM      :: 76;
    ASTC_4x4_UNORM_SRGB   :: 77;
    ASTC_5x4_UNORM_SRGB   :: 78;
    ASTC_5x5_UNORM_SRGB   :: 79;
    ASTC_6x5_UNORM_SRGB   :: 80;
    ASTC_6x6_UNORM_SRGB   :: 81;
    ASTC_8x5_UNORM_SRGB   :: 82;
    ASTC_8x6_UNORM_SRGB   :: 83;
    ASTC_8x8_UNORM_SRGB   :: 84;
    ASTC_10x5_UNORM_SRGB  :: 85;
    ASTC_10x6_UNORM_SRGB  :: 86;
    ASTC_10x8_UNORM_SRGB  :: 87;
    ASTC_10x10_UNORM_SRGB :: 88;
    ASTC_12x10_UNORM_SRGB :: 89;
    ASTC_12x12_UNORM_SRGB :: 90;
    ASTC_4x4_FLOAT        :: 91;
    ASTC_5x4_FLOAT        :: 92;
    ASTC_5x5_FLOAT        :: 93;
    ASTC_6x5_FLOAT        :: 94;
    ASTC_6x6_FLOAT        :: 95;
    ASTC_8x5_FLOAT        :: 96;
    ASTC_8x6_FLOAT        :: 97;
    ASTC_8x8_FLOAT        :: 98;
    ASTC_10x5_FLOAT       :: 99;
    ASTC_10x6_FLOAT       :: 100;
    ASTC_10x8_FLOAT       :: 101;
    ASTC_10x10_FLOAT      :: 102;
    ASTC_12x10_FLOAT      :: 103;
    ASTC_12x12_FLOAT      :: 104;

    SDL_GPU_TEXTUREFORMAT_INVALID               :: INVALID;
    SDL_GPU_TEXTUREFORMAT_A8_UNORM              :: A8_UNORM;
    SDL_GPU_TEXTUREFORMAT_R8_UNORM              :: R8_UNORM;
    SDL_GPU_TEXTUREFORMAT_R8G8_UNORM            :: R8G8_UNORM;
    SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UNORM        :: R8G8B8A8_UNORM;
    SDL_GPU_TEXTUREFORMAT_R16_UNORM             :: R16_UNORM;
    SDL_GPU_TEXTUREFORMAT_R16G16_UNORM          :: R16G16_UNORM;
    SDL_GPU_TEXTUREFORMAT_R16G16B16A16_UNORM    :: R16G16B16A16_UNORM;
    SDL_GPU_TEXTUREFORMAT_R10G10B10A2_UNORM     :: R10G10B10A2_UNORM;
    SDL_GPU_TEXTUREFORMAT_B5G6R5_UNORM          :: B5G6R5_UNORM;
    SDL_GPU_TEXTUREFORMAT_B5G5R5A1_UNORM        :: B5G5R5A1_UNORM;
    SDL_GPU_TEXTUREFORMAT_B4G4R4A4_UNORM        :: B4G4R4A4_UNORM;
    SDL_GPU_TEXTUREFORMAT_B8G8R8A8_UNORM        :: B8G8R8A8_UNORM;
    SDL_GPU_TEXTUREFORMAT_BC1_RGBA_UNORM        :: BC1_RGBA_UNORM;
    SDL_GPU_TEXTUREFORMAT_BC2_RGBA_UNORM        :: BC2_RGBA_UNORM;
    SDL_GPU_TEXTUREFORMAT_BC3_RGBA_UNORM        :: BC3_RGBA_UNORM;
    SDL_GPU_TEXTUREFORMAT_BC4_R_UNORM           :: BC4_R_UNORM;
    SDL_GPU_TEXTUREFORMAT_BC5_RG_UNORM          :: BC5_RG_UNORM;
    SDL_GPU_TEXTUREFORMAT_BC7_RGBA_UNORM        :: BC7_RGBA_UNORM;
    SDL_GPU_TEXTUREFORMAT_BC6H_RGB_FLOAT        :: BC6H_RGB_FLOAT;
    SDL_GPU_TEXTUREFORMAT_BC6H_RGB_UFLOAT       :: BC6H_RGB_UFLOAT;
    SDL_GPU_TEXTUREFORMAT_R8_SNORM              :: R8_SNORM;
    SDL_GPU_TEXTUREFORMAT_R8G8_SNORM            :: R8G8_SNORM;
    SDL_GPU_TEXTUREFORMAT_R8G8B8A8_SNORM        :: R8G8B8A8_SNORM;
    SDL_GPU_TEXTUREFORMAT_R16_SNORM             :: R16_SNORM;
    SDL_GPU_TEXTUREFORMAT_R16G16_SNORM          :: R16G16_SNORM;
    SDL_GPU_TEXTUREFORMAT_R16G16B16A16_SNORM    :: R16G16B16A16_SNORM;
    SDL_GPU_TEXTUREFORMAT_R16_FLOAT             :: R16_FLOAT;
    SDL_GPU_TEXTUREFORMAT_R16G16_FLOAT          :: R16G16_FLOAT;
    SDL_GPU_TEXTUREFORMAT_R16G16B16A16_FLOAT    :: R16G16B16A16_FLOAT;
    SDL_GPU_TEXTUREFORMAT_R32_FLOAT             :: R32_FLOAT;
    SDL_GPU_TEXTUREFORMAT_R32G32_FLOAT          :: R32G32_FLOAT;
    SDL_GPU_TEXTUREFORMAT_R32G32B32A32_FLOAT    :: R32G32B32A32_FLOAT;
    SDL_GPU_TEXTUREFORMAT_R11G11B10_UFLOAT      :: R11G11B10_UFLOAT;
    SDL_GPU_TEXTUREFORMAT_R8_UINT               :: R8_UINT;
    SDL_GPU_TEXTUREFORMAT_R8G8_UINT             :: R8G8_UINT;
    SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UINT         :: R8G8B8A8_UINT;
    SDL_GPU_TEXTUREFORMAT_R16_UINT              :: R16_UINT;
    SDL_GPU_TEXTUREFORMAT_R16G16_UINT           :: R16G16_UINT;
    SDL_GPU_TEXTUREFORMAT_R16G16B16A16_UINT     :: R16G16B16A16_UINT;
    SDL_GPU_TEXTUREFORMAT_R32_UINT              :: R32_UINT;
    SDL_GPU_TEXTUREFORMAT_R32G32_UINT           :: R32G32_UINT;
    SDL_GPU_TEXTUREFORMAT_R32G32B32A32_UINT     :: R32G32B32A32_UINT;
    SDL_GPU_TEXTUREFORMAT_R8_INT                :: R8_INT;
    SDL_GPU_TEXTUREFORMAT_R8G8_INT              :: R8G8_INT;
    SDL_GPU_TEXTUREFORMAT_R8G8B8A8_INT          :: R8G8B8A8_INT;
    SDL_GPU_TEXTUREFORMAT_R16_INT               :: R16_INT;
    SDL_GPU_TEXTUREFORMAT_R16G16_INT            :: R16G16_INT;
    SDL_GPU_TEXTUREFORMAT_R16G16B16A16_INT      :: R16G16B16A16_INT;
    SDL_GPU_TEXTUREFORMAT_R32_INT               :: R32_INT;
    SDL_GPU_TEXTUREFORMAT_R32G32_INT            :: R32G32_INT;
    SDL_GPU_TEXTUREFORMAT_R32G32B32A32_INT      :: R32G32B32A32_INT;
    SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UNORM_SRGB   :: R8G8B8A8_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_B8G8R8A8_UNORM_SRGB   :: B8G8R8A8_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_BC1_RGBA_UNORM_SRGB   :: BC1_RGBA_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_BC2_RGBA_UNORM_SRGB   :: BC2_RGBA_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_BC3_RGBA_UNORM_SRGB   :: BC3_RGBA_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_BC7_RGBA_UNORM_SRGB   :: BC7_RGBA_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_D16_UNORM             :: D16_UNORM;
    SDL_GPU_TEXTUREFORMAT_D24_UNORM             :: D24_UNORM;
    SDL_GPU_TEXTUREFORMAT_D32_FLOAT             :: D32_FLOAT;
    SDL_GPU_TEXTUREFORMAT_D24_UNORM_S8_UINT     :: D24_UNORM_S8_UINT;
    SDL_GPU_TEXTUREFORMAT_D32_FLOAT_S8_UINT     :: D32_FLOAT_S8_UINT;
    SDL_GPU_TEXTUREFORMAT_ASTC_4x4_UNORM        :: ASTC_4x4_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_5x4_UNORM        :: ASTC_5x4_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_5x5_UNORM        :: ASTC_5x5_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_6x5_UNORM        :: ASTC_6x5_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_6x6_UNORM        :: ASTC_6x6_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_8x5_UNORM        :: ASTC_8x5_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_8x6_UNORM        :: ASTC_8x6_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_8x8_UNORM        :: ASTC_8x8_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x5_UNORM       :: ASTC_10x5_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x6_UNORM       :: ASTC_10x6_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x8_UNORM       :: ASTC_10x8_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x10_UNORM      :: ASTC_10x10_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_12x10_UNORM      :: ASTC_12x10_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_12x12_UNORM      :: ASTC_12x12_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_4x4_UNORM_SRGB   :: ASTC_4x4_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_5x4_UNORM_SRGB   :: ASTC_5x4_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_5x5_UNORM_SRGB   :: ASTC_5x5_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_6x5_UNORM_SRGB   :: ASTC_6x5_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_6x6_UNORM_SRGB   :: ASTC_6x6_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_8x5_UNORM_SRGB   :: ASTC_8x5_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_8x6_UNORM_SRGB   :: ASTC_8x6_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_8x8_UNORM_SRGB   :: ASTC_8x8_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x5_UNORM_SRGB  :: ASTC_10x5_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x6_UNORM_SRGB  :: ASTC_10x6_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x8_UNORM_SRGB  :: ASTC_10x8_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x10_UNORM_SRGB :: ASTC_10x10_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_12x10_UNORM_SRGB :: ASTC_12x10_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_12x12_UNORM_SRGB :: ASTC_12x12_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_4x4_FLOAT        :: ASTC_4x4_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_5x4_FLOAT        :: ASTC_5x4_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_5x5_FLOAT        :: ASTC_5x5_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_6x5_FLOAT        :: ASTC_6x5_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_6x6_FLOAT        :: ASTC_6x6_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_8x5_FLOAT        :: ASTC_8x5_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_8x6_FLOAT        :: ASTC_8x6_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_8x8_FLOAT        :: ASTC_8x8_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x5_FLOAT       :: ASTC_10x5_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x6_FLOAT       :: ASTC_10x6_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x8_FLOAT       :: ASTC_10x8_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x10_FLOAT      :: ASTC_10x10_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_12x10_FLOAT      :: ASTC_12x10_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_12x12_FLOAT      :: ASTC_12x12_FLOAT;
}
SDL_GPUTextureUsageFlags :: Uint32;
SDL_GPUTextureType :: enum u32 {
    _2D        :: 0;
    _2D_ARRAY  :: 1;
    _3D        :: 2;
    CUBE       :: 3;
    CUBE_ARRAY :: 4;

    SDL_GPU_TEXTURETYPE_2D         :: _2D;
    SDL_GPU_TEXTURETYPE_2D_ARRAY   :: _2D_ARRAY;
    SDL_GPU_TEXTURETYPE_3D         :: _3D;
    SDL_GPU_TEXTURETYPE_CUBE       :: CUBE;
    SDL_GPU_TEXTURETYPE_CUBE_ARRAY :: CUBE_ARRAY;
}
SDL_GPUSampleCount :: enum u32 {
    _1 :: 0;
    _2 :: 1;
    _4 :: 2;
    _8 :: 3;

    SDL_GPU_SAMPLECOUNT_1 :: _1;
    SDL_GPU_SAMPLECOUNT_2 :: _2;
    SDL_GPU_SAMPLECOUNT_4 :: _4;
    SDL_GPU_SAMPLECOUNT_8 :: _8;
}
SDL_GPUCubeMapFace :: enum u32 {
    POSITIVEX :: 0;
    NEGATIVEX :: 1;
    POSITIVEY :: 2;
    NEGATIVEY :: 3;
    POSITIVEZ :: 4;
    NEGATIVEZ :: 5;

    SDL_GPU_CUBEMAPFACE_POSITIVEX :: POSITIVEX;
    SDL_GPU_CUBEMAPFACE_NEGATIVEX :: NEGATIVEX;
    SDL_GPU_CUBEMAPFACE_POSITIVEY :: POSITIVEY;
    SDL_GPU_CUBEMAPFACE_NEGATIVEY :: NEGATIVEY;
    SDL_GPU_CUBEMAPFACE_POSITIVEZ :: POSITIVEZ;
    SDL_GPU_CUBEMAPFACE_NEGATIVEZ :: NEGATIVEZ;
}
SDL_GPUBufferUsageFlags :: Uint32;
SDL_GPUTransferBufferUsage :: enum u32 {
    UPLOAD   :: 0;
    DOWNLOAD :: 1;

    SDL_GPU_TRANSFERBUFFERUSAGE_UPLOAD   :: UPLOAD;
    SDL_GPU_TRANSFERBUFFERUSAGE_DOWNLOAD :: DOWNLOAD;
}
SDL_GPUShaderStage :: enum u32 {
    VERTEX   :: 0;
    FRAGMENT :: 1;

    SDL_GPU_SHADERSTAGE_VERTEX   :: VERTEX;
    SDL_GPU_SHADERSTAGE_FRAGMENT :: FRAGMENT;
}
SDL_GPUShaderFormat :: Uint32;
SDL_GPUVertexElementFormat :: enum u32 {
    INVALID      :: 0;
    INT          :: 1;
    INT2         :: 2;
    INT3         :: 3;
    INT4         :: 4;
    UINT         :: 5;
    UINT2        :: 6;
    UINT3        :: 7;
    UINT4        :: 8;
    FLOAT        :: 9;
    FLOAT2       :: 10;
    FLOAT3       :: 11;
    FLOAT4       :: 12;
    BYTE2        :: 13;
    BYTE4        :: 14;
    UBYTE2       :: 15;
    UBYTE4       :: 16;
    BYTE2_NORM   :: 17;
    BYTE4_NORM   :: 18;
    UBYTE2_NORM  :: 19;
    UBYTE4_NORM  :: 20;
    SHORT2       :: 21;
    SHORT4       :: 22;
    USHORT2      :: 23;
    USHORT4      :: 24;
    SHORT2_NORM  :: 25;
    SHORT4_NORM  :: 26;
    USHORT2_NORM :: 27;
    USHORT4_NORM :: 28;
    HALF2        :: 29;
    HALF4        :: 30;

    SDL_GPU_VERTEXELEMENTFORMAT_INVALID      :: INVALID;
    SDL_GPU_VERTEXELEMENTFORMAT_INT          :: INT;
    SDL_GPU_VERTEXELEMENTFORMAT_INT2         :: INT2;
    SDL_GPU_VERTEXELEMENTFORMAT_INT3         :: INT3;
    SDL_GPU_VERTEXELEMENTFORMAT_INT4         :: INT4;
    SDL_GPU_VERTEXELEMENTFORMAT_UINT         :: UINT;
    SDL_GPU_VERTEXELEMENTFORMAT_UINT2        :: UINT2;
    SDL_GPU_VERTEXELEMENTFORMAT_UINT3        :: UINT3;
    SDL_GPU_VERTEXELEMENTFORMAT_UINT4        :: UINT4;
    SDL_GPU_VERTEXELEMENTFORMAT_FLOAT        :: FLOAT;
    SDL_GPU_VERTEXELEMENTFORMAT_FLOAT2       :: FLOAT2;
    SDL_GPU_VERTEXELEMENTFORMAT_FLOAT3       :: FLOAT3;
    SDL_GPU_VERTEXELEMENTFORMAT_FLOAT4       :: FLOAT4;
    SDL_GPU_VERTEXELEMENTFORMAT_BYTE2        :: BYTE2;
    SDL_GPU_VERTEXELEMENTFORMAT_BYTE4        :: BYTE4;
    SDL_GPU_VERTEXELEMENTFORMAT_UBYTE2       :: UBYTE2;
    SDL_GPU_VERTEXELEMENTFORMAT_UBYTE4       :: UBYTE4;
    SDL_GPU_VERTEXELEMENTFORMAT_BYTE2_NORM   :: BYTE2_NORM;
    SDL_GPU_VERTEXELEMENTFORMAT_BYTE4_NORM   :: BYTE4_NORM;
    SDL_GPU_VERTEXELEMENTFORMAT_UBYTE2_NORM  :: UBYTE2_NORM;
    SDL_GPU_VERTEXELEMENTFORMAT_UBYTE4_NORM  :: UBYTE4_NORM;
    SDL_GPU_VERTEXELEMENTFORMAT_SHORT2       :: SHORT2;
    SDL_GPU_VERTEXELEMENTFORMAT_SHORT4       :: SHORT4;
    SDL_GPU_VERTEXELEMENTFORMAT_USHORT2      :: USHORT2;
    SDL_GPU_VERTEXELEMENTFORMAT_USHORT4      :: USHORT4;
    SDL_GPU_VERTEXELEMENTFORMAT_SHORT2_NORM  :: SHORT2_NORM;
    SDL_GPU_VERTEXELEMENTFORMAT_SHORT4_NORM  :: SHORT4_NORM;
    SDL_GPU_VERTEXELEMENTFORMAT_USHORT2_NORM :: USHORT2_NORM;
    SDL_GPU_VERTEXELEMENTFORMAT_USHORT4_NORM :: USHORT4_NORM;
    SDL_GPU_VERTEXELEMENTFORMAT_HALF2        :: HALF2;
    SDL_GPU_VERTEXELEMENTFORMAT_HALF4        :: HALF4;
}
SDL_GPUVertexInputRate :: enum u32 {
    VERTEX   :: 0;
    INSTANCE :: 1;

    SDL_GPU_VERTEXINPUTRATE_VERTEX   :: VERTEX;
    SDL_GPU_VERTEXINPUTRATE_INSTANCE :: INSTANCE;
}
SDL_GPUFillMode :: enum u32 {
    FILL :: 0;
    LINE :: 1;

    SDL_GPU_FILLMODE_FILL :: FILL;
    SDL_GPU_FILLMODE_LINE :: LINE;
}
SDL_GPUCullMode :: enum u32 {
    NONE  :: 0;
    FRONT :: 1;
    BACK  :: 2;

    SDL_GPU_CULLMODE_NONE  :: NONE;
    SDL_GPU_CULLMODE_FRONT :: FRONT;
    SDL_GPU_CULLMODE_BACK  :: BACK;
}
SDL_GPUFrontFace :: enum u32 {
    COUNTER_CLOCKWISE :: 0;
    CLOCKWISE         :: 1;

    SDL_GPU_FRONTFACE_COUNTER_CLOCKWISE :: COUNTER_CLOCKWISE;
    SDL_GPU_FRONTFACE_CLOCKWISE         :: CLOCKWISE;
}
SDL_GPUCompareOp :: enum u32 {
    INVALID          :: 0;
    NEVER            :: 1;
    LESS             :: 2;
    EQUAL            :: 3;
    LESS_OR_EQUAL    :: 4;
    GREATER          :: 5;
    NOT_EQUAL        :: 6;
    GREATER_OR_EQUAL :: 7;
    ALWAYS           :: 8;

    SDL_GPU_COMPAREOP_INVALID          :: INVALID;
    SDL_GPU_COMPAREOP_NEVER            :: NEVER;
    SDL_GPU_COMPAREOP_LESS             :: LESS;
    SDL_GPU_COMPAREOP_EQUAL            :: EQUAL;
    SDL_GPU_COMPAREOP_LESS_OR_EQUAL    :: LESS_OR_EQUAL;
    SDL_GPU_COMPAREOP_GREATER          :: GREATER;
    SDL_GPU_COMPAREOP_NOT_EQUAL        :: NOT_EQUAL;
    SDL_GPU_COMPAREOP_GREATER_OR_EQUAL :: GREATER_OR_EQUAL;
    SDL_GPU_COMPAREOP_ALWAYS           :: ALWAYS;
}
SDL_GPUStencilOp :: enum u32 {
    INVALID             :: 0;
    KEEP                :: 1;
    ZERO                :: 2;
    REPLACE             :: 3;
    INCREMENT_AND_CLAMP :: 4;
    DECREMENT_AND_CLAMP :: 5;
    INVERT              :: 6;
    INCREMENT_AND_WRAP  :: 7;
    DECREMENT_AND_WRAP  :: 8;

    SDL_GPU_STENCILOP_INVALID             :: INVALID;
    SDL_GPU_STENCILOP_KEEP                :: KEEP;
    SDL_GPU_STENCILOP_ZERO                :: ZERO;
    SDL_GPU_STENCILOP_REPLACE             :: REPLACE;
    SDL_GPU_STENCILOP_INCREMENT_AND_CLAMP :: INCREMENT_AND_CLAMP;
    SDL_GPU_STENCILOP_DECREMENT_AND_CLAMP :: DECREMENT_AND_CLAMP;
    SDL_GPU_STENCILOP_INVERT              :: INVERT;
    SDL_GPU_STENCILOP_INCREMENT_AND_WRAP  :: INCREMENT_AND_WRAP;
    SDL_GPU_STENCILOP_DECREMENT_AND_WRAP  :: DECREMENT_AND_WRAP;
}
SDL_GPUBlendOp :: enum u32 {
    INVALID          :: 0;
    ADD              :: 1;
    SUBTRACT         :: 2;
    REVERSE_SUBTRACT :: 3;
    MIN              :: 4;
    MAX              :: 5;

    SDL_GPU_BLENDOP_INVALID          :: INVALID;
    SDL_GPU_BLENDOP_ADD              :: ADD;
    SDL_GPU_BLENDOP_SUBTRACT         :: SUBTRACT;
    SDL_GPU_BLENDOP_REVERSE_SUBTRACT :: REVERSE_SUBTRACT;
    SDL_GPU_BLENDOP_MIN              :: MIN;
    SDL_GPU_BLENDOP_MAX              :: MAX;
}
SDL_GPUBlendFactor :: enum u32 {
    INVALID                  :: 0;
    ZERO                     :: 1;
    ONE                      :: 2;
    SRC_COLOR                :: 3;
    ONE_MINUS_SRC_COLOR      :: 4;
    DST_COLOR                :: 5;
    ONE_MINUS_DST_COLOR      :: 6;
    SRC_ALPHA                :: 7;
    ONE_MINUS_SRC_ALPHA      :: 8;
    DST_ALPHA                :: 9;
    ONE_MINUS_DST_ALPHA      :: 10;
    CONSTANT_COLOR           :: 11;
    ONE_MINUS_CONSTANT_COLOR :: 12;
    SRC_ALPHA_SATURATE       :: 13;

    SDL_GPU_BLENDFACTOR_INVALID                  :: INVALID;
    SDL_GPU_BLENDFACTOR_ZERO                     :: ZERO;
    SDL_GPU_BLENDFACTOR_ONE                      :: ONE;
    SDL_GPU_BLENDFACTOR_SRC_COLOR                :: SRC_COLOR;
    SDL_GPU_BLENDFACTOR_ONE_MINUS_SRC_COLOR      :: ONE_MINUS_SRC_COLOR;
    SDL_GPU_BLENDFACTOR_DST_COLOR                :: DST_COLOR;
    SDL_GPU_BLENDFACTOR_ONE_MINUS_DST_COLOR      :: ONE_MINUS_DST_COLOR;
    SDL_GPU_BLENDFACTOR_SRC_ALPHA                :: SRC_ALPHA;
    SDL_GPU_BLENDFACTOR_ONE_MINUS_SRC_ALPHA      :: ONE_MINUS_SRC_ALPHA;
    SDL_GPU_BLENDFACTOR_DST_ALPHA                :: DST_ALPHA;
    SDL_GPU_BLENDFACTOR_ONE_MINUS_DST_ALPHA      :: ONE_MINUS_DST_ALPHA;
    SDL_GPU_BLENDFACTOR_CONSTANT_COLOR           :: CONSTANT_COLOR;
    SDL_GPU_BLENDFACTOR_ONE_MINUS_CONSTANT_COLOR :: ONE_MINUS_CONSTANT_COLOR;
    SDL_GPU_BLENDFACTOR_SRC_ALPHA_SATURATE       :: SRC_ALPHA_SATURATE;
}
SDL_GPUColorComponentFlags :: Uint8;
SDL_GPUFilter :: enum u32 {
    NEAREST :: 0;
    LINEAR  :: 1;

    SDL_GPU_FILTER_NEAREST :: NEAREST;
    SDL_GPU_FILTER_LINEAR  :: LINEAR;
}
SDL_GPUSamplerMipmapMode :: enum u32 {
    NEAREST :: 0;
    LINEAR  :: 1;

    SDL_GPU_SAMPLERMIPMAPMODE_NEAREST :: NEAREST;
    SDL_GPU_SAMPLERMIPMAPMODE_LINEAR  :: LINEAR;
}
SDL_GPUSamplerAddressMode :: enum u32 {
    REPEAT          :: 0;
    MIRRORED_REPEAT :: 1;
    CLAMP_TO_EDGE   :: 2;

    SDL_GPU_SAMPLERADDRESSMODE_REPEAT          :: REPEAT;
    SDL_GPU_SAMPLERADDRESSMODE_MIRRORED_REPEAT :: MIRRORED_REPEAT;
    SDL_GPU_SAMPLERADDRESSMODE_CLAMP_TO_EDGE   :: CLAMP_TO_EDGE;
}
SDL_GPUPresentMode :: enum u32 {
    VSYNC     :: 0;
    IMMEDIATE :: 1;
    MAILBOX   :: 2;

    SDL_GPU_PRESENTMODE_VSYNC     :: VSYNC;
    SDL_GPU_PRESENTMODE_IMMEDIATE :: IMMEDIATE;
    SDL_GPU_PRESENTMODE_MAILBOX   :: MAILBOX;
}
SDL_GPUSwapchainComposition :: enum u32 {
    SDR                 :: 0;
    SDR_LINEAR          :: 1;
    HDR_EXTENDED_LINEAR :: 2;
    HDR10_ST2048        :: 3;

    SDL_GPU_SWAPCHAINCOMPOSITION_SDR                 :: SDR;
    SDL_GPU_SWAPCHAINCOMPOSITION_SDR_LINEAR          :: SDR_LINEAR;
    SDL_GPU_SWAPCHAINCOMPOSITION_HDR_EXTENDED_LINEAR :: HDR_EXTENDED_LINEAR;
    SDL_GPU_SWAPCHAINCOMPOSITION_HDR10_ST2048        :: HDR10_ST2048;
}
SDL_GPUViewport :: struct {
    x:         float;
    y:         float;
    w:         float;
    h:         float;
    min_depth: float;
    max_depth: float;
}
SDL_GPUTextureTransferInfo :: struct {
    transfer_buffer: *SDL_GPUTransferBuffer;
    offset:          Uint32;
    pixels_per_row:  Uint32;
    rows_per_layer:  Uint32;
}
SDL_GPUTransferBufferLocation :: struct {
    transfer_buffer: *SDL_GPUTransferBuffer;
    offset:          Uint32;
}
SDL_GPUTextureLocation :: struct {
    texture:   *SDL_GPUTexture;
    mip_level: Uint32;
    layer:     Uint32;
    x:         Uint32;
    y:         Uint32;
    z:         Uint32;
}
SDL_GPUTextureRegion :: struct {
    texture:   *SDL_GPUTexture;
    mip_level: Uint32;
    layer:     Uint32;
    x:         Uint32;
    y:         Uint32;
    z:         Uint32;
    w:         Uint32;
    h:         Uint32;
    d:         Uint32;
}
SDL_GPUBlitRegion :: struct {
    texture:              *SDL_GPUTexture;
    mip_level:            Uint32;
    layer_or_depth_plane: Uint32;
    x:                    Uint32;
    y:                    Uint32;
    w:                    Uint32;
    h:                    Uint32;
}
SDL_GPUBufferLocation :: struct {
    buffer: *SDL_GPUBuffer;
    offset: Uint32;
}
SDL_GPUBufferRegion :: struct {
    buffer: *SDL_GPUBuffer;
    offset: Uint32;
    size:   Uint32;
}
SDL_GPUIndirectDrawCommand :: struct {
    num_vertices:   Uint32;
    num_instances:  Uint32;
    first_vertex:   Uint32;
    first_instance: Uint32;
}
SDL_GPUIndexedIndirectDrawCommand :: struct {
    num_indices:    Uint32;
    num_instances:  Uint32;
    first_index:    Uint32;
    vertex_offset:  Sint32;
    first_instance: Uint32;
}
SDL_GPUIndirectDispatchCommand :: struct {
    groupcount_x: Uint32;
    groupcount_y: Uint32;
    groupcount_z: Uint32;
}
SDL_GPUSamplerCreateInfo :: struct {
    min_filter:        SDL_GPUFilter;
    mag_filter:        SDL_GPUFilter;
    mipmap_mode:       SDL_GPUSamplerMipmapMode;
    address_mode_u:    SDL_GPUSamplerAddressMode;
    address_mode_v:    SDL_GPUSamplerAddressMode;
    address_mode_w:    SDL_GPUSamplerAddressMode;
    mip_lod_bias:      float;
    max_anisotropy:    float;
    compare_op:        SDL_GPUCompareOp;
    min_lod:           float;
    max_lod:           float;
    enable_anisotropy: bool;
    enable_compare:    bool;
    padding1:          Uint8;
    padding2:          Uint8;
    props:             SDL_PropertiesID;
}
SDL_GPUVertexBufferDescription :: struct {
    slot:               Uint32;
    pitch:              Uint32;
    input_rate:         SDL_GPUVertexInputRate;
    instance_step_rate: Uint32;
}
SDL_GPUVertexAttribute :: struct {
    location:    Uint32;
    buffer_slot: Uint32;
    format:      SDL_GPUVertexElementFormat;
    offset:      Uint32;
}
SDL_GPUVertexInputState :: struct {
    vertex_buffer_descriptions: *SDL_GPUVertexBufferDescription;
    num_vertex_buffers:         Uint32;
    vertex_attributes:          *SDL_GPUVertexAttribute;
    num_vertex_attributes:      Uint32;
}
SDL_GPUStencilOpState :: struct {
    fail_op:       SDL_GPUStencilOp;
    pass_op:       SDL_GPUStencilOp;
    depth_fail_op: SDL_GPUStencilOp;
    compare_op:    SDL_GPUCompareOp;
}
SDL_GPUColorTargetBlendState :: struct {
    src_color_blendfactor:   SDL_GPUBlendFactor;
    dst_color_blendfactor:   SDL_GPUBlendFactor;
    color_blend_op:          SDL_GPUBlendOp;
    src_alpha_blendfactor:   SDL_GPUBlendFactor;
    dst_alpha_blendfactor:   SDL_GPUBlendFactor;
    alpha_blend_op:          SDL_GPUBlendOp;
    color_write_mask:        SDL_GPUColorComponentFlags;
    enable_blend:            bool;
    enable_color_write_mask: bool;
    padding1:                Uint8;
    padding2:                Uint8;
}
SDL_GPUShaderCreateInfo :: struct {
    code_size:            u64;
    code:                 *Uint8;
    entrypoint:           *u8;
    format:               SDL_GPUShaderFormat;
    stage:                SDL_GPUShaderStage;
    num_samplers:         Uint32;
    num_storage_textures: Uint32;
    num_storage_buffers:  Uint32;
    num_uniform_buffers:  Uint32;
    props:                SDL_PropertiesID;
}
SDL_GPUTextureCreateInfo :: struct {
    type:                 SDL_GPUTextureType;
    format:               SDL_GPUTextureFormat;
    usage:                SDL_GPUTextureUsageFlags;
    width:                Uint32;
    height:               Uint32;
    layer_count_or_depth: Uint32;
    num_levels:           Uint32;
    sample_count:         SDL_GPUSampleCount;
    props:                SDL_PropertiesID;
}
SDL_GPUBufferCreateInfo :: struct {
    usage: SDL_GPUBufferUsageFlags;
    size:  Uint32;
    props: SDL_PropertiesID;
}
SDL_GPUTransferBufferCreateInfo :: struct {
    usage: SDL_GPUTransferBufferUsage;
    size:  Uint32;
    props: SDL_PropertiesID;
}
SDL_GPURasterizerState :: struct {
    fill_mode:                  SDL_GPUFillMode;
    cull_mode:                  SDL_GPUCullMode;
    front_face:                 SDL_GPUFrontFace;
    depth_bias_constant_factor: float;
    depth_bias_clamp:           float;
    depth_bias_slope_factor:    float;
    enable_depth_bias:          bool;
    enable_depth_clip:          bool;
    padding1:                   Uint8;
    padding2:                   Uint8;
}
SDL_GPUMultisampleState :: struct {
    sample_count: SDL_GPUSampleCount;
    sample_mask:  Uint32;
    enable_mask:  bool;
    padding1:     Uint8;
    padding2:     Uint8;
    padding3:     Uint8;
}
SDL_GPUDepthStencilState :: struct {
    compare_op:          SDL_GPUCompareOp;
    back_stencil_state:  SDL_GPUStencilOpState;
    front_stencil_state: SDL_GPUStencilOpState;
    compare_mask:        Uint8;
    write_mask:          Uint8;
    enable_depth_test:   bool;
    enable_depth_write:  bool;
    enable_stencil_test: bool;
    padding1:            Uint8;
    padding2:            Uint8;
    padding3:            Uint8;
}
SDL_GPUColorTargetDescription :: struct {
    format:      SDL_GPUTextureFormat;
    blend_state: SDL_GPUColorTargetBlendState;
}
SDL_GPUGraphicsPipelineTargetInfo :: struct {
    color_target_descriptions: *SDL_GPUColorTargetDescription;
    num_color_targets:         Uint32;
    depth_stencil_format:      SDL_GPUTextureFormat;
    has_depth_stencil_target:  bool;
    padding1:                  Uint8;
    padding2:                  Uint8;
    padding3:                  Uint8;
}
SDL_GPUGraphicsPipelineCreateInfo :: struct {
    vertex_shader:       *SDL_GPUShader;
    fragment_shader:     *SDL_GPUShader;
    vertex_input_state:  SDL_GPUVertexInputState;
    primitive_type:      SDL_GPUPrimitiveType;
    rasterizer_state:    SDL_GPURasterizerState;
    multisample_state:   SDL_GPUMultisampleState;
    depth_stencil_state: SDL_GPUDepthStencilState;
    target_info:         SDL_GPUGraphicsPipelineTargetInfo;
    props:               SDL_PropertiesID;
}
SDL_GPUComputePipelineCreateInfo :: struct {
    code_size:                      u64;
    code:                           *Uint8;
    entrypoint:                     *u8;
    format:                         SDL_GPUShaderFormat;
    num_samplers:                   Uint32;
    num_readonly_storage_textures:  Uint32;
    num_readonly_storage_buffers:   Uint32;
    num_readwrite_storage_textures: Uint32;
    num_readwrite_storage_buffers:  Uint32;
    num_uniform_buffers:            Uint32;
    threadcount_x:                  Uint32;
    threadcount_y:                  Uint32;
    threadcount_z:                  Uint32;
    props:                          SDL_PropertiesID;
}
SDL_GPUColorTargetInfo :: struct {
    texture:               *SDL_GPUTexture;
    mip_level:             Uint32;
    layer_or_depth_plane:  Uint32;
    clear_color:           SDL_FColor;
    load_op:               SDL_GPULoadOp;
    store_op:              SDL_GPUStoreOp;
    resolve_texture:       *SDL_GPUTexture;
    resolve_mip_level:     Uint32;
    resolve_layer:         Uint32;
    cycle:                 bool;
    cycle_resolve_texture: bool;
    padding1:              Uint8;
    padding2:              Uint8;
}
SDL_GPUDepthStencilTargetInfo :: struct {
    texture:          *SDL_GPUTexture;
    clear_depth:      float;
    load_op:          SDL_GPULoadOp;
    store_op:         SDL_GPUStoreOp;
    stencil_load_op:  SDL_GPULoadOp;
    stencil_store_op: SDL_GPUStoreOp;
    cycle:            bool;
    clear_stencil:    Uint8;
    padding1:         Uint8;
    padding2:         Uint8;
}
SDL_GPUBlitInfo :: struct {
    source:      SDL_GPUBlitRegion;
    destination: SDL_GPUBlitRegion;
    load_op:     SDL_GPULoadOp;
    clear_color: SDL_FColor;
    flip_mode:   SDL_FlipMode;
    filter:      SDL_GPUFilter;
    cycle:       bool;
    padding1:    Uint8;
    padding2:    Uint8;
    padding3:    Uint8;
}
SDL_GPUBufferBinding :: struct {
    buffer: *SDL_GPUBuffer;
    offset: Uint32;
}
SDL_GPUTextureSamplerBinding :: struct {
    texture: *SDL_GPUTexture;
    sampler: *SDL_GPUSampler;
}
SDL_GPUStorageBufferReadWriteBinding :: struct {
    buffer:   *SDL_GPUBuffer;
    cycle:    bool;
    padding1: Uint8;
    padding2: Uint8;
    padding3: Uint8;
}
SDL_GPUStorageTextureReadWriteBinding :: struct {
    texture:   *SDL_GPUTexture;
    mip_level: Uint32;
    layer:     Uint32;
    cycle:     bool;
    padding1:  Uint8;
    padding2:  Uint8;
    padding3:  Uint8;
}
SDL_GPUSupportsShaderFormats :: (format_flags: SDL_GPUShaderFormat, name: *u8) -> bool #foreign sdl3;
SDL_GPUSupportsProperties :: (props: SDL_PropertiesID) -> bool #foreign sdl3;
SDL_CreateGPUDevice :: (format_flags: SDL_GPUShaderFormat, debug_mode: bool, name: *u8) -> *SDL_GPUDevice #foreign sdl3;
SDL_CreateGPUDeviceWithProperties :: (props: SDL_PropertiesID) -> *SDL_GPUDevice #foreign sdl3;
SDL_DestroyGPUDevice :: (device: *SDL_GPUDevice) -> void #foreign sdl3;
SDL_GetNumGPUDrivers :: () -> s32 #foreign sdl3;
SDL_GetGPUDriver :: (index: s32) -> *u8 #foreign sdl3;
SDL_GetGPUDeviceDriver :: (device: *SDL_GPUDevice) -> *u8 #foreign sdl3;
SDL_GetGPUShaderFormats :: (device: *SDL_GPUDevice) -> SDL_GPUShaderFormat #foreign sdl3;
SDL_CreateGPUComputePipeline :: (device: *SDL_GPUDevice, createinfo: *SDL_GPUComputePipelineCreateInfo) -> *SDL_GPUComputePipeline #foreign sdl3;
SDL_CreateGPUGraphicsPipeline :: (device: *SDL_GPUDevice, createinfo: *SDL_GPUGraphicsPipelineCreateInfo) -> *SDL_GPUGraphicsPipeline #foreign sdl3;
SDL_CreateGPUSampler :: (device: *SDL_GPUDevice, createinfo: *SDL_GPUSamplerCreateInfo) -> *SDL_GPUSampler #foreign sdl3;
SDL_CreateGPUShader :: (device: *SDL_GPUDevice, createinfo: *SDL_GPUShaderCreateInfo) -> *SDL_GPUShader #foreign sdl3;
SDL_CreateGPUTexture :: (device: *SDL_GPUDevice, createinfo: *SDL_GPUTextureCreateInfo) -> *SDL_GPUTexture #foreign sdl3;
SDL_CreateGPUBuffer :: (device: *SDL_GPUDevice, createinfo: *SDL_GPUBufferCreateInfo) -> *SDL_GPUBuffer #foreign sdl3;
SDL_CreateGPUTransferBuffer :: (device: *SDL_GPUDevice, createinfo: *SDL_GPUTransferBufferCreateInfo) -> *SDL_GPUTransferBuffer #foreign sdl3;
SDL_SetGPUBufferName :: (device: *SDL_GPUDevice, buffer: *SDL_GPUBuffer, text: *u8) -> void #foreign sdl3;
SDL_SetGPUTextureName :: (device: *SDL_GPUDevice, texture: *SDL_GPUTexture, text: *u8) -> void #foreign sdl3;
SDL_InsertGPUDebugLabel :: (command_buffer: *SDL_GPUCommandBuffer, text: *u8) -> void #foreign sdl3;
SDL_PushGPUDebugGroup :: (command_buffer: *SDL_GPUCommandBuffer, name: *u8) -> void #foreign sdl3;
SDL_PopGPUDebugGroup :: (command_buffer: *SDL_GPUCommandBuffer) -> void #foreign sdl3;
SDL_ReleaseGPUTexture :: (device: *SDL_GPUDevice, texture: *SDL_GPUTexture) -> void #foreign sdl3;
SDL_ReleaseGPUSampler :: (device: *SDL_GPUDevice, sampler: *SDL_GPUSampler) -> void #foreign sdl3;
SDL_ReleaseGPUBuffer :: (device: *SDL_GPUDevice, buffer: *SDL_GPUBuffer) -> void #foreign sdl3;
SDL_ReleaseGPUTransferBuffer :: (device: *SDL_GPUDevice, transfer_buffer: *SDL_GPUTransferBuffer) -> void #foreign sdl3;
SDL_ReleaseGPUComputePipeline :: (device: *SDL_GPUDevice, compute_pipeline: *SDL_GPUComputePipeline) -> void #foreign sdl3;
SDL_ReleaseGPUShader :: (device: *SDL_GPUDevice, shader: *SDL_GPUShader) -> void #foreign sdl3;
SDL_ReleaseGPUGraphicsPipeline :: (device: *SDL_GPUDevice, graphics_pipeline: *SDL_GPUGraphicsPipeline) -> void #foreign sdl3;
SDL_AcquireGPUCommandBuffer :: (device: *SDL_GPUDevice) -> *SDL_GPUCommandBuffer #foreign sdl3;
SDL_PushGPUVertexUniformData :: (command_buffer: *SDL_GPUCommandBuffer, slot_index: Uint32, data: *void, length: Uint32) -> void #foreign sdl3;
SDL_PushGPUFragmentUniformData :: (command_buffer: *SDL_GPUCommandBuffer, slot_index: Uint32, data: *void, length: Uint32) -> void #foreign sdl3;
SDL_PushGPUComputeUniformData :: (command_buffer: *SDL_GPUCommandBuffer, slot_index: Uint32, data: *void, length: Uint32) -> void #foreign sdl3;
SDL_BeginGPURenderPass :: (command_buffer: *SDL_GPUCommandBuffer, color_target_infos: *SDL_GPUColorTargetInfo, num_color_targets: Uint32, depth_stencil_target_info: *SDL_GPUDepthStencilTargetInfo) -> *SDL_GPURenderPass #foreign sdl3;
SDL_BindGPUGraphicsPipeline :: (render_pass: *SDL_GPURenderPass, graphics_pipeline: *SDL_GPUGraphicsPipeline) -> void #foreign sdl3;
SDL_SetGPUViewport :: (render_pass: *SDL_GPURenderPass, viewport: *SDL_GPUViewport) -> void #foreign sdl3;
SDL_SetGPUScissor :: (render_pass: *SDL_GPURenderPass, scissor: *SDL_Rect) -> void #foreign sdl3;
SDL_SetGPUBlendConstants :: (render_pass: *SDL_GPURenderPass, blend_constants: SDL_FColor) -> void #foreign sdl3;
SDL_SetGPUStencilReference :: (render_pass: *SDL_GPURenderPass, reference: Uint8) -> void #foreign sdl3;
SDL_BindGPUVertexBuffers :: (render_pass: *SDL_GPURenderPass, first_slot: Uint32, bindings: *SDL_GPUBufferBinding, num_bindings: Uint32) -> void #foreign sdl3;
SDL_BindGPUIndexBuffer :: (render_pass: *SDL_GPURenderPass, binding: *SDL_GPUBufferBinding, index_element_size: SDL_GPUIndexElementSize) -> void #foreign sdl3;
SDL_BindGPUVertexSamplers :: (render_pass: *SDL_GPURenderPass, first_slot: Uint32, texture_sampler_bindings: *SDL_GPUTextureSamplerBinding, num_bindings: Uint32) -> void #foreign sdl3;
SDL_BindGPUVertexStorageTextures :: (render_pass: *SDL_GPURenderPass, first_slot: Uint32, storage_textures: **SDL_GPUTexture, num_bindings: Uint32) -> void #foreign sdl3;
SDL_BindGPUVertexStorageBuffers :: (render_pass: *SDL_GPURenderPass, first_slot: Uint32, storage_buffers: **SDL_GPUBuffer, num_bindings: Uint32) -> void #foreign sdl3;
SDL_BindGPUFragmentSamplers :: (render_pass: *SDL_GPURenderPass, first_slot: Uint32, texture_sampler_bindings: *SDL_GPUTextureSamplerBinding, num_bindings: Uint32) -> void #foreign sdl3;
SDL_BindGPUFragmentStorageTextures :: (render_pass: *SDL_GPURenderPass, first_slot: Uint32, storage_textures: **SDL_GPUTexture, num_bindings: Uint32) -> void #foreign sdl3;
SDL_BindGPUFragmentStorageBuffers :: (render_pass: *SDL_GPURenderPass, first_slot: Uint32, storage_buffers: **SDL_GPUBuffer, num_bindings: Uint32) -> void #foreign sdl3;
SDL_DrawGPUIndexedPrimitives :: (render_pass: *SDL_GPURenderPass, num_indices: Uint32, num_instances: Uint32, first_index: Uint32, vertex_offset: Sint32, first_instance: Uint32) -> void #foreign sdl3;
SDL_DrawGPUPrimitives :: (render_pass: *SDL_GPURenderPass, num_vertices: Uint32, num_instances: Uint32, first_vertex: Uint32, first_instance: Uint32) -> void #foreign sdl3;
SDL_DrawGPUPrimitivesIndirect :: (render_pass: *SDL_GPURenderPass, buffer: *SDL_GPUBuffer, offset: Uint32, draw_count: Uint32) -> void #foreign sdl3;
SDL_DrawGPUIndexedPrimitivesIndirect :: (render_pass: *SDL_GPURenderPass, buffer: *SDL_GPUBuffer, offset: Uint32, draw_count: Uint32) -> void #foreign sdl3;
SDL_EndGPURenderPass :: (render_pass: *SDL_GPURenderPass) -> void #foreign sdl3;
SDL_BeginGPUComputePass :: (command_buffer: *SDL_GPUCommandBuffer, storage_texture_bindings: *SDL_GPUStorageTextureReadWriteBinding, num_storage_texture_bindings: Uint32, storage_buffer_bindings: *SDL_GPUStorageBufferReadWriteBinding, num_storage_buffer_bindings: Uint32) -> *SDL_GPUComputePass #foreign sdl3;
SDL_BindGPUComputePipeline :: (compute_pass: *SDL_GPUComputePass, compute_pipeline: *SDL_GPUComputePipeline) -> void #foreign sdl3;
SDL_BindGPUComputeSamplers :: (compute_pass: *SDL_GPUComputePass, first_slot: Uint32, texture_sampler_bindings: *SDL_GPUTextureSamplerBinding, num_bindings: Uint32) -> void #foreign sdl3;
SDL_BindGPUComputeStorageTextures :: (compute_pass: *SDL_GPUComputePass, first_slot: Uint32, storage_textures: **SDL_GPUTexture, num_bindings: Uint32) -> void #foreign sdl3;
SDL_BindGPUComputeStorageBuffers :: (compute_pass: *SDL_GPUComputePass, first_slot: Uint32, storage_buffers: **SDL_GPUBuffer, num_bindings: Uint32) -> void #foreign sdl3;
SDL_DispatchGPUCompute :: (compute_pass: *SDL_GPUComputePass, groupcount_x: Uint32, groupcount_y: Uint32, groupcount_z: Uint32) -> void #foreign sdl3;
SDL_DispatchGPUComputeIndirect :: (compute_pass: *SDL_GPUComputePass, buffer: *SDL_GPUBuffer, offset: Uint32) -> void #foreign sdl3;
SDL_EndGPUComputePass :: (compute_pass: *SDL_GPUComputePass) -> void #foreign sdl3;
SDL_MapGPUTransferBuffer :: (device: *SDL_GPUDevice, transfer_buffer: *SDL_GPUTransferBuffer, cycle: bool) -> *void #foreign sdl3;
SDL_UnmapGPUTransferBuffer :: (device: *SDL_GPUDevice, transfer_buffer: *SDL_GPUTransferBuffer) -> void #foreign sdl3;
SDL_BeginGPUCopyPass :: (command_buffer: *SDL_GPUCommandBuffer) -> *SDL_GPUCopyPass #foreign sdl3;
SDL_UploadToGPUTexture :: (copy_pass: *SDL_GPUCopyPass, source: *SDL_GPUTextureTransferInfo, destination: *SDL_GPUTextureRegion, cycle: bool) -> void #foreign sdl3;
SDL_UploadToGPUBuffer :: (copy_pass: *SDL_GPUCopyPass, source: *SDL_GPUTransferBufferLocation, destination: *SDL_GPUBufferRegion, cycle: bool) -> void #foreign sdl3;
SDL_CopyGPUTextureToTexture :: (copy_pass: *SDL_GPUCopyPass, source: *SDL_GPUTextureLocation, destination: *SDL_GPUTextureLocation, w: Uint32, h: Uint32, d: Uint32, cycle: bool) -> void #foreign sdl3;
SDL_CopyGPUBufferToBuffer :: (copy_pass: *SDL_GPUCopyPass, source: *SDL_GPUBufferLocation, destination: *SDL_GPUBufferLocation, size: Uint32, cycle: bool) -> void #foreign sdl3;
SDL_DownloadFromGPUTexture :: (copy_pass: *SDL_GPUCopyPass, source: *SDL_GPUTextureRegion, destination: *SDL_GPUTextureTransferInfo) -> void #foreign sdl3;
SDL_DownloadFromGPUBuffer :: (copy_pass: *SDL_GPUCopyPass, source: *SDL_GPUBufferRegion, destination: *SDL_GPUTransferBufferLocation) -> void #foreign sdl3;
SDL_EndGPUCopyPass :: (copy_pass: *SDL_GPUCopyPass) -> void #foreign sdl3;
SDL_GenerateMipmapsForGPUTexture :: (command_buffer: *SDL_GPUCommandBuffer, texture: *SDL_GPUTexture) -> void #foreign sdl3;
SDL_BlitGPUTexture :: (command_buffer: *SDL_GPUCommandBuffer, info: *SDL_GPUBlitInfo) -> void #foreign sdl3;
SDL_WindowSupportsGPUSwapchainComposition :: (device: *SDL_GPUDevice, window: *SDL_Window, swapchain_composition: SDL_GPUSwapchainComposition) -> bool #foreign sdl3;
SDL_WindowSupportsGPUPresentMode :: (device: *SDL_GPUDevice, window: *SDL_Window, present_mode: SDL_GPUPresentMode) -> bool #foreign sdl3;
SDL_ClaimWindowForGPUDevice :: (device: *SDL_GPUDevice, window: *SDL_Window) -> bool #foreign sdl3;
SDL_ReleaseWindowFromGPUDevice :: (device: *SDL_GPUDevice, window: *SDL_Window) -> void #foreign sdl3;
SDL_SetGPUSwapchainParameters :: (device: *SDL_GPUDevice, window: *SDL_Window, swapchain_composition: SDL_GPUSwapchainComposition, present_mode: SDL_GPUPresentMode) -> bool #foreign sdl3;
SDL_GetGPUSwapchainTextureFormat :: (device: *SDL_GPUDevice, window: *SDL_Window) -> SDL_GPUTextureFormat #foreign sdl3;
SDL_AcquireGPUSwapchainTexture :: (command_buffer: *SDL_GPUCommandBuffer, window: *SDL_Window, swapchain_texture: **SDL_GPUTexture, swapchain_texture_width: *Uint32, swapchain_texture_height: *Uint32) -> bool #foreign sdl3;
SDL_SubmitGPUCommandBuffer :: (command_buffer: *SDL_GPUCommandBuffer) -> bool #foreign sdl3;
SDL_SubmitGPUCommandBufferAndAcquireFence :: (command_buffer: *SDL_GPUCommandBuffer) -> *SDL_GPUFence #foreign sdl3;
SDL_CancelGPUCommandBuffer :: (command_buffer: *SDL_GPUCommandBuffer) -> bool #foreign sdl3;
SDL_WaitForGPUIdle :: (device: *SDL_GPUDevice) -> bool #foreign sdl3;
SDL_WaitForGPUFences :: (device: *SDL_GPUDevice, wait_all: bool, fences: **SDL_GPUFence, num_fences: Uint32) -> bool #foreign sdl3;
SDL_QueryGPUFence :: (device: *SDL_GPUDevice, fence: *SDL_GPUFence) -> bool #foreign sdl3;
SDL_ReleaseGPUFence :: (device: *SDL_GPUDevice, fence: *SDL_GPUFence) -> void #foreign sdl3;
SDL_GPUTextureFormatTexelBlockSize :: (format: SDL_GPUTextureFormat) -> Uint32 #foreign sdl3;
SDL_GPUTextureSupportsFormat :: (device: *SDL_GPUDevice, format: SDL_GPUTextureFormat, type: SDL_GPUTextureType, usage: SDL_GPUTextureUsageFlags) -> bool #foreign sdl3;
SDL_GPUTextureSupportsSampleCount :: (device: *SDL_GPUDevice, format: SDL_GPUTextureFormat, sample_count: SDL_GPUSampleCount) -> bool #foreign sdl3;
SDL_CalculateGPUTextureFormatSize :: (format: SDL_GPUTextureFormat, width: Uint32, height: Uint32, depth_or_layer_count: Uint32) -> Uint32 #foreign sdl3;
SDL_hid_device :: struct {}
SDL_hid_bus_type :: enum u32 {
    UNKNOWN   :: 0;
    USB       :: 1;
    BLUETOOTH :: 2;
    I2C       :: 3;
    SPI       :: 4;

    SDL_HID_API_BUS_UNKNOWN   :: UNKNOWN;
    SDL_HID_API_BUS_USB       :: USB;
    SDL_HID_API_BUS_BLUETOOTH :: BLUETOOTH;
    SDL_HID_API_BUS_I2C       :: I2C;
    SDL_HID_API_BUS_SPI       :: SPI;
}
SDL_hid_device_info :: struct {
    path:                *u8;
    vendor_id:           u16;
    product_id:          u16;
    serial_number:       *s32;
    release_number:      u16;
    manufacturer_string: *s32;
    product_string:      *s32;
    usage_page:          u16;
    usage:               u16;
    interface_number:    s32;
    interface_class:     s32;
    interface_subclass:  s32;
    interface_protocol:  s32;
    bus_type:            SDL_hid_bus_type;
    next:                *SDL_hid_device_info;
}
SDL_hid_init :: () -> s32 #foreign sdl3;
SDL_hid_exit :: () -> s32 #foreign sdl3;
SDL_hid_device_change_count :: () -> Uint32 #foreign sdl3;
SDL_hid_enumerate :: (vendor_id: u16, product_id: u16) -> *SDL_hid_device_info #foreign sdl3;
SDL_hid_free_enumeration :: (devs: *SDL_hid_device_info) -> void #foreign sdl3;
SDL_hid_open :: (vendor_id: u16, product_id: u16, serial_number: *s32) -> *SDL_hid_device #foreign sdl3;
SDL_hid_open_path :: (path: *u8) -> *SDL_hid_device #foreign sdl3;
SDL_hid_write :: (dev: *SDL_hid_device, data: *u8, length: u64) -> s32 #foreign sdl3;
SDL_hid_read_timeout :: (dev: *SDL_hid_device, data: *u8, length: u64, milliseconds: s32) -> s32 #foreign sdl3;
SDL_hid_read :: (dev: *SDL_hid_device, data: *u8, length: u64) -> s32 #foreign sdl3;
SDL_hid_set_nonblocking :: (dev: *SDL_hid_device, nonblock: s32) -> s32 #foreign sdl3;
SDL_hid_send_feature_report :: (dev: *SDL_hid_device, data: *u8, length: u64) -> s32 #foreign sdl3;
SDL_hid_get_feature_report :: (dev: *SDL_hid_device, data: *u8, length: u64) -> s32 #foreign sdl3;
SDL_hid_get_input_report :: (dev: *SDL_hid_device, data: *u8, length: u64) -> s32 #foreign sdl3;
SDL_hid_close :: (dev: *SDL_hid_device) -> s32 #foreign sdl3;
SDL_hid_get_manufacturer_string :: (dev: *SDL_hid_device, _string: *s32, maxlen: u64) -> s32 #foreign sdl3;
SDL_hid_get_product_string :: (dev: *SDL_hid_device, _string: *s32, maxlen: u64) -> s32 #foreign sdl3;
SDL_hid_get_serial_number_string :: (dev: *SDL_hid_device, _string: *s32, maxlen: u64) -> s32 #foreign sdl3;
SDL_hid_get_indexed_string :: (dev: *SDL_hid_device, string_index: s32, _string: *s32, maxlen: u64) -> s32 #foreign sdl3;
SDL_hid_get_device_info :: (dev: *SDL_hid_device) -> *SDL_hid_device_info #foreign sdl3;
SDL_hid_get_report_descriptor :: (dev: *SDL_hid_device, buf: *u8, buf_size: u64) -> s32 #foreign sdl3;
SDL_hid_ble_scan :: (active: bool) -> void #foreign sdl3;
SDL_InitFlags :: Uint32;
SDL_AppResult :: enum u32 {
    CONTINUE :: 0;
    SUCCESS  :: 1;
    FAILURE  :: 2;

    SDL_APP_CONTINUE :: CONTINUE;
    SDL_APP_SUCCESS  :: SUCCESS;
    SDL_APP_FAILURE  :: FAILURE;
}
SDL_AppInit_func :: #type (appstate: **void, argc: s32, argv: **u8) -> SDL_AppResult #c_call;
SDL_AppIterate_func :: #type (appstate: *void) -> SDL_AppResult #c_call;
SDL_AppEvent_func :: #type (appstate: *void, event: *SDL_Event) -> SDL_AppResult #c_call;
SDL_AppQuit_func :: #type (appstate: *void, result: SDL_AppResult) -> void #c_call;
SDL_Init :: (flags: SDL_InitFlags) -> bool #foreign sdl3;
SDL_InitSubSystem :: (flags: SDL_InitFlags) -> bool #foreign sdl3;
SDL_QuitSubSystem :: (flags: SDL_InitFlags) -> void #foreign sdl3;
SDL_WasInit :: (flags: SDL_InitFlags) -> SDL_InitFlags #foreign sdl3;
SDL_Quit :: () -> void #foreign sdl3;
SDL_SetAppMetadata :: (appname: *u8, appversion: *u8, appidentifier: *u8) -> bool #foreign sdl3;
SDL_SetAppMetadataProperty :: (name: *u8, value: *u8) -> bool #foreign sdl3;
SDL_GetAppMetadataProperty :: (name: *u8) -> *u8 #foreign sdl3;
SDL_SharedObject :: struct {}
SDL_LoadObject :: (sofile: *u8) -> *SDL_SharedObject #foreign sdl3;
SDL_LoadFunction :: (handle: *SDL_SharedObject, name: *u8) -> SDL_FunctionPointer #foreign sdl3;
SDL_UnloadObject :: (handle: *SDL_SharedObject) -> void #foreign sdl3;
SDL_Locale :: struct {
    language: *u8;
    country:  *u8;
}
SDL_GetPreferredLocales :: (count: *s32) -> **SDL_Locale #foreign sdl3;
SDL_LogCategory :: enum u32 {
    APPLICATION :: 0;
    ERROR       :: 1;
    ASSERT      :: 2;
    SYSTEM      :: 3;
    AUDIO       :: 4;
    VIDEO       :: 5;
    RENDER      :: 6;
    INPUT       :: 7;
    TEST        :: 8;
    GPU         :: 9;
    RESERVED2   :: 10;
    RESERVED3   :: 11;
    RESERVED4   :: 12;
    RESERVED5   :: 13;
    RESERVED6   :: 14;
    RESERVED7   :: 15;
    RESERVED8   :: 16;
    RESERVED9   :: 17;
    RESERVED10  :: 18;
    CUSTOM      :: 19;

    SDL_LOG_CATEGORY_APPLICATION :: APPLICATION;
    SDL_LOG_CATEGORY_ERROR       :: ERROR;
    SDL_LOG_CATEGORY_ASSERT      :: ASSERT;
    SDL_LOG_CATEGORY_SYSTEM      :: SYSTEM;
    SDL_LOG_CATEGORY_AUDIO       :: AUDIO;
    SDL_LOG_CATEGORY_VIDEO       :: VIDEO;
    SDL_LOG_CATEGORY_RENDER      :: RENDER;
    SDL_LOG_CATEGORY_INPUT       :: INPUT;
    SDL_LOG_CATEGORY_TEST        :: TEST;
    SDL_LOG_CATEGORY_GPU         :: GPU;
    SDL_LOG_CATEGORY_RESERVED2   :: RESERVED2;
    SDL_LOG_CATEGORY_RESERVED3   :: RESERVED3;
    SDL_LOG_CATEGORY_RESERVED4   :: RESERVED4;
    SDL_LOG_CATEGORY_RESERVED5   :: RESERVED5;
    SDL_LOG_CATEGORY_RESERVED6   :: RESERVED6;
    SDL_LOG_CATEGORY_RESERVED7   :: RESERVED7;
    SDL_LOG_CATEGORY_RESERVED8   :: RESERVED8;
    SDL_LOG_CATEGORY_RESERVED9   :: RESERVED9;
    SDL_LOG_CATEGORY_RESERVED10  :: RESERVED10;
    SDL_LOG_CATEGORY_CUSTOM      :: CUSTOM;
}
SDL_LogPriority :: enum u32 {
    INVALID  :: 0;
    TRACE    :: 1;
    VERBOSE  :: 2;
    DEBUG    :: 3;
    INFO     :: 4;
    WARN     :: 5;
    ERROR    :: 6;
    CRITICAL :: 7;
    COUNT    :: 8;

    SDL_LOG_PRIORITY_INVALID  :: INVALID;
    SDL_LOG_PRIORITY_TRACE    :: TRACE;
    SDL_LOG_PRIORITY_VERBOSE  :: VERBOSE;
    SDL_LOG_PRIORITY_DEBUG    :: DEBUG;
    SDL_LOG_PRIORITY_INFO     :: INFO;
    SDL_LOG_PRIORITY_WARN     :: WARN;
    SDL_LOG_PRIORITY_ERROR    :: ERROR;
    SDL_LOG_PRIORITY_CRITICAL :: CRITICAL;
    SDL_LOG_PRIORITY_COUNT    :: COUNT;
}
SDL_SetLogPriorities :: (priority: SDL_LogPriority) -> void #foreign sdl3;
SDL_SetLogPriority :: (category: SDL_LogCategory, priority: SDL_LogPriority) -> void #foreign sdl3;
SDL_GetLogPriority :: (category: SDL_LogCategory) -> SDL_LogPriority #foreign sdl3;
SDL_ResetLogPriorities :: () -> void #foreign sdl3;
SDL_SetLogPriorityPrefix :: (priority: SDL_LogPriority, prefix: *u8) -> bool #foreign sdl3;
SDL_Log_CFormat :: (fmt: *u8, __args: ..Any) -> void #foreign sdl3 "SDL_Log";
SDL_Log :: (fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    SDL_Log_CFormat("%s", formatted_text.data);
} @PrintLike
SDL_LogTrace_CFormat :: (category: SDL_LogCategory, fmt: *u8, __args: ..Any) -> void #foreign sdl3 "SDL_LogTrace";
SDL_LogTrace :: (category: SDL_LogCategory, fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    SDL_LogTrace_CFormat(category, "%s", formatted_text.data);
} @PrintLike
SDL_LogVerbose_CFormat :: (category: SDL_LogCategory, fmt: *u8, __args: ..Any) -> void #foreign sdl3 "SDL_LogVerbose";
SDL_LogVerbose :: (category: SDL_LogCategory, fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    SDL_LogVerbose_CFormat(category, "%s", formatted_text.data);
} @PrintLike
SDL_LogDebug_CFormat :: (category: SDL_LogCategory, fmt: *u8, __args: ..Any) -> void #foreign sdl3 "SDL_LogDebug";
SDL_LogDebug :: (category: SDL_LogCategory, fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    SDL_LogDebug_CFormat(category, "%s", formatted_text.data);
} @PrintLike
SDL_LogInfo_CFormat :: (category: SDL_LogCategory, fmt: *u8, __args: ..Any) -> void #foreign sdl3 "SDL_LogInfo";
SDL_LogInfo :: (category: SDL_LogCategory, fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    SDL_LogInfo_CFormat(category, "%s", formatted_text.data);
} @PrintLike
SDL_LogWarn_CFormat :: (category: SDL_LogCategory, fmt: *u8, __args: ..Any) -> void #foreign sdl3 "SDL_LogWarn";
SDL_LogWarn :: (category: SDL_LogCategory, fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    SDL_LogWarn_CFormat(category, "%s", formatted_text.data);
} @PrintLike
SDL_LogError_CFormat :: (category: SDL_LogCategory, fmt: *u8, __args: ..Any) -> void #foreign sdl3 "SDL_LogError";
SDL_LogError :: (category: SDL_LogCategory, fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    SDL_LogError_CFormat(category, "%s", formatted_text.data);
} @PrintLike
SDL_LogCritical_CFormat :: (category: SDL_LogCategory, fmt: *u8, __args: ..Any) -> void #foreign sdl3 "SDL_LogCritical";
SDL_LogCritical :: (category: SDL_LogCategory, fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    SDL_LogCritical_CFormat(category, "%s", formatted_text.data);
} @PrintLike
SDL_LogMessage_CFormat :: (category: SDL_LogCategory, priority: SDL_LogPriority, fmt: *u8, __args: ..Any) -> void #foreign sdl3 "SDL_LogMessage";
SDL_LogMessage :: (category: SDL_LogCategory, priority: SDL_LogPriority, fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    SDL_LogMessage_CFormat(category, priority, "%s", formatted_text.data);
} @PrintLike
SDL_LogOutputFunction :: #type (userdata: *void, category: SDL_LogCategory, priority: SDL_LogPriority, message: *u8) -> void #c_call;
SDL_GetDefaultLogOutputFunction :: () -> SDL_LogOutputFunction #foreign sdl3;
SDL_GetLogOutputFunction :: (callback: *SDL_LogOutputFunction, userdata: **void) -> void #foreign sdl3;
SDL_SetLogOutputFunction :: (callback: SDL_LogOutputFunction, userdata: *void) -> void #foreign sdl3;
SDL_main_func :: #type (argc: s32, argv: **u8) -> s32 #c_call;
SDL_SetMainReady :: () -> void #foreign sdl3;
SDL_RunApp :: (argc: s32, argv: **u8, mainFunction: SDL_main_func, reserved: *void) -> s32 #foreign sdl3;
SDL_EnterAppMainCallbacks :: (argc: s32, argv: **u8, appinit: SDL_AppInit_func, appiter: SDL_AppIterate_func, appevent: SDL_AppEvent_func, appquit: SDL_AppQuit_func) -> s32 #foreign sdl3;
SDL_MessageBoxFlags :: Uint32;
SDL_MessageBoxButtonFlags :: Uint32;
SDL_MessageBoxButtonData :: struct {
    flags:    SDL_MessageBoxButtonFlags;
    buttonID: s32;
    text:     *u8;
}
SDL_MessageBoxColor :: struct {
    r: Uint8;
    g: Uint8;
    b: Uint8;
}
SDL_MessageBoxColorType :: enum u32 {
    BACKGROUND        :: 0;
    TEXT              :: 1;
    BUTTON_BORDER     :: 2;
    BUTTON_BACKGROUND :: 3;
    BUTTON_SELECTED   :: 4;
    COUNT             :: 5;

    SDL_MESSAGEBOX_COLOR_BACKGROUND        :: BACKGROUND;
    SDL_MESSAGEBOX_COLOR_TEXT              :: TEXT;
    SDL_MESSAGEBOX_COLOR_BUTTON_BORDER     :: BUTTON_BORDER;
    SDL_MESSAGEBOX_COLOR_BUTTON_BACKGROUND :: BUTTON_BACKGROUND;
    SDL_MESSAGEBOX_COLOR_BUTTON_SELECTED   :: BUTTON_SELECTED;
    SDL_MESSAGEBOX_COLOR_COUNT             :: COUNT;
}
SDL_MessageBoxColorScheme :: struct {
    colors: [5] SDL_MessageBoxColor;
}
SDL_MessageBoxData :: struct {
    flags:       SDL_MessageBoxFlags;
    window:      *SDL_Window;
    title:       *u8;
    message:     *u8;
    numbuttons:  s32;
    buttons:     *SDL_MessageBoxButtonData;
    colorScheme: *SDL_MessageBoxColorScheme;
}
SDL_ShowMessageBox :: (messageboxdata: *SDL_MessageBoxData, buttonid: *s32) -> bool #foreign sdl3;
SDL_ShowSimpleMessageBox :: (flags: SDL_MessageBoxFlags, title: *u8, message: *u8, window: *SDL_Window) -> bool #foreign sdl3;
SDL_MetalView :: *void;
SDL_Metal_CreateView :: (window: *SDL_Window) -> SDL_MetalView #foreign sdl3;
SDL_Metal_DestroyView :: (view: SDL_MetalView) -> void #foreign sdl3;
SDL_Metal_GetLayer :: (view: SDL_MetalView) -> *void #foreign sdl3;
SDL_OpenURL :: (url: *u8) -> bool #foreign sdl3;
SDL_GetPlatform :: () -> *u8 #foreign sdl3;
SDL_Process :: struct {}
SDL_CreateProcess :: (args: **u8, pipe_stdio: bool) -> *SDL_Process #foreign sdl3;
SDL_ProcessIO :: enum u32 {
    INHERITED :: 0;
    NULL      :: 1;
    APP       :: 2;
    REDIRECT  :: 3;

    SDL_PROCESS_STDIO_INHERITED :: INHERITED;
    SDL_PROCESS_STDIO_NULL      :: NULL;
    SDL_PROCESS_STDIO_APP       :: APP;
    SDL_PROCESS_STDIO_REDIRECT  :: REDIRECT;
}
SDL_CreateProcessWithProperties :: (props: SDL_PropertiesID) -> *SDL_Process #foreign sdl3;
SDL_GetProcessProperties :: (process: *SDL_Process) -> SDL_PropertiesID #foreign sdl3;
SDL_ReadProcess :: (process: *SDL_Process, datasize: *u64, exitcode: *s32) -> *void #foreign sdl3;
SDL_GetProcessInput :: (process: *SDL_Process) -> *SDL_IOStream #foreign sdl3;
SDL_GetProcessOutput :: (process: *SDL_Process) -> *SDL_IOStream #foreign sdl3;
SDL_KillProcess :: (process: *SDL_Process, force: bool) -> bool #foreign sdl3;
SDL_WaitProcess :: (process: *SDL_Process, block: bool, exitcode: *s32) -> bool #foreign sdl3;
SDL_DestroyProcess :: (process: *SDL_Process) -> void #foreign sdl3;
SDL_Vertex :: struct {
    position:  SDL_FPoint;
    color:     SDL_FColor;
    tex_coord: SDL_FPoint;
}
SDL_TextureAccess :: enum u32 {
    STATIC    :: 0;
    STREAMING :: 1;
    TARGET    :: 2;

    SDL_TEXTUREACCESS_STATIC    :: STATIC;
    SDL_TEXTUREACCESS_STREAMING :: STREAMING;
    SDL_TEXTUREACCESS_TARGET    :: TARGET;
}
SDL_RendererLogicalPresentation :: enum u32 {
    DISABLED      :: 0;
    STRETCH       :: 1;
    LETTERBOX     :: 2;
    OVERSCAN      :: 3;
    INTEGER_SCALE :: 4;

    SDL_LOGICAL_PRESENTATION_DISABLED      :: DISABLED;
    SDL_LOGICAL_PRESENTATION_STRETCH       :: STRETCH;
    SDL_LOGICAL_PRESENTATION_LETTERBOX     :: LETTERBOX;
    SDL_LOGICAL_PRESENTATION_OVERSCAN      :: OVERSCAN;
    SDL_LOGICAL_PRESENTATION_INTEGER_SCALE :: INTEGER_SCALE;
}
SDL_Renderer :: struct {}
SDL_Texture :: struct {
    format:   SDL_PixelFormat;
    w:        s32;
    h:        s32;
    refcount: s32;
}
SDL_GetNumRenderDrivers :: () -> s32 #foreign sdl3;
SDL_GetRenderDriver :: (index: s32) -> *u8 #foreign sdl3;
SDL_CreateWindowAndRenderer :: (title: *u8, width: s32, height: s32, window_flags: SDL_WindowFlags, window: **SDL_Window, renderer: **SDL_Renderer) -> bool #foreign sdl3;
SDL_CreateRenderer :: (window: *SDL_Window, name: *u8) -> *SDL_Renderer #foreign sdl3;
SDL_CreateRendererWithProperties :: (props: SDL_PropertiesID) -> *SDL_Renderer #foreign sdl3;
SDL_CreateSoftwareRenderer :: (surface: *SDL_Surface) -> *SDL_Renderer #foreign sdl3;
SDL_GetRenderer :: (window: *SDL_Window) -> *SDL_Renderer #foreign sdl3;
SDL_GetRenderWindow :: (renderer: *SDL_Renderer) -> *SDL_Window #foreign sdl3;
SDL_GetRendererName :: (renderer: *SDL_Renderer) -> *u8 #foreign sdl3;
SDL_GetRendererProperties :: (renderer: *SDL_Renderer) -> SDL_PropertiesID #foreign sdl3;
SDL_GetRenderOutputSize :: (renderer: *SDL_Renderer, w: *s32, h: *s32) -> bool #foreign sdl3;
SDL_GetCurrentRenderOutputSize :: (renderer: *SDL_Renderer, w: *s32, h: *s32) -> bool #foreign sdl3;
SDL_CreateTexture :: (renderer: *SDL_Renderer, format: SDL_PixelFormat, access: SDL_TextureAccess, w: s32, h: s32) -> *SDL_Texture #foreign sdl3;
SDL_CreateTextureFromSurface :: (renderer: *SDL_Renderer, surface: *SDL_Surface) -> *SDL_Texture #foreign sdl3;
SDL_CreateTextureWithProperties :: (renderer: *SDL_Renderer, props: SDL_PropertiesID) -> *SDL_Texture #foreign sdl3;
SDL_GetTextureProperties :: (texture: *SDL_Texture) -> SDL_PropertiesID #foreign sdl3;
SDL_GetRendererFromTexture :: (texture: *SDL_Texture) -> *SDL_Renderer #foreign sdl3;
SDL_GetTextureSize :: (texture: *SDL_Texture, w: *float, h: *float) -> bool #foreign sdl3;
SDL_SetTextureColorMod :: (texture: *SDL_Texture, r: Uint8, g: Uint8, b: Uint8) -> bool #foreign sdl3;
SDL_SetTextureColorModFloat :: (texture: *SDL_Texture, r: float, g: float, b: float) -> bool #foreign sdl3;
SDL_GetTextureColorMod :: (texture: *SDL_Texture, r: *Uint8, g: *Uint8, b: *Uint8) -> bool #foreign sdl3;
SDL_GetTextureColorModFloat :: (texture: *SDL_Texture, r: *float, g: *float, b: *float) -> bool #foreign sdl3;
SDL_SetTextureAlphaMod :: (texture: *SDL_Texture, alpha: Uint8) -> bool #foreign sdl3;
SDL_SetTextureAlphaModFloat :: (texture: *SDL_Texture, alpha: float) -> bool #foreign sdl3;
SDL_GetTextureAlphaMod :: (texture: *SDL_Texture, alpha: *Uint8) -> bool #foreign sdl3;
SDL_GetTextureAlphaModFloat :: (texture: *SDL_Texture, alpha: *float) -> bool #foreign sdl3;
SDL_SetTextureBlendMode :: (texture: *SDL_Texture, blendMode: SDL_BlendMode) -> bool #foreign sdl3;
SDL_GetTextureBlendMode :: (texture: *SDL_Texture, blendMode: *SDL_BlendMode) -> bool #foreign sdl3;
SDL_SetTextureScaleMode :: (texture: *SDL_Texture, scaleMode: SDL_ScaleMode) -> bool #foreign sdl3;
SDL_GetTextureScaleMode :: (texture: *SDL_Texture, scaleMode: *SDL_ScaleMode) -> bool #foreign sdl3;
SDL_UpdateTexture :: (texture: *SDL_Texture, rect: *SDL_Rect, pixels: *void, pitch: s32) -> bool #foreign sdl3;
SDL_UpdateYUVTexture :: (texture: *SDL_Texture, rect: *SDL_Rect, Yplane: *Uint8, Ypitch: s32, Uplane: *Uint8, Upitch: s32, Vplane: *Uint8, Vpitch: s32) -> bool #foreign sdl3;
SDL_UpdateNVTexture :: (texture: *SDL_Texture, rect: *SDL_Rect, Yplane: *Uint8, Ypitch: s32, UVplane: *Uint8, UVpitch: s32) -> bool #foreign sdl3;
SDL_LockTexture :: (texture: *SDL_Texture, rect: *SDL_Rect, pixels: **void, pitch: *s32) -> bool #foreign sdl3;
SDL_LockTextureToSurface :: (texture: *SDL_Texture, rect: *SDL_Rect, surface: **SDL_Surface) -> bool #foreign sdl3;
SDL_UnlockTexture :: (texture: *SDL_Texture) -> void #foreign sdl3;
SDL_SetRenderTarget :: (renderer: *SDL_Renderer, texture: *SDL_Texture) -> bool #foreign sdl3;
SDL_GetRenderTarget :: (renderer: *SDL_Renderer) -> *SDL_Texture #foreign sdl3;
SDL_SetRenderLogicalPresentation :: (renderer: *SDL_Renderer, w: s32, h: s32, mode: SDL_RendererLogicalPresentation) -> bool #foreign sdl3;
SDL_GetRenderLogicalPresentation :: (renderer: *SDL_Renderer, w: *s32, h: *s32, mode: *SDL_RendererLogicalPresentation) -> bool #foreign sdl3;
SDL_GetRenderLogicalPresentationRect :: (renderer: *SDL_Renderer, rect: *SDL_FRect) -> bool #foreign sdl3;
SDL_RenderCoordinatesFromWindow :: (renderer: *SDL_Renderer, window_x: float, window_y: float, x: *float, y: *float) -> bool #foreign sdl3;
SDL_RenderCoordinatesToWindow :: (renderer: *SDL_Renderer, x: float, y: float, window_x: *float, window_y: *float) -> bool #foreign sdl3;
SDL_ConvertEventToRenderCoordinates :: (renderer: *SDL_Renderer, event: *SDL_Event) -> bool #foreign sdl3;
SDL_SetRenderViewport :: (renderer: *SDL_Renderer, rect: *SDL_Rect) -> bool #foreign sdl3;
SDL_GetRenderViewport :: (renderer: *SDL_Renderer, rect: *SDL_Rect) -> bool #foreign sdl3;
SDL_RenderViewportSet :: (renderer: *SDL_Renderer) -> bool #foreign sdl3;
SDL_GetRenderSafeArea :: (renderer: *SDL_Renderer, rect: *SDL_Rect) -> bool #foreign sdl3;
SDL_SetRenderClipRect :: (renderer: *SDL_Renderer, rect: *SDL_Rect) -> bool #foreign sdl3;
SDL_GetRenderClipRect :: (renderer: *SDL_Renderer, rect: *SDL_Rect) -> bool #foreign sdl3;
SDL_RenderClipEnabled :: (renderer: *SDL_Renderer) -> bool #foreign sdl3;
SDL_SetRenderScale :: (renderer: *SDL_Renderer, scaleX: float, scaleY: float) -> bool #foreign sdl3;
SDL_GetRenderScale :: (renderer: *SDL_Renderer, scaleX: *float, scaleY: *float) -> bool #foreign sdl3;
SDL_SetRenderDrawColor :: (renderer: *SDL_Renderer, r: Uint8, g: Uint8, b: Uint8, a: Uint8) -> bool #foreign sdl3;
SDL_SetRenderDrawColorFloat :: (renderer: *SDL_Renderer, r: float, g: float, b: float, a: float) -> bool #foreign sdl3;
SDL_GetRenderDrawColor :: (renderer: *SDL_Renderer, r: *Uint8, g: *Uint8, b: *Uint8, a: *Uint8) -> bool #foreign sdl3;
SDL_GetRenderDrawColorFloat :: (renderer: *SDL_Renderer, r: *float, g: *float, b: *float, a: *float) -> bool #foreign sdl3;
SDL_SetRenderColorScale :: (renderer: *SDL_Renderer, scale: float) -> bool #foreign sdl3;
SDL_GetRenderColorScale :: (renderer: *SDL_Renderer, scale: *float) -> bool #foreign sdl3;
SDL_SetRenderDrawBlendMode :: (renderer: *SDL_Renderer, blendMode: SDL_BlendMode) -> bool #foreign sdl3;
SDL_GetRenderDrawBlendMode :: (renderer: *SDL_Renderer, blendMode: *SDL_BlendMode) -> bool #foreign sdl3;
SDL_RenderClear :: (renderer: *SDL_Renderer) -> bool #foreign sdl3;
SDL_RenderPoint :: (renderer: *SDL_Renderer, x: float, y: float) -> bool #foreign sdl3;
SDL_RenderPoints :: (renderer: *SDL_Renderer, points: *SDL_FPoint, count: s32) -> bool #foreign sdl3;
SDL_RenderLine :: (renderer: *SDL_Renderer, x1: float, y1: float, x2: float, y2: float) -> bool #foreign sdl3;
SDL_RenderLines :: (renderer: *SDL_Renderer, points: *SDL_FPoint, count: s32) -> bool #foreign sdl3;
SDL_RenderRect :: (renderer: *SDL_Renderer, rect: *SDL_FRect) -> bool #foreign sdl3;
SDL_RenderRects :: (renderer: *SDL_Renderer, rects: *SDL_FRect, count: s32) -> bool #foreign sdl3;
SDL_RenderFillRect :: (renderer: *SDL_Renderer, rect: *SDL_FRect) -> bool #foreign sdl3;
SDL_RenderFillRects :: (renderer: *SDL_Renderer, rects: *SDL_FRect, count: s32) -> bool #foreign sdl3;
SDL_RenderTexture :: (renderer: *SDL_Renderer, texture: *SDL_Texture, srcrect: *SDL_FRect, dstrect: *SDL_FRect) -> bool #foreign sdl3;
SDL_RenderTextureRotated :: (renderer: *SDL_Renderer, texture: *SDL_Texture, srcrect: *SDL_FRect, dstrect: *SDL_FRect, angle: float64, center: *SDL_FPoint, flip: SDL_FlipMode) -> bool #foreign sdl3;
SDL_RenderTextureTiled :: (renderer: *SDL_Renderer, texture: *SDL_Texture, srcrect: *SDL_FRect, scale: float, dstrect: *SDL_FRect) -> bool #foreign sdl3;
SDL_RenderTexture9Grid :: (renderer: *SDL_Renderer, texture: *SDL_Texture, srcrect: *SDL_FRect, left_width: float, right_width: float, top_height: float, bottom_height: float, scale: float, dstrect: *SDL_FRect) -> bool #foreign sdl3;
SDL_RenderGeometry :: (renderer: *SDL_Renderer, texture: *SDL_Texture, vertices: *SDL_Vertex, num_vertices: s32, indices: *s32, num_indices: s32) -> bool #foreign sdl3;
SDL_RenderGeometryRaw :: (renderer: *SDL_Renderer, texture: *SDL_Texture, xy: *float, xy_stride: s32, color: *SDL_FColor, color_stride: s32, uv: *float, uv_stride: s32, num_vertices: s32, indices: *void, num_indices: s32, size_indices: s32) -> bool #foreign sdl3;
SDL_RenderReadPixels :: (renderer: *SDL_Renderer, rect: *SDL_Rect) -> *SDL_Surface #foreign sdl3;
SDL_RenderPresent :: (renderer: *SDL_Renderer) -> bool #foreign sdl3;
SDL_DestroyTexture :: (texture: *SDL_Texture) -> void #foreign sdl3;
SDL_DestroyRenderer :: (renderer: *SDL_Renderer) -> void #foreign sdl3;
SDL_FlushRenderer :: (renderer: *SDL_Renderer) -> bool #foreign sdl3;
SDL_GetRenderMetalLayer :: (renderer: *SDL_Renderer) -> *void #foreign sdl3;
SDL_GetRenderMetalCommandEncoder :: (renderer: *SDL_Renderer) -> *void #foreign sdl3;
SDL_AddVulkanRenderSemaphores :: (renderer: *SDL_Renderer, wait_stage_mask: Uint32, wait_semaphore: Sint64, signal_semaphore: Sint64) -> bool #foreign sdl3;
SDL_SetRenderVSync :: (renderer: *SDL_Renderer, vsync: s32) -> bool #foreign sdl3;
SDL_GetRenderVSync :: (renderer: *SDL_Renderer, vsync: *s32) -> bool #foreign sdl3;
SDL_RenderDebugText :: (renderer: *SDL_Renderer, x: float, y: float, str: *u8) -> bool #foreign sdl3;
SDL_StorageInterface :: struct {
    version:         Uint32;
    close:           #type (userdata: *void) -> bool #c_call;
    ready:           #type (userdata: *void) -> bool #c_call;
    enumerate:       #type (userdata: *void, path: *u8, callback: SDL_EnumerateDirectoryCallback, callback_userdata: *void) -> bool #c_call;
    info:            #type (userdata: *void, path: *u8, info: *SDL_PathInfo) -> bool #c_call;
    read_file:       #type (userdata: *void, path: *u8, destination: *void, length: Uint64) -> bool #c_call;
    write_file:      #type (userdata: *void, path: *u8, source: *void, length: Uint64) -> bool #c_call;
    mkdir:           #type (userdata: *void, path: *u8) -> bool #c_call;
    _remove:         #type (userdata: *void, path: *u8) -> bool #c_call;
    rename:          #type (userdata: *void, oldpath: *u8, newpath: *u8) -> bool #c_call;
    copy:            #type (userdata: *void, oldpath: *u8, newpath: *u8) -> bool #c_call;
    space_remaining: #type (userdata: *void) -> Uint64 #c_call;
}
SDL_Storage :: struct {}
SDL_OpenTitleStorage :: (override: *u8, props: SDL_PropertiesID) -> *SDL_Storage #foreign sdl3;
SDL_OpenUserStorage :: (org: *u8, app: *u8, props: SDL_PropertiesID) -> *SDL_Storage #foreign sdl3;
SDL_OpenFileStorage :: (path: *u8) -> *SDL_Storage #foreign sdl3;
SDL_OpenStorage :: (iface: *SDL_StorageInterface, userdata: *void) -> *SDL_Storage #foreign sdl3;
SDL_CloseStorage :: (storage: *SDL_Storage) -> bool #foreign sdl3;
SDL_StorageReady :: (storage: *SDL_Storage) -> bool #foreign sdl3;
SDL_GetStorageFileSize :: (storage: *SDL_Storage, path: *u8, length: *Uint64) -> bool #foreign sdl3;
SDL_ReadStorageFile :: (storage: *SDL_Storage, path: *u8, destination: *void, length: Uint64) -> bool #foreign sdl3;
SDL_WriteStorageFile :: (storage: *SDL_Storage, path: *u8, source: *void, length: Uint64) -> bool #foreign sdl3;
SDL_CreateStorageDirectory :: (storage: *SDL_Storage, path: *u8) -> bool #foreign sdl3;
SDL_EnumerateStorageDirectory :: (storage: *SDL_Storage, path: *u8, callback: SDL_EnumerateDirectoryCallback, userdata: *void) -> bool #foreign sdl3;
SDL_RemoveStoragePath :: (storage: *SDL_Storage, path: *u8) -> bool #foreign sdl3;
SDL_RenameStoragePath :: (storage: *SDL_Storage, oldpath: *u8, newpath: *u8) -> bool #foreign sdl3;
SDL_CopyStorageFile :: (storage: *SDL_Storage, oldpath: *u8, newpath: *u8) -> bool #foreign sdl3;
SDL_GetStoragePathInfo :: (storage: *SDL_Storage, path: *u8, info: *SDL_PathInfo) -> bool #foreign sdl3;
SDL_GetStorageSpaceRemaining :: (storage: *SDL_Storage) -> Uint64 #foreign sdl3;
SDL_GlobStorageDirectory :: (storage: *SDL_Storage, path: *u8, pattern: *u8, flags: SDL_GlobFlags, count: *s32) -> **u8 #foreign sdl3;
_XEvent :: union {}
XEvent :: _XEvent;
SDL_X11EventHook :: #type (userdata: *void, xevent: *XEvent) -> bool #c_call;
SDL_SetX11EventHook :: (callback: SDL_X11EventHook, userdata: *void) -> void #foreign sdl3;
SDL_SetLinuxThreadPriority :: (threadID: Sint64, priority: s32) -> bool #foreign sdl3;
SDL_SetLinuxThreadPriorityAndPolicy :: (threadID: Sint64, sdlPriority: s32, schedPolicy: s32) -> bool #foreign sdl3;
SDL_IsTablet :: () -> bool #foreign sdl3;
SDL_IsTV :: () -> bool #foreign sdl3;
SDL_Sandbox :: enum u32 {
    NONE              :: 0;
    UNKNOWN_CONTAINER :: 1;
    FLATPAK           :: 2;
    SNAP              :: 3;
    MACOS             :: 4;

    SDL_SANDBOX_NONE              :: NONE;
    SDL_SANDBOX_UNKNOWN_CONTAINER :: UNKNOWN_CONTAINER;
    SDL_SANDBOX_FLATPAK           :: FLATPAK;
    SDL_SANDBOX_SNAP              :: SNAP;
    SDL_SANDBOX_MACOS             :: MACOS;
}
SDL_GetSandbox :: () -> SDL_Sandbox #foreign sdl3;
SDL_OnApplicationWillTerminate :: () -> void #foreign sdl3;
SDL_OnApplicationDidReceiveMemoryWarning :: () -> void #foreign sdl3;
SDL_OnApplicationWillEnterBackground :: () -> void #foreign sdl3;
SDL_OnApplicationDidEnterBackground :: () -> void #foreign sdl3;
SDL_OnApplicationWillEnterForeground :: () -> void #foreign sdl3;
SDL_OnApplicationDidEnterForeground :: () -> void #foreign sdl3;
SDL_DateTime :: struct {
    year:        s32;
    month:       s32;
    day:         s32;
    hour:        s32;
    minute:      s32;
    second:      s32;
    nanosecond:  s32;
    day_of_week: s32;
    utc_offset:  s32;
}
SDL_DateFormat :: enum u32 {
    YYYYMMDD :: 0;
    DDMMYYYY :: 1;
    MMDDYYYY :: 2;

    SDL_DATE_FORMAT_YYYYMMDD :: YYYYMMDD;
    SDL_DATE_FORMAT_DDMMYYYY :: DDMMYYYY;
    SDL_DATE_FORMAT_MMDDYYYY :: MMDDYYYY;
}
SDL_TimeFormat :: enum u32 {
    _24HR :: 0;
    _12HR :: 1;

    SDL_TIME_FORMAT_24HR :: _24HR;
    SDL_TIME_FORMAT_12HR :: _12HR;
}
SDL_GetDateTimeLocalePreferences :: (dateFormat: *SDL_DateFormat, timeFormat: *SDL_TimeFormat) -> bool #foreign sdl3;
SDL_GetCurrentTime :: (ticks: *SDL_Time) -> bool #foreign sdl3;
SDL_TimeToDateTime :: (ticks: SDL_Time, dt: *SDL_DateTime, localTime: bool) -> bool #foreign sdl3;
SDL_DateTimeToTime :: (dt: *SDL_DateTime, ticks: *SDL_Time) -> bool #foreign sdl3;
SDL_TimeToWindows :: (ticks: SDL_Time, dwLowDateTime: *Uint32, dwHighDateTime: *Uint32) -> void #foreign sdl3;
SDL_TimeFromWindows :: (dwLowDateTime: Uint32, dwHighDateTime: Uint32) -> SDL_Time #foreign sdl3;
SDL_GetDaysInMonth :: (year: s32, month: s32) -> s32 #foreign sdl3;
SDL_GetDayOfYear :: (year: s32, month: s32, day: s32) -> s32 #foreign sdl3;
SDL_GetDayOfWeek :: (year: s32, month: s32, day: s32) -> s32 #foreign sdl3;
SDL_GetTicks :: () -> Uint64 #foreign sdl3;
SDL_GetTicksNS :: () -> Uint64 #foreign sdl3;
SDL_GetPerformanceCounter :: () -> Uint64 #foreign sdl3;
SDL_GetPerformanceFrequency :: () -> Uint64 #foreign sdl3;
SDL_Delay :: (ms: Uint32) -> void #foreign sdl3;
SDL_DelayNS :: (ns: Uint64) -> void #foreign sdl3;
SDL_DelayPrecise :: (ns: Uint64) -> void #foreign sdl3;
SDL_TimerID :: Uint32;
SDL_TimerCallback :: #type (userdata: *void, timerID: SDL_TimerID, interval: Uint32) -> Uint32 #c_call;
SDL_AddTimer :: (interval: Uint32, callback: SDL_TimerCallback, userdata: *void) -> SDL_TimerID #foreign sdl3;
SDL_NSTimerCallback :: #type (userdata: *void, timerID: SDL_TimerID, interval: Uint64) -> Uint64 #c_call;
SDL_AddTimerNS :: (interval: Uint64, callback: SDL_NSTimerCallback, userdata: *void) -> SDL_TimerID #foreign sdl3;
SDL_RemoveTimer :: (id: SDL_TimerID) -> bool #foreign sdl3;
SDL_GetVersion :: () -> s32 #foreign sdl3;
SDL_GetRevision :: () -> *u8 #foreign sdl3;

#import "Basic"; // For push_context

#if OS == .WINDOWS {
    sdl3 :: #library "lib/x64/sdl3";
} else #if OS == .LINUX {
    sdl3 :: #library "lib/linux/libSDL3";
} else {
    #assert(false);
}
