extends HScrollBar
class_name EDSShaderParam_float


func _ready():
    self.connect("value_changed", self, "_on_value_changed")
    self.hint_tooltip = String(self.value)


func _on_value_changed(value: float):

    match self.name:
        _:
            get_tree().call_group("render_mode", "set_shader_param", self.name, value)
            self.editor_description = String(value)
