extends MeshInstance
class_name ModelMesh


var base_scale = Vector3.ONE
var calc_scale = 1.0
var base_material: ShaderMaterial


func reset():
    self.scale = base_scale


func get_scale_value():
    return calc_scale


func set_scale_value(new_scale: float):
    self.calc_scale = clamp(new_scale, 0.1, 10.0)
    self.scale = base_scale * self.calc_scale


func scale_inc():
    set_scale_value(calc_scale + 0.1)
func scale_dec():
    set_scale_value(calc_scale - 0.1)


func attach_mesh(new_mesh: Mesh):

    var bbox = new_mesh.get_aabb()

    self.translation = Vector3.ZERO - bbox.position
    self.translation -= (bbox.size / 2)

    var scale = 10.0 / bbox.size.x

    for n in range(new_mesh.get_surface_count()):
        new_mesh.surface_set_material(n, base_material)


    self.base_scale = Vector3(scale, scale, scale)
    self.set_scale_value(1)
    self.mesh = new_mesh


func set_shader_off():
    base_material.set_shader_param("color_mode", 0)


func set_shader_edge():
    base_material.set_shader_param("color_mode", 0)


func set_shader_normal():
    base_material.set_shader_param("color_mode", 1)


func set_shader_depth():
    base_material.set_shader_param("color_mode", 0)


func _ready():

    base_material = ShaderMaterial.new()
    base_material.shader = load("res://shader/visual_shader.tres")
    base_material.set_shader_param("color_mode", 0)
