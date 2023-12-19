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

Global_Matrices :: struct {
    projection: Matrix4;
    view      : Matrix4;
    light     : Matrix4;
    light_vec : Vector3;
    __align : float;
}

Instance_Data :: struct {
    joint_matrices: [128]Matrix4;
}