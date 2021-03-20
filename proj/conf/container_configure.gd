extends VBoxContainer


var o_dlg: FileDialog
var o_control: LineEdit


func ext_name() -> String:
    return "Configure"


func ext_init(ext_dir: String) -> bool:
    return true


func ext_show(_o_cam: Camera, o_node: Spatial, _o_ext: Spatial) -> bool:
    return true

func ext_hide():
    pass

func ext_accept():

    LibConfigure.mesh_dir = $hbox1/hbox1/mesh_dir.text
    LibConfigure.capture_image_dir = $hbox2/hbox1/capture_image_dir.text

    match $hbox3/render_scale.get_selected_id():
        0:
            LibConfigure.render_scale = 1
        1:
            LibConfigure.render_scale = 2
        2:
            LibConfigure.render_scale = 4
        3:
            LibConfigure.render_scale = 8

    LibConfigure.line_scale = $hbox4/line_scale.get_selected_id()
    
    LibConfigure.save()


func ext_term():
    pass


func _ready():

    LibConfigure.load()

    self.o_dlg = FileDialog.new()
    self.o_dlg.rect_size.x = 480
    self.o_dlg.rect_size.y = 360
    self.o_dlg.mode = FileDialog.MODE_OPEN_DIR
    self.o_dlg.access = FileDialog.ACCESS_FILESYSTEM
    self.o_dlg.connect("confirmed", self, "_on_confirmed")

    self.add_child(self.o_dlg)

    $hbox1/hbox1/mesh_dir.text = LibConfigure.mesh_dir
    $hbox1/hbox1/btn_mesh_dir.connect("pressed", self, "_on_pressed_mesh_dir")

    $hbox2/hbox1/capture_image_dir.text = LibConfigure.capture_image_dir
    $hbox2/hbox1/btn_capture_image_dir.connect("pressed", self, "_on_pressed_capture_image_dir")

    $hbox3/render_scale.add_item("x1")
    $hbox3/render_scale.add_item("x2")
    $hbox3/render_scale.add_item("x4")
    $hbox3/render_scale.add_item("x8")

    match LibConfigure.render_scale:
        1:
            $hbox3/render_scale.select(0)
        2:
            $hbox3/render_scale.select(1)
        4:
            $hbox3/render_scale.select(2)
        8:
            $hbox3/render_scale.select(3)

    $hbox4/line_scale.add_item("none scaling")
    $hbox4/line_scale.add_item("scaling")

    $hbox4/line_scale.select(LibConfigure.line_scale)


func _on_pressed_mesh_dir():

    self.o_control = $hbox1/hbox1/mesh_dir
    self.o_dlg.current_dir = self.o_control.text
    self.o_dlg.popup_centered()


func _on_pressed_capture_image_dir():

    self.o_control= $hbox2/hbox1/capture_image_dir
    self.o_dlg.current_dir = self.o_control.text
    self.o_dlg.popup_centered()


func _on_confirmed():
    self.o_control.text = self.o_dlg.current_dir

