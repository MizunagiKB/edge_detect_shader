extends Panel
class_name EDSPanel


var require_update: bool = false
var window_move: Vector2
var mouse_pos: Vector2
var mouse_pressed: bool = false


func _ready():
    
    self.window_move = OS.window_position

    self.connect("gui_input", self, "_on_gui_input")


func _process(_delta):

    if self.require_update == true:
        OS.window_position = self.window_move
        self.require_update = false


func _on_gui_input(event):

    if LibUi.show != true:
        return

    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT:
            if event.pressed == true:
                Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
                self.window_move = OS.window_position
                self.mouse_pos = get_viewport().get_mouse_position()
            else:
                Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
                get_viewport().warp_mouse(self.mouse_pos)

            self.mouse_pressed = event.pressed


    if event is InputEventMouseMotion:
        if self.mouse_pressed == true:
            self.require_update = true
            self.window_move += event.relative

