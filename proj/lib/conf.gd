extends Node


const CONF_PATHNAME = "user://eds.conf"


var capture_image_dir: String = ""
var capture_scale: int = 1


func parameter_load():

    var o_file = File.new()
    
    if o_file.file_exists(CONF_PATHNAME) == true:
        o_file.open(CONF_PATHNAME, File.READ)

        var json_result = JSON.parse(o_file.get_as_text())
        if json_result.error == OK:
            self.capture_image_dir = json_result.result.get("capture_image_dir", self.capture_image_dir)
            self.capture_scale = json_result.result.get("capture_scale", self.capture_scale)


func parameter_save():

    var o_file = File.new()

    var dict_param = {
        "version": ProjectSettings.get_setting("application/config/version"),
        "capture_image_dir": self.capture_image_dir,
        "capture_scale": self.capture_scale
    }

    if o_file.open(CONF_PATHNAME, File.WRITE) == 0:
        o_file.store_string(JSON.print(dict_param))


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.
