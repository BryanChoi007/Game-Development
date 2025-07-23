extends Control

@onready var start_button = $ButtonContainer/StartButton
@onready var quit_button = $ButtonContainer/QuitButton
@onready var halo_ring = $HaloRing

func _ready():
	# Connect button signals
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
	# Start the fruit and blood animations
	_animate_fruits()
	_animate_blood_splatters()

func _on_start_button_pressed():
	print("Starting game...")
	# Reset the game state
	GameManager.reset_game()
	print("Game state reset, current chapter: ", GameManager.current_chapter)
	# Start with chapter transition for chapter 1
	print("Loading ChapterTransition scene...")
	get_tree().change_scene_to_file("res://scenes/ChapterTransition.tscn")

func _on_quit_button_pressed():
	print("Quitting game...")
	# Quit the game
	get_tree().quit()

func _animate_fruits():
	# Animate the fruits with gentle floating motion
	var fruits = $FruitDecorations.get_children()
	for fruit in fruits:
		var tween = create_tween()
		tween.set_loops()  # Loop forever
		var original_pos = fruit.position
		tween.tween_property(fruit, "position", original_pos + Vector2(0, -10), 2.0)
		tween.tween_property(fruit, "position", original_pos, 2.0)

func _animate_blood_splatters():
	# Animate blood splatters with pulsing effect
	var blood_splatters = $BloodSplatters.get_children()
	for splatter in blood_splatters:
		var tween = create_tween()
		tween.set_loops()  # Loop forever
		var original_scale = splatter.scale
		tween.tween_property(splatter, "scale", original_scale * 1.2, 1.5)
		tween.tween_property(splatter, "scale", original_scale, 1.5)

func _input(event):
	# Allow ESC key to quit
	if event.is_action_pressed("ui_cancel"):
		_on_quit_button_pressed() 