extends WindowDialog


var extention_dir = null

var result = false
var o_base_ctl = null
var node_instance = null
var list_node = []

var need_update = false
onready var list_update_event = [
    {"control": $lbl_size/size, "signal_name": "value_changed"},
    {"control": $lbl_amount/amount, "signal_name": "value_changed"},
    {"control": $lbl_initial_velocity/initial_velocity, "signal_name": "value_changed"}
]


func ext_name() -> String:
    return "[Particle Lain]"


func ext_init(ext_dir: String) -> bool:
    self.extention_dir = ext_dir
    return true


func ext_show(o_cam: Camera, o_control: Spatial, o_ext: Spatial) -> bool:

    self.result = false
    self.o_base_ctl = o_control
    self.list_node = []

    for o in self.o_base_ctl.get_children():
        self.o_base_ctl.remove_child(o)
        self.list_node.append(o)

    assert(self.node_instance == null)
    self.node_instance = load(self.extention_dir + "/particle_lain.tscn").instance()
    self.o_base_ctl.add_child(self.node_instance)

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
        self.node_instance.queue_free()
    
        for o in self.list_node:
            self.o_base_ctl.add_child(o)

    self.node_instance = null


func _ready():
    pass # Replace with function body.


func _process(delta):

    if self.need_update == true:
        self.node_instance.draw_pass_1.size.y = $lbl_size/size.value
        self.node_instance.amount = $lbl_amount/amount.value
        self.node_instance.process_material.initial_velocity = float($lbl_initial_velocity/initial_velocity.value)
        self.need_update = false



func evt_value_changed(value):
    self.need_update = true


func _on_btn_ok_pressed():
    self.result = true
    self.hide()

