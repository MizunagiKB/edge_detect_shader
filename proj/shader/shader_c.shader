shader_type spatial;
render_mode cull_disabled, unshaded;


uniform vec3 color_albedo = vec3(1.0);
uniform float color_alpha = 1.0;


void vertex()
{
}


void fragment()
{
    ALBEDO = color_albedo;
    //ALPHA = color_alpha;
}

