extends Control
class_name EDSControlSize

const MIN_WINDOW_W = 640
const MIN_WINDOW_H = 480

var require_update: bool = false
var window_move: Vector2
var window_size: Vector2
var mouse_pos: Vector2
var mouse_pressed: bool = false


func _ready():

    self.window_move = OS.window_position
    self.window_size = OS.window_size

    self.connect("gui_input", self, "_on_gui_input")


func _process(_delta):

    if self.require_update == true:
        OS.window_size = self.window_size
        OS.window_position = self.window_move
        self.require_update = false


func _on_gui_input(event):

    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT:
            if event.pressed == true:
                self.window_move = OS.window_position
                self.window_size = OS.window_size
                self.mouse_pos = event.position
            else:
                self.warp_mouse(self.mouse_pos)

            self.mouse_pressed = event.pressed


    if event is InputEventMouseMotion:
        if self.mouse_pressed == true:

            match self.mouse_default_cursor_shape:
                CURSOR_HSIZE:
                    self.window_size.x += event.relative.x
                CURSOR_VSIZE:
                    self.window_size.y += event.relative.y
                CURSOR_FDIAGSIZE:
                    self.window_size += event.relative

            var w = max(self.window_size.x, MIN_WINDOW_W)
            var h = max(self.window_size.y, MIN_WINDOW_H)
            self.window_size = Vector2(w, h)
            self.require_update = true
