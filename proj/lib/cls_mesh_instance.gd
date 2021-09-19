extends MeshInstance
class_name CEDSMeshInstance
const EXT_GUID = "f32b11c7-008b-41ef-bafb-5c1e80b41340"


func set_mesh(new_mesh: Mesh):

    if new_mesh != null:

        self.transform = Transform.IDENTITY
    
        var bbox = new_mesh.get_aabb()
    
        var length = bbox.size.length()
        var vct_trans = Vector3.ZERO
        var scale = 8
        if length > 0:
            scale /= length
    
        self.scale = Vector3(scale, scale, scale)
            
        vct_trans -= bbox.position
        vct_trans -= (bbox.size / 2)

        print(self.scale)
        print(vct_trans)
    
        self.translate_object_local(vct_trans)

        self.add_to_group("render_node")

        get_tree().call_group("render_mode", "request_material")

    self.mesh = new_mesh

