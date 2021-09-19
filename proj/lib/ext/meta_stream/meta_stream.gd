extends Spatial
# EXT_GUID
const EXT_GUID = "e1a0e57e-b750-4c65-9391-23ece7de2680"


const GRAVITY: float = 9.8

var camera: Camera
var base_node: Spatial
var mat_curr: ShaderMaterial
var liquid_entity = 0.2
var liquid_outline = 2.5

var extension_dir = ""
var recalc_gravity = false


func _ready():

    $Viewport.own_world = true

    self.camera = get_node("/root/main_frame/camera")
    self.base_node = get_node("/root/main_frame/base/node")

    self.connect("tree_exiting", self, "_on_tree_exiting")

    $direction.add_to_group("render_node")
    get_tree().call_group("render_mode", "request_material")

    $Viewport/base/node/particle1.amount = 256
    $Viewport/base/node/particle1.lifetime = 5.0
    $Viewport/base/node/particle1.explosiveness = 0
    $Viewport/base/node/particle1.process_material = ParticlesMaterial.new()
    $Viewport/base/node/particle1.process_material.spread = 1
    $Viewport/base/node/particle1.process_material.initial_velocity = 10
    $Viewport/base/node/particle1.process_material.initial_velocity_random = 0.1
    $Viewport/base/node/particle1.process_material.linear_accel = 0
    $Viewport/base/node/particle1.process_material.scale = 1
    $Viewport/base/node/particle1.process_material.scale_random = 0.5
    
    $Viewport/base/node/particle1.process_material.scale_curve = load(self.extension_dir + "/cv_water.tres")

    self.mat_curr = ShaderMaterial.new()
    self.mat_curr.shader = load(self.extension_dir + "/ms_screen.shader")
    self.mat_curr.set_shader_param("tex", $Viewport.get_texture())

    get_tree().call_group("render_mode", "set_shader_param", "next_pass", self.mat_curr);


func _process(_delta):

    $Viewport.size = get_viewport().size

    $Viewport/camera.fov = self.camera.fov
    $Viewport/camera.h_offset = self.camera.h_offset
    $Viewport/camera.v_offset = self.camera.v_offset
    $Viewport/camera.transform = self.camera.transform
    $Viewport/base/node.transform = self.base_node.transform

    var rot = $Viewport/base/node.rotation
    var vct_dir = Vector3.RIGHT
    var vct_gra = Vector3.DOWN

    if self.recalc_gravity == true:
        vct_gra = vct_gra.rotated(Vector3.UP, rot.y)
        vct_gra = vct_gra.rotated(Vector3.LEFT, rot.x)
        vct_gra = vct_gra.rotated(Vector3.FORWARD, rot.z)
    else:
        vct_gra = Vector3.DOWN

    $Viewport/base/node/particle1.process_material.gravity = vct_gra.normalized() * GRAVITY


func _on_tree_exiting():

    get_tree().call_group("render_mode", "set_shader_param", "next_pass", 0)

