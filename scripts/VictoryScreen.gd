extends Control

@onready var main_menu_button = $VictoryPanel/ButtonContainer/MainMenuButton
@onready var quit_button = $VictoryPanel/ButtonContainer/QuitButton
@onready var fireworks = $Fireworks
@onready var victory_character = $VictoryCharacter

func _ready():
	# Connect button signals
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
	# Start animations
	_animate_victory_character()
	_animate_fireworks()

func _on_main_menu_button_pressed():
	print("Returning to main menu...")
	# Reset the game state
	GameManager.reset_game()
	# Return to start screen
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")

func _on_quit_button_pressed():
	print("Quitting game...")
	# Quit the game
	get_tree().quit()

func _animate_victory_character():
	# Animate the victory character jumping up and down
	var tween = create_tween()
	tween.set_loops()  # Loop forever
	var original_pos = victory_character.position
	tween.tween_property(victory_character, "position", original_pos + Vector2(0, -30), 0.5)
	tween.tween_property(victory_character, "position", original_pos, 0.5)

func _animate_fireworks():
	# Animate fireworks with explosion effects
	var firework_list = fireworks.get_children()
	for firework in firework_list:
		var tween = create_tween()
		tween.set_loops()  # Loop forever
		
		# Random delay for each firework
		var random_delay = randf_range(0, 2.0)
		await get_tree().create_timer(random_delay).timeout
		
		# Explosion animation
		var original_scale = firework.scale
		var original_modulate = firework.modulate
		
		# Scale up and fade in
		tween.tween_property(firework, "scale", original_scale * 3.0, 0.3)
		tween.parallel().tween_property(firework, "modulate", Color(1, 1, 1, 1), 0.3)
		
		# Scale down and fade out
		tween.tween_property(firework, "scale", original_scale, 0.3)
		tween.parallel().tween_property(firework, "modulate", original_modulate, 0.3)
		
		# Wait before next explosion
		tween.tween_delay(randf_range(1.0, 3.0))

func _input(event):
	# Allow ESC key to quit
	if event.is_action_pressed("ui_cancel"):
		_on_quit_button_pressed() 