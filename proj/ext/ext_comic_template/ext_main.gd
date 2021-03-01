extends WindowDialog


var extention_dir = null

var result = false
var o_base_ctl = null
var list_node = []

var need_update = false
onready var list_update_event = [
]


func ext_name() -> String:
    return "[Comic Template]"


func ext_init(ext_dir: String) -> bool:
    self.extention_dir = ext_dir
    return true


func ext_show(o_cam: Camera, o_control: Spatial, o_ext: Spatial) -> bool:

    self.result = false
    self.o_base_ctl = o_control
    self.list_node = []

    for o in self.o_base_ctl.get_children():
        self.o_base_ctl.remove_child(o)
        self.list_node.append(o)

    for o_ui in list_update_event:
        if o_ui.control.is_connected(o_ui.signal_name, self, "evt_value_changed") != true:
            o_ui.control.connect(o_ui.signal_name, self, "evt_value_changed")

    return true


func ext_hide():

    if self.result == true:
        for o in self.list_node:
            o.queue_free()
    else:

        for o in self.list_node:
            if o != null:
                self.o_base_ctl.add_child(o)


func mm_to_px(w_mm, h_mm, dpi):

    var rect_result = Rect2(0, 0, 0, 0)
    rect_result.size.x = float(w_mm * dpi) / 25.4
    rect_result.size.x = int(floor(rect_result.size.x + 1)) & ~1

    rect_result.size.y = float(h_mm * dpi) / 25.4
    rect_result.size.y = int(floor(rect_result.size.y + 1)) & ~1

    return rect_result


func generate_paper(margin):

    var rect_a4 = mm_to_px(210, 297, $ViewportContainer/Viewport/comic.DPI)

    $ViewportContainer/Viewport/comic.PAPER_RECT = rect_a4
    

    $ViewportContainer/Viewport.size = rect_a4.size
    $ViewportContainer/Viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)

    yield(VisualServer, "frame_post_draw")
    

    var o_image = $ViewportContainer/Viewport.get_texture().get_data()

    if o_image != null:
        o_image.convert(Image.FORMAT_RGBA8)
        o_image.flip_y()
        o_image.save_png(CONF.capture_image_dir + "/testimage.png")

    $ViewportContainer/Viewport.size = Vector2.ZERO


func _ready():
    pass # Replace with function body.


func _process(delta):

    if self.need_update == true:

        self.need_update = false


func evt_value_changed(value):
    self.need_update = true


func _on_btn_ok_pressed():
    self.result = true
    self.hide()




func _on_btn_generate_pressed():
    self.generate_paper(3)


func _on_paper_dpi_item_selected(id):
    match id:
        0:
            $ViewportContainer/Viewport/comic.DPI = 150
        1:
            $ViewportContainer/Viewport/comic.DPI = 300
        2:
            $ViewportContainer/Viewport/comic.DPI = 600
