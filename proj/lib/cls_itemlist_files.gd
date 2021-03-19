extends ItemList
class_name EDSItemListFiles


const TYPE_FOLD = 0
const TYPE_FILE = 1

var tex_fold = load("res://res_ui/icon/folder-solid_hover.svg")
var tex_file = load("res://res_ui/icon/file-solid_hover.svg")
var tex_null = load("res://res_ui/icon/icon_null.png")
var dir_curr = ""


func order_dir_file(a, b):
    if a[0] == b[0]:
        if a[1] < b[1]:
            return true
    if a[0] < b[0]:
        return true
    return false


func reload(pathname: String) -> bool:

    if pathname == "":
        pathname = "/"

    var o_dir = Directory.new()

    if o_dir.open(pathname) != OK:
        return false

    self.clear()

    o_dir.list_dir_begin()

    var list_name = []

    while true:

        var name = o_dir.get_next()
    
        if name == "":
            break

        if name == ".":
            continue

        if o_dir.current_is_dir():
            list_name.append([TYPE_FOLD, name])
        else:
            list_name.append([TYPE_FILE, name])

    list_name.sort_custom(self, "order_dir_file")


    for item in list_name:
        match item[0]:
            TYPE_FOLD:
                self.add_item(item[1], tex_fold)
            TYPE_FILE:
                self.add_item(item[1], tex_null)

    self.dir_curr = pathname
    
    self.get_node("../file_search").clear()

    return true


func load_mesh(pathname: String):

    var lower_ext: String = pathname.to_lower()
    var new_mesh: Mesh

    match lower_ext.get_extension():
        "mesh":
            new_mesh = load(pathname)
        "obj":
            var loader = FileFormatObj.new()
            new_mesh = loader.load(pathname)

    if new_mesh != null:

        var o_node = self.get_node("/root/main_frame/base/node")
        for o in o_node.get_children():
            o.queue_free()

        var o_mesh_instance = CEDSMeshInstance.new()
        o_node.add_child(o_mesh_instance)
        o_mesh_instance.set_mesh(new_mesh)
        

func _ready():

    self.connect("item_selected", self, "_on_item_selected")


func _on_item_selected(index: int):

    if self.get_item_icon(index) == self.tex_fold:

        var name = self.get_item_text(index)

        if name != ".":
            if name == "..":
                var list_pathname = self.dir_curr.split("/")
                list_pathname.remove(list_pathname.size() - 1)
                self.reload(list_pathname.join("/"))
            else:
                self.reload(self.dir_curr.plus_file(self.get_item_text(index)))

    else:

        var name = self.get_item_text(index)
        self.load_mesh(self.dir_curr.plus_file(name))

