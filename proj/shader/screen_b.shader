shader_type spatial;


uniform sampler2D tex;


void vertex()
{
    POSITION = vec4(VERTEX, 1.0);
}


void fragment()
{
    vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);

    EMISSION = color.rgb;
    ALPHA = color.a;
}
