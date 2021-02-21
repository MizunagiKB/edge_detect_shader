extends Spatial


# https://3dwarehouse.sketchup.com/model/1bd2fba303e04ce1283ffcfc40c29975/Weapon-FN-P90


var cam_z = 10
var btn_l = false
var btn_r = false
var btn_c = false
var pos = Vector2(0, 0)
var rot_l = Vector2(0, 0)
var rot_r = Vector2(0, 0)

var ctl_focus = false

var o_mesh_instance: MeshInstance = null

var DIR_PATH = "res://model"

func _ready():

    $ui/chk_edge_render.pressed = $render_screen.visible

    var dir = Directory.new()
    
    if dir.open(DIR_PATH) == OK:
        dir.list_dir_begin()
        var file_name = dir.get_next()
        while file_name != "":
            if dir.current_is_dir():
                print("Found directory: " + file_name)
            else:
                if file_name.ends_with(".obj") == true:
                    print("Found file: " + file_name)
                    $ui/models.add_item(file_name)
                    
            file_name = dir.get_next()
    else:
        print("An error occurred when trying to access the path.")




func _input(event):
    if ctl_focus == true:
        return

    if event is InputEventKey:
        if event.pressed == true:
            if event.scancode == KEY_TAB:
                if $ui.visible == true:
                    $ui.visible = false
                else:
                    $ui.visible = true

    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT:
            btn_l = event.pressed
            rot_l = event.position
        if event.button_index == BUTTON_MIDDLE:
            btn_c = event.pressed
            pos = event.position
            
        if event.button_index == BUTTON_RIGHT:
            btn_r = event.pressed
            rot_r = event.position
            
        if event.pressed == true:
            if event.button_index == BUTTON_WHEEL_UP:
                o_mesh_instance.scale += Vector3.ONE
            if event.button_index == BUTTON_WHEEL_DOWN:
                o_mesh_instance.scale -= Vector3.ONE

    if event is InputEventMouseMotion:
        if btn_c == true:
            var vct_camera = ((event.position - pos) / 50)
            $cam.h_offset = -vct_camera.x
            $cam.v_offset = vct_camera.y

        if btn_l == true:
            var m = event.position - rot_l
            var tf

            tf = $base_control.transform.rotated(Vector3.UP, deg2rad(m.x))
            $base_control.transform = tf

            tf = $base_control.transform.rotated(Vector3.RIGHT, deg2rad(m.y))
            $base_control.transform = tf
            
            rot_l = event.position

        if btn_r == true:
            var m = event.position - rot_r
            var tf = $base_control.transform.rotated(Vector3.FORWARD, deg2rad(m.y))
            $base_control.transform = tf
            
            rot_r = event.position

    $cam.translation.z = cam_z


func _process(delta):
    pass


func reset():
    for node in $base_control.get_children():
        node.queue_free()

    if o_mesh_instance != null:
        o_mesh_instance = null

    $base_control.transform = Transform.IDENTITY


func _on_edge_range_value_changed(value):
    $render_screen.material.set_shader_param("edge_range", float(value))


func _on_chk_edge_render_pressed():
    $render_screen.visible = $ui/chk_edge_render.pressed


func _on_edge_range_mouse_entered():
    ctl_focus = true


func _on_edge_range_mouse_exited():
    ctl_focus = false


func _on_edge_size_value_changed(value):
    $render_screen.material.set_shader_param("edge_size", float(value))



func _on_edge_size_mouse_entered():
    ctl_focus = true


func _on_edge_size_mouse_exited():
    ctl_focus = false


func _on_btn_reset_pressed():
    self.reset()


func _on_models_item_selected(index):
    self.reset()

    var res = ResourceLoader.load(DIR_PATH + "/" + $ui/models.get_item_text(index))
    o_mesh_instance = MeshInstance.new()
    o_mesh_instance.mesh = res
    $base_control.add_child(o_mesh_instance)


func _on_cam_fov_value_changed(value):
    $cam.fov = value



func _on_cam_fov_mouse_entered():
    ctl_focus = true


func _on_cam_fov_mouse_exited():
    ctl_focus = false
