extends Sprite2D

func _ready():
	queue_redraw()

func _draw():
	# Master Chief color scheme
	var armor_green = Color(0.2, 0.6, 0.3, 1)  # Dark green armor
	var visor_gold = Color(0.8, 0.7, 0.2, 1)   # Gold visor
	var visor_dark = Color(0.4, 0.3, 0.1, 1)   # Dark visor
	var armor_dark = Color(0.1, 0.3, 0.15, 1)  # Darker green for details
	
	# Main helmet/head (oval shape using multiple arcs)
	draw_arc(Vector2.ZERO, 16, 0, TAU, 32, armor_green, 32)
	
	# Helmet outline
	draw_arc(Vector2.ZERO, 16, 0, TAU, 32, armor_dark, 2)
	
	# Visor (gold rectangle)
	draw_rect(Rect2(-8, -4, 16, 8), visor_gold)
	
	# Visor details (dark lines)
	draw_line(Vector2(-8, -4), Vector2(8, -4), visor_dark, 1)
	draw_line(Vector2(-8, 4), Vector2(8, 4), visor_dark, 1)
	draw_line(Vector2(-8, -4), Vector2(-8, 4), visor_dark, 1)
	draw_line(Vector2(8, -4), Vector2(8, 4), visor_dark, 1)
	
	# Visor center line
	draw_line(Vector2(0, -4), Vector2(0, 4), visor_dark, 1)
	
	# Shoulder armor plates
	draw_rect(Rect2(-18, -8, 6, 12), armor_green)
	draw_rect(Rect2(12, -8, 6, 12), armor_green)
	
	# Chest armor
	draw_rect(Rect2(-10, 8, 20, 12), armor_green)
	
	# Armor details (lines)
	draw_line(Vector2(-10, 8), Vector2(10, 8), armor_dark, 1)
	draw_line(Vector2(-10, 14), Vector2(10, 14), armor_dark, 1)
	draw_line(Vector2(-10, 20), Vector2(10, 20), armor_dark, 1)
	
	# UNSC emblem on chest (simplified)
	draw_circle(Vector2(0, 14), 3, Color.WHITE)
	draw_circle(Vector2(0, 14), 2, Color.BLUE) 
