

compile_lib :: () {
    success := build_cpp_static_lib("stbtruetype", "stb_truetype.cpp");
}

generate_bindings :: () {
    output_filename: string;
    opts: Generate_Bindings_Options;
    {
        using opts;
        output_filename          = "module.jai";
        
        array_add(*libpaths,       ".");
        array_add(*libnames,      "stbtruetype");
        array_add(*system_include_paths, GENERATOR_DEFAULT_SYSTEM_INCLUDE_PATH);
        array_add(*source_files,  "stb_truetype.h");
        array_add(*extra_clang_arguments, "-x", "c++");

        // strip_flags &= ~(Strip_Flags.CONSTRUCTORS | .DESTRUCTORS);
    }

    generate_bindings(opts, output_filename);
}

#run { 
    compile_lib();
    // generate_bindings();
}

#import "BuildCpp";
#import "Bindings_Generator";
#import "Basic";