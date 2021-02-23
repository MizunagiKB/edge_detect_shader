extends Spatial


# https://3dwarehouse.sketchup.com/model/1bd2fba303e04ce1283ffcfc40c29975/Weapon-FN-P90
# https://3dwarehouse.sketchup.com/model/ca46c75c-df9e-4542-9e23-ce348c5de05f/M14-EBR
# https://3dwarehouse.sketchup.com/model/e815bffc1dee0414f4aa69a000077765/Milkor-MGL-140-rocket-launcher3D
# https://3dwarehouse.sketchup.com/model/b3460dcd945cb4598cb138e49a70d8bc/G36

const DEFAULT_FOV = 45
const DEFAULT_EDGE_DEPTH = 25600
const DEFAULT_EDGE_SIZE = 1

var cam_z = 10
var btn_l = false
var btn_r = false
var btn_c = false
var pos = Vector2(0, 0)
var rot_l = Vector2(0, 0)
var rot_r = Vector2(0, 0)

var ctl_focus = false

var move_window = false
var window_base_pos = Vector2(0, 0)
var rot_axis = Vector2(0, 0)

var shader_edge = load("res://shader/edge.shader")
var shader_depth = load("res://shader/depth.shader")

var DIR_PATH = "res://model"


# -------------------------------------------------------------- mesh:shader(s)
var mesh_shader: VisualShader = load("res://shader/visual_shader.tres")
var mesh_material: ShaderMaterial


func _ready():

    $ui/panel/cam_fov.value = DEFAULT_FOV
    $ui/panel/edge_depth.value = DEFAULT_EDGE_DEPTH
    $ui/panel/edge_size.value = DEFAULT_EDGE_SIZE

    mesh_material = ShaderMaterial.new()
    mesh_material.shader = mesh_shader
    mesh_material.set_shader_param("color_mode", 0)

    var dir = Directory.new()
    
    if dir.open(DIR_PATH) == OK:
        dir.list_dir_begin()
        var file_name = dir.get_next()
        while file_name != "":
            if dir.current_is_dir():
                print("Found directory: " + file_name)
            else:
                var b_ready = false
                if file_name.ends_with(".obj"):
                    b_ready = true

                if b_ready == true:
                    $ui/panel/models.add_item(file_name)
                    
            file_name = dir.get_next()
    else:
        print("An error occurred when trying to access the path.")


func _input(event):    

    if ctl_focus == true:
        return

    if event is InputEventKey:
        if event.pressed == true:
            if event.scancode == KEY_TAB:
                if $ui/window_knob.visible == true:
                    $ui/window_knob.visible = false
                else:
                    $ui/window_knob.visible = true

                if $ui/panel.visible == true:
                    $ui/panel.visible = false
                else:
                    $ui/panel.visible = true



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

    $render_screen.material.set_shader_param("screen_w", OS.window_size.x)
    $render_screen.material.set_shader_param("screen_h", OS.window_size.y)

    if move_window == true:
        OS.window_position = window_base_pos


func reset():
    $cam.h_offset = 0
    $cam.v_offset = 0
    $base_control/mesh.scale = Vector3.ONE

    $ui/panel/cam_fov.value = DEFAULT_FOV
    $ui/panel/edge_depth.value = DEFAULT_EDGE_DEPTH
    $ui/panel/edge_size.value = DEFAULT_EDGE_SIZE

    $base_control.transform = Transform.IDENTITY


func _on_edge_range_value_changed(value):
    $render_screen.material.set_shader_param("edge_range", float(value))

    $ui/panel/edge_depth/value.text = str(value)
    $ui/tween.interpolate_property(
        $ui/panel/edge_depth/value,
        "visible",
        true, false, 3,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $ui/tween.start()


func _on_edge_size_value_changed(value):
    $render_screen.material.set_shader_param("edge_size", float(value))

    $ui/panel/edge_size/value.text = str(value)
    $ui/tween.interpolate_property(
        $ui/panel/edge_size/value,
        "visible",
        true, false, 3,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $ui/tween.start()


func _on_btn_reset_pressed():
    self.reset()


func _on_models_item_selected(index):

    var res: Mesh = ResourceLoader.load(DIR_PATH + "/" + $ui/panel/models.get_item_text(index))
    
    var box = res.get_aabb()
    
    var vct = box.end - box.position
    
    $base_control/mesh.translation = Vector3.ZERO - box.position
    $base_control/mesh.translation -= (box.size / 2)
    
    for n in range(res.get_surface_count()):
        res.surface_set_material(n, mesh_material)

    $base_control/mesh.mesh = res


func _on_cam_fov_value_changed(value):
    $cam.fov = value

    $ui/panel/cam_fov/value.text = str(value)
    $ui/tween.interpolate_property(
        $ui/panel/cam_fov/value,
        "visible",
        true, false, 3,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $ui/tween.start()
    

func _on_btn_shader_item_selected(id):
    if id == 0:
        mesh_material.set_shader_param("color_mode", 0)
        $render_screen.visible = false
    elif id == 1:
        mesh_material.set_shader_param("color_mode", 0)
        $render_screen.visible = true
        $render_screen.material.shader = shader_edge
    elif id == 2:
        mesh_material.set_shader_param("color_mode", 1)
        $render_screen.visible = false
        $render_screen.material.shader = shader_edge
    elif id == 3:
        mesh_material.set_shader_param("color_mode", 0)
        $render_screen.visible = true
        $render_screen.material.shader = shader_depth


func _on_btn_transparent_toggled(button_pressed):
    get_tree().get_root().set_transparent_background(button_pressed)


func _on_window_knob_gui_input(event):
    
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT:
            if event.pressed == true:
                Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
            else:
                Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
                get_viewport().warp_mouse(rot_axis)

            window_base_pos = OS.window_position
            rot_axis = get_viewport().get_mouse_position()
            move_window = event.pressed

    if event is InputEventMouseMotion:
        if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
            window_base_pos += event.relative


func _on_ui_gui_input(event):

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
                if $base_control/mesh.scale.x < 1:
                        $base_control/mesh.scale += Vector3(0.1, 0.1, 0.1)
                else:
                    if $base_control/mesh.scale.x < 10:
                        $base_control/mesh.scale += Vector3.ONE
            if event.button_index == BUTTON_WHEEL_DOWN:
                if $base_control/mesh.scale.x < 1:
                    if $base_control/mesh.scale.x > 0.1:
                        $base_control/mesh.scale -= Vector3(0.1, 0.1, 0.1)
                else:
                    $base_control/mesh.scale -= Vector3.ONE


func _on_btn_exit_pressed():
    get_tree().quit(0)



func _on_btn_fullscreen_toggled(button_pressed):
    OS.window_maximized = button_pressed
