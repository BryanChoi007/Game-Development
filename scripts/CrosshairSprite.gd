extends Sprite2D

func _ready():
	queue_redraw()

func _draw():
	# Draw a red crosshair
	var size = 8
	var thickness = 2
	
	# Horizontal line
	draw_line(Vector2(-size, 0), Vector2(size, 0), Color(1, 0, 0, 0.8), thickness)
	# Vertical line
	draw_line(Vector2(0, -size), Vector2(0, size), Color(1, 0, 0, 0.8), thickness)
	
	# Draw small circles at the ends for better visibility
	draw_circle(Vector2(-size, 0), 2, Color(1, 0, 0, 0.8))
	draw_circle(Vector2(size, 0), 2, Color(1, 0, 0, 0.8))
	draw_circle(Vector2(0, -size), 2, Color(1, 0, 0, 0.8))
	draw_circle(Vector2(0, size), 2, Color(1, 0, 0, 0.8)) 
