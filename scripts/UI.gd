extends CanvasLayer

@onready var health_label = $HealthLabel
@onready var health_bar = $HealthBar
@onready var ammo_label = $AmmoLabel
@onready var crosshair = $Crosshair

func _ready():
	# Set up crosshair to follow mouse
	crosshair.visible = true

func _process(delta):
	# Update crosshair position to follow mouse
	crosshair.global_position = get_viewport().get_mouse_position()

func update_health(current_health: int, max_health: int):
	health_label.text = "Health: %d/%d" % [current_health, max_health]
	health_bar.max_value = max_health
	health_bar.value = current_health
	
	# Change color based on health percentage
	var health_percent = float(current_health) / float(max_health)
	if health_percent > 0.6:
		health_bar.modulate = Color.GREEN
	elif health_percent > 0.3:
		health_bar.modulate = Color.YELLOW
	else:
		health_bar.modulate = Color.RED

func update_ammo(current_ammo: int, max_ammo: int):
	ammo_label.text = "Ammo: %d/%d" % [current_ammo, max_ammo]

func show_message(message: String, duration: float = 3.0):
	var message_label = Label.new()
	message_label.text = message
	message_label.add_theme_font_size_override("font_size", 24)
	message_label.position = Vector2(640, 100)
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	add_child(message_label)
	
	# Fade out effect
	var tween = create_tween()
	tween.tween_property(message_label, "modulate", Color.TRANSPARENT, duration)
	tween.tween_callback(message_label.queue_free) 
