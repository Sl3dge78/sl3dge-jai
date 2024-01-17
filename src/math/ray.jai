Ray :: struct {
    origin: Vector3;
    dir: Vector3;
}

Quad :: struct {
    v0: Vector3; 
    v1: Vector3;
    v2: Vector3;
    v3: Vector3;

    #place v0; v: [4]Vector3;
 
    make :: (center: Vector3, size: Vector2) -> Quad {
        hs := size / 2.0;
        quad : Quad;
        quad.v0 = .{center.x - hs.x, center.y, center.z - hs.y};
        quad.v1 = .{center.x - hs.x, center.y, center.z + hs.y};
        quad.v2 = .{center.x + hs.x, center.y, center.z + hs.y};
        quad.v3 = .{center.x + hs.x, center.y, center.z - hs.y};
        return quad; 
    }
}

AABB :: struct {
    p0: Vector3;
    p1: Vector3;
}

// Triangle
// Points should be CCW
ray_intersects :: (ray: Ray, v0: Vector3, v1: Vector3, v2: Vector3) -> bool, Vector3 {
    edge1 := v1 - v0;
    edge2 := v2 - v0;
    n := cross(ray.dir, edge2);
    a := dot(edge1, n);
    if ((a < FLOAT32_MIN) && (a > -FLOAT32_MIN)) then return false, .{}; // Ray and poly are parallel

    f := 1.0 / a;
    s := ray.origin - v0;
    u := f * dot(s, n);
    if (u < 0 || u > 1) then return false, .{};
    q := cross(s, edge1);
    v := f * dot(ray.dir, q);
    if ((v < 0) || ((v + u) > 1)) then return false, .{};

    t := f * dot(edge2, q);
    if t < FLOAT32_MIN then return false, .{};

    intersection := ray.origin + ray.dir * t;
    return true, intersection;
}

// Quad
// Points should be CCW
ray_intersects :: (ray: Ray, v0: Vector3, v1: Vector3, v2: Vector3, v3: Vector3) -> bool, Vector3 {
    coll, point := ray_intersects(ray, v0, v1, v2);
    if coll then return true, point;
    
    coll2, point2 := ray_intersects(ray, v0, v2, v3);
    return coll2, point2;
}

// Quad, array overload
// Points should be CCW
ray_intersects :: inline (ray: Ray, q : Quad) -> bool, Vector3 {
    a, b := ray_intersects(ray, q.v[0], q.v[1], q.v[2], q.v[3]);
    return a, b;
}

// aabb
ray_intersects :: (ray: Ray, aabb: AABB) -> bool, Vector3 {
    inv_dir := 1.0/ray.dir;
    tx1 := (aabb.p0.x - ray.origin.x)*inv_dir.x;
    tx2 := (aabb.p1.x - ray.origin.x)*inv_dir.x;

    tmin := min(tx1, tx2);
    tmax := max(tx1, tx2);

    ty1 := (aabb.p0.y - ray.origin.y)*inv_dir.y;
    ty2 := (aabb.p1.y - ray.origin.y)*inv_dir.y;

    tmin = max(tmin, min(ty1, ty2));
    tmax = min(tmax, max(ty1, ty2));

    tz1 := (aabb.p0.z - ray.origin.z)*inv_dir.z;
    tz2 := (aabb.p1.z - ray.origin.z)*inv_dir.z;

    tmin = max(tmin, min(tz1, tz2));
    tmax = min(tmax, max(tz1, tz2));

    return !((tmax < 0) || (tmin > tmax)), ray.dir * tmax;
}
