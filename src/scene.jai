Scene :: struct {
    static_models: [..]Instanced(Static_Mesh);
    skinned_meshes: [..]Instanced(Skinned_Mesh);

    color_draw_data: Draw_Data;
    ui_draw_data: Draw_Data;

    destroy :: (using self: *Scene) {
        array_reset(*static_models);
        array_reset(*skinned_meshes);
    }
}

Instanced :: struct(T: Type) {
    transform: Matrix4;
    mesh: *T;
}

instantiate :: (scene: *Scene, mesh: *$T, matrix := Matrix4_Identity) -> *Instanced(T) {
    inst : *Instanced(T); 
    #if T == Static_Mesh {
        inst = array_add(*scene.static_models);
    } else #if T == Skinned_Mesh {
        inst = array_add(*scene.skinned_meshes);
    } else {
        #assert false, "Unsupported mesh type";
    }

    inst.transform = matrix;
    inst.mesh = mesh;
    return inst;
}
