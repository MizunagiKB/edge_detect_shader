extends MeshInstance
class_name ModelMesh


var base_scale = Vector3.ONE
var calc_scale = 1.0
var base_material: ShaderMaterial

var prev_mesh: Mesh = null
var curr_mesh: Mesh = null

var color_value = Color.white
var o_mesh = MeshInstance


func reset():
    self.calc_scale = 1.0
    self.scale = base_scale


func get_scale_value():
    return calc_scale


func set_scale_value(new_scale: float):
    self.calc_scale = clamp(new_scale, 0.1, 10.0)
    self.scale = base_scale * self.calc_scale


func scale_inc():
    set_scale_value(self.calc_scale + 0.1)
func scale_dec():
    set_scale_value(self.calc_scale - 0.1)


func attach_mesh(new_mesh: Mesh):

    if new_mesh == null:
        o_mesh.mesh = null
        return

    var bbox = new_mesh.get_aabb()

    if new_mesh is ArrayMesh:
        if new_mesh.custom_aabb.has_no_area() != true:
            bbox = new_mesh.custom_aabb

    o_mesh.translation = Vector3.ZERO - bbox.position
    o_mesh.translation -= (bbox.size / 2)

    var l = bbox.size.length()
    var scale = 5
    if l > 0:
        scale /= l

    for n in range(new_mesh.get_surface_count()):
        new_mesh.surface_set_material(n, base_material)


    self.base_scale = Vector3(scale, scale, scale)
    self.set_scale_value(1)
    o_mesh.mesh = new_mesh


func set_color_value(new_color: Color):
    self.color_value = new_color
    base_material.set_shader_param("color", self.color_value)

func set_shader_off():
    base_material.set_shader_param("color_mode", 0)


func set_shader_edge():
    base_material.set_shader_param("color_mode", 0)


func set_shader_normal():
    base_material.set_shader_param("color_mode", 1)


func set_shader_depth():
    base_material.set_shader_param("color_mode", 0)


func _ready():

    o_mesh = MeshInstance.new()
    self.add_child(o_mesh)

    base_material = ShaderMaterial.new()
    base_material.shader = load("res://shader/visual_shader.tres")
    base_material.set_shader_param("color_mode", 0)
    base_material.set_shader_param("color", self.color_value)
