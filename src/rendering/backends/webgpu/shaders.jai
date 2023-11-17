
UI_SHADER :: #string __WGSL

    struct Vertex_Input {
        @location(0) position: vec2f, 
        @location(1) uv: vec2f,
        @location(2) color: vec4f,
    };

    struct Vertex_Output {
        @builtin(position) position: vec4f,
        @location(0) color: vec4f,
        @location(1) uv: vec2f,
    };

    struct Push_Constants {
        scale: vec2f,
        translation: vec2f,
    };

    @group(0) @binding(0) var texture_sampler: sampler;
    @group(0) @binding(1) var texture: texture_2d<f32>;

    var<push_constant> push_constants : Push_Constants;

    @vertex
    fn vs_main (in: Vertex_Input) -> Vertex_Output {
        var out: Vertex_Output;
        out.color = in.color;
        out.uv    = in.uv;
        let pos_2d : vec2f = in.position.xy * push_constants.scale + push_constants.translation;
        out.position = vec4f(pos_2d, 0.0, 1.0);
        return out;
    }

    @fragment
    fn fs_main (in: Vertex_Output) -> @location(0) vec4f {
        return in.color * textureSample(texture, texture_sampler, in.uv).r;
    }

__WGSL

UI_Vertex :: struct {
    position: Vector2;
    uv: Vector2;
    color: Vector4 = .{1, 1, 1, 1};
}

UI_Push_Constants :: struct {
    scale: Vector2;
    translation: Vector2;
}


// Standard

STANDARD_SHADER :: #string __WGSL 
    struct Static_Vertex_Input {
        @location(0) position: vec3f, 
        @location(1) normal: vec3f,
        @location(2) uv: vec2f,
        @location(3) color: vec4f,
    };

    struct Skinned_Vertex_Input {
        @location(0) position: vec3f, 
        @location(1) normal: vec3f,
        @location(2) uv: vec2f,
        @location(3) color: vec4f,
        @location(4) joints: vec4<u32>,
        @location(5) weights: vec4f,
    };

    struct Vertex_Output {
        @builtin(position) position: vec4f,
        @location(0) normal: vec3f,
        @location(1) uv: vec2f,
        @location(2) color: vec4f,
        @location(3) pos_light_space: vec4f,
    };

    struct Push_Constants {
        transform: mat4x4f,
        inverse_transform: mat4x4f,
    };

    struct Global_Buffer {
        projection: mat4x4f,
        view      : mat4x4f,
        light     : mat4x4f,
        light_dir : vec3f,
    };

    struct Instance_Data {
        joint_matrices: array<mat4x4f, 128>,
    };

    var<push_constant> push_constants : Push_Constants;
    @group(0) @binding(0) var<uniform> global_data: Global_Buffer;
    @group(1) @binding(0) var shadow_sampler: sampler;
    @group(1) @binding(1) var shadow_texture: texture_depth_2d;
    @group(2) @binding(0) var<uniform> instance_data: Instance_Data;

    @vertex
    fn static_vs (in: Static_Vertex_Input) -> Vertex_Output {
        var result : Vertex_Output;
        let xform = global_data.projection * global_data.view * push_constants.transform;
        result.position = xform * vec4f(in.position, 1.0);
        result.color = in.color;
        let inv_transform3 = mat3x3f(push_constants.inverse_transform[0].xyz, push_constants.inverse_transform[1].xyz, push_constants.inverse_transform[2].xyz);
        result.normal = transpose(inv_transform3) * in.normal;
        result.uv = in.uv;
        let light_xform = global_data.light * push_constants.transform;
        result.pos_light_space = light_xform * vec4f(in.position, 1.0);
        return result;
    }

    @vertex
    fn skinned_vs (in: Skinned_Vertex_Input) -> Vertex_Output {
        let skin_mat = in.weights.x * instance_data.joint_matrices[in.joints.x] + 
            in.weights.y * instance_data.joint_matrices[in.joints.y] +
            in.weights.z * instance_data.joint_matrices[in.joints.z] +
            in.weights.w * instance_data.joint_matrices[in.joints.w];
        let world_pos = push_constants.transform * skin_mat * vec4f(in.position, 1.0);

        var result: Vertex_Output;
        result.position = global_data.projection * (global_data.view * world_pos);

        result.color = in.color;
        result.normal = (skin_mat * vec4f(in.normal, 0.0)).xyz;
        result.uv = in.uv;
        result.pos_light_space = global_data.light * world_pos;
        return result;
    }
    
    fn shadow (shadow_coord: vec4f, normal: vec3f) -> f32 {
        let pcf_count = 3;
        let pcf_total_texels = (pcf_count * 2 + 1) * (pcf_count * 2 + 1);
        let map_size = 2048.0;
        let texel_size = 1.0 / map_size;

        let uv : vec2f = shadow_coord.xy * vec2f(0.5, -0.5) + 0.5; // @TODO: Do depth calc in -1 to 1 range
        let current : f32 = shadow_coord.z;
        var total : i32 = 0;
        let x = 1.0 - max(dot(normal, global_data.light_dir), 0.0);
        var bias = max(2.5 * x, 1.0);
        bias *= texel_size;
        for(var x = -pcf_count; x <= pcf_count; x++) {
            for(var y = -pcf_count; y <= pcf_count; y++) {
                let closest = textureSample(shadow_texture, shadow_sampler, uv + vec2f(f32(x), f32(y)) * vec2f(texel_size, texel_size));        
                if (current - bias > closest) {
                    total += 1;
                }
            }
        }
        let result = f32(total) / f32(pcf_total_texels);
        return 1.0 - result;
    }

    @fragment
    fn fs_main (in: Vertex_Output) -> @location(0) vec4f {
        let L = global_data.light_dir;
        var iterated_color = in.color.rgb;
        let NdotL = max(dot(in.normal, -L), 0.0);
        let shadow = shadow(in.pos_light_space / in.pos_light_space.w, in.normal);
        let ambient = vec3(0.529, 0.808, 0.922) * 0.1;
        let factor = max(min(shadow, sqrt(NdotL)), 0.2);
        iterated_color = ambient * (1.0 - factor) + iterated_color * factor;

        return vec4f(iterated_color, 1.0);
    }

__WGSL

Standard_Vertex :: struct {
    position: Vector3;
    normal: Vector3;
    uv: Vector2;
    color: Vector4 = .{1, 1, 1, 1};
}

Skinned_Vertex :: struct {
    joints: [4]u8;
    weights: Vector4;
}

Standard_Push_Constants :: struct {
    transform: Matrix4;
    inverse_transform: Matrix4;
}

Global_Matrices :: struct {
    projection: Matrix4;
    view      : Matrix4;
    light     : Matrix4;
    light_dir : Vector3;
    __align : float;
}

Instance_Data :: struct {
    joint_matrices: [128]Matrix4;
};

// DEBUG

DEBUG_SHADER :: #string __WGSL
    struct Vertex_Input {
        @location(0) position: vec3f, 
        @location(1) color: vec4f,
    };

    struct Vertex_Output {
        @builtin(position) position: vec4f,
        @location(0) color: vec4f,
    };

    struct Push_Constants {
        transform: mat4x4f,
        inverse_transform: mat4x4f,
    };

    struct Global_Buffer {
        projection: mat4x4f,
        view      : mat4x4f,
        light     : mat4x4f,
        light_dir : vec3f,
    };

    var<push_constant> push_constants : Push_Constants;
    @group(0) @binding(0) var<uniform> global_data: Global_Buffer;

    @vertex
    fn vs_main (in: Vertex_Input) -> Vertex_Output {
        var out: Vertex_Output;
        out.color = in.color;
        let xform = global_data.projection * global_data.view * push_constants.transform;
        out.position = xform * vec4f(in.position, 1.0);
        return out;
    }

    @fragment
    fn fs_main (in: Vertex_Output) -> @location(0) vec4f {
        return in.color;
    }
__WGSL

Debug_Vertex :: struct {
    position: Vector3;
    color: Vector4 = .{1, 1, 1, 1};
}