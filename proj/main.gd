extends Control


const DEFAULT_CAMERA_POS = 10
const DEFAULT_CAMERA_FOV = 45
const DEFAULT_LINE_WEIGHT = 100
const DEFAULT_DEPTH_POW = 100

var ENABLE_ROT_X = 0b001
var ENABLE_ROT_Y = 0b010
var ENABLE_ROT_Z = 0b100

var mouse_pos_save: Vector2
var mouse_actve: bool = false

var error_reason: String = ""


func open_extention(ext_pathname: String):

    var ext_frame = load("res://lib/eds_ext_frame.tscn").instance()

    get_tree().get_root().get_node("main_frame").add_child(ext_frame)

    ext_frame.add_control(ext_pathname)
    ext_frame.popup_exclusive = true
    ext_frame.popup_centered()


func _ready():

    LibUi.main_frame = self
    LibConfigure.load()

    var mesh_dir: String = LibConfigure.mesh_dir
    if mesh_dir == "":
        mesh_dir = "res://model"

    $frmR/container/Files/files.reload(mesh_dir)
    $frmR/container/Extentions.reload("res://lib/ext")

    get_tree().connect("files_dropped", self, "_files_droppped")

    self.connect("resized", self, "_on_resized")

    self.connect("gui_input", self, "_on_gui_input_rot_xy")
    self.connect("mouse_entered", self, "_on_mouse_entered")
    self.connect("mouse_exited", self, "_on_mouse_exited")


    $frmT/rot_x.connect("value_changed", self, "_on_value_changed_rot_x")
    $frmT/rot_y.connect("value_changed", self, "_on_value_changed_rot_y")
    $frmT/rot_z.connect("value_changed", self, "_on_value_changed_rot_z")

    $frmB/rotate_box.connect("gui_input", self, "_on_gui_input_rot_x")
    $frmB/rotate_box.connect("mouse_entered", self, "_on_mouse_entered")
    $frmB/rotate_box.connect("mouse_exited", self, "_on_mouse_exited")

    $frmL/btn_maximize.connect("toggled", self, "_on_toggle_maximize")    
    $frmL/btn_transparent.connect("toggled", self, "_on_toggle_transparent")
    $frmL/camera_pos.connect("value_changed", self, "_on_value_changed_camera_pos")
    $frmL/btn_configure.connect("pressed", self, "_on_pressed_configure")
    $frmL/btn_close.connect("pressed", self, "_on_close")

    $frmR/rotate_box.connect("gui_input", self, "_on_gui_input_rot_y")
    $frmR/rotate_box.connect("mouse_entered", self, "_on_mouse_entered")
    $frmR/rotate_box.connect("mouse_exited", self, "_on_mouse_exited")

    $frmR/btn_reset.connect("pressed", self, "_on_pressed_reset")
    $frmR/container/Files/btn_create.connect("pressed", self, "_on_pressed_create")
    $frmR/container/Files/btn_delete.connect("pressed", self, "_on_pressed_delete")
    $frmR/btn_capture.connect("pressed", self, "_on_pressed_capture")

    $frmR/lbl_version.text = "Version " + ProjectSettings.get_setting("application/config/version")


func _on_mouse_entered():
    self.mouse_actve = true


func _on_mouse_exited():
    self.mouse_actve = false
    

func _input(_delta):

    if Input.is_action_just_pressed("show_user_interface") == true:
        LibUi.show = not LibUi.show
 
    if Input.is_action_just_pressed("undo") == true:
        pass

    if Input.is_action_just_pressed("redo") == true:
        pass


func _on_gui_input_rot_x(event):
    self._on_gui_input(event, ENABLE_ROT_X)

func _on_gui_input_rot_y(event):
    self._on_gui_input(event, ENABLE_ROT_Y)

func _on_gui_input_rot_xy(event):
    self._on_gui_input(event, ENABLE_ROT_X | ENABLE_ROT_Y)


func _on_gui_input(event, enable_rot: int):

    if self.mouse_actve == false:
        return

    if $frmT/btn_locked.pressed_status == true:
        return

    if $frmR/btn_camera.pressed == true:
        
        # Camera rotation mode
        if event is InputEventMouseButton:
            if event.button_index == BUTTON_LEFT:
                if event.pressed == true:
                    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
                else:
                    Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
    
        if event is InputEventMouseMotion:
            if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:

                if enable_rot & ENABLE_ROT_Y:
                    var r = $camera.rotation_degrees.y
                    r = r - event.relative.x
                    $camera.rotation_degrees.y = r
                
                if enable_rot & ENABLE_ROT_X:
                    var r = $camera.rotation_degrees.x
                    r = clamp(r - event.relative.y, -89, 89)
                    $camera.rotation_degrees.x = r

    else:

        # Model rotation mode
        if event is InputEventMouseMotion:
    
            if Input.is_mouse_button_pressed(BUTTON_LEFT) == true:
                var vct = event.position - self.mouse_pos_save
                if enable_rot & ENABLE_ROT_X:
                    $base/node.rotate(Vector3.UP, deg2rad(vct.x))
                if enable_rot & ENABLE_ROT_Y:
                    $base/node.rotate(Vector3.RIGHT, deg2rad(vct.y))
                self.mouse_pos_save = event.position
    
            if Input.is_mouse_button_pressed(BUTTON_RIGHT) == true:
                var vct = event.position - self.mouse_pos_save
                $base/node.rotate(Vector3.FORWARD, deg2rad(vct.y))
                self.mouse_pos_save = event.position
    
            if Input.is_mouse_button_pressed(BUTTON_MIDDLE) == true:
                var vct = ((event.position - self.mouse_pos_save) / 50)
                if enable_rot & ENABLE_ROT_X:
                    $camera.h_offset -= vct.x
                if enable_rot & ENABLE_ROT_Y:
                    $camera.v_offset += vct.y
                self.mouse_pos_save = event.position
    
        if event is InputEventMouseButton:
            match event.button_index:
                BUTTON_LEFT:
                    self.mouse_pos_save = event.position
    
                BUTTON_RIGHT:
                    self.mouse_pos_save = event.position
    
                BUTTON_MIDDLE:
                    self.mouse_pos_save = event.position
    
                BUTTON_WHEEL_UP:
                    var scale = min($base/node.scale.x + 0.1, 10)
                    $base/node.scale = Vector3.ONE * scale
    
                BUTTON_WHEEL_DOWN:
                    var scale = max($base/node.scale.x - 0.1, 0.1)
                    $base/node.scale = Vector3.ONE * scale
    
        $frmT/rot_x.value = $base/node.rotation_degrees.x
        $frmT/rot_y.value = $base/node.rotation_degrees.y
        $frmT/rot_z.value = $base/node.rotation_degrees.z


func _files_droppped(files: PoolStringArray, _screen: int):
    for pathname in files:
        $frmR/container/Files/files.load_mesh(pathname)
        break

func _on_resized():
    get_tree().call_group("render_mode", "set_shader_param", "viewport", get_viewport().size)


func _on_pressed_configure():

    self.open_extention("res://conf/container_configure.tscn")


func _on_close():
    get_tree().quit(0)


func _on_value_changed_rot_x(value: float):
    $base/node.rotation_degrees.x = value

func _on_value_changed_rot_y(value: float):
    $base/node.rotation_degrees.y = value

func _on_value_changed_rot_z(value: float):
    $base/node.rotation_degrees.z = value


func _on_toggle_maximize(value: bool):
    OS.window_maximized = value


func _on_value_changed_camera_pos(value: float):

    $camera.translation.z = value;


func _on_toggle_transparent(value: bool):

    get_tree().get_root().set_transparent_background(value)


func _on_pressed_reset():

    $camera.rotation_degrees = Vector3.ZERO
    $camera.h_offset = 0
    $camera.v_offset = 0

    $frmT/rot_x.value = 0
    $frmT/rot_y.value = 0
    $frmT/rot_z.value = 0
    $base/node.scale = Vector3.ONE
    $frmL/camera_pos.value = DEFAULT_CAMERA_POS
    $frmR/panel/fov.value = DEFAULT_CAMERA_FOV
    $frmR/panel/depth_pow.value = DEFAULT_DEPTH_POW
    $frmR/panel/line_weight.value = DEFAULT_LINE_WEIGHT


func _on_pressed_create():

    self.open_extention("res://lib/builtins/simple_mesh/ext_simple_mesh.tscn")


func _on_pressed_delete():

    var list_node: Array = []

    for node in $base/node.get_children():
        list_node.append(node)

    for node in list_node:
        $base/node.remove_child(node)
        node.queue_free()


func _capture_to_file(imagedata: Image) -> bool:

    var base_dir = LibConfigure.capture_image_dir
    if base_dir.length() == 0:
        error_reason = "There are undefined configuration items."
        return false

    var o_dir = Directory.new()
    if o_dir.dir_exists(base_dir) != true:
        error_reason = "The specified directory does not exist."
        return false

    var dict_datetime = OS.get_datetime()
    # year, month, day, weekday, dst (Daylight Savings Time), hour, minute, second.

    var pathname = "%s/eds_%04d%02d%02d_%02d%02d%02d.png" % [
        base_dir,
        dict_datetime["year"],
        dict_datetime["month"],
        dict_datetime["day"],
        dict_datetime["hour"],
        dict_datetime["minute"],
        dict_datetime["second"]
    ]
    
    imagedata.save_png(pathname)

    return true


func _on_pressed_capture():

    var save_viewport_size = get_viewport().size

    get_viewport().size *= LibConfigure.render_scale

    if LibConfigure.line_scale == 1:
        get_tree().call_group("render_mode", "set_shader_param", "viewport", save_viewport_size)

    self.visible = false

    get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)

    yield(VisualServer, "frame_post_draw")

    var imagedata = get_viewport().get_texture().get_data()

    imagedata.convert(Image.FORMAT_RGBA8)
    imagedata.flip_y()

    if self._capture_to_file(imagedata) == false:
        var popup_frame: EDSPopupFrame = load("res://lib/eds_popup_frame.tscn").instance()

        get_tree().get_root().get_node("main_frame").add_child(popup_frame)

        popup_frame.get_node("lbl_rich_message").text = error_reason
        popup_frame.popup_exclusive = true
        popup_frame.popup_centered()

    self.visible = true
    
    get_viewport().size = save_viewport_size
    get_tree().call_group("render_mode", "set_shader_param", "viewport", get_viewport().size)

