
Circle :: struct {
    center: Vector2;
    radius : float;
}

Rect :: struct {
    x, y: float;
    w, h: float;
}

is_in_rect :: (a: Vector2, rect: Rect) -> bool {
    return !(a.x < rect.x || a.x > rect.x + rect.w) && !(a.y < rect.y || a.y > rect.y + rect.h);
}

Vector3i :: struct {
    x: int;
    y: int;
    z: int;
}

to_vector3i :: (v: Vector3) -> Vector3i {
    return .{roundi(v.x), roundi(v.y), roundi(v.z)};
}

to_vector3 :: (v: Vector3i) -> Vector3 {
    return .{xx v.x, xx v.y, xx v.z};
}

operator == :: (a: Vector3i, b: Vector3i) -> bool {
    return a.x == b.x && a.y == b.y && a.z == b.z;
}

operator + :: (a: Vector3i, b: Vector3i) -> Vector3i {
    return .{a.x + b.x, a.y + b.y, a.z + b.z};
}

operator - :: (a: Vector3i, b: Vector3i) -> Vector3i {
    return .{a.x - b.x, a.y - b.y, a.z - b.z};
}