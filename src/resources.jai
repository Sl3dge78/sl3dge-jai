/*
    This file handles the game's resources.
    Resources are static assets that aren't modified by the game itself. Like shaders, 3d models, audio files, ...
    1. At compile time, we generate the contents of the Resource struct by browsing inside the res/ folder.
       Add file types by adding cases to the multiple if extension == 
    2. At runtime, we use File_Watcher to check for changes in the res folder, and hotreload assets
        We generate a function called get_res_ptr which returns the address and type of the struct member
        associated with a particular file.

    As future upgrades, we can imagine lazyly loading/offloading assets as required.
*/

Resource_Info :: struct {
    path : string;
    pointer: *void;
    type: Type;
    load: (*Resource_Info) -> bool;
    unload: #type (*Resource_Info);
}

Extension_Info :: struct {
    ext: string;
    load: (*Resource_Info) -> bool;
    unload: #type (*Resource_Info);
    type: (path: string) -> string;
}

extension_infos := Extension_Info.[
    .{"var", load_var_file, unload_var, get_var_type},
    .{"ttf", load_font_file, unload_font, get_font_type},
    .{"pipeline", load_pipeline, unload_pipeline, get_pipeline_type},
    .{"compute", load_compute, unload_compute, get_compute_type},
    .{"mat", load_material, unload_material, get_material_type},
    .{"png", load_image, unload_image, get_image_type},
];

resources : Resources;

Resources :: struct {
    watcher : File_Watcher.File_Watcher;
    on_reload : (r: *Resource_Info, data: *void) = null;
    data: *void;

    // Creates all members with names = to the filenames
    #insert #run -> string {
        #import "File_Utilities";

        builders : [3]String_Builder;

        set_working_directory("bin");
        defer set_working_directory("../");

        // Prepare the get_res_ptr function
        print_to_builder(*builders[1], "get_res_ptr :: (path: string) -> *void, Type {\nif path == {\n");

        // Prepare the array of resource infos
        print_to_builder(*builders[2], "infos := Resource_Info.[\n");

        for_all_files :: (info: *File_Visit_Info, user_data: [3]String_Builder) {
            // log("%", info.full_name);
            path, basename, extension := path_decomp(info.full_name);
            ext_info := get_ext_info(extension);
            if !ext_info then return;
            
            // Add a case to the get_res_ptr function call
            print_to_builder(*user_data[1], "\tcase \"%\"; return *resources.%2, type_of(resources.%2);\n", info.full_name, basename);
            // Add an entry in the resource info array
            print_to_builder(*user_data[2], "\t.{path = \"%\"},\n", info.full_name);
            // Add the asset to the struct
            print_to_builder(*user_data[0], "%: %;\n", basename, ext_info.type(info.full_name));
        }

        if file_exists("res") {
            visit_files("res", true, builders, for_all_files);
        }

        // Close the resource info array
        print_to_builder(*builders[2], "];\n");

        // Add a default case 
        print_to_builder(*builders[1], "\tcase; return null, type_of(null);\n");
        print_to_builder(*builders[1], "}\n"); // Close the if ==
        print_to_builder(*builders[1], "}\n"); // Close the procedure

        // Concatenate all builders
        print_to_builder(*builders[0], "%\n", builder_to_string(*builders[1])); 
        print_to_builder(*builders[0], "%\n", builder_to_string(*builders[2]));

        return builder_to_string(*builders[0]);
    };

    get_ext_info :: (ext: string) -> *Extension_Info {
        for * extension_infos {
            if it.ext == ext then return it;
        }
        return null;
    }

    create :: () {
        // Initialize the file watcher and fill the resource_info array with run time info
        File_Watcher.init(*resources.watcher, on_file_change);
        File_Watcher.add_directories(*resources.watcher, "res");

        for *info: resources.infos {
            ptr, type := get_res_ptr(info.path);
            info.pointer = ptr;
            info.type = type;
            ext := path_extension(info.path);
            ext_info := get_ext_info(ext);
            assert(ext_info != null, tprint("No extension info for file %", info.path));
            info.load = ext_info.load;
            info.unload = ext_info.unload;
        }
        load_all();
    }

    destroy :: () {
        File_Watcher.deinit(resources.watcher);
        unload_all();
    }

    update :: () {
        File_Watcher.process_changes(*resources.watcher);
    }

    load_all :: () {
        for *resources.infos {
            log("[RESOURCES] Loading %", it.path);
            it.load(it);
        }
    }

    unload_all :: () {
        for *resources.infos {
            log("[RESOURCES] Destroying %", it.path);
            it.unload(it);
        }
    }

    on_file_change :: (watcher: *File_Watcher.File_Watcher(void), change: *File_Watcher.File_Change, user_data: *void) {
        info : *Resource_Info;
        for *resources.infos {
            if it.path == change.full_path {
                info = it;
                break;
            }
        }
        if !info then return;
        log("[RESOURCES] Reloading %", info.path);
        info.unload(info);
        info.load(info);
        if resources.on_reload {
            resources.on_reload(info, resources.data);
        }
    }
}

// .var files
// @Todo extend this to be an equivalent to .ini
get_var_type :: (file: string) -> string {
    builder : String_Builder;
    contents := read_entire_file(file);
    defer free(contents);
    lines := split(contents, "\n");
    print_to_builder(*builder, "struct {\n");
    for line: lines {
        decomp := split(trim(line), "=");
        if decomp.count != 2 then continue;
        print_to_builder(*builder, "\t%: float =%;\n", decomp[0], decomp[1]);
    }
    print_to_builder(*builder, "};\n");

    return builder_to_string(*builder);
}

load_var_file :: (info: *Resource_Info) -> bool {
    push_allocator(temp);
    contents := read_entire_file(info.path);
    defer free(contents);
    ti: *Type_Info_Struct = xx info.type;

    find_member_offset :: (ti: *Type_Info_Struct, name: string) -> bool, s64 {
        for ti.members {
            if it.name == name {
                return true, it.offset_in_bytes;
            }
        }
        return false, 0;
    }; 

    lines := split(contents, "\n");
    for line: lines {
        decomp := split(trim(line), "=");
        if decomp.count != 2 then continue;
        ok, offset := find_member_offset(ti, trim(decomp[0]));
        if !ok {
            log("Couldn't find % in struct !", decomp[0]);
            continue;
        }
        addr : *float = cast(*float)(cast(*u8)info.pointer + offset);
        val := parse_float(*trim(decomp[1]));
        addr.* = val;
    }
    return true;
}

unload_var :: (info: *Resource_Info) {
    // nop
}

// .ttf files
load_font_file :: (info: *Resource_Info) -> bool {
    font : *Font = cast(*Font)info.pointer;
    font.* = font_from_file(info.path, 8); // @Todo: Find a way to specify a font size
    return true;
}

unload_font :: (info :*Resource_Info) {
    destroy(cast(*Font)info.pointer);
}

get_font_type :: (path: string) -> string {
    return "Font";
}

// .png files
load_image :: (info: *Resource_Info) -> bool {
    info.pointer = texture_from_file(info.path);
    return true;
}

unload_image :: (info: *Resource_Info) {
    destroy(cast(Texture) info.pointer);
}

get_image_type :: (path: string) -> string {
    return "Texture";
}

load_pipeline :: (info: *Resource_Info) -> bool {
    success, json := json_parse_file(info.path, Pipeline_Info,, temp);
    assert(success);

    builder: Pipeline_Builder;
    from_info(*builder, json);

    info.pointer.(**SDL_GPUGraphicsPipeline).* = build_pipeline(*builder, global_renderer.device);
    return true;
}

unload_pipeline :: (info: *Resource_Info) {
    SDL_ReleaseGPUGraphicsPipeline(global_renderer.device, info.pointer.(**SDL_GPUGraphicsPipeline).*);
}

get_pipeline_type :: (path: string) -> string {
    return "*SDL_GPUGraphicsPipeline";
}

load_compute :: (info: *Resource_Info) -> bool {
    success, json := json_parse_file(info.path, Compute_Info,, temp);
    assert(success);

    info.pointer.(**SDL_GPUComputePipeline).* = build_compute_pipeline(json);
    return true;
}

unload_compute :: (info: *Resource_Info) {
    SDL_ReleaseGPUComputePipeline(global_renderer.device, info.pointer.(**SDL_GPUComputePipeline).*);
}

get_compute_type :: (path: string) -> string {
    return "*SDL_GPUComputePipeline";
}

load_material :: (info: *Resource_Info) -> bool {
    success, json := json_parse_file(info.path, Pipeline_Info,, temp);
    assert(success);

    {   // Shadowmap   
        builder: Pipeline_Builder;
        shadow_info := json;
        shadow_info.fragment_shader = "shaders/noop.frag";
        shadow_info.fragment_info = .{0, 0, 0, 0};
        from_info(*builder, shadow_info);
        builder.targets.count = 0;
        set_depth_bias(*builder, 1.25, 0, 1.75);
        add_depth_stencil_target(*builder, .D32_FLOAT);
        builder.rasterizer_state.cull_mode = .NONE;
        info.pointer.(*Material).pipelines[Pipeline_Kind.SHADOWMAP] = build_pipeline(*builder, global_renderer.device);
    }
    {   // Color
        builder: Pipeline_Builder;
        from_info(*builder, json);
        info.pointer.(*Material).pipelines[Pipeline_Kind.COLOR] = build_pipeline(*builder, global_renderer.device);
    }

    return true;
}

unload_material :: (info: *Resource_Info) {
    destroy(info.pointer.(*Material));
}

get_material_type :: (path: string) -> string {
    return "Material";
}
