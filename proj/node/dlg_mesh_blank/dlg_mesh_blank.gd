extends WindowDialog


var o_base_ctl = null


func ext_name() -> String:
    return "[Blank]"


func ext_init(_ext_dir: String) -> bool:
    return true


func ext_show(_o_cam: Camera, o_control: Spatial, _o_ext: Spatial) -> bool:

    self.o_base_ctl = o_control

    return true


func ext_hide():
    pass



func _on_btn_ok_pressed():
    for o in self.o_base_ctl.get_children():
        o.queue_free()
    self.hide()

