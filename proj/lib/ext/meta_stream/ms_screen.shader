shader_type spatial;
render_mode blend_mix, cull_disabled, unshaded, specular_disabled, shadows_disabled, ambient_light_disabled;//, depth_test_disable;


uniform sampler2D tex;

uniform float liquid_entity = 0.2;
uniform float liquid_outline = 2.5;


void vertex()
{
    POSITION = vec4(VERTEX, 1.0);
}


void fragment()
{
    float n_out5p1;
    vec4 tex_screen = texture(tex, UV);

    {
        n_out5p1 = tex_screen.a;
    }

    if(n_out5p1 > liquid_entity)
    {
        float r = min((n_out5p1 * liquid_outline), 1.0);
        float v = sin(radians(r * 180.0));
        ALBEDO.rgb = vec3(0.0);
        n_out5p1 = v;
    } else {
        n_out5p1 = 0.0;
    }
    
    ALPHA = n_out5p1;
}
