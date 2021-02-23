extends Spatial


# https://3dwarehouse.sketchup.com/model/1bd2fba303e04ce1283ffcfc40c29975/Weapon-FN-P90
# https://3dwarehouse.sketchup.com/model/ca46c75c-df9e-4542-9e23-ce348c5de05f/M14-EBR
# https://3dwarehouse.sketchup.com/model/e815bffc1dee0414f4aa69a000077765/Milkor-MGL-140-rocket-launcher3D
# https://3dwarehouse.sketchup.com/model/b3460dcd945cb4598cb138e49a70d8bc/G36

const DEFAULT_FOV = 45
const DEFAULT_SIZE = 1
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
var model_mesh: ModelMesh = null


func _ready():

    model_mesh = $base_control/model_mesh
    reset()


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
                if $ui/knob_L.visible == true:
                    $ui/knob_U.visible = false
                    $ui/knob_D.visible = false
                    $ui/knob_L.visible = false
                    $ui/panel.visible = false
                else:
                    $ui/knob_U.visible = true
                    $ui/knob_D.visible = true
                    $ui/knob_L.visible = true
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

    $ui/knob_D/spin_x.value = $base_control.rotation_degrees.x
    $ui/knob_D/spin_y.value = $base_control.rotation_degrees.y
    $ui/knob_D/spin_z.value = $base_control.rotation_degrees.z
    $cam.translation.z = cam_z


func _process(delta):

    $render_screen.material.set_shader_param("screen_w", OS.window_size.x)
    $render_screen.material.set_shader_param("screen_h", OS.window_size.y)

    if move_window == true:
        OS.window_position = window_base_pos


func reset():
    $cam.h_offset = 0
    $cam.v_offset = 0

    model_mesh.reset()

    $base_control.transform = Transform.IDENTITY

    _on_btn_cam_item_selected(0)
    $ui/panel/edge_depth.value = DEFAULT_EDGE_DEPTH
    $ui/panel/edge_size.value = DEFAULT_EDGE_SIZE


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

    var new_mesh: Mesh = ResourceLoader.load(DIR_PATH + "/" + $ui/panel/models.get_item_text(index))

    if new_mesh != null:
        model_mesh.attach_mesh(new_mesh)


func _on_btn_shader_item_selected(id):
    if id == 0:
        model_mesh.set_shader_off()
        $render_screen.visible = false
    elif id == 1:
        model_mesh.set_shader_edge()
        $render_screen.visible = true
        $render_screen.material.shader = shader_edge
    elif id == 2:
        model_mesh.set_shader_normal()
        $render_screen.visible = false
        $render_screen.material.shader = shader_edge
    elif id == 3:
        model_mesh.set_shader_depth()
        $render_screen.visible = true
        $render_screen.material.shader = shader_depth


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
                model_mesh.scale_inc()
            if event.button_index == BUTTON_WHEEL_DOWN:
                model_mesh.scale_dec()


func _on_btn_transparent_toggled(button_pressed):
    get_tree().get_root().set_transparent_background(button_pressed)


func _on_btn_fullscreen_toggled(button_pressed):
    OS.window_maximized = button_pressed


func _on_btn_exit_pressed():
    get_tree().quit(0)


func knob_control(event):
    
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

func _on_knob_U_gui_input(event):
    knob_control(event)

func _on_knob_D_gui_input(event):
    knob_control(event)

func _on_knob_L_gui_input(event):
    knob_control(event)

func _on_panel_gui_input(event):
    knob_control(event)



func _on_spin_x_value_changed(value):
    $base_control.rotation_degrees.x = value

func _on_spin_y_value_changed(value):
    $base_control.rotation_degrees.y = value

func _on_spin_z_value_changed(value):
    $base_control.rotation_degrees.z = value


func _on_btn_cam_item_selected(id):
    match id:
        0:
            $cam.projection = Camera.PROJECTION_PERSPECTIVE
            $ui/panel/btn_cam/spin_fov.min_value = 30
            $ui/panel/btn_cam/spin_fov.max_value = 120
            $ui/panel/btn_cam/spin_fov.step = 5
            $ui/panel/btn_cam/spin_fov.value = DEFAULT_FOV
        1:
            $cam.projection = Camera.PROJECTION_ORTHOGONAL
        2:
            $cam.projection = Camera.PROJECTION_FRUSTUM
            $ui/panel/btn_cam/spin_fov.min_value = 0.1
            $ui/panel/btn_cam/spin_fov.max_value = 2
            $ui/panel/btn_cam/spin_fov.step = 0.1
            $ui/panel/btn_cam/spin_fov.value = DEFAULT_SIZE


func _on_spin_fov_value_changed(value):
    match $cam.projection:
        Camera.PROJECTION_PERSPECTIVE:
            $cam.fov = value
        Camera.PROJECTION_ORTHOGONAL:
            pass
        Camera.PROJECTION_FRUSTUM:
            $cam.size = value
