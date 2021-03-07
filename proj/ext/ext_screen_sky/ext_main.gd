extends WindowDialog


var extention_dir = null

var o_base_cam: Camera = null
var o_base_ext: Spatial = null
var o_extention_node = null


func ext_name() -> String:
    return "[Sceen Sky Shader]"


func ext_init(ext_dir: String) -> bool:
    self.extention_dir = ext_dir
    return true


func get_conf() -> Dictionary:
    return {}


func set_conf(_conf: Dictionary) -> bool:
    return false


func ext_show(o_cam: Camera, _o_control: Spatial, o_ext: Spatial) -> bool:
    self.o_base_cam = o_cam
    self.o_base_ext = o_ext

    if o_base_ext.get_child_count() == 0:
        $btn_screen.select(0)
    else:
        $btn_screen.select(1)

    return true


func ext_hide():
    self.o_base_cam = null
    self.o_base_ext = null


func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_btn_screen_item_selected(id):
    match id:
        0:
            self.o_extention_node.queue_free()
            self.o_extention_node = null
            self.o_base_cam.environment = null
        1:
            self.o_extention_node = load(self.extention_dir + "/screen_sky.tscn").instance()
            self.o_extention_node.set_time_of_day($lbl_time/slider_time.value / 1440.0)
            self.o_extention_node.set_clouds_coverage($lbl_cloud_coverage/slider_clouds_coverage.value)
            self.o_extention_node.set_clouds_size($lbl_cloud_size/slider_clouds_size.value)
            self.o_extention_node.set_wind_strength($lbl_wind_strength/wind_strength.value)
            self.o_base_ext.add_child(self.o_extention_node)
            self.o_base_cam.environment = null


func _on_slider_time_value_changed(value):
    if self.o_extention_node != null:
        self.o_extention_node.set_time_of_day(value / 1444.0)


func _on_slider_clouds_coverage_value_changed(value):
    if self.o_extention_node != null:
        self.o_extention_node.set_clouds_coverage(value)


func _on_slider_clouds_size_value_changed(value):
    if self.o_extention_node != null:
        self.o_extention_node.set_clouds_size(value)


func _on_wind_strength_value_changed(value):
    if self.o_extention_node != null:
        self.o_extention_node.set_wind_strength(value)


func _on_btn_ok_pressed():
    self.hide()

