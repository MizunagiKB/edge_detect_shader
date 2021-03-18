shader_type spatial;
render_mode cull_disabled, unshaded;


void vertex()
{
}


void fragment()
{
    float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
    ALBEDO = vec3(depth);
}

