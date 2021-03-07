extends Spatial


const DEFAULT_PERSPECTIVE_FOV = 45
const DEFAULT_CAM_DISTANCE = 10
const DEFAULT_FRUSTUM_SIZE = 1
const DEFAULT_EDGE_DEPTH = 25600
const DEFAULT_EDGE_SIZE = 1

enum MOUSEMODE {
    MOUSE,
    SCROLL    
}
var btn_l = false
var btn_r = false
var e_mouse_mode = MOUSEMODE.MOUSE
var mouse_pos_save = Vector2.ZERO
var mouse_btn_l = false
var event_frame: Rect2 = Rect2(16, 16, 740 - 16, 544 - 16)

var ui_visible = true
var move_window = false
var size_window = false

var window_base_move = Vector2(0, 0)
var window_base_size = Vector2(0, 0)
var rot_axis = Vector2(0, 0)

var shader_edge = load("res://shader/edge.shader")
var shader_depth = load("res://shader/depth.shader")


onready var knob_L_pos = [$ui/knob_L.rect_position, $ui/knob_L.rect_position + Vector2(-128, 0)]
onready var knob_R_pos = [$ui/knob_R.rect_position, $ui/knob_R.rect_position + Vector2(256, 0)]

onready var knob_U_pos = [$ui/knob_U.rect_position, $ui/knob_U.rect_position + Vector2(0, -128)]
onready var knob_D_pos = [$ui/knob_D.rect_position, $ui/knob_D.rect_position + Vector2(0, 128)]

# -------------------------------------------------------------- mesh:shader(s)
var active_win: WindowDialog = null


# ------------------------------------------------------------------- method(s)
func ui_visible(show: bool):

    var order = [0, 1]

    if show == true:
        order = [1, 0]

    $ui/tween.interpolate_property(
        $ui/knob_R,
        "rect_position",
        knob_R_pos[order[0]], knob_R_pos[order[1]], 0.3,
        Tween.TRANS_SINE, Tween.EASE_IN_OUT)

    $ui/tween.interpolate_property(
        $ui/knob_L,
        "rect_position",
        knob_L_pos[order[0]], knob_L_pos[order[1]], 0.3,
        Tween.TRANS_SINE, Tween.EASE_IN_OUT)

    $ui/tween.interpolate_property(
        $ui/knob_U,
        "rect_position",
        knob_U_pos[order[0]], knob_U_pos[order[1]], 0.3,
        Tween.TRANS_SINE, Tween.EASE_IN_OUT)

    $ui/tween.interpolate_property(
        $ui/knob_D,
        "rect_position",
        knob_D_pos[order[0]], knob_D_pos[order[1]], 0.3,
        Tween.TRANS_SINE, Tween.EASE_IN_OUT)

    $ui/tween.start()

    self.ui_visible = show


func load_extension(base_dir: String, o_itemlist: ItemList):

    var o_dir = Directory.new()

    if o_dir.open(base_dir) == OK:
        o_dir.list_dir_begin()
        while true:
            var dirname = o_dir.get_next()
            if dirname == "":
                break
            if dirname in [".", ".."]:
                continue
            else:
                if o_dir.current_is_dir():
                    var dir_path = "{0}/{1}".format([base_dir, dirname])
                    var o_class = load(dir_path + "/ext_main.tscn")
                    if o_class != null:
                        var o_instance = o_class.instance()
                        if o_instance.ext_init(dir_path) == true:
                            o_itemlist.add_item(o_instance.ext_name())
                            o_itemlist.set_item_metadata(o_itemlist.get_item_count() - 1, o_instance)


func load_mesh(mesh_pathname: String):

    var new_mesh: Mesh = load(mesh_pathname)
    
    if new_mesh == null:
        new_mesh = MODEL_OBJ.load(mesh_pathname)

    if new_mesh != null:
        for o in $base_ctl.get_children():
            o.queue_free()

        var eds_mesh_instance: EDSMeshInstance = null

        eds_mesh_instance = EDSMeshInstance.new()
        eds_mesh_instance.mesh_setup(new_mesh)
        $base_ctl.add_child(eds_mesh_instance)


func _files_droppped(files: PoolStringArray, screen: int):
    for pathname in files:
        if pathname.ends_with(".mesh"):
            self.load_mesh(pathname)
            break


func _ready():

    get_tree().connect("files_dropped", self, "_files_droppped")
    
    CONF.parameter_load()

    reset()

    $ui/knob_R/lbl_version.text = "Version " + ProjectSettings.get_setting("application/config/version")

    # Models
    var o_instance = null

    o_instance = load("res://node/dlg_mesh_blank/dlg_mesh_blank.tscn").instance()
    if o_instance.ext_init("res://node/dlg_mesh_blank") == true:
        $ui/knob_R/tab_container/models.add_item(o_instance.ext_name())
        $ui/knob_R/tab_container/models.set_item_metadata(0, o_instance)

    o_instance = load("res://node/dlg_mesh_create/dlg_mesh_create.tscn").instance()
    if o_instance.ext_init("res://node/dlg_mesh_create") == true:
        $ui/knob_R/tab_container/models.add_item(o_instance.ext_name())
        $ui/knob_R/tab_container/models.set_item_metadata(1, o_instance)

    #
    self.load_extension("res://ext", $ui/knob_R/tab_container/extentions)

    $ui/knob_R/btn_color_body.color = Color.white
    $ui/knob_R/btn_color_edge.color = Color.black

    var dir = Directory.new()
    
    if dir.open(CONF.mesh_dir) == OK:
        dir.list_dir_begin()
        var file_name = dir.get_next()
        while file_name != "":
            if dir.current_is_dir():
                pass
            else:
                var b_ready = false

                if file_name.ends_with(".mesh"):
                    b_ready = true

                if file_name.ends_with(".obj"):
                    b_ready = true

                if b_ready == true:
                    $ui/knob_R/tab_container/models.add_item(file_name)
                    var item_count = $ui/knob_R/tab_container/models.get_item_count()
                    if item_count > 0:
                        $ui/knob_R/tab_container/models.set_item_metadata(item_count - 1, null)

                    
            file_name = dir.get_next()
    else:
        pass


func _input(event):

    if event is InputEventKey:
        """
        if event.scancode == KEY_SPACE:
            if event.pressed == true:
                e_mouse_mode = MOUSEMODE.SCROLL
            else:
                e_mouse_mode = MOUSEMODE.MOUSE
        """

        if event.scancode == KEY_TAB:
            if event.pressed == true:
                ui_visible(not self.ui_visible)


func _on_ui_gui_input(event):

    if event is InputEventMouseMotion:
        if self.event_frame.has_point(event.position) != true:
            return

        match self.e_mouse_mode:
            MOUSEMODE.SCROLL:
                var vct = ((event.position - self.mouse_pos_save) / 50)
                $cam.h_offset -= vct.x
                $cam.v_offset += vct.y
                self.mouse_pos_save = event.position
            MOUSEMODE.MOUSE:
                if Input.is_mouse_button_pressed(BUTTON_LEFT) == true:
                    var vct = event.position - mouse_pos_save
                    $base_ctl.rotate(Vector3.UP, deg2rad(vct.x))
                    $base_ctl.rotate(Vector3.RIGHT, deg2rad(vct.y))
                    mouse_pos_save = event.position

                if Input.is_mouse_button_pressed(BUTTON_RIGHT) == true:
                    var vct = event.position - mouse_pos_save
                    $base_ctl.rotate(Vector3.FORWARD, deg2rad(vct.y))
                    self.mouse_pos_save = event.position

    if event is InputEventMouseButton:
        if self.event_frame.has_point(event.position) != true:
            return

        match event.button_index:
            BUTTON_MIDDLE:
                if event.pressed == true:
                    self.mouse_pos_save = event.position
                    self.e_mouse_mode = MOUSEMODE.SCROLL
                else:
                    self.e_mouse_mode = MOUSEMODE.MOUSE

            BUTTON_WHEEL_UP:
                $base_ctl.scale += Vector3(0.1, 0.1, 0.1)
                if $base_ctl.scale.length() > 10:
                    $base_ctl.scale = Vector3(10, 10, 10)
                    
                #self.model_mesh.scale_inc()
            BUTTON_WHEEL_DOWN:
                $base_ctl.scale -= Vector3(0.1, 0.1, 0.1)
                if $base_ctl.scale.length() < 0.1:
                    $base_ctl.scale = Vector3(0.1, 0.1, 0.1)
            _:
                mouse_pos_save = event.position

    $ui/knob_U/spin_x.value = $base_ctl.rotation_degrees.x
    $ui/knob_U/spin_y.value = $base_ctl.rotation_degrees.y
    $ui/knob_U/spin_z.value = $base_ctl.rotation_degrees.z


func _process(delta):

    $ui/knob_L/btn_pause.pressed = get_tree().paused

    if move_window == true:
        OS.window_position = self.window_base_move

    if size_window == true:
        OS.window_size = self.window_base_size

    if $base_ext.get_child_count() == 0:
        if $cam.environment == null:
            $cam.environment = Environment.new()
            $cam.environment.background_mode = Environment.BG_COLOR
            $cam.environment.background_color = Color.gray


func reset():
    $cam.h_offset = 0
    $cam.v_offset = 0

    $cam.rotation = Vector3.ZERO
    $base_ctl.transform = Transform.IDENTITY

    $ui/knob_L/cam_distance.value = DEFAULT_CAM_DISTANCE
    $ui/knob_R/btn_cam.selected = 0
    _on_btn_cam_item_selected($ui/knob_R/btn_cam.selected)
    $ui/knob_R/edge_depth.value = DEFAULT_EDGE_DEPTH
    $ui/knob_R/edge_size.value = DEFAULT_EDGE_SIZE


func _on_edge_range_value_changed(value):
    $render_screen.material.set_shader_param("edge_range", float(value))

    $ui/knob_R/edge_depth/value.text = str(value)
    $ui/tween.interpolate_property(
        $ui/knob_R/edge_depth/value,
        "visible",
        true, false, 3,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $ui/tween.start()


func _on_edge_size_value_changed(value):
    $render_screen.material.set_shader_param("edge_size", float(value))

    $ui/knob_R/edge_size/value.text = str(value)
    $ui/tween.interpolate_property(
        $ui/knob_R/edge_size/value,
        "visible",
        true, false, 3,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $ui/tween.start()


func _on_btn_reset_pressed():
    self.reset()


func _on_models_item_selected(index):

    assert(self.active_win == null)
    
    get_tree().paused = false

    active_win = $ui/knob_R/tab_container/models.get_item_metadata(index)

    if active_win != null:
        $ui.add_child(active_win)
        active_win.connect("popup_hide", self, "evt_extenttions_popup_hide")
        active_win.ext_show($cam, $base_ctl, $base_ext)

        active_win.popup()
        var calcsize = event_frame.size - active_win.rect_size
        active_win.rect_position = calcsize / 2

    else:
        self.load_mesh(CONF.mesh_dir + "/" + $ui/knob_R/tab_container/models.get_item_text(index))


func _on_extentions_item_selected(index):

    assert(self.active_win == null)

    get_tree().paused = false

    active_win = $ui/knob_R/tab_container/extentions.get_item_metadata(index)

    if active_win != null:

        $ui.add_child(active_win)
        active_win.connect("popup_hide", self, "evt_extenttions_popup_hide")
        active_win.ext_show($cam, $base_ctl, $base_ext)

        active_win.popup()
        var calcsize = event_frame.size - active_win.rect_size
        active_win.rect_position = calcsize / 2


func evt_extenttions_popup_hide():

    assert(self.active_win != null)

    active_win.ext_hide()
    active_win.disconnect("popup_hide", self, "evt_extenttions_popup_hide")

    $ui.remove_child(active_win)
    active_win = null


func _on_btn_shader_item_selected(id):

    for o in $base_ctl.get_children():
        if id == 2:
            o.set_shader_normal()
        else:
            o.set_shader_edge()

    if id == 0:
        $render_screen.visible = false
        $render_screen.material.shader = shader_edge
    elif id == 1:
        $render_screen.visible = true
        $render_screen.material.shader = shader_edge
    elif id == 2:
        $render_screen.visible = false
        $render_screen.material.shader = shader_edge
    elif id == 3:
        $render_screen.visible = true
        $render_screen.material.shader = shader_depth


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

            self.window_base_move = OS.window_position
            rot_axis = get_viewport().get_mouse_position()
            move_window = event.pressed

    if event is InputEventMouseMotion:
        if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
            self.window_base_move += event.relative

func _on_knob_U_gui_input(event):
    knob_control(event)

func _on_knob_D_gui_input(event):
    knob_control(event)

func _on_knob_L_gui_input(event):
    knob_control(event)

func _on_panel_gui_input(event):
    knob_control(event)

func _on_knob_Resize_gui_input(event):

    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT:
            if event.pressed == true:
                Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
            else:
                Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
                get_viewport().warp_mouse(rot_axis)

            self.window_base_size = OS.window_size
            rot_axis = get_viewport().get_mouse_position()
            size_window = event.pressed

    if event is InputEventMouseMotion:
        if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
            """ for TEST
            self.window_base_size += event.relative

            var w = max(self.window_base_size.x, 960)
            var h = max(self.window_base_size.y, 540)
            self.window_base_size = Vector2(w, h)
            """


func _on_spin_x_value_changed(value):
    $base_ctl.rotation_degrees.x = value

func _on_spin_y_value_changed(value):
    $base_ctl.rotation_degrees.y = value

func _on_spin_z_value_changed(value):
    $base_ctl.rotation_degrees.z = value


func _on_btn_cam_item_selected(id):
    match id:
        0:
            $cam.projection = Camera.PROJECTION_PERSPECTIVE
            $ui/knob_R/btn_cam/spin_fov.min_value = 30
            $ui/knob_R/btn_cam/spin_fov.max_value = 120
            $ui/knob_R/btn_cam/spin_fov.step = 5
            $ui/knob_R/btn_cam/spin_fov.value = DEFAULT_PERSPECTIVE_FOV
        1:
            $cam.projection = Camera.PROJECTION_ORTHOGONAL
        2:
            $cam.projection = Camera.PROJECTION_FRUSTUM
            $ui/knob_R/btn_cam/spin_fov.min_value = 0.1
            $ui/knob_R/btn_cam/spin_fov.max_value = 2
            $ui/knob_R/btn_cam/spin_fov.step = 0.1
            $ui/knob_R/btn_cam/spin_fov.value = DEFAULT_FRUSTUM_SIZE


func _on_spin_fov_value_changed(value):
    match $cam.projection:
        Camera.PROJECTION_PERSPECTIVE:
            $cam.fov = value
        Camera.PROJECTION_ORTHOGONAL:
            pass
        Camera.PROJECTION_FRUSTUM:
            $cam.size = value


func _on_btn_color_edge_color_changed(color):
    $render_screen.material.set_shader_param("color_value", Vector3(color.r, color.g, color.b))


func _on_btn_color_body_color_changed(color):

    for o in $base_ctl.get_children():
        o.set_color_value(color)


func _on_btn_capture_pressed():

    var save_viewport_size = get_viewport().size
    get_viewport().size = save_viewport_size * CONF.capture_scale

    if CONF.capture_screen_ratio == 1:
        $render_screen.material.set_shader_param("screen_w", OS.window_size.x * CONF.capture_scale)
        $render_screen.material.set_shader_param("screen_h", OS.window_size.y * CONF.capture_scale)
    
    $ui.visible = false
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

    $ui.visible = true

    $render_screen.material.set_shader_param("screen_w", OS.window_size.x)
    $render_screen.material.set_shader_param("screen_h", OS.window_size.y)
    
    get_viewport().size = save_viewport_size


func _on_btn_conf_pressed():
    $ui/dlg_conf.popup_centered()


func _on_cam_distance_value_changed(value):
    $cam.translation.z = value



func _on_btn_camera_gui_input(event):


    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT:
            if event.pressed == true:
                Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
            else:
                Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

    if event is InputEventMouseMotion:
        if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:

            var r = $cam.rotation_degrees.y
            r = r - event.relative.x
            $cam.rotation_degrees.y = r
            
            r = $cam.rotation_degrees.x
            r = clamp(r - event.relative.y, -89, 89)
            $cam.rotation_degrees.x = r


func _on_btn_resize_toggled(button_pressed):

    var pos = OS.window_position
    var size = Vector2(960, 540)

    if button_pressed == true:
        OS.window_size = size * 2
    else:
        OS.window_size = size

    OS.window_position = pos


func _on_btn_pause_toggled(button_pressed):
    
    get_tree().paused = button_pressed

