extends Node2D

@export var enemy_scene: PackedScene
@export var max_enemies = 5
@export var spawn_interval = 3.0
@export var spawn_radius = 300.0

@onready var player = get_tree().get_first_node_in_group("player")

var enemies = []
var can_spawn = true

func _ready():
	if not player:
		player = get_tree().get_nodes_in_group("player")[0] if get_tree().get_nodes_in_group("player").size() > 0 else null
	
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
	
	print("Spawning enemy at position: ", spawn_position)  # Debug output
	
	# Create enemy
	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_position
	get_parent().add_child(enemy)
	
	# Track enemy
	enemies.append(enemy)
	enemy.tree_exited.connect(_on_enemy_died.bind(enemy))
	
	# Wait before next spawn
	await get_tree().create_timer(spawn_interval).timeout
	can_spawn = true
	
	# Spawn next enemy
	spawn_enemy()

func _on_enemy_died(enemy):
	enemies.erase(enemy) 