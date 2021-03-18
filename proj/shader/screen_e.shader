shader_type spatial;
render_mode unshaded;


uniform float depth_pow = 10240.0;
uniform float line_weight = 1.0;
uniform vec3 color_line = vec3(0.0);

uniform vec2 viewport = vec2(960, 560);


void vertex()
{
    POSITION = vec4(VERTEX, 1.0);
}


void fragment()
{
    vec2 screen_unit = vec2(line_weight / viewport.x, line_weight / viewport.y);
    
    float lin_depth = -8.0 * texture(DEPTH_TEXTURE, SCREEN_UV).r;

    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + vec2(0.0, screen_unit.y)).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + vec2(0.0, -screen_unit.y)).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + vec2(screen_unit.x, 0.0)).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + vec2(-screen_unit.x, 0.0)).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + screen_unit.xy).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV - screen_unit.xy).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + vec2(-screen_unit.x, screen_unit.y)).r;
    lin_depth += texture(DEPTH_TEXTURE, SCREEN_UV + vec2(screen_unit.x, -screen_unit.y)).r;

    float v = abs(lin_depth * depth_pow);
    //if(v < 0.01) v = 0.0;

    ALPHA = v;
    ALBEDO = color_line;
    //EMISSION = vec3(1.0);
}
