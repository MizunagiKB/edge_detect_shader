shader_type spatial;
render_mode blend_add, cull_disabled, unshaded, specular_disabled, shadows_disabled, ambient_light_disabled;//, depth_test_disable;


void vertex()
{
    vec2 scale = vec2(
        length(MODELVIEW_MATRIX[0]) / 2.0,
        length(MODELVIEW_MATRIX[1])
    );
    
    scale *= 8.0;
    
    vec4 billboard = MODELVIEW_MATRIX * vec4(0.0, 0.0, 0.0, 1.0);
    vec4 newPosition = PROJECTION_MATRIX * billboard + vec4(scale * VERTEX.xy, 0.0, 0.0);
    vec4 orig_pos = POSITION;

    UV = vec2(VERTEX.x + 0.5, VERTEX.y + 0.5);
    POSITION = newPosition;
    VERTEX = VERTEX;
}


void fragment()
{
    vec2 pos = UV - vec2(0.5);

    float len = max(0.5 - length(pos), 0.0);
    float alp = len;

    ALPHA = alp;
    ALBEDO = vec3(len);
}
