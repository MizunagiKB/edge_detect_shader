extends Node


const CONF_PATHNAME = "user://eds.conf"


var mesh_dir: String = ""
var capture_image_dir: String = ""
var capture_scale: int = 1
var capture_screen_ratio: int = 0


func parameter_load():

    var o_file = File.new()
    
    if o_file.file_exists(CONF_PATHNAME) == true:
        o_file.open(CONF_PATHNAME, File.READ)

        var json_result = JSON.parse(o_file.get_as_text())
        if json_result.error == OK:
            self.mesh_dir = json_result.result.get("mesh_dir", self.mesh_dir)
            self.capture_image_dir = json_result.result.get("capture_image_dir", self.capture_image_dir)
            self.capture_scale = json_result.result.get("capture_scale", self.capture_scale)
            self.capture_screen_ratio = json_result.result.get("capture_screen_ratio", self.capture_screen_ratio)


func parameter_save():

    var o_file = File.new()

    var dict_param = {
        "version": ProjectSettings.get_setting("application/config/version"),
        "mesh_dir": self.mesh_dir,
        "capture_image_dir": self.capture_image_dir,
        "capture_scale": self.capture_scale,
        "capture_screen_ratio": self.capture_screen_ratio
    }

    if o_file.open(CONF_PATHNAME, File.WRITE) == 0:
        o_file.store_string(JSON.print(dict_param))

