extends WindowDialog


const extention_code = "0000"
var o_base_node: Spatial = null
var o_extention_node = null


func ext_name() -> String:
    return "screen_sky"


func ext_init(o_node: Spatial) -> bool:

    self.o_base_node = o_node
    self.o_base_node.get_node("ui").add_child(self)
    self.popup_centered()

    if self.o_base_node.get_node("screen").get_child_count() == 0:
        $btn_screen.select(0)
    else:
        $btn_screen.select(1)

    return true


func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_dlg_screen_sky_popup_hide():
    self.o_base_node.get_node("ui").remove_child(self)


func _on_btn_screen_item_selected(id):
    match id:
        0:
            self.o_extention_node.queue_free()
            self.o_extention_node = null

            self.o_base_node.get_node("cam").environment = null

        1:
            self.o_extention_node = load("res://node/screen_sky/screen_sky.tscn").instance()
            self.o_base_node.get_node("screen").add_child(self.o_extention_node)

            self.o_base_node.get_node("cam").environment = null


func _on_Panel_gui_input(event):

    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT:
            if event.pressed == true:
                Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
            else:
                Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

    if event is InputEventMouseMotion:
        if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:

            var r = self.o_base_node.get_node("cam").rotation_degrees.y
            r = r - event.relative.x
            self.o_base_node.get_node("cam").rotation_degrees.y = r
            
            r = self.o_base_node.get_node("cam").rotation_degrees.x
            r = clamp(r - event.relative.y, -89, 89)
            self.o_base_node.get_node("cam").rotation_degrees.x = r



func _on_slider_time_value_changed(value):
    self.o_extention_node.set_time_of_day(value / 1444.0)


func _on_slider_cloud_size_value_changed(value):
    self.o_extention_node.set_clouds_size(value)


func _on_slider_cloud_coverage_value_changed(value):
    self.o_extention_node.set_clouds_coverage(value)


func _on_wind_strength_value_changed(value):
    self.o_extention_node.set_wind_strength(value)



func _on_btn_ok_pressed():
    self.hide()

