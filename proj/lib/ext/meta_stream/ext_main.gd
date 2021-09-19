extends VBoxContainer


var extension_dir = null
var extension_cls = null
var own_guid = null
var own_inst = null

var result = false
var o_base_ctl = null
var list_node = []

var need_update = false


func ext_name() -> String:
    return "Meta Stream"


func ext_init(ext_dir: String) -> bool:

    self.extension_dir = ext_dir
    self.extension_cls = load(self.extension_dir + "/meta_stream.tscn")

    self.own_guid = self.extension_cls.instance().EXT_GUID

    return true


func ext_show(o_camera: Camera, o_base_node: Spatial, o_base_extension: Spatial) -> bool:

    self.result = false
    self.o_base_ctl = o_base_node
    self.list_node = []

    for node in o_base_node.get_children():
        if node.EXT_GUID == self.own_guid:       
            self.own_inst = node
            break

    if self.own_inst == null:
        for o in self.o_base_ctl.get_children():
            self.o_base_ctl.remove_child(o)
            self.list_node.append(o)

        self.own_inst = self.extension_cls.instance()
        
        self.own_inst.extension_dir = self.extension_dir
        self.o_base_ctl.add_child(self.own_inst)


    match self.own_inst.get_node("Viewport/base/node/particle1").process_material.emission_shape:
        0:
            $hbox1/emission_shape.current_tab = 0
        2:
            $hbox1/emission_shape.current_tab = 1

    $grid/liquid_entity.value = self.own_inst.liquid_entity
    $grid/liquid_outline.value = self.own_inst.liquid_outline

    $hbox1/emission_shape/Box/grid/x.text = String(self.own_inst.get_node("Viewport/base/node/particle1").process_material.emission_box_extents.x)
    $hbox1/emission_shape/Box/grid/y.text = String(self.own_inst.get_node("Viewport/base/node/particle1").process_material.emission_box_extents.y)
    $hbox1/emission_shape/Box/grid/z.text = String(self.own_inst.get_node("Viewport/base/node/particle1").process_material.emission_box_extents.z)


    $hbox1/grid/amount.value = self.own_inst.get_node("Viewport/base/node/particle1").amount
    $hbox1/grid/lifetime.value = self.own_inst.get_node("Viewport/base/node/particle1").lifetime
    $hbox1/grid/explosiveness.value = self.own_inst.get_node("Viewport/base/node/particle1").explosiveness

    $hbox1/grid/spread.value = self.own_inst.get_node("Viewport/base/node/particle1").process_material.spread
    $hbox1/grid/initial_velocity.value = self.own_inst.get_node("Viewport/base/node/particle1").process_material.initial_velocity
    
    $hbox1/grid/initial_velocity_random.value = self.own_inst.get_node("Viewport/base/node/particle1").process_material.initial_velocity_random
    $hbox1/grid/scale.value = self.own_inst.get_node("Viewport/base/node/particle1").process_material.scale
    $hbox1/grid/scale_random.value = self.own_inst.get_node("Viewport/base/node/particle1").process_material.scale_random

    $recalc_gravity.pressed = self.own_inst.recalc_gravity

    self.need_update = true

    return true


func ext_hide() -> bool:

    if self.result == true:
        for o in self.list_node:
            o.queue_free()
    else:
        self.o_base_ctl.remove_child(self.own_inst)
        self.own_inst.free()
    
        for o in self.list_node:
            if o != null:
                self.o_base_ctl.add_child(o)

    self.own_inst = null

    return true


func ext_accept():
    self.result = true


func ext_term():
    pass


func _ready():

    $hbox1/emission_shape.connect("tab_changed", self, "_on_tab_changed")

    $grid/liquid_entity.connect("value_changed", self, "_on_value_changed")
    $grid/liquid_outline.connect("value_changed", self, "_on_value_changed")

    $hbox1/emission_shape/Box/grid/x.connect("text_changed", self, "_on_text_changed")
    $hbox1/emission_shape/Box/grid/y.connect("text_changed", self, "_on_text_changed")
    $hbox1/emission_shape/Box/grid/z.connect("text_changed", self, "_on_text_changed")

    $hbox1/grid/amount.connect("value_changed", self, "_on_value_changed")
    $hbox1/grid/lifetime.connect("value_changed", self, "_on_value_changed")
    $hbox1/grid/explosiveness.connect("value_changed", self, "_on_value_changed")
    $hbox1/grid/spread.connect("value_changed", self, "_on_value_changed")
    $hbox1/grid/initial_velocity.connect("value_changed", self, "_on_value_changed")
    $hbox1/grid/initial_velocity_random.connect("value_changed", self, "_on_value_changed")
    $hbox1/grid/linear_accel.connect("value_changed", self, "_on_value_changed")
    $hbox1/grid/scale.connect("value_changed", self, "_on_value_changed")
    $hbox1/grid/scale_random.connect("value_changed", self, "_on_value_changed")

    $recalc_gravity.connect("pressed", self, "_on_pressed")


func _process(_delta):

    if self.need_update == true:

        self.own_inst.liquid_entity = $grid/liquid_entity.value
        self.own_inst.mat_curr.set_shader_param("liquid_entity", $grid/liquid_entity.value)
        self.own_inst.liquid_outline = $grid/liquid_outline.value
        self.own_inst.mat_curr.set_shader_param("liquid_outline", $grid/liquid_outline.value)

        match $hbox1/emission_shape.current_tab:
            0:
                self.own_inst.get_node("Viewport/base/node/particle1").process_material.emission_shape = 0
            1:
                self.own_inst.get_node("Viewport/base/node/particle1").process_material.emission_shape = 2
                self.own_inst.get_node("Viewport/base/node/particle1").process_material.emission_box_extents.x = float($hbox1/emission_shape/Box/grid/x.text)
                self.own_inst.get_node("Viewport/base/node/particle1").process_material.emission_box_extents.y = float($hbox1/emission_shape/Box/grid/y.text)
                self.own_inst.get_node("Viewport/base/node/particle1").process_material.emission_box_extents.z = float($hbox1/emission_shape/Box/grid/z.text)

        $hbox1/grid/txt_amount.text = String($hbox1/grid/amount.value)
        self.own_inst.get_node("Viewport/base/node/particle1").amount = $hbox1/grid/amount.value
        $hbox1/grid/txt_lifetime.text = String($hbox1/grid/lifetime.value)
        self.own_inst.get_node("Viewport/base/node/particle1").lifetime = $hbox1/grid/lifetime.value
        $hbox1/grid/txt_explosiveness.text = String($hbox1/grid/explosiveness.value)
        self.own_inst.get_node("Viewport/base/node/particle1").explosiveness = $hbox1/grid/explosiveness.value

        $hbox1/grid/txt_spread.text = String($hbox1/grid/spread.value)
        self.own_inst.get_node("Viewport/base/node/particle1").process_material.spread = $hbox1/grid/spread.value
        $hbox1/grid/txt_initial_velocity.text = String($hbox1/grid/initial_velocity.value)
        self.own_inst.get_node("Viewport/base/node/particle1").process_material.initial_velocity = $hbox1/grid/initial_velocity.value
        $hbox1/grid/txt_initial_velocity_random.text = String($hbox1/grid/initial_velocity_random.value)
        self.own_inst.get_node("Viewport/base/node/particle1").process_material.initial_velocity_random = $hbox1/grid/initial_velocity_random.value

        $hbox1/grid/txt_linear_accel.text = String($hbox1/grid/linear_accel.value)
        self.own_inst.get_node("Viewport/base/node/particle1").process_material.linear_accel = $hbox1/grid/linear_accel.value

        $hbox1/grid/txt_scale.text = String($hbox1/grid/scale.value)
        self.own_inst.get_node("Viewport/base/node/particle1").process_material.scale = $hbox1/grid/scale.value
        $hbox1/grid/txt_scale_random.text = String($hbox1/grid/scale_random.value)
        self.own_inst.get_node("Viewport/base/node/particle1").process_material.scale_random = $hbox1/grid/scale_random.value

        self.own_inst.recalc_gravity = $recalc_gravity.pressed

        self.need_update = false


func _on_tab_changed(_tab):
    self.need_update = true


func _on_text_changed(_value):
    self.need_update = true


func _on_value_changed(_value):
    self.need_update = true


func _on_pressed():
    self.need_update = true

