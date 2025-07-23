extends CanvasLayer

@onready var health_label = $HealthLabel
@onready var health_bar = $HealthBar
@onready var ammo_label = $AmmoLabel
@onready var chapter_label = $ChapterLabel
@onready var progress_label = $ProgressLabel
@onready var crosshair = $Crosshair
@onready var stage_cleared_label = $StageClearedLabel
@onready var you_died_label = $YouDiedLabel

func _ready():
	# Add UI to group for easy access
	add_to_group("ui")
	
	# Set up crosshair to follow mouse
	crosshair.visible = true
	
	# Debug: Check if stage cleared label is initialized
	print("UI: Stage cleared label: ", stage_cleared_label)
	if stage_cleared_label:
		print("UI: Stage cleared label found and initialized")
		print("UI: Stage cleared label visible: ", stage_cleared_label.visible)
	else:
		print("UI: ERROR - Stage cleared label not found!")
	
	# Debug: Check if you died label is initialized
	print("UI: You died label: ", you_died_label)
	if you_died_label:
		print("UI: You died label found and initialized")
		print("UI: You died label visible: ", you_died_label.visible)
	else:
		print("UI: ERROR - You died label not found!")

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

func update_chapter_info(chapter_number: int, chapter_name: String):
	chapter_label.text = "Chapter %d: %s" % [chapter_number, chapter_name]

func update_progress(enemies_killed: int, enemies_required: int):
	progress_label.text = "Enemies: %d/%d" % [enemies_killed, enemies_required]

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

func show_stage_cleared():
	print("UI: show_stage_cleared() called")
	if stage_cleared_label:
		print("UI: Stage cleared label found, making visible")
		stage_cleared_label.visible = true
		print("UI: Stage Cleared text displayed")
		
		# Optional: Add a fade in effect
		var tween = create_tween()
		stage_cleared_label.modulate = Color.TRANSPARENT
		tween.tween_property(stage_cleared_label, "modulate", Color.WHITE, 0.5)
		print("UI: Fade in animation started")
	else:
		print("UI: ERROR - Stage cleared label not found!")

func hide_stage_cleared():
	stage_cleared_label.visible = false
	print("UI: Stage Cleared text hidden")

func show_you_died():
	print("UI: show_you_died() called")
	if you_died_label:
		print("UI: You died label found, making visible")
		you_died_label.visible = true
		print("UI: You Died text displayed")
		
		# Optional: Add a fade in effect
		var tween = create_tween()
		you_died_label.modulate = Color.TRANSPARENT
		tween.tween_property(you_died_label, "modulate", Color.WHITE, 0.5)
		print("UI: Fade in animation started for You Died")
	else:
		print("UI: ERROR - You died label not found!")

func hide_you_died():
	you_died_label.visible = false
	print("UI: You Died text hidden") 
