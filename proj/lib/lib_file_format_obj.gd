extends Node
class_name FileFormatObj


class CModelMesh:
    var ary_vert = []
    var ary_vert_index = []
    var ary_norm = []
    var ary_norm_index = []

    func append_vertex(ary_data):
        assert(ary_data.size() == 4)
        self.ary_vert.append(Vector3(float(ary_data[1]), float(ary_data[2]), float(ary_data[3])))

    func append_normal(ary_data):
        assert(ary_data.size() == 4)
        self.ary_norm.append(Vector3(float(ary_data[1]), float(ary_data[2]), float(ary_data[3])))

    func append_face(ary_data):
        match ary_data.size():
            4:
                var idx = [ary_data[1].split("/"), ary_data[2].split("/"), ary_data[3].split("/")]
                self.ary_vert_index.append([int(idx[0][0]), int(idx[1][0]), int(idx[2][0])])
                self.ary_norm_index.append([int(idx[0][2]), int(idx[1][2]), int(idx[2][2])])
            5:
                var idx = [ary_data[1].split("/"), ary_data[2].split("/"), ary_data[3].split("/"), ary_data[4].split("/")]
                self.ary_vert_index.append([int(idx[0][0]), int(idx[1][0]), int(idx[2][0])])
                self.ary_norm_index.append([int(idx[0][2]), int(idx[1][2]), int(idx[2][2])])
                self.ary_vert_index.append([int(idx[0][0]), int(idx[2][0]), int(idx[3][0])])
                self.ary_norm_index.append([int(idx[0][2]), int(idx[2][2]), int(idx[3][2])])
                pass
            _:
                assert(false)

    func create_mesh() -> Mesh:
        var ary_pool_vert = PoolVector3Array()
        var ary_pool_norm = PoolVector3Array()
        var ary_pool_face = PoolIntArray()
        var o_mesh: ArrayMesh = ArrayMesh.new()
        var ary_mesh = []
        
        assert(self.ary_norm.size() <= self.ary_vert.size())
        
        ary_pool_vert.resize(self.ary_vert.size())
        ary_pool_norm.resize(self.ary_vert.size())
        ary_pool_face.resize(self.ary_vert_index.size() * 3)

        for idx in range(self.ary_vert_index.size()):
            var v_idx = [
                self.ary_vert_index[idx][0] - 1,
                self.ary_vert_index[idx][1] - 1,
                self.ary_vert_index[idx][2] - 1
            ]
            var n_idx = [
                self.ary_norm_index[idx][0] - 1,
                self.ary_norm_index[idx][1] - 1,
                self.ary_norm_index[idx][2] - 1
            ]
                        
            ary_pool_face[idx * 3 + 0] = v_idx[0]
            ary_pool_face[idx * 3 + 1] = v_idx[1]
            ary_pool_face[idx * 3 + 2] = v_idx[2]

            ary_pool_vert[v_idx[0]] = self.ary_vert[v_idx[0]]
            ary_pool_vert[v_idx[1]] = self.ary_vert[v_idx[1]]
            ary_pool_vert[v_idx[2]] = self.ary_vert[v_idx[2]]

            ary_pool_norm[v_idx[0]] = self.ary_norm[n_idx[0]]
            ary_pool_norm[v_idx[1]] = self.ary_norm[n_idx[1]]
            ary_pool_norm[v_idx[2]] = self.ary_norm[n_idx[2]]


        ary_mesh.resize(ArrayMesh.ARRAY_MAX)
        ary_mesh[ArrayMesh.ARRAY_VERTEX] = ary_pool_vert
        ary_mesh[ArrayMesh.ARRAY_NORMAL] = ary_pool_norm
        ary_mesh[ArrayMesh.ARRAY_INDEX] = ary_pool_face

        o_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, ary_mesh)

        return o_mesh


func load(model_pathname: String) -> Mesh:

    var file = File.new()
    var e = file.open(model_pathname, File.READ)
    var filesize = file.get_len()

    var o_mmesh = CModelMesh.new()

    while file.get_position() < filesize:
        var line = file.get_line()

        line = line.strip_edges()
        
        if line.length() == 0:
            continue

        var arydata = line.split(" ")

        if arydata.size() > 0:
            match arydata[0]:
                "o":
                    pass
                "g":
                    pass
                "s":
                    pass
                "v":
                    o_mmesh.append_vertex(arydata)
                "vt":
                    pass
                "vn":
                    o_mmesh.append_normal(arydata)
                "f":
                    o_mmesh.append_face(arydata)
                "mtllib":
                    pass
                "usemtl":
                    pass
                "#":
                    pass
                _:
                    print(arydata)
                    assert(false)

    return o_mmesh.create_mesh()
