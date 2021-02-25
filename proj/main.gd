extends Spatial


# https://3dwarehouse.sketchup.com/model/1bd2fba303e04ce1283ffcfc40c29975/Weapon-FN-P90
# https://3dwarehouse.sketchup.com/model/ca46c75c-df9e-4542-9e23-ce348c5de05f/M14-EBR
# https://3dwarehouse.sketchup.com/model/e815bffc1dee0414f4aa69a000077765/Milkor-MGL-140-rocket-launcher3D
# https://3dwarehouse.sketchup.com/model/b3460dcd945cb4598cb138e49a70d8bc/G36

const DEFAULT_PERSPECTIVE_FOV = 45
const DEFAULT_CAM_DISTANCE = 10
const DEFAULT_FRUSTUM_SIZE = 1
const DEFAULT_EDGE_DEPTH = 25600
const DEFAULT_EDGE_SIZE = 1

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
var active_win: WindowDialog = null


# ------------------------------------------------------------------- method(s)
func ui_visible(show: bool):
    $ui/knob_U.visible = show
    $ui/knob_D.visible = show
    $ui/knob_L.visible = show
    $ui/panel.visible = show


func _ready():

    CONF.parameter_load()

    model_mesh = $base_control/model_mesh
    reset()

    $ui/panel/lbl_version.text = "Version " + ProjectSettings.get_setting("application/config/version")

    # Models
    $ui/panel/tab_container/models.add_item("[Blank]")
    $ui/panel/tab_container/models.set_item_metadata(0, $ui/dlg_mesh_blank)
    $ui/panel/tab_container/models.add_item("[Mesh]")
    $ui/panel/tab_container/models.set_item_metadata(1, $ui/dlg_create_mesh)

    #
    var o_instance = null
    o_instance = load("res://node/screen_sky/dlg_screen_sky.tscn").instance()
    $ui/panel/tab_container/extentions.add_item(o_instance.ext_name())
    $ui/panel/tab_container/extentions.set_item_metadata(0, o_instance)

    $ui/panel/btn_color_body.color = Color.white
    $ui/panel/btn_color_edge.color = Color.black

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
                    $ui/panel/tab_container/models.add_item(file_name)
                    var item_count = $ui/panel/tab_container/models.get_item_count()
                    if item_count > 0:
                        $ui/panel/tab_container/models.set_item_metadata(item_count - 1, null)

                    
            file_name = dir.get_next()
    else:
        print("An error occurred when trying to access the path.")


func _input(event):    

    if ctl_focus == true:
        return

    if event is InputEventKey:
        if event.pressed == true:
            if event.scancode == KEY_TAB:
                ui_visible(not $ui/panel.visible)




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


func _process(delta):

    $render_screen.material.set_shader_param("screen_w", OS.window_size.x)
    $render_screen.material.set_shader_param("screen_h", OS.window_size.y)

    if move_window == true:
        OS.window_position = window_base_pos

    if $screen.get_child_count() == 0:
        if $cam.environment == null:
            $cam.environment = Environment.new()
            $cam.environment.background_mode = Environment.BG_COLOR
            $cam.environment.background_color = Color.gray


func reset():
    $cam.h_offset = 0
    $cam.v_offset = 0

    model_mesh.reset()

    $cam.rotation = Vector3.ZERO
    $base_control.transform = Transform.IDENTITY

    $ui/knob_L/cam_distance.value = DEFAULT_CAM_DISTANCE
    $ui/panel/btn_cam.selected = 0
    _on_btn_cam_item_selected($ui/panel/btn_cam.selected)
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

    active_win = $ui/panel/tab_container/models.get_item_metadata(index)
    if active_win != null:
        active_win.plugin_open()
    else:
        var new_mesh: Mesh = ResourceLoader.load(DIR_PATH + "/" + $ui/panel/tab_container/models.get_item_text(index))

        if new_mesh != null:
            model_mesh.attach_mesh(new_mesh)


func _on_extentions_item_selected(index):

    active_win = $ui/panel/tab_container/extentions.get_item_metadata(index)
    if active_win != null:
        active_win.ext_init(self)


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
    CONF.parameter_save()
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
            $ui/panel/btn_cam/spin_fov.value = DEFAULT_PERSPECTIVE_FOV
        1:
            $cam.projection = Camera.PROJECTION_ORTHOGONAL
        2:
            $cam.projection = Camera.PROJECTION_FRUSTUM
            $ui/panel/btn_cam/spin_fov.min_value = 0.1
            $ui/panel/btn_cam/spin_fov.max_value = 2
            $ui/panel/btn_cam/spin_fov.step = 0.1
            $ui/panel/btn_cam/spin_fov.value = DEFAULT_FRUSTUM_SIZE


func _on_spin_fov_value_changed(value):
    match $cam.projection:
        Camera.PROJECTION_PERSPECTIVE:
            $cam.fov = value
        Camera.PROJECTION_ORTHOGONAL:
            pass
        Camera.PROJECTION_FRUSTUM:
            $cam.size = value


func _on_dlg_create_mesh_popup_hide():
    if $ui/dlg_create_mesh.exit == true:
        var new_mesh = $ui/dlg_create_mesh.get_mesh()

        if new_mesh != null:
            model_mesh.attach_mesh(new_mesh)


func _on_btn_color_edge_color_changed(color):
    $render_screen.material.set_shader_param("color_value", Vector3(color.r, color.g, color.b))


func _on_btn_color_body_color_changed(color):
    $base_control/model_mesh.set_color_value(color)


func _on_btn_capture_pressed():

    var save_viewport_size = get_viewport().size
    get_viewport().size = save_viewport_size * CONF.capture_scale
    
    self.ui_visible(false)
    get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)

    yield(VisualServer, "frame_post_draw")

    var img = get_viewport().get_texture().get_data()

    img.convert(Image.FORMAT_RGBA8)
    img.flip_y()

    var o_dir = Directory.new()
    
    if o_dir.dir_exists(CONF.capture_image_dir) == true:

        var dict_datetime = OS.get_datetime()
        # year, month, day, weekday, dst (Daylight Savings Time), hour, minute, second.

        var pathname = "%s/eds_%04d%02d%02d_%02d%02d%02d.png" % [
            CONF.capture_image_dir,
            dict_datetime["year"],
            dict_datetime["month"],
            dict_datetime["day"],
            dict_datetime["hour"],
            dict_datetime["minute"],
            dict_datetime["second"]
        ]
        
        img.save_png(pathname)

    self.ui_visible(true)

    get_viewport().size = save_viewport_size


func _on_btn_conf_pressed():
    $dlg_conf.popup_centered()


func _on_cam_distance_value_changed(value):
    $cam.translation.z = value

