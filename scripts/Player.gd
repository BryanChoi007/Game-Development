extends CharacterBody2D

class_name Player

@export var speed = 200.0
@export var max_health = 100
@export var bullet_speed = 400
@export var fire_rate = 0.2

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var bullet_spawn = $BulletSpawn
@onready var camera = $Camera2D
@onready var gunshot_sound = $GunshotSound

var current_health: int
var can_shoot = true
var is_dead = false
var bullet_scene = preload("res://scenes/Bullet.tscn")

signal health_changed(new_health: int, max_health: int)

func _ready():
	reset_health()
	
	# Save health to GameManager for persistence
	if GameManager:
		GameManager.save_player_health(current_health)
	
	# Test tree access immediately
	print("Player _ready() - testing tree access...")
	var tree = get_tree()
	if tree:
		print("Tree access successful in _ready()")
	else:
		print("Tree is null in _ready()")
	
	# Generate gunshot sound if not already set
	if gunshot_sound and not gunshot_sound.stream:
		var audio_generator = preload("res://scripts/AudioGenerator.gd").new()
		gunshot_sound.stream = audio_generator.generate_gunshot_sound()

func _physics_process(delta):
	handle_movement()
	handle_shooting()
	update_animation()
	update_rotation()
	
	# Test tree access occasionally
	if Engine.get_process_frames() % 300 == 0:  # Every 300 frames (5 seconds at 60fps)
		var tree = get_tree()
		if not tree:
			print("WARNING: Tree became null during gameplay!")

func handle_movement():
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	
	direction = direction.normalized()
	velocity = direction * speed
	
	move_and_slide()

func handle_shooting():
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

func shoot():
	if not can_shoot:
		return
	
	can_shoot = false
	
	# Get mouse position in world coordinates
	var mouse_pos = get_viewport().get_mouse_position()
	var camera_pos = camera.global_position
	var screen_center = get_viewport().get_visible_rect().size / 2
	var world_mouse_pos = camera_pos + (mouse_pos - screen_center) / camera.zoom
	
	# Calculate direction from player to mouse
	var direction_to_mouse = world_mouse_pos - global_position
	direction_to_mouse = direction_to_mouse.normalized()
	
	# Position bullet spawn point in the direction of the mouse
	var spawn_distance = 30  # Distance from player center
	var spawn_position = global_position + (direction_to_mouse * spawn_distance)
	
	var bullet = bullet_scene.instantiate()
	bullet.global_position = spawn_position
	bullet.direction = direction_to_mouse
	bullet.speed = bullet_speed
	get_parent().add_child(bullet)
	
	# Play shooting animation
	animation_player.play("shoot")
	
	# Play gunshot sound
	if gunshot_sound:
		gunshot_sound.play()
	
	# Reset fire rate
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true

func update_rotation():
	# Get mouse position in world coordinates
	var mouse_pos = get_viewport().get_mouse_position()
	var camera_pos = camera.global_position
	var screen_center = get_viewport().get_visible_rect().size / 2
	var world_mouse_pos = camera_pos + (mouse_pos - screen_center) / camera.zoom
	
	# Calculate direction to mouse
	var direction_to_mouse = world_mouse_pos - global_position
	
	# Flip the sprite based on mouse position (don't rotate)
	if direction_to_mouse.length() > 0:
		if direction_to_mouse.x < 0:  # Mouse is on the left
			sprite.flip_h = true
		else:  # Mouse is on the right
			sprite.flip_h = false

func update_animation():
	var direction = velocity.normalized()
	
	if direction.length() > 0.1:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				animation_player.play("walk_right")
			else:
				animation_player.play("walk_left")
		else:
			if direction.y > 0:
				animation_player.play("walk_down")
			else:
				animation_player.play("walk_up")
	else:
		animation_player.play("idle")

func take_damage(amount: int):
	current_health = max(0, current_health - amount)
	emit_signal("health_changed", current_health, max_health)
	
	# Save health to GameManager for persistence
	if GameManager:
		GameManager.save_player_health(current_health)
	
	# Play damage animation
	animation_player.play("damage")
	
	if current_health <= 0:
		die()

func heal(amount: int):
	current_health = min(max_health, current_health + amount)
	emit_signal("health_changed", current_health, max_health)

func die():
	if is_dead:
		return  # Prevent multiple death calls
	
	is_dead = true
	print("Player died! Starting death animation...")
	
	# Stop all game progression immediately
	if GameManager:
		GameManager.set_game_over(true)
	
	# Disable player input and movement
	set_physics_process(false)
	set_process_input(false)
	
	# Start death animation sequence
	_player_death_animation()

func _player_death_animation():
	# Create blood splatter effect around the player
	_create_player_blood_splatter()
	
	# Rotate player 90 degrees to look like they fell down
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 90.0, 0.5)
	
	# Wait for the rotation animation to complete
	await tween.finished
	
	print("Player: Death animation complete, showing You Died text...")
	
	# Show "You Died" text
	var ui = get_tree().get_first_node_in_group("ui")
	if ui and ui.has_method("show_you_died"):
		print("Player: Calling UI show_you_died()")
		ui.show_you_died()
	else:
		print("Player: ERROR - UI not found or show_you_died method not available")
	
	# Wait a moment for the text to appear before pausing
	print("Player: Waiting 0.5 seconds for You Died text to appear...")
	await get_tree().create_timer(0.5).timeout
	
	print("Player: Pausing game for 5 seconds...")
	
	# Pause the game for 5 seconds
	get_tree().paused = true
	await get_tree().create_timer(5.0).timeout
	get_tree().paused = false
	
	print("Player: 5-second pause complete, transitioning to game over screen...")
	
	# Change to game over screen
	var tree = get_tree()
	if tree:
		tree.change_scene_to_file("res://scenes/GameOver.tscn")

func _create_player_blood_splatter():
	# Create blood splatter effect around the player
	for i in range(8):  # Create 8 blood splatters
		var blood_splatter = ColorRect.new()
		blood_splatter.color = Color(0.7, 0.1, 0.1, 0.8)
		blood_splatter.size = Vector2(randf_range(10, 25), randf_range(8, 20))
		
		# Position blood splatter around the player
		var angle = randf() * TAU
		var distance = randf_range(30, 80)
		var offset = Vector2(cos(angle), sin(angle)) * distance
		blood_splatter.position = global_position + offset
		
		# Add to the scene
		get_parent().add_child(blood_splatter)
		
		# Remove blood splatter after 5 seconds
		await get_tree().create_timer(5.0).timeout
		blood_splatter.queue_free()

func is_player_dead() -> bool:
	return is_dead

func reset_health():
	# Check if this is the first level or if we should maintain health
	if not GameManager or GameManager.current_chapter == 1:
		# First level - start with full health
		current_health = max_health
		print("Player: Starting with full health (Chapter 1)")
	else:
		# Subsequent levels - get health from GameManager
		var saved_health = GameManager.get_player_health()
		if saved_health > 0:
			current_health = saved_health
			print("Player: Restored health from previous level: ", current_health)
		else:
			current_health = max_health
			print("Player: No saved health found, using full health")
	
	emit_signal("health_changed", current_health, max_health) 
