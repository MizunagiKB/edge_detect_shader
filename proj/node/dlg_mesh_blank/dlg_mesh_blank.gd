extends WindowDialog


func ext_name() -> String:
    return "[Blank]"


func ext_init(o_node: Spatial) -> bool:

    o_node.get_node("ui").add_child(self)
    o_node.get_node("base_control/model_mesh").mesh = null

    return true
