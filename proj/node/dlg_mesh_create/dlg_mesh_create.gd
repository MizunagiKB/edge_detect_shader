extends WindowDialog


const list_cube_vtx = [
    Vector3( 1.0, -1.0, -1.0),
    Vector3( 1.0, -1.0,  1.0),
    Vector3(-1.0, -1.0,  1.0),
    Vector3(-1.0, -1.0, -1.0),
    Vector3( 1.0,  1.0, -1.0),
    Vector3( 1.0,  1.0,  1.0),
    Vector3(-1.0,  1.0,  1.0),
    Vector3(-1.0,  1.0, -1.0)
]

const list_cube_idx = [
    0, 1, 1, 2, 2, 3, 3, 0,
    4, 5, 5, 6, 6, 7, 7, 4,
    0, 4, 1, 5, 2, 6, 3, 7
]

const fixed_aabb = AABB(
    Vector3(-100, -100, -1),
    Vector3(200, 200, 2)
)


var result = false
var o_base_ctl = null
var eds_mesh_instance: EDSMeshInstance = null
var list_node = []

var need_update = false
onready var list_update_event = [
    {"control": $btn_primitive, "signal_name": "item_selected"},
    {"control": $lbl_inner/spin_min, "signal_name": "value_changed"},
    {"control": $lbl_inner/spin_max, "signal_name": "value_changed"},
    {"control": $lbl_width/spin_width, "signal_name": "value_changed"},
    {"control": $lbl_space/spin_space, "signal_name": "value_changed"}
]


func ext_name() -> String:
    return "[Mesh Create]"


func ext_init(ext_dir: String) -> bool:
    return true


func ext_show(o_cam: Camera, o_control: Spatial, o_ext: Spatial) -> bool:

    self.result = false
    self.o_base_ctl = o_control
    self.list_node = []

    for o in self.o_base_ctl.get_children():
        self.o_base_ctl.remove_child(o)
        self.list_node.append(o)

    assert(self.eds_mesh_instance == null)
    self.eds_mesh_instance = EDSMeshInstance.new()
    self.o_base_ctl.add_child(self.eds_mesh_instance)
    
    for o_ui in list_update_event:
        if o_ui.control.is_connected(o_ui.signal_name, self, "evt_value_changed") != true:
            o_ui.control.connect(o_ui.signal_name, self, "evt_value_changed")

    self.need_update = true

    return true


func ext_hide():

    if self.result == true:
        for o in self.list_node:
            o.queue_free()
    else:
        self.eds_mesh_instance.queue_free()
    
        for o in self.list_node:
            self.o_base_ctl.add_child(o)

    self.eds_mesh_instance = null


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
                var cv0 = v.rotated(Vector3.FORWARD, deg2rad(r)) * rand_range(
                    $lbl_inner/spin_min.value,
                    $lbl_inner/spin_max.value
                )

                var calc_r = max((randf() * $lbl_width/spin_width.value) / 2, 0.1)

                var cv1 = v.rotated(Vector3.FORWARD, deg2rad(r - calc_r)) * 100
                var cv2 = v.rotated(Vector3.FORWARD, deg2rad(r + calc_r)) * 100

                ary_vtx.push_back(cv0)
                ary_vtx.push_back(cv1)
                ary_vtx.push_back(cv2)

                ary_vtx.push_back(cv0)
                ary_vtx.push_back(cv2)
                ary_vtx.push_back(cv1)

                r += randf() * $lbl_space/spin_space.value

            var arrays = []
            arrays.resize(ArrayMesh.ARRAY_MAX)
            arrays[ArrayMesh.ARRAY_VERTEX] = ary_vtx

            var o_array_mesh = ArrayMesh.new()
            o_array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
            o_array_mesh.custom_aabb = fixed_aabb
                        
            return o_array_mesh

        5:
            var r = 0
            var v = Vector3.RIGHT

            var ary_vtx = PoolVector3Array()

            seed(0)

            while r < 200:
                
                var length = rand_range(
                    $lbl_inner/spin_min.value,
                    $lbl_inner/spin_max.value
                )
                var base_y = r - 100
                var width = max((randf() * $lbl_width/spin_width.value) / 2, 0.1)

                var cv0 = Vector3(length, base_y, 0.0)
                var cv1 = Vector3(-100.0, base_y - width, 0.0)
                var cv2 = Vector3(-100.0, base_y + width, 0.0)

                ary_vtx.push_back(cv0)
                ary_vtx.push_back(cv1)
                ary_vtx.push_back(cv2)

                ary_vtx.push_back(cv0)
                ary_vtx.push_back(cv2)
                ary_vtx.push_back(cv1)

                r += randf() * $lbl_space/spin_space.value

            var arrays = []
            arrays.resize(ArrayMesh.ARRAY_MAX)
            arrays[ArrayMesh.ARRAY_VERTEX] = ary_vtx

            var o_array_mesh = ArrayMesh.new()
            o_array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
            o_array_mesh.custom_aabb = fixed_aabb

            return o_array_mesh

    return null


func _ready():
    pass # Replace with function body.


func _process(delta):
    if self.need_update == true:
        var new_mesh = self.get_mesh()
        self.eds_mesh_instance.mesh_setup(new_mesh)
        self.need_update = false


func evt_value_changed(value):
    self.need_update = true


func _on_btn_ok_pressed():
    self.result = true
    self.hide()

