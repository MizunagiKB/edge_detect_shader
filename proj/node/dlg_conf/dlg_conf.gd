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
    $lbl_capture_image_dir/capture_image_dir.text = CONF.capture_image_dir
    $lbl_capture_scale/spin_capture_scale.value = CONF.capture_scale


func _on_btn_capture_image_dir_pressed():

    $dlg_capture_image_dir.current_dir = $lbl_capture_image_dir/capture_image_dir.text
    $dlg_capture_image_dir.popup_centered()


func _on_dlg_capture_image_dir_confirmed():

    $lbl_capture_image_dir/capture_image_dir.text = $dlg_capture_image_dir.current_dir


func _on_btn_ok_pressed():

    CONF.capture_image_dir = $lbl_capture_image_dir/capture_image_dir.text
    CONF.capture_scale = $lbl_capture_scale/spin_capture_scale.value

    self.hide()


