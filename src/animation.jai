
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

sample_animation :: (using self: Animation, skeleton: Skeleton_Definition, time: float, result: Skeleton_Pose) {
    time = clamp(time, 0, length);
    
    for tracks {
        time_in_samples := (time / length * it.key_times.count);
        first_key := cast(int) time_in_samples;
        second_key := (first_key + 1) % it.key_times.count;

        t := time_in_samples - cast(float)first_key;

        joint : *Joint = *result[it.target_node];

        if #complete it.target == { 
            case .TRANSLATION; {
                tx := lerp(it.translation[first_key], it.translation[second_key], t);
                joint.translation = tx;
            }
            case .ROTATION; {
                a := it.rotation[first_key];
                b := it.rotation[second_key];
                if dot(a, b) < 0 then b = -b;
                rx := nlerp(a, b, t);
                joint.rotation = rx;
            }
            case .SCALE; {
                sx := lerp(it.scale[first_key], it.scale[second_key], t);
                joint.scale = sx;
            }
        }
        joint.dirty = true;
    }
}