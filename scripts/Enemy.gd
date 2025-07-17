extends CharacterBody2D

class_name Enemy

@export var speed = 100.0
@export var max_health = 50
@export var damage = 10
@export var detection_range = 150.0
@export var attack_range = 30.0

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var health_bar = $HealthBar

var current_health: int
var player: Player
var can_attack = true
var attack_cooldown = 1.0

func _ready():
	current_health = max_health
	health_bar.max_value = max_health
	health_bar.value = current_health
	
	# Find the player
	player = get_tree().get_first_node_in_group("player")
	if not player:
		player = get_tree().get_nodes_in_group("player")[0] if get_tree().get_nodes_in_group("player").size() > 0 else null

func _physics_process(delta):
	if not player:
		return
	
	var distance_to_player = global_position.distance_to(player.global_position)
	
	if distance_to_player <= detection_range:
		# Move towards player
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		
		# Attack if close enough
		if distance_to_player <= attack_range and can_attack:
			attack_player()
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	update_animation()

func attack_player():
	if not can_attack:
		return
	
	can_attack = false
	
	# Deal damage to player
	if player.has_method("take_damage"):
		player.take_damage(damage)
	
	# Play attack animation
	animation_player.play("attack")
	
	# Reset attack cooldown
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func update_animation():
	var direction = velocity.normalized()
	
	if direction.length() > 0.1:
		animation_player.play("walk")
	else:
		animation_player.play("idle")

func take_damage(amount: int):
	current_health = max(0, current_health - amount)
	health_bar.value = current_health
	
	print("Enemy took ", amount, " damage. Health: ", current_health)  # Debug output
	
	# Play damage animation
	animation_player.play("damage")
	
	if current_health <= 0:
		print("Enemy dying!")  # Debug output
		die()

func die():
	print("Enemy die() function called")  # Debug output
	# Remove from scene immediately (no animation wait)
	queue_free() 
