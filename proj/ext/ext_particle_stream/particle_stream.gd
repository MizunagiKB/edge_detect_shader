extends Particles


#var mat_particle: ParticlesMaterial = null


# Called when the node enters the scene tree for the first time.
# func _ready():
#    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

    var rot = self.get_parent().rotation
    var vct_dir = Vector3.RIGHT
    var vct_gra = Vector3.DOWN

    vct_gra = vct_gra.rotated(Vector3.UP, rot.y)
    vct_gra = vct_gra.rotated(Vector3.LEFT, rot.x)
    vct_gra = vct_gra.rotated(Vector3.FORWARD, rot.z)

    self.process_material.gravity = vct_gra.normalized() * 9.8

