extends ColorPickerButton
class_name EDSShaderParam_ColorPickerButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    self.connect("color_changed", self, "_on_color_changed")
    self.hint_tooltip = "R:%d, G:%d, B:%d, A:%d" % [
        self.color.r8,
        self.color.g8,
        self.color.b8,
        self.color.a8
        ]


func _on_color_changed(color: Color):

    match self.name:
        _:
            get_tree().call_group("render_mode", "set_shader_param", self.name, color)
