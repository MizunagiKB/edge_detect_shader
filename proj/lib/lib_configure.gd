extends Node

const CONF_PATHNAME =  "user://edge_ds.conf"

const MESH_DIR_KEY = "61d06f23-0386-4516-bda4-da5334ac42cb"
const CAPTURE_IMAGE_DIR_KEY = "a93955ce-bd07-4e27-8af5-f0c9820cc5e4"

var mesh_dir: String = ""
var capture_image_dir: String = ""


func save() -> bool:

    var o_file = File.new()

    var dict_param = {
        "version": ProjectSettings.get_setting("application/config/Version"),
        MESH_DIR_KEY: self.mesh_dir,
        CAPTURE_IMAGE_DIR_KEY: self.capture_image_dir
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

    print("configure load.")

    return true
   
