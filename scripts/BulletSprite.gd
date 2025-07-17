extends Sprite2D

func _ready():
	queue_redraw()

func _draw():
	# Draw a yellow circle for bullets
	draw_circle(Vector2.ZERO, 4, Color(1, 1, 0, 1))
	# Draw a brighter center
	draw_circle(Vector2.ZERO, 2, Color(1, 1, 1, 1)) 