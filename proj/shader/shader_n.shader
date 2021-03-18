shader_type spatial;
render_mode cull_disabled, unshaded;

void vertex()
{
}


void fragment()
{
    ALBEDO = NORMAL;
}
