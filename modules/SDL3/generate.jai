#run {
    set_build_options_dc(.{do_output=false});
    if !generate_bindings() {
        compiler_set_workspace_status(.FAILED);
    }
}

generate_bindings :: () -> bool {
    output_filename: string;
    opts: Generate_Bindings_Options;
    {
        using opts;

        #if OS == .WINDOWS {
            array_add(*libnames, "SDL3");
            array_add(*libpaths, "lib/x64");
        } else #if OS == .LINUX {
            // array_add(*libnames, "libwgpu_native");
            // array_add(*libpaths, "linux");
        } else #if OS == .MACOS {
            assert(false);
        } else {
            assert(false);
        }
        output_filename  = "module.jai";

        array_add(*source_files, 
            // "include/SDL3/SDL.h",
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
            // "include/SDL3/SDL_stdinc.h",
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
            "include/SDL3/SDL_vulkan.h"
            );
        array_add(*system_include_paths, "include", GENERATOR_DEFAULT_SYSTEM_INCLUDE_PATH);

        generate_library_declarations = false;
        will_print_bindings = () {
            // Change the library name to be the same on all platforms
            // so that we don't have to generate identical bindings for every platform just because the library name is different.
            context.generator.libraries[0].name = "sdl3";
        };
        footer = FOOTER;

        log_stripped_declarations = true;
        generate_compile_time_struct_checks = false;
        try_to_preserve_comments = false;
        mimic_spacing_flags = 0;
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

FOOTER :: #string END
#scope_file

#if OS == .WINDOWS {
    sdl3 :: #library "lib/x64/sdl3";
} else #if OS == .LINUX {
    sdl3 :: #library "sdl3";
} else {
    #assert(false);
}
END
