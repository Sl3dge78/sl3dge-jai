Scene :: struct {
    static_models: [..]Instanced(Static_Mesh);
    skinned_meshes: [..]Instanced(Skinned_Mesh);

    color_draw_data: Draw_Data;
    ui_draw_data: Draw_Data;
}

Instanced :: struct(T: Type) {
    transform: Matrix4;
    mesh: *T;
}

instantiate :: (scene: *Scene, mesh: *$T, matrix := Matrix4_Identity) -> Instanced(T) {
    inst := Instanced(T).{ matrix, mesh}; 
    #if T == Static_Mesh {
        array_add(*scene.static_models, inst);
    } else #if T == Skinned_Mesh {
        array_add(*scene.skinned_meshes, inst);
    } else {
        #assert false, "Unsupported mesh type";
    }
    return inst;
}
