
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
