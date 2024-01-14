

#run {
    set_build_options_dc(.{do_output=false});
    #if OS == .WINDOWS {
        build_cpp_dynamic_lib("vk_mem_alloc", "vk_mem_alloc.cpp", extra = .["-I", "C:\\VulkanSDK\\1.3.268.0\\Include"]);
    } else #if OS == .LINUX {
        build_cpp_dynamic_lib("vk_mem_alloc", "vk_mem_alloc.cpp", extra = .["-x", "c++", "-stdlib=libc++", "-std=c++14", "-lc++", "-lvulkan", "-fno-exceptions", "-fno-rtti"]);
    }
    return;
    log("Built!");
    if !generate_bindings() {
        compiler_set_workspace_status(.FAILED);
    }
}

generate_bindings :: () -> bool {
    opts: Generate_Bindings_Options;
    output_filename: string;
    {
        using opts;

        array_add(*libnames, "vk_mem_alloc");
        array_add(*source_files, "vk_mem_alloc.h");
        array_add(*system_include_paths, "C:\\VulkanSDK\\1.3.268.0\\Include");

        auto_detect_enum_prefixes = true;
        // log_stripped_declarations = false;
        generate_compile_time_struct_checks = false;
        output_filename = "module.jai";
        try_to_preserve_comments = false;
        mimic_spacing_flags = 0;
        omit_global_declarations = true;
        array_add(*libpaths, ".");

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
