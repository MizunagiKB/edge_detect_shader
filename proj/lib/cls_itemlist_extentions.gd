extends ItemList
class_name EDSItemListExtentions


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

        var name: String = o_dir.get_next()
    
        if name == "":
            break

        if o_dir.current_is_dir():
            var ext_pathname: String = pathname + "/" + name.plus_file("ext_main.tscn")
            var o_class = load(ext_pathname)
            if o_class != null:
                list_name.append([TYPE_FILE, o_class])
            else:
                list_name.append([TYPE_FOLD, name])

    list_name.sort_custom(self, "order_dir_file")


    for item in list_name:
        match item[0]:
            TYPE_FOLD:
                self.add_item(item[1], tex_fold)
            TYPE_FILE:
                var o_instance = item[1].instance()
                var idx = self.get_item_count()
                self.add_item(o_instance.ext_name(), tex_null)
                self.set_item_metadata(idx, item[1])

    self.dir_curr = pathname
    
    # self.get_node("../file_search").clear()

    return true


func load_extention(ext_pathname: String):

    var ext_frame = load("res://lib/eds_ext_frame.tscn").instance()

    get_tree().get_root().get_node("main_frame").add_child(ext_frame)

    if ext_frame.add_control(ext_pathname) == true:
        ext_frame.popup_exclusive = true
        ext_frame.popup_centered()
    else:
        ext_frame.queue_Free()


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

        var o_class = self.get_item_metadata(index)        
        self.load_extention(o_class.get_path())

