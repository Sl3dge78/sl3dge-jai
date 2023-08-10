

UI_SHADER :: #string __WGSL

    struct Vertex_Input {
        @location(0) position: vec3f, 
        @location(1) normal: vec3f,
        @location(2) uv: vec2f,
        @location(3) color: vec4f,
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

    var<push_constant> push_constants : Push_Constants;
    @group(0) @binding(0) var<uniform> global_data: Global_Buffer;

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
    /*
    fn shadow (shadow_coord: vec4f) -> float {
        let uv : vec2f = shadow_coord.xy * 0.5 + 0.5; // @TODO: Do depth calc in -1 to 1 range
        let current : float = shadow_coord.z;
        var total : int = 0;
        let x = 1.0 - max(dot(In.normal, light_dir), 0.0);
        var bias = max(2.5 * x, 1.0);
        bias *= texel_size;
        for(int x = -pcf_count; x <= pcf_count; x++) {
            for(int y = -pcf_count; y <= pcf_count; y++) {
                float closest = texture(shadow_map, uv + vec2(x, y) * texel_size).r;        
                if (current - bias > closest) {
                    total += 1;
                }
            }
        }
        float result = float(total) / float(pcf_total_texels);
        return 1.0 - result;
    }
    */

    @fragment
    fn fs_main (in: Vertex_Output) -> @location(0) vec4f {
        return vec4f(1.0, 1.0, 1.0, 1.0);
    }

__WGSL

Standard_Push_Constants :: struct {
    transform: Matrix4;
    inverse_transform: Matrix4;
}

Global_Buffer :: struct {
    projection: Matrix4;
    view      : Matrix4;
    light     : Matrix4;
    light_dir : Vector3;
}