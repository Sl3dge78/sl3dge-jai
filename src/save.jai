#import "System";

#scope_file
save_dir : string;

init_save_dir :: () {
    if save_dir.count == 0 {
        #if OS == .LINUX {
            save_dir = join(get_home_directory(), "/.local/share/ship_os");
        } else #if OS == .WINDOWS {
            save_dir = join(get_home_directory(), "/ship_os");
        }
        log("Save dir : %", save_dir);
        result := make_directory_if_it_does_not_exist(save_dir);
        if !result {
            log("Unable to create directory!");
        }
    }
}

#scope_module

save_file :: (serialized_data: string, file_name: string) -> bool {
    init_save_dir();
    full_path := join(save_dir, "/", file_name,, allocator = temp);
    result := write_entire_file(full_path, serialized_data);
    assert(result, "Unable to save %", file_name);
    log("Saved %", full_path);
    return result;
}

load_file :: (file_name: string) -> bool, string {
    init_save_dir();

    result: string;
    ok: bool;
    full_path := join(save_dir, "/", file_name,, allocator = temp);

    new_context := context;
    new_context.allocator = temp;
    push_context new_context {
        result, ok = read_entire_file(full_path, log_errors = false);
    }
    if result {
        log("Loaded %", file_name);
    } else {
        log("Unable to load %", file_name);
    }
    return ok, result;
}

load_or_default :: (file_name: string, call_if_ok: (string) -> (bool, $T), call_if_nok: () -> T) -> T {
    loaded, str := load_file(file_name);
    if !loaded {
        log("Unable to load %, defaulting...", file_name);
        return call_if_nok();
    }

    success, result := call_if_ok(str);
    if !success {
        log("Unable to deserialize %, defaulting...", file_name);
        return call_if_nok();
    }

    return result;
}
