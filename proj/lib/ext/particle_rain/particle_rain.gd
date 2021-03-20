extends Spatial


var amount: float setget set_amount


func set_amount(value: float):

    $particles_snow_2/snow_1.amount = 2 * value
    $particles_snow_2/snow_2.amount = 16 * value
    $particles_snow_2/snow_3.amount = 256 * value
    $particles_snow_2/snow_4.amount = 128 * value


func _ready():

    self.add_to_group("render_node")
    $particles_rain.add_to_group("render_node")
    $particles_snow_1.add_to_group("render_node")

    get_tree().call_group("render_mode", "request_material")


func _process(_delta):

    pass

