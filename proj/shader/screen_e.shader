shader_type spatial;
render_mode blend_mix, cull_disabled, unshaded, specular_disabled, shadows_disabled, ambient_light_disabled;//, depth_test_disable;


uniform float depth_pow = 10240.0;
uniform float line_weight = 1.0;
uniform vec3 color_line = vec3(0.0);

uniform vec2 viewport = vec2(960, 560);
uniform bool enable_tex = false;
uniform sampler2D tex;


void vertex()
{
    POSITION = vec4(VERTEX, 1.0);
}


void fragment()
{
    if(enable_tex == false)
    {
        vec2 screen_unit = vec2(line_weight / viewport.x, line_weight / viewport.y);
        
        float lin_depth = -8.0 * textureLod(DEPTH_TEXTURE, SCREEN_UV, 0.0).r;
    
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

    } else {

        vec3 n_out5p0;
        float n_out5p1;
        vec4 tex_screen = texture(tex, UV);
    
        {
            n_out5p0 = tex_screen.rgb;
            n_out5p1 = tex_screen.a;
        }
    
        if(n_out5p0.r > 0.5)
        {
            float r = min((n_out5p0.r * 1.5), 1.0);
            float v = sin(radians(r * 180.0));
            ALBEDO.rgb = vec3(0.0);//vec3(v);
            n_out5p1 = v;
        } else {
            n_out5p1 = 0.0;
        }
        
        ALPHA = n_out5p1;
    }
}
