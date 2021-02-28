extends WindowDialog


func ext_name() -> String:
    return "[Blank]"


func ext_init(ext_dir: String) -> bool:
    return true


func ext_show(o_cam: Camera, o_control: Spatial, o_ext: Spatial) -> bool:

    for o in o_control.get_children():
        o.queue_free()

    return true


func ext_hide():
    pass

