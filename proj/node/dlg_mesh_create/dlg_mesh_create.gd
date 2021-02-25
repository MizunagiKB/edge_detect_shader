extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var need_update = false
var exit = false

var list_cube_vtx = [
    Vector3( 1.0, -1.0, -1.0),
    Vector3( 1.0, -1.0,  1.0),
    Vector3(-1.0, -1.0,  1.0),
    Vector3(-1.0, -1.0, -1.0),
    Vector3( 1.0,  1.0, -1.0),
    Vector3( 1.0,  1.0,  1.0),
    Vector3(-1.0,  1.0,  1.0),
    Vector3(-1.0,  1.0, -1.0)
]

var list_cube_idx = [
    0, 1, 1, 2, 2, 3, 3, 0,
    4, 5, 5, 6, 6, 7, 7, 4,
    0, 4, 1, 5, 2, 6, 3, 7
]

var fixed_aabb = AABB(
    Vector3(-25, -25, -1),
    Vector3(50, 50, 2)
)


func plugin_open():
    self.popup_centered()


func get_mesh() -> Mesh:

    match $btn_primitive.selected:
        0:
            return CubeMesh.new()
        1:
            return CylinderMesh.new()
        2:
            return SphereMesh.new()
        3:
            var ary_vtx = PoolVector3Array()
            var ary_idx = PoolIntArray()
            for v in list_cube_vtx:
                ary_vtx.push_back(v)
            for i in list_cube_idx:
                ary_idx.push_back(i)

            var arrays = []
            arrays.resize(ArrayMesh.ARRAY_MAX)
            arrays[ArrayMesh.ARRAY_VERTEX] = ary_vtx                
            arrays[ArrayMesh.ARRAY_INDEX] = ary_idx

            var o_array_mesh = ArrayMesh.new()
            o_array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
            
            return o_array_mesh

        4:
            var r = 0
            var v = Vector3.RIGHT

            var ary_vtx = PoolVector3Array()

            seed(0)

            while r < 360:
                var cv = v.rotated(Vector3.FORWARD, deg2rad(r)) * rand_range(
                    $lbl_inner/spin_min.value,
                    $lbl_inner/spin_max.value
                )
                ary_vtx.push_back(cv)

                var calc_r = (randf() * $lbl_width/spin_width.value) / 2

                cv = v.rotated(Vector3.FORWARD, deg2rad(r - calc_r)) * 100
                ary_vtx.push_back(cv)

                cv = v.rotated(Vector3.FORWARD, deg2rad(r + calc_r)) * 100
                ary_vtx.push_back(cv)

                r += randf() * $lbl_space/spin_space.value

            var arrays = []
            arrays.resize(ArrayMesh.ARRAY_MAX)
            arrays[ArrayMesh.ARRAY_VERTEX] = ary_vtx

            var o_array_mesh = ArrayMesh.new()
            o_array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
            o_array_mesh.custom_aabb = fixed_aabb
                        
            return o_array_mesh

    return null


func request_preview(node: ModelMesh):
    if self.need_update == true:
        var new_mesh = self.get_mesh()
        
        node.attach_mesh(new_mesh)
        self.need_update = false


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func _on_btn_ok_pressed():
    self.exit = true
    self.hide()


func _on_dlg_create_mesh_about_to_show():
    self.exit = false


func _on_btn_primitive_item_selected(id):
    self.need_update = true


func _on_value_changed(value):
    self.need_update = true
