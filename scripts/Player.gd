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
var bullet_scene = preload("res://scenes/Bullet.tscn")

signal health_changed(new_health: int, max_health: int)

func _ready():
	current_health = max_health
	emit_signal("health_changed", current_health, max_health)
	
	# Generate gunshot sound if not already set
	if gunshot_sound and not gunshot_sound.stream:
		var audio_generator = preload("res://scripts/AudioGenerator.gd").new()
		gunshot_sound.stream = audio_generator.generate_gunshot_sound()

func _physics_process(delta):
	handle_movement()
	handle_shooting()
	update_animation()
	update_rotation()

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
	
	# Play damage animation
	animation_player.play("damage")
	
	if current_health <= 0:
		die()

func heal(amount: int):
	current_health = min(max_health, current_health + amount)
	emit_signal("health_changed", current_health, max_health)

func die():
	# Play death animation
	animation_player.play("death")
	await animation_player.animation_finished
	
	# Reset position and health (for now, just respawn)
	global_position = Vector2(640, 360)
	current_health = max_health
	emit_signal("health_changed", current_health, max_health) 
