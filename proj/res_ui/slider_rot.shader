shader_type canvas_item;

void fragment()
{
    vec4 col = texture(TEXTURE, UV);
    
    col.a = col.r;
    col.rgb = vec3(0.0);

    COLOR = col;
}