extends OptionButton
class_name EDSOptionButton


var mat_s_curr: ShaderMaterial = ShaderMaterial.new()
var mat_shader_b = load("res://shader/screen_b.shader") # Basic
var mat_shader_e = load("res://shader/screen_e.shader") # Edge

var mat_m_curr: ShaderMaterial = ShaderMaterial.new()


func request_material():
    get_tree().call_group("screen", "set_material_override", self.mat_s_curr)
    get_tree().call_group("render_node", "set_material_override", self.mat_m_curr)


func set_shader_param(param: String, value):

    match param:
        "color_line":
            var col: Color = value

            self.mat_s_curr.set_shader_param(param, Vector3(col.r, col.g, col.b))

        "color_albedo":
            var col: Color = value

            self.mat_m_curr.set_shader_param(param, Vector3(col.r, col.g, col.b))
            self.mat_m_curr.set_shader_param("color_alpha", col.a)

        "depth_pow":
            var f: float = value

            self.mat_s_curr.set_shader_param(param, (1024.0 * 16.0 * f) / 100.0);

        "line_weight":
            var f: float = value

            self.mat_s_curr.set_shader_param(param, (1.0 * f) / 100.0);

        "viewport":
            var vec2: Vector2 = value

            self.mat_s_curr.set_shader_param(param, vec2);

        "tex":
            if value is Texture:
                var tex: Texture = value
                self.mat_s_curr.set_shader_param("enable_tex", true);
                self.mat_s_curr.set_shader_param(param, tex);
            else:
                self.mat_s_curr.set_shader_param("enable_tex", false);


func _ready():

    self.mat_s_curr.render_priority = 0
    self.mat_m_curr.render_priority = 10

    self.connect("item_selected", self, "_on_item_selected")

    self.add_item("Off")
    self.add_separator()
    self.add_item("Edge")
    self.add_item("Normal")
    self.add_item("Depth")

    self.select(2)
    self._on_item_selected(2)


func _on_item_selected(id: int):

    match id:
        0:
            get_tree().call_group("screen", "set_material_override", self.mat_s_curr)
            self.mat_s_curr.shader = self.mat_shader_b
            get_tree().call_group("render_node", "set_material_override", null)
            self.mat_m_curr.shader = load("res://shader/shader_e.shader")

        2:
            get_tree().call_group("screen", "set_material_override", self.mat_s_curr)
            self.mat_s_curr.shader = self.mat_shader_e
            get_tree().call_group("render_node", "set_material_override", self.mat_m_curr)
            self.mat_m_curr.shader = load("res://shader/shader_c.shader")

        3:
            get_tree().call_group("screen", "set_material_override", self.mat_s_curr)
            self.mat_s_curr.shader = self.mat_shader_b
            get_tree().call_group("render_node", "set_material_override", self.mat_m_curr)
            self.mat_m_curr.shader = load("res://shader/shader_n.shader")

        4:
            get_tree().call_group("screen", "set_material_override", self.mat_s_curr)
            self.mat_s_curr.shader = self.mat_shader_b
            get_tree().call_group("render_node", "set_material_override", self.mat_m_curr)
            self.mat_m_curr.shader = load("res://shader/shader_d.shader")
