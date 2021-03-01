extends MeshInstance
class_name EDSMeshInstance


var color_value = Color.white


func mesh_setup(new_mesh: Mesh):

    if new_mesh == null:
        self.mesh = null
        return

    self.transform = Transform.IDENTITY

    var bbox = new_mesh.get_aabb()

    if new_mesh is ArrayMesh:
        if new_mesh.custom_aabb.has_no_area() != true:
            bbox = new_mesh.custom_aabb

    var l = bbox.size.length()
    var vct_trans = Vector3.ZERO
    var scale = 8
    if l > 0:
        scale /= l

    self.scale = Vector3(scale, scale, scale)

    vct_trans -= bbox.position
    vct_trans -= (bbox.size / 2)

    self.translate_object_local(vct_trans)

    self.mesh = new_mesh


func set_color_value(new_color: Color):
    self.color_value = new_color
    self.material_override.set_shader_param("color", self.color_value)


func set_shader_off():
    self.material_override.set_shader_param("color_mode", 0)


func set_shader_edge():
    self.material_override.set_shader_param("color_mode", 0)


func set_shader_normal():
    self.material_override.set_shader_param("color_mode", 1)


func set_shader_depth():
    self.material_override.set_shader_param("color_mode", 0)


func _ready():

    self.material_override = ShaderMaterial.new()
    self.material_override.shader = load("res://shader/visual_shader.tres")
    self.material_override.set_shader_param("color_mode", 0)
    self.material_override.set_shader_param("color", self.color_value)

