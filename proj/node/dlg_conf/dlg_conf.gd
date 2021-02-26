extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func _on_dlg_conf_about_to_show():

    $lbl_mesh_dir/line_edit.text = CONF.mesh_dir
    $lbl_capture_image_dir/line_edit.text = CONF.capture_image_dir
    $lbl_capture_scale/spin_capture_scale.value = CONF.capture_scale
    $lbl_capture_screen_ratio/btn_capture_screen_ratio.selected = CONF.capture_screen_ratio


func _on_btn_mesh_dir_pressed():

    $dlg_choose_dir.current_dir = $lbl_mesh_dir/line_edit.text
    $dlg_choose_dir.connect("confirmed", self, "_evt_mesh_dir_confirmed")
    $dlg_choose_dir.popup_centered()


func _on_btn_capture_image_dir_pressed():

    $dlg_choose_dir.current_dir = $lbl_capture_image_dir/line_edit.text
    $dlg_choose_dir.connect("confirmed", self, "_on_dlg_choose_dir_confirmed")
    $dlg_choose_dir.popup_centered()


func _evt_mesh_dir_confirmed():
    $lbl_mesh_dir/line_edit.text = $dlg_choose_dir.current_dir


func _evt_capture_image_dir_confirmed():
    $lbl_capture_image_dir/line_edit.text = $dlg_choose_dir.current_dir


func _on_btn_ok_pressed():

    CONF.mesh_dir = $lbl_mesh_dir/line_edit.text
    CONF.capture_image_dir = $lbl_capture_image_dir/line_edit.text
    CONF.capture_scale = $lbl_capture_scale/spin_capture_scale.value
    CONF.capture_screen_ratio = $lbl_capture_screen_ratio/btn_capture_screen_ratio.selected

    self.hide()






