c_print :: (format: string, args: ..Any, to_standard_error := false) #expand {
    new_ctx: Context;
    push_context new_ctx {
        print(format, ..args, to_standard_error);
    }
} @PrintLike

wgpu_log_callback :: (level: wgpu.LogLevel, message: *u8, data: *void) #c_call {
    c_print("WGPU - % : %\n", level, to_string(message));
}

wgpu_device_lost_callback :: (reason: wgpu.DeviceLostReason, message: *u8, userdata: *void) -> void #c_call {
    c_print("WGPU DEVICE LOST - % : %\n", reason, to_string(message));
    debug_break();
}

wgpu_error_callback :: (type: wgpu.ErrorType, message: *u8, userdata: *void) -> void #c_call {
    c_print("WGPU ERROR - % : %\n", type, to_string(message));
    debug_break();
}

wgpu_on_queue_work_done :: (status: wgpu.QueueWorkDoneStatus, userdata: *void) -> void #c_call {
    c_print("WGPU QUEUE - %\n", status);
}

WGPU_Check :: (item: *$T) -> *T #expand {
    assert(item != null, "Unable to create %!", T);
    return item;
}
