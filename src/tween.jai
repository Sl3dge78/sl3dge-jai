

Quaternion_Tween :: struct {
    starting_value: Quaternion;
    end_value: Quaternion;
    current_time: float; 
    end_time: float;
    value :*Quaternion;
}

quat_tween_list: [..]Quaternion_Tween;

tween :: (value: *Quaternion, end_value: Quaternion, time: float) {
    the_tween := Quaternion_Tween.{
        starting_value = value.*,
        end_value = end_value,
        end_time = time,
        value = value,
    };
    array_add(*quat_tween_list, the_tween);
    log("[Tween] New % -> %", value.*, end_value);
}

tween :: (value: *Quaternion, start_value: Quaternion, end_value: Quaternion, time: float) {
    the_tween := Quaternion_Tween.{
        starting_value = value.*,
        end_value = end_value,
        end_time = time,
        value = value,
    };
    array_add(*quat_tween_list, the_tween);
    log("[Tween] New % -> %", value.*, end_value);
}

update_tweens :: (delta_time: float) {
    for *quat_tween_list {
        it.current_time += delta_time;
        it.value.* = slerp(it.starting_value, it.end_value, it.current_time / it.end_time);
        if it.current_time >= it.end_time {
            it.value.* = it.end_value;
            remove it;
        }
    }
}