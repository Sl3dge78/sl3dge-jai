#run {
    set_build_options_dc(.{do_output=false});
    // if !generate_sdl_bindings() {
    //     compiler_set_workspace_status(.FAILED);
    // }
    if !generate_shader_cross_bindings() {
        compiler_set_workspace_status(.FAILED);
    }
}

generate_shader_cross_bindings :: () -> bool {
    output_filename: string;
    opts: Generate_Bindings_Options;
    {
        using opts;

        #if OS == .WINDOWS {
            array_add(*libnames, "SDL3_shadercross-static");
            array_add(*libpaths, "lib/windows");
        } else #if OS == .LINUX {
            array_add(*libnames, "libSDL3_shadercross-static");
            array_add(*libpaths, "lib/linux");
        } else #if OS == .MACOS {
            assert(false);
        } else {
            assert(false);
        }
        output_filename  = "SDL_shadercross.jai";

        array_add(*source_files, 
            "include/SDL3/SDL_shadercross.h",
            );
        array_add(*system_include_paths, "include", GENERATOR_DEFAULT_SYSTEM_INCLUDE_PATH);
        array_add(*extra_clang_arguments, "-DNO_SDL_VULKAN_TYPEDEFS");

        generate_library_declarations = false;
        will_print_bindings = () {
            // Change the library name to be the same on all platforms
            // so that we don't have to generate identical bindings for every platform just because the library name is different.
            context.generator.libraries[0].name = "sdl3_shadercross";
        };

        footer = SHADER_CROSS_FOOTER;
        log_stripped_declarations = true;
        generate_compile_time_struct_checks = false;
        try_to_preserve_comments = false;
        mimic_spacing_flags = 0;
    }

    return generate_bindings(opts, output_filename);
}

generate_sdl_bindings :: () -> bool {
    output_filename: string;
    opts: Generate_Bindings_Options;
    {
        using opts;

        #if OS == .WINDOWS {
            array_add(*libnames, "SDL3");
            array_add(*libpaths, "lib/x64");
        } else #if OS == .LINUX {
            array_add(*libnames, "libSDL3");
            array_add(*libpaths, "lib/linux");
        } else #if OS == .MACOS {
            assert(false);
        } else {
            assert(false);
        }
        output_filename  = "module.jai";

        array_add(*source_files, 
            // "include/SDL3/SDL.h",
            "include/SDL3/SDL_stdinc.h",
            "include/SDL3/SDL_assert.h",
            "include/SDL3/SDL_atomic.h",
            "include/SDL3/SDL_audio.h",
            // "include/SDL3/SDL_begin_code.h",
            "include/SDL3/SDL_bits.h",
            "include/SDL3/SDL_blendmode.h",
            "include/SDL3/SDL_camera.h",
            "include/SDL3/SDL_clipboard.h",
            // "include/SDL3/SDL_close_code.h",
            // "include/SDL3/SDL_copying.h",
            "include/SDL3/SDL_cpuinfo.h",
            "include/SDL3/SDL_dialog.h",
            // "include/SDL3/SDL_egl.h",
            // "include/SDL3/SDL_endian.h",
            "include/SDL3/SDL_error.h",
            "include/SDL3/SDL_events.h",
            "include/SDL3/SDL_filesystem.h",
            "include/SDL3/SDL_gamepad.h",
            "include/SDL3/SDL_gpu.h",
            "include/SDL3/SDL_guid.h",
            // "include/SDL3/SDL_haptic.h",
            "include/SDL3/SDL_hidapi.h",
            // "include/SDL3/SDL_hints.h",
            "include/SDL3/SDL_init.h",
            // "include/SDL3/SDL_intrin.h",
            "include/SDL3/SDL_iostream.h",
            "include/SDL3/SDL_joystick.h",
            "include/SDL3/SDL_keyboard.h",
            "include/SDL3/SDL_keycode.h",
            "include/SDL3/SDL_loadso.h",
            "include/SDL3/SDL_locale.h",
            "include/SDL3/SDL_log.h",
            "include/SDL3/SDL_main.h",
            // "include/SDL3/SDL_main_impl.h",
            "include/SDL3/SDL_messagebox.h",
            "include/SDL3/SDL_metal.h",
            "include/SDL3/SDL_misc.h",
            "include/SDL3/SDL_mouse.h",
            "include/SDL3/SDL_mutex.h",
            // "include/SDL3/SDL_oldnames.h",
            // "include/SDL3/SDL_opengl.h",
            // "include/SDL3/SDL_opengles.h",
            // "include/SDL3/SDL_opengles2.h",
            // "include/SDL3/SDL_opengles2_gl2.h",
            // "include/SDL3/SDL_opengles2_gl2ext.h",
            // "include/SDL3/SDL_opengles2_gl2platform.h",
            // "include/SDL3/SDL_opengles2_khrplatform.h",
            // "include/SDL3/SDL_opengl_glext.h",
            "include/SDL3/SDL_pen.h",
            "include/SDL3/SDL_pixels.h",
            "include/SDL3/SDL_platform.h",
            // "include/SDL3/SDL_platform_defines.h",
            "include/SDL3/SDL_power.h",
            "include/SDL3/SDL_process.h",
            "include/SDL3/SDL_properties.h",
            "include/SDL3/SDL_rect.h",
            "include/SDL3/SDL_render.h",
            "include/SDL3/SDL_revision.h",
            "include/SDL3/SDL_scancode.h",
            "include/SDL3/SDL_sensor.h",
            "include/SDL3/SDL_storage.h",
            "include/SDL3/SDL_surface.h",
            "include/SDL3/SDL_system.h",
            // "include/SDL3/SDL_test.h",
            // "include/SDL3/SDL_test_assert.h",
            // "include/SDL3/SDL_test_common.h",
            // "include/SDL3/SDL_test_compare.h",
            // "include/SDL3/SDL_test_crc32.h",
            // "include/SDL3/SDL_test_font.h",
            // "include/SDL3/SDL_test_fuzzer.h",
            // "include/SDL3/SDL_test_harness.h",
            // "include/SDL3/SDL_test_log.h",
            // "include/SDL3/SDL_test_md5.h",
            // "include/SDL3/SDL_test_memory.h",
            "include/SDL3/SDL_thread.h",
            "include/SDL3/SDL_time.h",
            "include/SDL3/SDL_timer.h",
            "include/SDL3/SDL_touch.h",
            "include/SDL3/SDL_version.h",
            "include/SDL3/SDL_video.h",
            // "include/SDL3/SDL_vulkan.h"
            );
        array_add(*system_include_paths, "include", GENERATOR_DEFAULT_SYSTEM_INCLUDE_PATH);
        array_add(*extra_clang_arguments, "-DNO_SDL_VULKAN_TYPEDEFS");

        generate_library_declarations = false;
        will_print_bindings = () {
            // Change the library name to be the same on all platforms
            // so that we don't have to generate identical bindings for every platform just because the library name is different.
            context.generator.libraries[0].name = "sdl3";
        };
        footer = FOOTER;
        header = HEADER;

        log_stripped_declarations = true;
        generate_compile_time_struct_checks = false;
        try_to_preserve_comments = false;
        mimic_spacing_flags = 0;
        array_add(*path_fragments_to_treat_as_non_system_paths, "SDL");
    }

    return generate_bindings(opts, output_filename);
}

#scope_file
#import "Basic";
#import "Compiler";
#import "Check";
#import "Bindings_Generator";
#import "File";
#import "String";
#import "Hash_Table";

HEADER :: #string END

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

END

FOOTER :: #string END

#if OS == .WINDOWS {
    sdl3 :: #library "lib/x64/sdl3";
} else #if OS == .LINUX {
    sdl3 :: #library "lib/linux/libSDL3";
} else {
    #assert(false);
}
END

SHADER_CROSS_FOOTER :: #string END
#if OS == .WINDOWS {
    sdl3_shadercross:: #library,no_dll "lib/windows/SDL3_shadercross";
} else #if OS == .LINUX {
    sdl3_shadercross:: #library,no_dll "lib/linux/libSDL3";
} else {
    #assert(false);
}
END
