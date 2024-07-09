c_print :: (format: string, args: ..Any, to_standard_error := false) #expand {
    new_ctx: Context;
    push_context new_ctx {
        print(format, ..args, to_standard_error);
    }
} @PrintLike

adapter_cb :: (status: wgpu.RequestAdapterStatus, adapter: wgpu.Adapter, message: *u8, userdata: *void) -> void #c_call {
    if status != .Success {
        c_print("%\n", message);
        return;
    }
    (cast(*wgpu.Adapter) userdata).* = adapter;
}

device_cb :: (status: wgpu.RequestDeviceStatus, device: wgpu.Device, message: *u8, userdata: *void) #c_call {
    if status != .Success {
        c_print("%\n", message);
        return;
    }
    (cast(*wgpu.Device) userdata).* = device;
}

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

report_gpu_leaks :: (instance: wgpu.Instance) {
    storage_report :: (s: wgpu.RegistryReport, name: string, builder: *String_Builder) -> bool {
        if s.numAllocated == 0 then return false;
        print_to_builder(builder, "%: %\n", name, s.numAllocated);
        return true;
    }

    hub_report :: (h: wgpu.HubReport, builder: *String_Builder) -> bool {
        found := false;
        arr : [16]wgpu.RegistryReport = xx *h;
        ti := type_info(wgpu.HubReport);
        
        for 1..ti.members.count - 1 { // Skip adapters...
            found |= storage_report(arr[it], ti.members[it].name, builder);
        }
        return found;
    }

    report : wgpu.GlobalReport;
    wgpu.GenerateReport(instance, *report);
    
    builder: String_Builder;
    found:= false;

    found |= storage_report(report.surfaces, "Surfaces", *builder);
    found |= hub_report(report.vulkan, *builder);
    found |= hub_report(report.gl, *builder);
    found |= hub_report(report.metal, *builder);
    found |= hub_report(report.dx12, *builder);
    if found {
        log("=== GPU Leaks found ===");
        str := builder_to_string(*builder);
        defer free(str);
        log("%", str);
        // print_all_handles();
        debug_break();
    }
}

// WgpuAllocInfo :: struct {
//     handle: wgpu.BindGroup;
//     id : int;
// }

// handle_id := 0;
// all_handles : [..]WgpuAllocInfo;
// print_all_handles :: () {
//     for all_handles {
//         log("%", it);
//     }
// }

// DeviceCreateBindGroup :: (device: wgpu.Device, desc: *wgpu.BindGroupDescriptor) -> wgpu.BindGroup {
//     result := wgpu.DeviceCreateBindGroup(device, desc);
//     array_add(*all_handles, .{result, handle_id});
//     handle_id += 1;
//     return result;
// }

// BindGroupRelease :: (h: wgpu.BindGroup) {
//     wgpu.BindGroupRelease(h);
//     for all_handles {
//         if it.handle == h {
//             array_unordered_remove_by_index(*all_handles, it_index);
//             return;
//         }
//     }
//     assert(false, "Double free??");
// }