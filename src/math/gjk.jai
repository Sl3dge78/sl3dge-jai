
gjk :: (a: []$T, b: []T) -> bool 
#modify {
    if T == Vector3 || T == Vector2 then return true;
    else { 
        return false, "gjk only supports arrays of Vector2 or Vector3.";
    }
}{
    simplex : [..]T;
    dir := center(b) - center(a);
    if !add_vertex(*simplex, a, b, dir) then return false;
    if !add_vertex(*simplex, a, b, dir * -1) then return false;
    while true {
        if evolve_simplex(*simplex, a, b) == {
            case .INTERSECTS; return true;
            case .CONTINUE; continue;
            case .STOP; return false;
        }
    }
    return false; // Unreachable
}

#scope_file
add_vertex :: (simplex: *[..]$T, a: []T, b: []T, direction: T) -> bool {
    v := support(a, direction) - support(b, -1 * direction);
    array_add(simplex, v);

    return dot(direction, v) >= 0.0;
}

triple_product :: (a: Vector2, b: Vector2, c: Vector2) -> Vector2 {
    _a := unit_vector(xyz(a, 0));
    _b := unit_vector(xyz(b, 0));
    _c := unit_vector(xyz(c, 0));

    return cross(cross(_a, _b), _c).xy;
}

EvolveResult :: enum {
    INTERSECTS;
    CONTINUE;
    STOP;
}

evolve_simplex :: (simplex: *[..]Vector2, a: []Vector2, b: []Vector2) -> EvolveResult {
    direction : Vector2 = ---;
    if simplex.count == {
        case 2; {
            cb := (<< simplex)[1] - (<< simplex)[0];
            c0 := (<< simplex)[0] * -1;
            direction = triple_product(cb, c0, cb);
        }
        case 3; {
            a0 := (<< simplex)[2] * -1.0;
            ab := (<< simplex)[1] - (<< simplex)[2];
            ac := (<< simplex)[0] - (<< simplex)[2];

            ab_perp := triple_product(ac, ab, ab);
            ac_perp := triple_product(ab, ac, ac);
            if dot(ab_perp, a0) > 0.0 {
                array_unordered_remove_by_index(simplex, 0);
                direction = ab_perp;
            } else if dot(ac_perp, a0) > 0.0 {
                array_unordered_remove_by_index(simplex, 1);
                direction = ac_perp;
            } else {
                return .INTERSECTS;
            }
        }
        case; assert(false, "2D Simplex has 4 elements, this shouldn't happen!");
    }

    if !add_vertex(simplex, a, b, direction * -1) {
        return .STOP;
    } else {
        return .CONTINUE;
    }
}

evolve_simplex :: (simplex: *[..]Vector3, a: []Vector3, b: []Vector3) -> EvolveResult {
    s := << simplex;
    direction : Vector3 = ---;
    if simplex.count == {
        case 2; {
            cb := unit_vector(s[1] - s[0]);
            c0 := unit_vector(s[0] * -1);
            direction = cross(cross(cb, c0), cb);
        }
        case 3; {
            ac := s[2] - s[0];
            ab := s[1] - s[0];
            a0 := s[0] * -1.0;

            direction = cross(ac, ab);
            if(dot(direction, a0) < 0) then direction *= -1;
        } 
        case 4; {
            da := s[3] - s[0];
            db := s[3] - s[1];
            dc := s[3] - s[2];

            d0 := s[3] * -1;

            abd := cross(da, db);
            bcd := cross(db, dc);
            cad := cross(dc, da);
    
            if dot(abd, d0) > 0 {
                array_unordered_remove_by_index(simplex, 2);
                direction := abd;
            } else if dot(bcd, d0) > 0 {
                array_unordered_remove_by_index(simplex, 0);
                direction := bcd;
            } else if dot(cad, d0) > 0 {
                array_unordered_remove_by_index(simplex, 1);
                direction := cad;
            } else {
                return .INTERSECTS;
            }
        }
        case; assert(false, "2D Simplex has 4 elements, this shouldn't happen!");
    }

    if !add_vertex(simplex, a, b, direction * -1) {
        return .STOP;
    } else {
        return .CONTINUE;
    }

}

support :: (vertices: []$T, direction: T) -> T {
    dist := 0.0; 
    vtx := vertices[0];
    for vertices {
        distance := dot(it, unit_vector(direction));
        if distance > dist {
            dist = distance;
            vtx = it;
        }
    }

    return vtx;
}

// This is just to get a base vector, we don't really care about preciseness,
// so we just take the average.
center :: (vertices: []$T) -> T {
    acc: T;
    for vertices {
        acc += it;
    }
    return acc / cast(float)vertices.count;
}

#scope_export

gjk_test :: () -> bool {
    {
        a := Vector2.[.{0, 0}, .{0, 1}, .{1, 1}, .{1, 0}];
        assert(support(a, .{-1, -1}) == .{0, 0}, "Support 1");
        assert(support(a, .{1, 1}) == .{1, 1}, "Support 2");
        b := Vector2.[.{0.5, .5}, .{1.5, 1}, .{.75, 2}];
        assert(support(b, .{1, 0}) == .{1.5, 1}, "Support 3");
        
        assert(triple_product(.{1, 0}, .{0, 1}, .{1, 0}) == .{0, 1}, "Triple Product 1");
        assert(triple_product(.{2, 0}, .{0, 1}, .{2, 0}) == .{0, 1}, "Triple Product 2");
        
        assert(gjk(a, b) == true, "2D GJK 1");
    }
    {
        a := Vector3.[.{0, 0, 0}, .{1, 0, 0}, .{1, 1, 0}, .{0, 0, 1}];
        b := Vector3.[.{0, 0, 0.5}, .{1, 0, 0.5}, .{1, 1, 0.5}, .{0, 0, 1.5}];

        assert(gjk(a, b) == true, "3D GJK 1");

        c := Vector3.[.{-1, 0, 0.5}, .{-1, 0, 0.5}, .{-1, 1, 0.5}, .{-0.5, 0, 1.5}];
        assert(gjk(a, c) == false, "3D GJK 2");
    }
    return true;
} @Test

