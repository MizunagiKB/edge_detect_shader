extends VBoxContainer


var o_dlg: FileDialog
var o_control: LineEdit


func save():
    
    LibConfigure.mesh_dir = $ctl_mesh_dir/mesh_dir.text
    LibConfigure.capture_image_dir = $ctl_capture_image_dir/capture_image_dir.text
    
    LibConfigure.save()


func _ready():

    LibConfigure.load()

    self.o_dlg = FileDialog.new()
    self.o_dlg.rect_size.x = 480
    self.o_dlg.rect_size.y = 360
    self.o_dlg.mode = FileDialog.MODE_OPEN_DIR
    self.o_dlg.access = FileDialog.ACCESS_FILESYSTEM
    self.add_child(self.o_dlg)

    $ctl_mesh_dir/mesh_dir.text = LibConfigure.mesh_dir
    $ctl_mesh_dir/btn_mesh_dir.connect("pressed", self, "_on_pressed_mesh_dir")

    $ctl_capture_image_dir/capture_image_dir.text = LibConfigure.capture_image_dir
    $ctl_capture_image_dir/btn_capture_image_dir.connect("pressed", self, "_on_pressed_capture_image_dir")

    self.o_dlg.connect("confirmed", self, "_on_confirmed")


func _on_pressed_mesh_dir():

    self.o_control = $ctl_mesh_dir/mesh_dir
    self.o_dlg.current_dir = self.o_control.text
    self.o_dlg.popup_centered()


func _on_pressed_capture_image_dir():

    self.o_control= $ctl_capture_image_dir/capture_image_dir
    self.o_dlg.current_dir = self.o_control.text
    self.o_dlg.popup_centered()


func _on_confirmed():
    self.o_control.text = self.o_dlg.current_dir

