extends Node

const SLIDE_PADDING := 95

enum E_FADE {
    E_FADE_I,E_FADE_O
}

var main_frame: Control = null

var b_show: bool = true
var show setget set_show, get_show


func swap(a, b):
    return [b, a]


func set_show(new_value: bool):

    var tween = self.main_frame.get_node("ui_tween")
    var twI: Vector2
    var twO: Vector2
    var list_tw: Array
    var o_frm: Control

    # frmU
    o_frm = self.main_frame.get_node("frmU")
    twI = Vector2(0, 0)
    twO = twI - Vector2(0, o_frm.rect_size.y + SLIDE_PADDING)
    list_tw = [twI, twO]

    if new_value:
        list_tw = swap(twI, twO)

    tween.interpolate_property(
        o_frm,
        "rect_position",
        list_tw[0], list_tw[1], 0.3,
        Tween.TRANS_SINE, Tween.EASE_IN_OUT)

    # frmD
    o_frm = self.main_frame.get_node("frmD")
    twI = Vector2(0, self.main_frame.rect_size.y - o_frm.rect_size.y)
    twO = twI + Vector2(0, o_frm.rect_size.y + SLIDE_PADDING)
    list_tw = [twI, twO]

    if new_value:
        list_tw = swap(twI, twO)

    tween.interpolate_property(
        o_frm,
        "rect_position",
        list_tw[0], list_tw[1], 0.3,
        Tween.TRANS_SINE, Tween.EASE_IN_OUT)

    # frmL
    o_frm = self.main_frame.get_node("frmL")
    twI = Vector2(0, 0)
    twO = twI - Vector2(o_frm.rect_size.x + SLIDE_PADDING, 0)
    list_tw = [twI, twO]

    if new_value:
        list_tw = swap(twI, twO)

    tween.interpolate_property(
        o_frm,
        "rect_position",
        list_tw[0], list_tw[1], 0.3,
        Tween.TRANS_SINE, Tween.EASE_IN_OUT)

    # frmR
    o_frm = self.main_frame.get_node("frmR")
    twI = Vector2(self.main_frame.rect_size.x - o_frm.rect_size.x, 0)
    twO = twI + Vector2(o_frm.rect_size.x + SLIDE_PADDING, 0)
    list_tw = [twI, twO]

    if new_value:
        list_tw = swap(twI, twO)

    tween.interpolate_property(
        o_frm,
        "rect_position",
        list_tw[0], list_tw[1], 0.3,
        Tween.TRANS_SINE, Tween.EASE_IN_OUT)

    tween.start()

    self.b_show = new_value


func get_show():
    return self.b_show
