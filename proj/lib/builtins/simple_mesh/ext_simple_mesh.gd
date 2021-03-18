extends VBoxContainer


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


var o_mesh_instance: CEDSMeshInstance
var o_node: Node
var list_node = []

var result = false
var need_update = false


onready var list_update_event = [
    {"control": $btn_primitive, "signal_name": "item_selected"}
]


func ext_name() -> String:
    return "SimpleMesh"
    self.add

func ext_init(ext_dir: String) -> bool:

    $btn_primitive.add_item("CubeMesh")
    $btn_primitive.add_item("CylinderMesh")
    $btn_primitive.add_item("SphereMesh")

    return true


func ext_show(o_cam: Camera, o_node: Spatial, o_extention: Spatial) -> bool:

    self.list_node = []

    self.o_node = o_node

    for o in self.o_node.get_children():
        self.o_node.remove_child(o)
        self.list_node.append(o)

    self.o_mesh_instance = CEDSMeshInstance.new()
    self.o_node.add_child(self.o_mesh_instance)

    for o_control in list_update_event:
        if o_control.control.is_connected(
            o_control.signal_name,
            self,
            "_on_event"
        ) != true:
            o_control.control.connect(
                o_control.signal_name, self, "_on_event"
            )

    self.need_update = true

    return true


func ext_hide() -> bool:

    if self.result == true:
        for o in self.list_node:
            o.queue_free()
    else:
        self.o_mesh_instance.queue_free()
    
        for o in self.list_node:
            self.o_node.add_child(o)

    self.o_mesh_instance = null

    return true


func ext_accept():
    self.result = true


func ext_term():
    pass


func get_mesh() -> Mesh:

    match $btn_primitive.selected:
        0:
            return CubeMesh.new()
        1:
            return CylinderMesh.new()
        2:
            return SphereMesh.new()

    return null


func _process(delta):

    if self.need_update == true:
        var new_mesh = self.get_mesh()
        self.o_mesh_instance.set_mesh(new_mesh)
        self.need_update = false


func _on_event(_value):
    self.need_update = true

