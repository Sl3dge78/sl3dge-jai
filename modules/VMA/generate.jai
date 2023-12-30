
FILE_PATH :: "vk_mem_alloc.h";
LIB_BASE_NAME :: "vk_mem_alloc";

#run {
    set_build_options_dc(.{do_output=false});
    // build_cpp_static_lib("vk_mem_alloc", "vk_mem_alloc.cpp", extra = .["-I", "C:\\Program Files\\VulkanSDK\\1.3.268.0\\Include", "-D","VMA_IMPLEMENTATION", "-stdlib=libc++"]);
    if !generate_bindings() {
        compiler_set_workspace_status(.FAILED);
    }
}

generate_bindings :: () -> bool {
    opts: Generate_Bindings_Options;
    output_filename: string;
    {
        using opts;

        array_add(*libnames, LIB_BASE_NAME);
        array_add(*source_files, FILE_PATH);
        // array_add(*extra_clang_arguments, "-stdlib=libc++");

        auto_detect_enum_prefixes = true;
        // log_stripped_declarations = false;
        generate_compile_time_struct_checks = false;
        output_filename = "module.jai";
        try_to_preserve_comments = false;
        mimic_spacing_flags = 0;

        #if OS == .LINUX {
            array_add(*libpaths, ".");

        } else {
            #assert(false, "TODO");
        }
        // #if OS == .WINDOWS {
        //     #assert(false, "TODO");
        //     array_add(*libpaths, "windows");
        //     output_filename = "windows.jai";
        //     generate_library_declarations = false;
        //     footer = tprint(FOOTER_WINDOWS_TEMPLATE, LIB_BASE_NAME);
        // } else {
        //     #if OS == .LINUX {
        //         array_add(*libpaths, "linux");
        //     } else #if OS == .MACOS {
        //         array_add(*libpaths, "macos");
        //     } else {
        //         assert(false);
        //     }
        //     output_filename = "unix.jai";
        //     generate_library_declarations = false;
        //     footer = tprint(FOOTER_UNIX_TEMPLATE, LIB_BASE_NAME);
        // }


    }

    return generate_bindings(opts, output_filename);
}

#import "Basic";
#import "Bindings_Generator";
#import "Compiler";
#import "BuildCpp";
