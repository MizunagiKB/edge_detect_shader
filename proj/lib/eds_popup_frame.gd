extends WindowDialog
class_name EDSPopupFrame


func _ready():

    $base/btn_ok.connect("pressed", self, "_on_pressed_ok")


func _on_pressed_ok():
    self.hide()
    self.queue_free()
    
