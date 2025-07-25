extends Node2D

signal enemy_spawned(enemy)

@export var enemy_scene: PackedScene
@export var base_spawn_interval = 3.0
@export var base_spawn_radius = 150.0

var max_enemies = 5  # Will be calculated based on chapter
var spawn_interval = 3.0  # Will be calculated based on chapter
var spawn_radius = 150.0  # Will be calculated based on chapter

@onready var player = get_tree().get_first_node_in_group("player")

var enemies = []
var can_spawn = true

func _ready():
	add_to_group("enemy_spawner")
	
	if not player:
		player = get_tree().get_nodes_in_group("player")[0] if get_tree().get_nodes_in_group("player").size() > 0 else null
	
	# Calculate spawn parameters based on current chapter
	if GameManager:
		var current_chapter = GameManager.current_chapter
		max_enemies = current_chapter * 5
		
		# Spawn interval decreases with each chapter (faster spawning)
		spawn_interval = max(0.2, base_spawn_interval - (current_chapter - 1) * 0.3 - 0.3)
		
		# Spawn radius gets progressively smaller as levels increase
		spawn_radius = max(200.0, 600.0 - (current_chapter - 1) * 50)  # Decreases by 50 pixels per chapter
	else:
		max_enemies = 5  # Default fallback
		spawn_interval = base_spawn_interval
		spawn_radius = 600.0  # Default spawn radius
	
	# Clear any existing enemies from tracking (in case of scene reload)
	enemies.clear()
	
	# Wait a frame to let Main scene reset the scene changing flag
	call_deferred("_start_spawning")

func _start_spawning():
	# Start spawning enemies
	spawn_enemy()

func spawn_enemy():
	if not can_spawn or not player or enemies.size() >= max_enemies:
		return
	
	can_spawn = false
	
	# Calculate spawn position around player
	var spawn_angle = randf() * TAU
	var spawn_distance = spawn_radius + randf_range(0, 100)
	var spawn_position = player.global_position + Vector2(cos(spawn_angle), sin(spawn_angle)) * spawn_distance
	
	# Create enemy
	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_position
	get_parent().add_child(enemy)
	
	# Check if enemy is within camera view
	if player and player.get_node("Camera2D"):
		var camera = player.get_node("Camera2D")
		var camera_pos = camera.global_position
		var viewport_size = get_viewport().get_visible_rect().size
		var camera_zoom = camera.zoom
		var visible_area = Rect2(camera_pos - viewport_size * camera_zoom / 2, viewport_size * camera_zoom)
	
	# Track enemy
	enemies.append(enemy)
	
	# Connect to enemy death signal
	enemy.tree_exited.connect(_on_enemy_died.bind(enemy))
	
	# Emit signal for level manager
	enemy_spawned.emit(enemy)
	
	# Wait before next spawn
	var tree = get_tree()
	if tree:
		await tree.create_timer(spawn_interval).timeout
		can_spawn = true
		# Continue spawning enemies
		spawn_enemy()
	else:
		# If tree is null, stop spawning
		can_spawn = false

func _on_enemy_died(enemy):
	enemies.erase(enemy)
	
	# Notify GameManager directly since LevelManager might not be in tree
	if GameManager:
		GameManager.enemy_killed() 
