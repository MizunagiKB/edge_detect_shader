extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var PAPER_RECT = Rect2(0, 0, 0, 0)
var DPI = 150
var MARGIN = 3
var FONT

func mm_to_px(v: float) -> int:
    var result = float(v * self.DPI) / 25.4

    return int(floor(result + 1)) & ~1


func _ready():

    FONT = DynamicFont.new()
    FONT.font_data = load("res://font/07LogoTypeGothic7.ttf")
    FONT.size = 12


func _process(delta):
    self.update()


func _draw():

    self.draw_rect(self.PAPER_RECT, Color.white, true)

    var rect_size
    var rect_pos


    rect_size = Vector2(mm_to_px(1024), mm_to_px(257))
    rect_pos = ((self.PAPER_RECT.size - rect_size) / 2).floor()

    self.draw_rect(Rect2(rect_pos, rect_size), Color.blue, false)


    rect_size = Vector2(mm_to_px(182), mm_to_px(1024))
    rect_pos = ((self.PAPER_RECT.size - rect_size) / 2).floor()

    self.draw_rect(Rect2(rect_pos, rect_size), Color.blue, false)


    rect_size = Vector2(mm_to_px(182), mm_to_px(1024))
    rect_pos = (self.PAPER_RECT.size / 2).floor()

    self.draw_line(Vector2(rect_pos.x, 0), Vector2(rect_pos.x, self.PAPER_RECT.size.y), Color.blue, false)
    self.draw_line(Vector2(0, rect_pos.y), Vector2(self.PAPER_RECT.size.x, rect_pos.y), Color.blue, false)


    rect_size = Vector2(mm_to_px(182 + self.MARGIN * 4), mm_to_px(257 + self.MARGIN * 4))
    rect_pos = ((self.PAPER_RECT.size - rect_size) / 2).floor()

    self.draw_rect(Rect2(rect_pos, rect_size), Color.blue, false, 1)


    # border
    rect_size = Vector2(mm_to_px(182 + self.MARGIN * 2), mm_to_px(257 + self.MARGIN * 2))
    rect_pos = ((self.PAPER_RECT.size - rect_size) / 2).floor()

    self.draw_rect(Rect2(rect_pos, rect_size), Color.white, true)
    self.draw_rect(Rect2(rect_pos, rect_size), Color.blue, false, 3)



    rect_size = Vector2(mm_to_px(182), mm_to_px(257))
    rect_pos = ((self.PAPER_RECT.size - rect_size) / 2).floor()
        
    self.draw_rect(Rect2(rect_pos, rect_size), Color.blue, false)
    

    rect_size = Vector2(mm_to_px(150), mm_to_px(220))
    rect_pos = ((self.PAPER_RECT.size - rect_size) / 2).floor()
        
    self.draw_rect(Rect2(rect_pos, rect_size), Color.blue, false)



    var text_x = floor(self.PAPER_RECT.size.x - mm_to_px(182)) / 2
    var text_y = floor(self.PAPER_RECT.size.y - mm_to_px(257)) / 2

    self.draw_string(
        self.FONT,
        Vector2(mm_to_px(1) + text_x, mm_to_px(257 + 6) + text_y),
        "水凪工房",
        Color.blue
    )

