
roundf :: (v: float) -> float {
    return floor(v + 0.5);
}

roundi :: (v: float) -> int {
    return xx floor(v + 0.5);
}

radians :: (angle: float) -> float #expand {
    return angle * (PI / 180.0);
}

get_aligned_size :: (size: u64, alignement: u64) -> u64 {
    return (size + alignement - 1) & ~(alignement - 1);
}

rot_from_mat4 :: (mat: Matrix4) -> Quaternion {

    result: Quaternion = ---;
    tr := mat.floats[0] + mat.floats[5] + mat.floats[10];
    if(tr > 0) {
        S := sqrt(tr+1.0) * 2.0;
        result.w = 0.25 * S;
        result.x = (mat.floats[9] - mat.floats[6]) / S;
        result.y = (mat.floats[3] - mat.floats[8]) / S;
        result.z = (mat.floats[4] - mat.floats[1]) / S;
    } else if(mat.floats[0] > mat.floats[5] && mat.floats[0] > mat.floats[10]) {
        S := sqrt(1.0 + mat.floats[0] - mat.floats[5] - mat.floats[10]) * 2.0;
        result.w = (mat.floats[9] - mat.floats[6]) / S;
        result.x = 0.25 * S;
        result.y = (mat.floats[4] + mat.floats[1]) / S;
        result.z = (mat.floats[3] + mat.floats[8]) / S;
    } else if(mat.floats[5] > mat.floats[10]) {
        S := sqrt(1.0 + mat.floats[5] - mat.floats[0] - mat.floats[10]) * 2.0;
        result.w = (mat.floats[3] - mat.floats[8]) / S;
        result.x = (mat.floats[4] + mat.floats[1]) / S;
        result.y = 0.25 * S;
        result.z = (mat.floats[9] + mat.floats[6]) / S;
    } else {
        S := sqrt(1.0 + mat.floats[10] - mat.floats[0] - mat.floats[5]) * 2.0;
        result.w = (mat.floats[4] + mat.floats[1]) / S;
        result.y = (mat.floats[9] - mat.floats[6]) / S;
        result.x = (mat.floats[3] + mat.floats[8]) / S;
        result.z = 0.25 * S;
    }
    return result;
}

hex :: (hex : string) -> Vector4 {
    result, success := string_to_int(hex, base=16);
    val := clamp_to_another_integer_type(result, u32);
    r := ((val & 0xff0000) >> 16) / 255.0;
    g := ((val & 0x00ff00) >>  8) / 255.0;
    b :=  (val & 0x0000ff)        / 255.0;
    return .{r, g, b, 1};
}