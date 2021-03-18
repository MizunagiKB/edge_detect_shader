extends SpinBox


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():

    self.connect("value_changed", self, "_on_value_changed")
    self.hint_tooltip = String(self.value)


func _on_value_changed(value: float):

    match self.name:
        _:
            get_tree().call_group("camera", "set_fov", value)
            self.hint_tooltip = String(value)

