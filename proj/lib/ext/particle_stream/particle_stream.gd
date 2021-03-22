extends Particles
#
const EXT_GUID = "e7237b8c-87ec-4abb-8bf8-792528d9591f"


var recalc_gravity = false


func _ready():

    self.add_to_group("render_node")
    $direction.add_to_group("render_node")

    get_tree().call_group("render_mode", "request_material")


func _process(delta):

    var rot = self.get_parent().rotation
    var vct_dir = Vector3.RIGHT
    var vct_gra = Vector3.DOWN

    if self.recalc_gravity == true:
        vct_gra = vct_gra.rotated(Vector3.UP, rot.y)
        vct_gra = vct_gra.rotated(Vector3.LEFT, rot.x)
        vct_gra = vct_gra.rotated(Vector3.FORWARD, rot.z)
    else:
        vct_gra = Vector3.DOWN

    self.process_material.gravity = vct_gra.normalized() * 9.8

