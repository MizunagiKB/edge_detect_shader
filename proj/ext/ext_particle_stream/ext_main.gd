extends WindowDialog


var extention_dir = null

var result = false
var o_base_ctl = null
var node_instance = null
var list_node = []

var need_update = false
onready var list_update_event = [
    {"control": $lbl_amount/amount, "signal_name": "value_changed"},
    {"control": $lbl_spread/spread, "signal_name": "value_changed"},
    {"control": $lbl_initial_velocity/initial_velocity, "signal_name": "value_changed"},
    {"control": $recalc_gravity, "signal_name": "toggled"}
]


func ext_name() -> String:
    return "[Particle Stream]"


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
    self.node_instance = load(self.extention_dir + "/particle_stream.tscn").instance()
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
        self.o_base_ctl.remove_child(self.node_instance)
        self.node_instance.free()
    
        for o in self.list_node:
            if o != null:
                self.o_base_ctl.add_child(o)

    self.node_instance = null


func _ready():
    pass # Replace with function body.


func _process(delta):

    if self.need_update == true:
        self.node_instance.recalc_gravity = $recalc_gravity.pressed
        self.node_instance.amount = $lbl_amount/amount.value
        self.node_instance.process_material.spread = $lbl_spread/spread.value
        self.node_instance.process_material.initial_velocity = float($lbl_initial_velocity/initial_velocity.value)
        self.need_update = false


func evt_value_changed(value):
    self.need_update = true


func _on_btn_ok_pressed():
    self.result = true
    self.hide()

