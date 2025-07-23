extends Area2D

class_name Bullet

@export var speed = 400
@export var damage = 25
@export var lifetime = 3.0

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var impact_sound = $ImpactSound

var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var can_hit_player = false

func _ready():
	velocity = direction * speed
	
	# Rotate bullet sprite to face direction
	var angle = direction.angle()
	sprite.rotation = angle
	
	# Generate impact sound if not already set
	if impact_sound and not impact_sound.stream:
		var audio_generator = preload("res://scripts/AudioGenerator.gd").new()
		impact_sound.stream = audio_generator.generate_impact_sound()
	
	# Set up lifetime
	var timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(queue_free)
	
	# Allow hitting player after a short delay (to avoid spawning collision)
	await get_tree().create_timer(0.1).timeout
	can_hit_player = true

func _physics_process(delta):
	position += velocity * delta
	# Debug: Print bullet position occasionally
	if Engine.get_process_frames() % 60 == 0:  # Every 60 frames
		print("Bullet position: ", global_position, " Velocity: ", velocity)

func _on_body_entered(body):
	print("Bullet hit body: ", body.name, " Groups: ", body.get_groups())
	
	# Make bullet invisible immediately
	sprite.visible = false
	
	# Don't damage the player (who fired the bullet) unless enough time has passed
	if body.is_in_group("player") and not can_hit_player:
		print("Ignoring player hit (too soon)")
		return
		
	# Check if the body can take damage
	if body.has_method("take_damage") or body.is_in_group("damageable"):
		print("Dealing damage to: ", body.name)
		if body.has_method("take_damage"):
			body.take_damage(damage)
	else:
		print("Body cannot take damage: ", body.name)
	
	# Play impact sound
	if impact_sound:
		impact_sound.volume_db = 20.0
		impact_sound.play()
		
		# Also try creating a new audio player as backup
		var backup_sound = AudioStreamPlayer.new()
		backup_sound.stream = impact_sound.stream
		backup_sound.volume_db = 20.0
		get_parent().add_child(backup_sound)
		backup_sound.play()
		
		# Clean up backup sound after playing
		await backup_sound.finished
		backup_sound.queue_free()
	
	# Create impact effect
	# create_impact_effect()  # Commented out for testing
	
	# Make bullet disappear immediately
	queue_free()

func _on_area_entered(area):
	print("Bullet hit area: ", area.name, " Groups: ", area.get_groups())
	
	# Make bullet invisible immediately
	sprite.visible = false
	
	# Don't damage the player (who fired the bullet) unless enough time has passed
	if area.is_in_group("player") and not can_hit_player:
		print("Ignoring player area hit (too soon)")
		return
		
	# Check if the area can take damage
	if area.has_method("take_damage") or area.is_in_group("damageable"):
		print("Dealing damage to area: ", area.name)
		if area.has_method("take_damage"):
			area.take_damage(damage)
	else:
		print("Area cannot take damage: ", area.name)
	
	# Play impact sound
	if impact_sound:
		impact_sound.volume_db = 20.0
		impact_sound.play()
		
		# Also try creating a new audio player as backup
		var backup_sound = AudioStreamPlayer.new()
		backup_sound.stream = impact_sound.stream
		backup_sound.volume_db = 20.0
		get_parent().add_child(backup_sound)
		backup_sound.play()
		
		# Clean up backup sound after playing
		await backup_sound.finished
		backup_sound.queue_free()
	
	# Create impact effect
	# create_impact_effect()  # Commented out for testing
	
	# Make bullet disappear immediately
	queue_free()

func create_impact_effect():
	# Create a simple impact effect
	var impact = Sprite2D.new()
	# impact.texture = preload("res://assets/impact_placeholder.png")  # Commented out to avoid loading error
	impact.global_position = global_position
	impact.modulate = Color.WHITE
	
	# Add to scene
	get_parent().add_child(impact)
	
	# Fade out effect
	var tween = create_tween()
	tween.tween_property(impact, "modulate", Color.TRANSPARENT, 0.3)
	tween.tween_callback(impact.queue_free) 

func _exit_tree():
	pass 
