extends Node

const CONF_PATHNAME =  "user://edge_ds.conf"
# https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html#doc-data-paths

const MESH_DIR_KEY = "61d06f23-0386-4516-bda4-da5334ac42cb"
const CAPTURE_IMAGE_DIR_KEY = "a93955ce-bd07-4e27-8af5-f0c9820cc5e4"
const RENDER_SCALE = "9a09ba29-86a8-4d72-a50f-6182dec915b8"
const SCALE_MIN: int = 1
const SCALE_MAX: int = 8
const LINE_SCALE = "e6581fbc-b83c-42d0-bff9-519fece43e87"

var mesh_dir: String = ""
var capture_image_dir: String = ""
var render_scale: int = 1
var line_scale: int = 1


func save() -> bool:

    var o_file = File.new()

    var dict_param = {
        "version": ProjectSettings.get_setting("application/config/Version"),
        MESH_DIR_KEY: self.mesh_dir,
        CAPTURE_IMAGE_DIR_KEY: self.capture_image_dir,
        RENDER_SCALE: clamp(self.render_scale, SCALE_MIN, SCALE_MAX),
        LINE_SCALE: self.line_scale
    }

    if o_file.open(CONF_PATHNAME, File.WRITE) == 0:
        o_file.store_string(JSON.print(dict_param))

    print("configure save.")

    return true


func load() -> bool:

    var o_file = File.new()
    
    if o_file.file_exists(CONF_PATHNAME) != true:
        return false

    o_file.open(CONF_PATHNAME, File.READ)

    var json_result = JSON.parse(o_file.get_as_text())

    if json_result.error == OK:

        self.mesh_dir = json_result.result.get(
            MESH_DIR_KEY,
            self.mesh_dir)

        self.capture_image_dir = json_result.result.get(
            CAPTURE_IMAGE_DIR_KEY,
            self.capture_image_dir)

        self.render_scale = json_result.result.get(
            RENDER_SCALE,
            self.render_scale)

        self.line_scale = json_result.result.get(
            LINE_SCALE,
            self.line_scale)

    print("configure load.")

    return true
   
