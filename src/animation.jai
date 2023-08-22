
Animation :: struct {
    length: float;
    tracks: []Animation_Track;

    destroy :: (using self: *Animation) {
        for *tracks {
            free(it.times.data);
            free(it.keys);
        }

        free(tracks.data);
    }
}

Animation_Target :: enum {
    TRANSLATION;
    ROTATION;
}

Animation_Track :: struct {
    key_type: Type;
    times: [] float;
    keys: *void;
    target_node: int;
    target: Animation_Target;
}


load_animation_from_gltf :: (path: string, skeleton: Skeleton_Definition) -> Animation {
    gltf_data := gltf_parse_file(path);
    defer gltf_free(*gltf_data);

    gltf_load_buffers(*gltf_data);

    assert(gltf_data.animations.count == 1, "No or multiple animations in file, this isn't handled!");

    src_anim := gltf_data.animations[0];

    self: Animation;
    self.tracks = NewArray(src_anim.channels.count, Animation_Track);

    for *channel: src_anim.channels {
        track := *self.tracks[it_index];

        assert(channel.target.node != -1, "Animation channel %'s target isn't a node");
        success: bool;
        track.target_node, success = table_find(*skeleton.name_to_id, gltf_data.nodes[channel.target.node].name);
    }

    return self;
}