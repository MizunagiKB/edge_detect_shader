extends WindowDialog


var extention_dir = null

var result = false
var o_base_ctl = null
var list_node = []

var need_update = false
onready var list_update_event = [
]

var PAPER_SIZE = [
    {"id": 0, "name": "ComicB5",
        "src": {"w": 210, "h": 297},
        "dst": {"w": 182, "h": 257}
        },
    {"id": 1, "name": "A3", "src": {"w": 297, "h": 420}},
    {"id": 2, "name": "A4", "src": {"w": 210, "h": 297}},
    {"id": 3, "name": "A5", "src": {"w": 148, "h": 210}},
    {"id": 4, "name": "B4", "src": {"w": 257, "h": 364}},
    {"id": 5, "name": "B5", "src": {"w": 182, "h": 257}},
    {"id": 6, "name": "Shikishi", "src": {"w": 242, "h": 273}},
    {"id": 7, "name": "Shikishi Half", "src": {"w": 120, "h": 135}},
    {"id": 8, "name": "Hagaki", "src": {"w": 100, "h": 148}}
]

func ext_name() -> String:
    return "[Paper Template]"


func ext_init(ext_dir: String) -> bool:
    self.extention_dir = ext_dir
    return true


func ext_show(_o_cam: Camera, o_control: Spatial, _o_ext: Spatial) -> bool:

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


func mm_to_px(size_mm: Vector2) -> Vector2:

    var vct_result = Vector2.ZERO
    vct_result.x = float(size_mm.x * $preview/viewport/paper.DPI) / 25.4
    vct_result.x = int(floor(vct_result.x + 1)) & ~1

    vct_result.y = float(size_mm.y * $preview/viewport/paper.DPI) / 25.4
    vct_result.y = int(floor(vct_result.y + 1)) & ~1

    return vct_result


func generate_paper():

    match $paper_dpi.get_selected_id():
        0: $preview/viewport/paper.DPI = 75
        1: $preview/viewport/paper.DPI = 150
        2: $preview/viewport/paper.DPI = 300
        3: $preview/viewport/paper.DPI = 600

    $preview/viewport/paper.MARGIN = self.mm_to_px(
        Vector2($lbl_margin/margin.value, $lbl_margin/margin.value)
        )
    $preview/viewport/paper.COMMENT = $lbl_comment/comment.text

    var item = PAPER_SIZE[$paper_size.get_item_index($paper_size.get_selected_id())]
    var src_rect: Rect2
    var dst_rect: Rect2
    var paper_name: String = "/{0}_{1}x{2}-{3}.png".format(
        [item.name, item.src.w, item.src.h, $preview/viewport/paper.DPI]
        )
    
    assert(item.src != null)
    src_rect = Rect2(Vector2.ZERO, self.mm_to_px(Vector2(item.src.w, item.src.h)))
    $preview/viewport/paper.PAPER_SRC_RECT = src_rect
    if item.has("dst") == true:
        var size = self.mm_to_px(Vector2(item.dst.w, item.dst.h))
        dst_rect = Rect2((src_rect.size - size) / 2, size)
    $preview/viewport/paper.PAPER_DST_RECT = dst_rect

    # render
    $preview/viewport.size = src_rect.size

    $preview/viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)

    yield(VisualServer, "frame_post_draw")

    var o_image = $preview/viewport.get_texture().get_data()

    if o_image != null:
        o_image.convert(Image.FORMAT_RGBA8)
        o_image.flip_y()
        o_image.save_png(CONF.capture_image_dir + paper_name)

    $preview/viewport.size = Vector2.ZERO


func _ready():

    for item in PAPER_SIZE:
        var label = "{0} ({1}mm x {2}mm)".format([item.name, item.src.w, item.src.h])
        $paper_size.add_item(label, item.id)


func _process(_delta):

    if self.need_update == true:

        self.need_update = false


func evt_value_changed(_value):
    self.need_update = true


func _on_btn_ok_pressed():
    self.result = true
    self.hide()




func _on_btn_generate_pressed():
    self.generate_paper()


func _on_paper_dpi_item_selected(id):
    match id:
        0:
            $ViewportContainer/Viewport/comic.DPI = 150
        1:
            $ViewportContainer/Viewport/comic.DPI = 300
        2:
            $ViewportContainer/Viewport/comic.DPI = 600



