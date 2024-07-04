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
            array_add(*libnames, "wgpu_native");
            array_add(*libpaths, "windows");
        } else #if OS == .LINUX {
            array_add(*libnames, "libwgpu_native");
            array_add(*libpaths, "linux");
        } else #if OS == .MACOS {
            assert(false);
        } else {
            assert(false);
        }
        output_filename  = "module.jai";

        array_add(*source_files, "webgpu.h");
        array_add(*source_files, "wgpu.h");
        array_add(*system_include_paths, GENERATOR_DEFAULT_SYSTEM_INCLUDE_PATH);

        generate_library_declarations = false;
        will_print_bindings = () {
            // Change the library name to be the same on all platforms
            // so that we don't have to generate identical bindings for every platform just because the library name is different.
            context.generator.libraries[0].name = "wgpu_native";
        };
        footer = FOOTER;
        array_add(*strip_prefixes, "wgpu");
        array_add(*strip_prefixes, "WGPU");

        log_stripped_declarations = false;
        generate_compile_time_struct_checks = false;
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
// Generated with wgpu-native v0.19.4.1
#scope_file

#if OS == .WINDOWS {
    wgpu_native :: #library,no_dll "wgpu_native";
} else #if OS == .LINUX {
    wgpu_native :: #library,no_dll "linux/libwgpu_native";
} else {
    #assert(false);
}
END
