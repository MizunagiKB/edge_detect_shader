tool
extends TextureButton
class_name EDSTextureButton


export(Texture) var tex0_normal
export(Texture) var tex0_hover
export(Texture) var tex0_pressed
export(Texture) var tex0_disabled
export(Texture) var tex1_normal
export(Texture) var tex1_hover
export(Texture) var tex1_pressed
export(Texture) var tex1_disabled

var pressed_status: bool = false


func set_textures():
    if self.pressed_status == true:
        self.texture_normal = tex1_normal
        self.texture_hover = tex1_hover
        self.texture_pressed = tex0_pressed
        self.texture_disabled = tex1_disabled
    else:
        self.texture_normal = tex0_normal
        self.texture_hover = tex0_hover
        self.texture_pressed = tex1_pressed
        self.texture_disabled = tex0_disabled


func _ready():
    self.connect("pressed", self, "_on_pressed")
    self.set_textures()


func _process(delta):
    pass


func _on_pressed():
    self.pressed_status = not self.pressed_status
    self.set_textures()

