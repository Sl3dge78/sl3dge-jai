
// --------
// Shaders

STANDARD :: #string _GLSL
#ifdef VERTEX_SHADER
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aUv;
layout (location = 3) in vec4 aColor;

uniform mat4 Projection;
uniform mat4 View;
uniform mat4 Model;
uniform mat4 Light;

out vec3 Normal;
out vec2 TexCoords;
out vec3 FragPos;
out vec4 VertexColor;
out vec4 FragPosLightSpace;

void main() {
    Normal = aNormal;
    TexCoords = aUv;
    VertexColor = aColor;
    FragPos = vec3(Model * vec4(aPos, 1.0));
    FragPosLightSpace = Light * vec4(FragPos, 1.0);
    gl_Position = Projection * View * vec4(FragPos, 1.0);
    // gl_Position = Light * vec4(FragPos, 1.0);
}

#endif // VERTEX_SHADER

#ifdef FRAGMENT_SHADER
out vec4 FragColor;

in vec3 FragPos;
in vec3 Normal;
in vec2 TexCoords;
in vec4 VertexColor;
in vec4 FragPosLightSpace;

uniform sampler2D texture0;
uniform sampler2D shadow_map;
uniform vec3 light_dir;

float constant = 1.0f;
float linear = 0.09f;
float quadratic = 0.002f;

vec3 ambient_color = vec3(0.529, 0.808, 0.922);

const float shadow_factor = 0.1;

const int pcf_count = 2;
const int pcf_total_texels = (pcf_count * 2 + 1) * (pcf_count * 2 + 1);
const float map_size = 2048.0;
const float texel_size = 1.0 / map_size;

float Shadow(vec4 fragPosLightSpace) {
    vec3 projCoord = fragPosLightSpace.xyz / fragPosLightSpace.w;
    projCoord = projCoord * 0.5 + 0.5;
    float current = projCoord.z;
    int total = 0;
    float x = 1.0 - abs(dot(Normal, light_dir));
    float bias = max(10.0 * x, 1.0);
    // float bias = 2;
    // float bias = exp(x * 3.0);
    // float bias = mix(1.0, 10.0, 1.0-x);
    bias *= texel_size;
    for(int x = -pcf_count; x <= pcf_count; x++) {
        for(int y = -pcf_count; y <= pcf_count; y++) {
            float closest = texture(shadow_map, projCoord.xy + vec2(x, y) * texel_size).r;        
            if (current - bias > closest) {
                total += 1;
            }
        }
    }
    float result = float(total) / float(pcf_total_texels);
    return 1.0 - result;
}

void main() {
    vec3 iterated_color = texture(texture0, TexCoords).rgb * VertexColor.rgb;
    float NdotL = abs(dot(Normal, light_dir));
    float shadow = Shadow(FragPosLightSpace);
    float factor = clamp(min(shadow, NdotL), 0.2, 1.0);
    vec3 ambient = ambient_color * 0.1;
    iterated_color = ambient * (1.0 - factor) + iterated_color * factor;
    FragColor = vec4(iterated_color, 1);
} 

#endif // FRAGMENT_SHADER
_GLSL;

SCREEN_SPACE_SHADER :: #string _GLSL
#ifdef VERTEX_SHADER
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aUv;
layout (location = 3) in vec4 aColor;

out vec2 TexCoords;
out vec4 VertexColor;

uniform mat4 Projection;

void main() {
    gl_Position = Projection * vec4(aPos.xy, 0.0, 1.0); 
    TexCoords = aUv;
    VertexColor = aColor;
}  
#endif // VERTEX_SHADER
#ifdef FRAGMENT_SHADER

out vec4 FragColor;
  
in vec2 TexCoords;
in vec4 VertexColor;

uniform sampler2D texture0;

void main() { 

    vec4 tex = texture(texture0, TexCoords);
    FragColor = vec4(VertexColor.xyz, tex.a * VertexColor.a);
}

#endif // FRAGMENT_SHADER
_GLSL;

SHADOWMAP_SHADER :: #string _GLSL
#ifdef VERTEX_SHADER
layout (location = 0) in vec3 aPos;

uniform mat4 Light;
uniform mat4 Model;

void main() {
    gl_Position = Light * Model * vec4(aPos, 1.0);
}

#endif
#ifdef FRAGMENT_SHADER
void main() {

}

#endif

_GLSL

