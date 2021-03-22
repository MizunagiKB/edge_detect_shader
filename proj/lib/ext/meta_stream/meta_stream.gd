extends Spatial
# EXT_GUID
const EXT_GUID = "e1a0e57e-b750-4c65-9391-23ece7de2680"


var camera: Camera
var base_node: Spatial

var recalc_gravity = false


func _ready():

    $Viewport.own_world = true

    self.camera = get_node("/root/main_frame/camera")
    self.base_node = get_node("/root/main_frame/base/node")

    self.connect("tree_exiting", self, "_on_tree_exiting")

    get_tree().call_group("render_mode", "set_shader_param", "tex", $Viewport.get_texture());

    $direction.add_to_group("render_node")
    get_tree().call_group("render_mode", "request_material")


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

    $Viewport/base/node/particle1.process_material.gravity = vct_gra.normalized() * 9.8


func _on_tree_exiting():
    
    get_tree().call_group("render_mode", "set_shader_param", "tex", "");

