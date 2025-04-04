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
    tangent: Vector3;
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

PBR_Material_Buffer :: struct {
    albedo: Vector3 #align 16;
    metallic: float;
    roughness: float;
}

Texture_Binding :: enum {
    SHADOWMAP :: 0;
    IRRADIANCE;
    PREFILTERED;
    BRDF_LUT;
    DIFFUSE;
    NORMAL;
    METALLIC_ROUGHNESS;
    AMBIENT_OCCLUSION;
    EMISSIVE;
}

