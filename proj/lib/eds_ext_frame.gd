extends WindowDialog
class_name EDSExtFrame


const WINDOW_MIN_SIZE: int = 256

var ext_node: Control


func add_control(ext_pathname: String) -> bool:

    var node = load(ext_pathname).instance()

    if node == null:
        return false

    node.anchor_top = 0
    node.anchor_bottom = 0
    node.anchor_left = 0
    node.anchor_right = 0

    #node.rect_size.x = 0
    #node.rect_size.y = 0
    node.rect_position.x += 8
    node.rect_position.y += 8

    self.add_child(node)

    var size = Vector2.ZERO

    size.x = max(node.rect_min_size.x, node.rect_size.x)
    size.x = max(WINDOW_MIN_SIZE, size.x)
    size.y = max(node.rect_min_size.y, node.rect_size.y)
    size.y += $base.rect_size.y

    size.x += 16
    size.y += 16

    self.rect_size = size

    self.ext_node = node
    self.ext_node.ext_init(ext_pathname.get_base_dir())

    return true


func _ready():

    self.connect("visibility_changed", self, "_on_visibility_changed")
    self.connect("tree_exited", self, "_on_tree_exited")

    $base/btn_ok.connect("pressed", self, "_on_pressed_ok")
    $base/btn_cancel.connect("pressed", self, "_on_pressed_cancel")


func _on_tree_exited():
    self.ext_node.ext_term()
    self.ext_node.queue_free()


func _on_visibility_changed():
    self.window_title = self.ext_node.ext_name()
    
    if self.visible == true:
        self.ext_node.ext_show(
            get_node("../camera"),
            get_node("../base/node"),
            get_node("../base/extension")
        )
    else:
        self.ext_node.ext_hide()


func _on_pressed_ok():
    self.ext_node.ext_accept()
    self.hide()
    self.queue_free()


func _on_pressed_cancel():
    self.hide()
    self.queue_free()



