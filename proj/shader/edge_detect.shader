shader_type spatial;

uniform float edge_range = 1.0;
uniform float edge_size = 1.0;

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
    vec2 screen_unit = vec2(edge_size / 960.0, edge_size / 540.0);
    
    float lin_depth = -8.0 * texture(DEPTH_TEXTURE, SCREEN_UV).r;

    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + vec2(0.0, screen_unit.y)).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + vec2(0.0, -screen_unit.y)).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + vec2(screen_unit.x, 0.0)).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + vec2(-screen_unit.x, 0.0)).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + screen_unit.xy).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV - screen_unit.xy).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + vec2(-screen_unit.x, screen_unit.y)).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + vec2(screen_unit.x, -screen_unit.y)).r;

    //ALPHA = 0.5;
    //EMISSION = vec3(1.0 - (lin_depth * edge_range));

    ALPHA = abs(lin_depth * edge_range);
    // EMISSION = vec3(0.0);
}
