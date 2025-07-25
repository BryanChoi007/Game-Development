extends CharacterBody2D

class_name Enemy

@export var base_speed = 100.0
@export var max_health = 50
@export var damage = 10
@export var detection_range = 150.0
@export var attack_range = 40.0

var speed = 100.0  # Will be calculated based on chapter

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var health_bar = $HealthBar

var current_health: int
var player: Player
var can_attack = true
var attack_cooldown = 1.0

func _ready():
	current_health = max_health
	
	# Calculate enemy speed based on current chapter
	if GameManager:
		var current_chapter = GameManager.current_chapter
		speed = base_speed + (current_chapter - 1) * 20  # Increase speed by 20 per chapter
	else:
		speed = base_speed
	
	# Set up elite enemy appearance
	if sprite and sprite.texture:
		# Scale the elite to match the game size
		sprite.scale = Vector2(0.1, 0.1)  # Same scale as Master Chief
	else:
		# Fallback to a colored enemy if texture fails
		sprite.modulate = Color(0.2, 0.8, 0.2, 1)  # Green for elite
	
	# Find the player
	player = get_tree().get_first_node_in_group("player")
	if not player:
		player = get_tree().get_nodes_in_group("player")[0] if get_tree().get_nodes_in_group("player").size() > 0 else null

func _physics_process(delta):
	if not player:
		return
	
	var distance_to_player = global_position.distance_to(player.global_position)
	
	# Calculate desired distance from player
	var desired_distance = attack_range - 5  # Keep slightly closer than attack range
	
	# All enemies now move toward player immediately regardless of distance
	if distance_to_player <= attack_range:
		# In attack range - stop moving and attack
		velocity = Vector2.ZERO
		if can_attack:
			attack_player()
	else:
		# Move towards player immediately (no detection range check)
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
	
	# Handle movement with collision detection
	var collision = move_and_collide(velocity * delta)
	
	# If we hit something, stop moving and push back slightly
	if collision:
		velocity = Vector2.ZERO
		# Push back to prevent getting stuck
		if distance_to_player < attack_range:
			var push_direction = (global_position - player.global_position).normalized()
			global_position += push_direction * 3
	
	update_animation()

func attack_player():
	if not can_attack:
		return
	
	# Check if player is already dead
	if player.has_method("is_player_dead") and player.is_player_dead():
		return
	
	can_attack = false
	
	# Deal damage to player
	if player.has_method("take_damage"):
		player.take_damage(damage)
	
	# Play attack animation
	animation_player.play("attack")
	
	# Reset attack cooldown
	var tree = get_tree()
	if tree:
		await tree.create_timer(attack_cooldown).timeout
		can_attack = true
	else:
		# If tree is null, just reset immediately
		can_attack = true

func update_animation():
	var direction = velocity.normalized()
	
	if direction.length() > 0.1:
		animation_player.play("walk")
	else:
		animation_player.play("idle")
	
	# Make enemy face the player
	if player:
		var player_direction = (player.global_position - global_position).normalized()
		# Flip sprite based on player position
		if player_direction.x > 0:
			# Player is to the right, face right
			sprite.flip_h = false
		elif player_direction.x < 0:
			# Player is to the left, face left
			sprite.flip_h = true

func take_damage(amount: int):
	current_health = max(0, current_health - amount)
	
	# Play damage animation
	animation_player.play("damage")
	
	if current_health <= 0:
		die()

func die():
	# Check if this is the final enemy (last enemy killed in chapter)
	var progress = GameManager.get_progress()
	var is_final_enemy = (progress.enemies_killed + 1 >= progress.enemies_required)
	
	if is_final_enemy:
		# Final enemy death animation - don't notify GameManager yet
		_final_enemy_death_animation()
	else:
		# Regular enemy death animation - notify GameManager after animation
		_regular_enemy_death_animation()

func _final_enemy_death_animation():
	# Disable movement and attacks
	set_physics_process(false)
	can_attack = false
	
	# Disable collision detection so bullets pass through dead enemy
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	
	# Set z-index so enemy appears behind player but on top of terrain
	z_index = 0.5
	
	# Create blood splatter effect
	_create_blood_splatter()
	
	# Rotate enemy 90 degrees to look like it fell down
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 90.0, 0.5)
	
	# Wait for the rotation animation to complete
	await tween.finished
	
	# Notify GameManager that enemy was killed after animation
	GameManager.enemy_killed()
	
	# Keep the enemy sprite visible (don't remove from scene)

func _regular_enemy_death_animation():
	# Disable movement and attacks
	set_physics_process(false)
	can_attack = false
	
	# Disable collision detection so bullets pass through dead enemy
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	
	# Set z-index so enemy appears behind player but on top of terrain
	z_index = 0.5
	
	# Create blood splatter effect
	_create_blood_splatter()
	
	# Rotate enemy 90 degrees to look like it fell down
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 90.0, 0.5)
	
	# Wait for the rotation animation to complete
	await tween.finished
	
	# Notify GameManager that enemy was killed after animation
	GameManager.enemy_killed()
	
	# Keep the enemy sprite visible (don't remove from scene)

func _create_blood_splatter():
	# Create blood splatter effect around the enemy
	for i in range(8):  # Create 8 blood splatters
		var blood_splatter = ColorRect.new()
		blood_splatter.color = Color(0.7, 0.1, 0.1, 0.8)
		blood_splatter.size = Vector2(randf_range(10, 25), randf_range(8, 20))
		
		# Position blood splatter around the enemy
		var angle = randf() * TAU
		var distance = randf_range(30, 80)
		var offset = Vector2(cos(angle), sin(angle)) * distance
		blood_splatter.position = global_position + offset
		
		# Add to the scene
		get_parent().add_child(blood_splatter)
		
		# Remove blood splatter after 5 seconds
		await get_tree().create_timer(5.0).timeout
		blood_splatter.queue_free() 
