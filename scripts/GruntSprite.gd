extends Sprite2D

func _ready():
	queue_redraw()

func _draw():
	# Draw a grunt-like enemy using primitives
	var size = 12
	
	# Main body (brown)
	draw_circle(Vector2.ZERO, size, Color(0.6, 0.4, 0.2, 1))
	
	# Armor plates (darker brown)
	draw_arc(Vector2.ZERO, size, 0, TAU, 24, Color(0.4, 0.2, 0.1, 1), 2)
	
	# Helmet/head area (lighter brown)
	draw_circle(Vector2(0, -size * 0.3), size * 0.6, Color(0.7, 0.5, 0.3, 1))
	
	# Eyes (red)
	draw_circle(Vector2(-size * 0.3, -size * 0.4), size * 0.2, Color(0.8, 0.1, 0.1, 1))
	draw_circle(Vector2(size * 0.3, -size * 0.4), size * 0.2, Color(0.8, 0.1, 0.1, 1))
	
	# Weapon/arm (darker)
	draw_rect(Rect2(size * 0.7, -size * 0.2, size * 0.4, size * 0.4), Color(0.3, 0.3, 0.3, 1)) 