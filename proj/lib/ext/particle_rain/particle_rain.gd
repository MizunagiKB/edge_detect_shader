extends Spatial


func _ready():

    self.add_to_group("render_node")
    $particles_rain.add_to_group("render_node")
    $particles_snow_1.add_to_group("render_node")

    get_tree().call_group("render_mode", "request_material")


func _process(_delta):

    pass

