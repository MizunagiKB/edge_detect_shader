shader_type canvas_item;


void vertex()
{
}


void fragment() {

    vec3 n_out4p0 = vec3(UV, 0.0);
    vec3 n_out5p0;
    float n_out5p1;
    vec4 tex_screen = texture(SCREEN_TEXTURE, SCREEN_UV);

    {
        vec4 _tex_read = texture(TEXTURE, n_out4p0.xy);
        n_out5p0 = _tex_read.rgb;
        n_out5p1 = _tex_read.a;
    }

    if(n_out5p0.r > 0.5)
    {
        	COLOR.rgb = n_out5p0;
    } else {
        	COLOR.rgb = tex_screen.rgb;
    }
}


void light() {
}

