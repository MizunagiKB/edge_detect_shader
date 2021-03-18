extends HBoxContainer


var extention_dir = null

var result = false
var o_base_ctl = null
var node_instance = null
var list_node = []

var need_update = false
onready var list_update_event = [
    {"control": $vbox1/particle_type, "signal_name": "item_selected"},
    {"control": $vbox1/hbox1/size, "signal_name": "value_changed"},
    {"control": $vbox1/hbox2/amount, "signal_name": "value_changed"},
    {"control": $vbox1/hbox3/initial_velocity, "signal_name": "value_changed"},

    {"control": $vbox2/fog_enable, "signal_name": "toggled"},
    {"control": $vbox2/hbox1/amount, "signal_name": "value_changed"}, 
    {"control": $vbox2/hbox2/fog_color, "signal_name": "color_changed"},
]


func ext_name() -> String:
    return "Particle Rain"


func ext_init(ext_dir: String) -> bool:

    self.extention_dir = ext_dir

    return true


func ext_show(_o_cam: Camera, o_control: Spatial, _o_ext: Spatial) -> bool:

    self.result = false
    self.o_base_ctl = o_control
    self.list_node = []

    for o in self.o_base_ctl.get_children():
        self.o_base_ctl.remove_child(o)
        self.list_node.append(o)
        print("obj", o)

    assert(self.node_instance == null)
    self.node_instance = load(self.extention_dir + "/particle_rain.tscn").instance()
    self.o_base_ctl.add_child(self.node_instance)

    for o_ui in list_update_event:
        if o_ui.control.is_connected(o_ui.signal_name, self, "evt_value_changed") != true:
            o_ui.control.connect(o_ui.signal_name, self, "evt_value_changed")

    self.need_update = true

    return true


func ext_hide() -> bool:

    if self.result == true:
        for o in self.list_node:
            o.queue_free()
    else:
        self.o_base_ctl.remove_child(self.node_instance)
        self.node_instance.free()
                 
        for o in self.list_node:
            self.o_base_ctl.add_child(o)

    self.node_instance = null

    return true


func ext_accept():
    self.result = true


func ext_term():
    pass


func _ready():
    pass # Replace with function body.


func _process(_delta):

    var node_r = self.node_instance.get_node("particles_rain")
    var node_s = self.node_instance.get_node("particles_snow")
    var node_f: Particles = self.node_instance.get_node("particles_fog")

    if self.need_update == true:

        match $vbox1/particle_type.get_selected_id():
            0:
                node_r.visible = false
                node_s.visible = false
            1:
                node_r.visible = true
                node_s.visible = false
            2:
                node_r.visible = false
                node_s.visible = true

        node_r.draw_pass_1.size.y = $vbox1/hbox1/size.value
        node_r.amount = $vbox1/hbox2/amount.value
        node_r.process_material.initial_velocity = float($vbox1/hbox3/initial_velocity.value)

        var radius = $vbox1/hbox1/size.value / 64
        node_s.draw_pass_1.radius = radius
        node_s.draw_pass_1.height = radius * 2
        node_s.amount = $vbox1/hbox2/amount.value
        node_s.process_material.initial_velocity = float($vbox1/hbox3/initial_velocity.value) / 10
        
        node_f.visible = $vbox2/fog_enable.pressed
        node_f.amount = $vbox2/hbox1/amount.value
        node_f.process_material.color = $vbox2/hbox2/fog_color.color

        self.need_update = false


func evt_value_changed(_value):
    self.need_update = true

