extends WindowDialog


func ext_name() -> String:
    return "[Blank]"


func ext_init(o_node: Spatial) -> bool:

    o_node.get_node("base_control/model_mesh").attach_mesh(null)

    return true
