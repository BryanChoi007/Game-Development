extends Node2D

@export var tile_size = 32
@export var map_width = 50
@export var map_height = 50

func _ready():
	generate_terrain()

func generate_terrain():
	# Create a simple terrain pattern
	for x in range(map_width):
		for y in range(map_height):
			var tile = ColorRect.new()
			tile.size = Vector2(tile_size, tile_size)
			tile.position = Vector2(x * tile_size, y * tile_size)
			
			# Create a pattern: mostly grass with some dirt patches
			var is_grass = true
			
			# Create dirt patches in certain areas
			if (x + y) % 7 == 0 or (x * y) % 13 == 0:
				is_grass = false
			
			# Create larger dirt areas
			if x > map_width * 0.7 and y > map_height * 0.6:
				is_grass = false
			
			if x < map_width * 0.3 and y < map_height * 0.4:
				is_grass = false
			
			# Set colors
			if is_grass:
				# Grass colors (green variations)
				var grass_variations = [
					Color(0.2, 0.6, 0.2, 1),  # Dark green
					Color(0.3, 0.7, 0.3, 1),  # Medium green
					Color(0.4, 0.8, 0.4, 1),  # Light green
					Color(0.25, 0.65, 0.25, 1)  # Medium-dark green
				]
				tile.color = grass_variations[(x + y) % 4]
			else:
				# Dirt colors (brown variations)
				var dirt_variations = [
					Color(0.6, 0.4, 0.2, 1),  # Light brown
					Color(0.5, 0.3, 0.1, 1),  # Medium brown
					Color(0.7, 0.5, 0.3, 1),  # Tan
					Color(0.4, 0.25, 0.1, 1)  # Dark brown
				]
				tile.color = dirt_variations[(x + y) % 4]
			
			add_child(tile) 