extends Sprite2D

func _ready():
	queue_redraw()

func _draw():
	# Draw a red circle for enemies
	draw_circle(Vector2.ZERO, 12, Color(0.8, 0.2, 0.2, 1))
	# Draw a darker outline
	draw_arc(Vector2.ZERO, 12, 0, TAU, 24, Color(0.4, 0.1, 0.1, 1), 2) 
