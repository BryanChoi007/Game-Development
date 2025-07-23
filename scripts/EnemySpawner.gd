extends Node2D

signal enemy_spawned(enemy)

@export var enemy_scene: PackedScene
@export var spawn_interval = 3.0
@export var spawn_radius = 150.0

var max_enemies = 5  # Will be calculated based on chapter

@onready var player = get_tree().get_first_node_in_group("player")

var enemies = []
var can_spawn = true

func _ready():
	add_to_group("enemy_spawner")
	
	if not player:
		player = get_tree().get_nodes_in_group("player")[0] if get_tree().get_nodes_in_group("player").size() > 0 else null
	
	# Calculate max enemies based on current chapter
	if GameManager:
		max_enemies = GameManager.current_chapter * 5
		print("EnemySpawner: Chapter ", GameManager.current_chapter, " - Max enemies: ", max_enemies)
	else:
		max_enemies = 5  # Default fallback
		print("EnemySpawner: GameManager not found, using default max enemies: ", max_enemies)
	
	print("EnemySpawner _ready() - starting spawn process")
	print("EnemySpawner: Initial enemies array size: ", enemies.size())
	
	# Clear any existing enemies from tracking (in case of scene reload)
	enemies.clear()
	print("EnemySpawner: Cleared enemies array, new size: ", enemies.size())
	
	# Wait a frame to let Main scene reset the scene changing flag
	call_deferred("_start_spawning")

func _start_spawning():
	print("EnemySpawner: Starting spawn process")
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
	
	print("EnemySpawner: Player position: ", player.global_position)
	print("EnemySpawner: Spawn angle: ", spawn_angle, ", distance: ", spawn_distance)
	print("EnemySpawner: Spawning enemy at position: ", spawn_position)
	
	# Create enemy
	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_position
	get_parent().add_child(enemy)
	
	print("EnemySpawner: Enemy added to scene tree: ", enemy.is_inside_tree())
	print("EnemySpawner: Enemy parent: ", enemy.get_parent().name if enemy.get_parent() else "No parent")
	
	print("EnemySpawner: Enemy created and added to scene at position: ", spawn_position)
	print("EnemySpawner: Current enemies count: ", enemies.size())
	
	# Check if enemy is within camera view
	if player and player.get_node("Camera2D"):
		var camera = player.get_node("Camera2D")
		var camera_pos = camera.global_position
		var viewport_size = get_viewport().get_visible_rect().size
		var camera_zoom = camera.zoom
		var visible_area = Rect2(camera_pos - viewport_size * camera_zoom / 2, viewport_size * camera_zoom)
		
		print("EnemySpawner: Camera position: ", camera_pos, ", zoom: ", camera_zoom)
		print("EnemySpawner: Visible area: ", visible_area)
		print("EnemySpawner: Enemy in view: ", visible_area.has_point(spawn_position))
	
	# Track enemy
	enemies.append(enemy)
	print("EnemySpawner: Enemy added to tracking array. Total enemies: ", enemies.size())
	
	# Connect to enemy death signal
	if enemy.tree_exited.connect(_on_enemy_died.bind(enemy)) != OK:
		print("EnemySpawner: WARNING - Failed to connect to enemy death signal!")
	else:
		print("EnemySpawner: Successfully connected to enemy death signal")
	
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
	print("EnemySpawner: Enemy died, removing from tracking. Current enemies: ", enemies.size())
	enemies.erase(enemy)
	print("EnemySpawner: Enemy removed from tracking. Remaining enemies: ", enemies.size())
	
	# Notify GameManager directly since LevelManager might not be in tree
	if GameManager:
		print("EnemySpawner: Notifying GameManager of enemy death")
		GameManager.enemy_killed()
	else:
		print("EnemySpawner: WARNING - GameManager not available for enemy death notification") 
