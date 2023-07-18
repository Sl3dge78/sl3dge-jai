Camera :: struct {
    yaw: float = -PI / 2.0;
    pitch: float = PI / 2.0; 
    position : Vector3 = .{0, 0, 0};
    forward: Vector3 = .{0, 0, -1};

    get_view :: (using camera: Camera) -> Matrix4 {
        return make_look_at_matrix(position, position + forward, .{0, 1, 0}, false);
    }
}

fly_cam :: (using camera: *Camera, delta_time: float) {
    yaw += cast(float)(Input.mouse_delta_x()) * 0.2 * delta_time;
    yaw = fmod_cycling(yaw, 2.0 * PI);
    pitch += cast(float)(Input.mouse_delta_y()) * 0.2 * delta_time;
    pitch = clamp(pitch, 0.001, PI - 0.001);
    forward = unit_vector(xyz(sin(pitch) * cos(yaw), cos(pitch), sin(pitch) * sin(yaw)));

    flat := xyz(forward.x, 0, forward.z);
    right := cross(flat, Vector3.{0, 1, 0});
    
    // Horizontal movement
    acceleration: Vector3;
    speed := 10.0;

    if Input.key_down(SDL_SCANCODE_W) then acceleration += flat;
    if Input.key_down(SDL_SCANCODE_S) then acceleration -= flat;
    if Input.key_down(SDL_SCANCODE_D) then acceleration += right;
    if Input.key_down(SDL_SCANCODE_A) then acceleration -= right;
    if Input.key_down(SDL_SCANCODE_Q) then acceleration -= .{0, 1, 0};
    if Input.key_down(SDL_SCANCODE_E) then acceleration += .{0, 1, 0};
    if Input.key_down(SDL_SCANCODE_LSHIFT) then speed = 200.0;

    position += acceleration * delta_time * speed;
}

orbit_cam :: (using camera: *Camera, delta_time: float, distance: float, center: Vector3) {
    yaw += cast(float)(Input.mouse_delta_x()) * 0.2 * delta_time;
    yaw = fmod_cycling(yaw, 2.0 * PI);
    pitch += cast(float)(Input.mouse_delta_y()) * 0.2 * delta_time;
    pitch = clamp(pitch, 0.001, PI - 0.001);
    forward = unit_vector(xyz(sin(pitch) * cos(yaw), cos(pitch), sin(pitch) * sin(yaw)));

    position = center - forward * distance;
}