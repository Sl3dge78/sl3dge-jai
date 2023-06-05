Scene :: struct {
    static_models: [..]*Model;
    this_frame_models: [..]Model;
}

push_model :: (scene: *Scene, model: *Model $static := true) {
    #if static {
        array_add(*scene.static_models, model);
    } else {
        array_add(*scene.this_frame_models, model);
    }
}


Model :: struct {
    vertices: []Vertex;
}