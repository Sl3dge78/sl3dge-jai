// @VOLATILE, always sync with shaders

UI_Vertex :: struct {
    position: Vector2;
    uv: Vector2;
    color: Vector4 = .{1, 1, 1, 1};
}

UI_Push_Constants :: struct {
    scale: Vector2;
    translation: Vector2;
}

Standard_Vertex :: struct {
    position: Vector3;
    normal: Vector3;
    uv: Vector2;
    color: Vector4 = .{1, 1, 1, 1};
}

Skinned_Vertex :: struct {
    joints: [4]u8;
    weights: Vector4;
}

Standard_Push_Constants :: struct {
    transform: Matrix4;
    inverse_transform: Matrix4;
}

Light_Kind :: enum u64 #specified {
    DIRECTIONAL :: 0;
    POINT :: 1;
}

Light :: struct {
    kind: Light_Kind #align 16;
    position_or_direction: Vector3 #align 16; // Position if point, direction if directional
    color: Vector3 #align 16;
} 

Global_Matrices :: struct {
    projection: Matrix4;
    view: Matrix4;
    sun: Matrix4;
    camera_position: Vector3 #align 16;
    light_count: u32;
    lights: [16]Light;
    time: float;
} 

Instance_Data :: struct {
    joint_matrices: [128]Matrix4;
}

PBR_Material :: struct {
    albedo: Vector3 #align 16;
    metallic: float;
    roughness: float;
    ambient_occlusion: float;
}

#import "Process";

compile_shader :: (path: string) {
    real_path := tprint("shaders/%", path);
    output_file := tprint("res/shaders/%.spv", path);
    metadata_file := tprint("res/shaders/%.json", path);
    
    if false {
        run_command("glslang", "-gVS", "-V", real_path, "-o", output_file, working_directory = "bin", capture_and_return_output = true, arg_quoting = .QUOTE_IF_NEEDED);
    } else {
        result, stdout, stderr := run_command("glslang", "-V", real_path, "-o", output_file, working_directory = "bin", capture_and_return_output = true);
        if result.exit_code != 0 {
            print_color("========\n", color = .RED);
            print_color("%\n%", stdout, stderr, color = .RED);
            print_color("========\n", color = .RED);
            return;
        }
    }
    result, stout, stderr := run_command("shadercross", output_file, "-o", metadata_file, working_directory = "bin", capture_and_return_output = true,, logger = (msg: string, data: *void, info: Log_Info) {});
    if result.exit_code != 0 {
        // Shadercross not installed, maybe log it
    }
    print_color("%\n", path, color = .GREEN);
}

export_material :: (name: string, v: string, f: string, info: Pipeline_Info) {
    compile_shader(v);
    compile_shader(f);
    info2 := info;
    info2.vertex_shader = tprint("res/shaders/%.spv", v);
    info2.fragment_shader = tprint("res/shaders/%.spv", f);
    builder: String_Builder;
    json_write_native(*builder, *info2, type_info(type_of(info2)));

    write_entire_file(tprint("bin/res/%.mat", name), *builder);
}

export_pipeline :: (name: string, v: string, f: string, info: Pipeline_Info) {
    compile_shader(v);
    compile_shader(f);
    info2 := info;
    info2.vertex_shader = tprint("res/shaders/%.spv", v);
    info2.fragment_shader = tprint("res/shaders/%.spv", f);
    builder: String_Builder;
    json_write_native(*builder, *info2, type_info(type_of(info2)));
    s := builder_to_string(*builder);

    write_entire_file(tprint("bin/res/%.pipeline", name), s);
}
