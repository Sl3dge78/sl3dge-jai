roundf :: (v: float) -> float {
    return floor(v + 0.5);
}

roundi :: (v: float) -> int {
    return xx floor(v + 0.5);
}

radians :: (angle: float) -> float #expand {
    return angle * (PI / 180.0);
}

aligned_size :: (size: u64, alignement: u64) -> u64 {
    return (size + alignement - 1) & ~(alignement - 1);
}