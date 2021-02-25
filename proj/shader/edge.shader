shader_type spatial;
render_mode unshaded, specular_disabled, shadows_disabled, ambient_light_disabled;


uniform float edge_range = 1.0;
uniform float edge_size = 1.0;
uniform vec3 color_value = vec3(0.0, 0.0, 0.0);

uniform float screen_w = 960;
uniform float screen_h = 540;


void vertex()
{
    POSITION = vec4(VERTEX, 1.0);
}


float get_depth(mat4 inv_proj_mtx, sampler2D tex, vec2 uv)
{
    float tex_depth = texture(tex, uv).x;
    vec3 ndc = vec3(uv, tex_depth) * 2.0 - 1.0;
    vec4 view = inv_proj_mtx * vec4(ndc, 1.0);
    view.xyz /= view.w;

    return -view.z;
}

void fragment()
{
    vec2 screen_unit = vec2(edge_size / screen_w, edge_size / screen_h);
    
    float lin_depth = -8.0 * texture(DEPTH_TEXTURE, SCREEN_UV).r;

    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + vec2(0.0, screen_unit.y)).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + vec2(0.0, -screen_unit.y)).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + vec2(screen_unit.x, 0.0)).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + vec2(-screen_unit.x, 0.0)).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + screen_unit.xy).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV - screen_unit.xy).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + vec2(-screen_unit.x, screen_unit.y)).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + vec2(screen_unit.x, -screen_unit.y)).r;

    float v = abs(lin_depth * edge_range);
    if(v < 0.01) v = 0.0;

    ALPHA = v;
    ALBEDO = color_value;
    EMISSION = vec3(0.0);
}
