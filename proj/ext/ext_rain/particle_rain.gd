extends Spatial


var color_value = Color.white


func set_color_value(new_color: Color):
    self.color_value = new_color
    $particles_rain.material_override.set_shader_param("color", self.color_value)
    $particles_snow.material_override.set_shader_param("color", self.color_value)


func set_shader_off():
    # $particle_rain.material_override.set_shader_param("color_mode", 0)
    pass

func set_shader_edge():
    # $particle_rain.material_override.set_shader_param("color_mode", 0)
    pass

func set_shader_normal():
    # $particle_rain.material_override.set_shader_param("color_mode", 1)
    pass

func set_shader_depth():
    # $particle_rain.material_override.set_shader_param("color_mode", 0)
    pass


func _ready():

    $particles_rain.material_override = ShaderMaterial.new()
    $particles_rain.material_override.shader = load("res://shader/visual_shader.tres")
    $particles_rain.material_override.set_shader_param("color_mode", 0)
    $particles_rain.material_override.set_shader_param("color", self.color_value)

    $particles_snow.material_override = ShaderMaterial.new()
    $particles_snow.material_override.shader = load("res://shader/visual_shader.tres")
    $particles_snow.material_override.set_shader_param("color_mode", 0)
    $particles_snow.material_override.set_shader_param("color", self.color_value)


func _process(delta):

    pass

