
Animation :: struct {
    length: float;
    tracks: []Animation_Track;
    root_transform: Matrix4;
}

destroy :: (using self: *Animation) {
    for *tracks {
        free(it.key_times.data);
        free(it.translation.data);
    }

    free(tracks.data);
}

Animation_Target :: enum {
    TRANSLATION;
    ROTATION;
    SCALE;
}

Animation_Track_Data :: struct {
    target: Animation_Target;
    translation: []Vector3;
    #place translation;
    rotation: []Quaternion;
    #place translation;
    scale: []Vector3;
}

Animation_Track :: struct {
    target: Animation_Target;
    target_node: int;

    key_times: [] float;
    translation: []Vector3;
    #place translation;
    rotation: []Quaternion;
    #place translation;
    scale: []Vector3;
}

load_animation_from_gltf :: (path: string, skeleton: Skeleton_Definition, scale_factor : float = 1) -> Animation {
    gltf_data := gltf_parse_file(path);
    defer gltf_free(*gltf_data);

    gltf_load_buffers(*gltf_data);

    assert(gltf_data.animations.count == 1, "No or multiple animations in file, this isn't handled!");
    src_anim := gltf_data.animations[0];

    self: Animation;
    tracks : [..]Animation_Track;

    for *channel: src_anim.channels {
        
        sampler := src_anim.samplers[channel.sampler];
        input := gltf_data.accessors[sampler.input];
        output := gltf_data.accessors[sampler.output];

        assert(channel.target.node != -1, "Animation channel %'s target isn't a node");
        assert(input.count == output.count, "Key times count != Key values count");
        bone_name := gltf_data.nodes[channel.target.node].name;
        target_node, success := table_find(*skeleton.name_to_id, bone_name);
        if !success {
            log_error("Bone % couldn't be found in reference skeleton", bone_name);
            continue;
        }

        track := array_add(*tracks);
        track.target_node = target_node;
        
        track.key_times = NewArray(input.count, float);
        read_accessor_into_array(track.key_times.data, 0, size_of(float), gltf_data, sampler.input);

        if channel.target.property == {
            case .TRANSLATION; {
                track.target = .TRANSLATION;
                track.translation = NewArray(output.count, Vector3);
                read_accessor_into_array(track.translation.data, 0, size_of(Vector3), gltf_data, sampler.output);
                // Because in fucking blender you can't reset the scale of the skeleton without destroying your whole animation
                // And I don't want to have to apply its xform matrix to each bone for each frame...
                for *track.translation {
                    it.* = it.* * scale_factor;
                }
            }
            case .ROTATION; {
                track.target = .ROTATION;
                track.rotation = NewArray(output.count, Quaternion);
                read_accessor_into_array(track.rotation.data, 0, size_of(Quaternion), gltf_data, sampler.output);
            }
            case .SCALE; {
                track.target = .SCALE;
                track.scale = NewArray(output.count, Vector3);
                read_accessor_into_array(track.scale.data, 0, size_of(Vector3), gltf_data, sampler.output);
            }
            case; assert(false, "Unhandled track type");
        }

        if self.length < track.key_times[track.key_times.count - 1] {
            self.length = track.key_times[track.key_times.count - 1];
        }
    }

    self.tracks.data = tracks.data;
    self.tracks.count = tracks.count;

    return self;
}

animation_track_sample :: (using self: Animation_Track, time_in_samples: float, joint: *Joint) {
    first_key := cast(int) time_in_samples;
    second_key := (first_key + 1) % self.key_times.count;

    t := time_in_samples - cast(float)first_key;

    if #complete self.target == { 
        case .TRANSLATION; {
            joint.translation = lerp(self.translation[first_key], self.translation[second_key], t);
        }
        case .ROTATION; {
            a := self.rotation[first_key];
            b := self.rotation[second_key];
            if dot(a, b) < 0 then b = -b;
            rx := nlerp(a, b, t);
            joint.rotation = rx;
        }
        case .SCALE; {
            sx := lerp(self.scale[first_key], self.scale[second_key], t);
            joint.scale = sx;
        }
    }
}

animation_sample :: (using self: Animation, skeleton: Skeleton_Definition, time: float, result: Skeleton_Pose) {
    time = clamp(time, 0, length);
    
    for tracks {
        time_in_samples := (time / length * it.key_times.count);
        
        joint : *Joint = *result[it.target_node];
        animation_track_sample(it, time_in_samples, joint);
        joint.dirty = true;
    }
}

// Blends from anim1 to anim2
animation_blend :: (anim1: Animation, anim2: Animation, anim1_time: float, anim2_time: float, blend_normalized_time: float, skeleton: Skeleton_Definition, result: Skeleton_Pose) {
    anim1_time = clamp(anim1_time, 0, anim1.length);
    anim2_time = clamp(anim2_time, 0, anim2.length);

    assert(anim1.tracks.count == anim2.tracks.count, "UNIMPLEMENTED: Different no of tracks in animations to blend!");
    
    // @TODO @Robustness We should go through each track in anim1, find the equivalent in anim2 
    // and blend from there
    for it : 0..anim1.tracks.count - 1 {
        t1 := anim1.tracks[it];
        t2 := anim2.tracks[it];

        assert(t1.target_node == t2.target_node, "UNIMPLEMENTED: Tracks target different nodes");
        assert(t1.target == t2.target, "UNIMPLEMENTED: Tracks target different components");

        time_in_samples1 := ((anim1_time / anim1.length) * t1.key_times.count);
        time_in_samples2 := ((anim2_time / anim2.length) * t2.key_times.count);
        
        j1: Joint;
        animation_track_sample(t1, time_in_samples1, *j1);
        j2: Joint;
        animation_track_sample(t2, time_in_samples2, *j2);

        joint : *Joint = *result[t1.target_node];
        if #complete t1.target == { 
            case .TRANSLATION; {
                joint.translation = lerp(j1.translation, j2.translation, blend_normalized_time);
            }
            case .ROTATION; {
                a := j1.rotation;
                b := j2.rotation;
                if dot(a, b) < 0 then b = -b;
                rx := nlerp(a, b, blend_normalized_time);
                joint.rotation = rx;
            }
            case .SCALE; {
                sx := lerp(j1.scale, j2.scale, blend_normalized_time);
                joint.scale = sx;
            }
        }

        joint.dirty = true;
    }
}