extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var PAPER_SRC_RECT: Rect2 = Rect2(0, 0, 0, 0)
var PAPER_DST_RECT: Rect2
var DPI: float = 150
var MARGIN: Vector2 = Vector2.ZERO
var COMMENT: String = ""
var FONT: DynamicFont = null


func mm_to_px(v: float) -> int:
    var result = float(v * self.DPI) / 25.4

    return int(floor(result + 1)) & ~1


func _ready():

    FONT = DynamicFont.new()
    FONT.font_data = load("res://font/07LogoTypeGothic7.ttf")
    FONT.size = 12


func _process(_delta):
    self.update()


func _draw():

    # Fill
    self.draw_rect(self.PAPER_SRC_RECT, Color.white, true)

    if self.PAPER_DST_RECT.has_no_area() != true:

        var tombow_line_width = self.mm_to_px(15)

        # Center
        self.draw_line(
            Vector2(0, self.PAPER_SRC_RECT.size.y / 2).floor(),
            Vector2(self.PAPER_SRC_RECT.size.x, self.PAPER_SRC_RECT.size.y / 2),
            Color.blue, 1.0
            )

        self.draw_line(
            Vector2(self.PAPER_SRC_RECT.size.x / 2, 0).floor(),
            Vector2(self.PAPER_SRC_RECT.size.x / 2, self.PAPER_SRC_RECT.size.y),
            Color.blue, 1.0
            )

        # Tombow U
        self.draw_line(
            Vector2(
                (self.PAPER_SRC_RECT.size.x / 2) - tombow_line_width,
                self.PAPER_DST_RECT.position.y - self.MARGIN.y * 2),
            Vector2(
                (self.PAPER_SRC_RECT.size.x / 2) + tombow_line_width,
                self.PAPER_DST_RECT.position.y - self.MARGIN.y * 2),
            Color.blue, 1.0
            )

        self.draw_line(
            Vector2(0, self.PAPER_DST_RECT.position.y),
            Vector2(self.PAPER_SRC_RECT.size.x, self.PAPER_DST_RECT.position.y),
            Color.blue, 1.0
            )

        # Tombow D
        self.draw_line(
            Vector2(
                (self.PAPER_SRC_RECT.size.x / 2) - tombow_line_width,
                self.PAPER_DST_RECT.end.y + self.MARGIN.y * 2
                ),
            Vector2(
                (self.PAPER_SRC_RECT.size.x / 2) + tombow_line_width,
                self.PAPER_DST_RECT.end.y + self.MARGIN.y * 2
                ),
            Color.blue, 1.0
            )

        self.draw_line(
            Vector2(0, self.PAPER_DST_RECT.position.y + self.PAPER_DST_RECT.size.y),
            Vector2(self.PAPER_SRC_RECT.size.x, self.PAPER_DST_RECT.end.y),
            Color.blue, 1.0
            )

        # Tombow L
        self.draw_line(
            Vector2(
                self.PAPER_DST_RECT.position.x - self.MARGIN.y * 2,
                (self.PAPER_SRC_RECT.size.y / 2) - tombow_line_width
                ),
            Vector2(
                self.PAPER_DST_RECT.position.x - self.MARGIN.y * 2,
                (self.PAPER_SRC_RECT.size.y / 2) + tombow_line_width
                ),
            Color.blue, 1.0
            )

        self.draw_line(
            Vector2(self.PAPER_DST_RECT.position.x, 0),
            Vector2(self.PAPER_DST_RECT.position.x, self.PAPER_SRC_RECT.size.y),
            Color.blue, 1.0
            )

        # Tombow R
        self.draw_line(
            Vector2(
                self.PAPER_DST_RECT.end.x + self.MARGIN.y * 2,
                (self.PAPER_SRC_RECT.size.y / 2) - tombow_line_width
                ),
            Vector2(
                self.PAPER_DST_RECT.end.x + self.MARGIN.y * 2,
                (self.PAPER_SRC_RECT.size.y / 2) + tombow_line_width
                ),
            Color.blue, 1.0
            )

        self.draw_line(
            Vector2(self.PAPER_DST_RECT.position.x + self.PAPER_DST_RECT.size.x, 0),
            Vector2(self.PAPER_DST_RECT.end.x, self.PAPER_SRC_RECT.size.y),
            Color.blue, 1.0
            )

        # Border
        self.draw_rect(
            Rect2(
                self.PAPER_DST_RECT.position - self.MARGIN,
                self.PAPER_DST_RECT.size + (self.MARGIN * 2)
                ),
            Color.white, true
            )

        self.draw_rect(
            Rect2(
                self.PAPER_DST_RECT.position - self.MARGIN.floor(),
                self.PAPER_DST_RECT.size + (self.MARGIN * 2).floor()
                ),
            Color.blue, false, 4.0
            )

        # Size
        self.draw_rect(self.PAPER_DST_RECT, Color.blue, false, 1.0)

        # inner frame
        var vct_size = Vector2(self.mm_to_px(150), self.mm_to_px(220))
        var vct_pos = (self.PAPER_SRC_RECT.size - vct_size) / 2
        self.draw_rect(Rect2(vct_pos, vct_size), Color.blue, false, 1.0)

        self.FONT.size = int((12 * self.DPI) / 150)

        self.draw_string(
            self.FONT,
            Vector2(self.PAPER_DST_RECT.position.x, self.PAPER_DST_RECT.end.y) + self.MARGIN * 2,
            self.COMMENT,
            Color.blue
        )


