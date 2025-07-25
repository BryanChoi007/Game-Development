extends Control

@onready var start_button = $ButtonContainer/StartButton
@onready var quit_button = $ButtonContainer/QuitButton
@onready var animated_characters = $AnimatedCharacters
@onready var background_music = $BackgroundMusic

func _ready():
	# Connect button signals
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
	# Start the fruit and blood animations
	_animate_fruits()
	_animate_blood_splatters()
	
	# Start the character animations
	_animate_characters()

func _on_start_button_pressed():
	print("Starting game...")
	# Stop the background music
	if background_music:
		background_music.stop()
	# Reset the game state
	GameManager.reset_game()
	print("Game state reset, current chapter: ", GameManager.current_chapter)
	# Start with chapter transition for chapter 1
	print("Loading ChapterTransition scene...")
	get_tree().change_scene_to_file("res://scenes/ChapterTransition.tscn")

func _on_quit_button_pressed():
	print("Quitting game...")
	# Stop the background music
	if background_music:
		background_music.stop()
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

func _animate_characters():
	# Get all characters
	var main_character = $AnimatedCharacters/MainCharacter
	var enemy1 = $AnimatedCharacters/Enemy1
	var enemy2 = $AnimatedCharacters/Enemy2
	var enemy3 = $AnimatedCharacters/Enemy3
	
	# Movement speed and distance
	var move_speed = 150.0  # pixels per second (3x faster)
	var screen_width = 1920
	var start_x = -200  # Start closer to screen (more visible)
	var middle_x = screen_width / 2  # Stop in the middle of the screen
	
	# Calculate when enemies reach the middle (Enemy1 has the shortest distance)
	var enemy1_distance = (middle_x + 100) - (start_x + 300)
	var enemy1_duration = enemy1_distance / move_speed
	
	# Animate main character movement (chasing - no jumping) - stops when enemies reach middle
	_animate_character_movement(main_character, start_x, start_x + (enemy1_duration * move_speed), move_speed, 0.0, false)
	
	# Show speech bubble after everyone stops
	var speech_bubble = main_character.get_node("SpeechBubble")
	if speech_bubble:
		var speech_tween = create_tween()
		speech_tween.tween_callback(func(): pass).set_delay(enemy1_duration + 0.5)  # Wait for movement + 0.5s
		speech_tween.tween_callback(func(): speech_bubble.visible = true)
	
	# Animate enemies with slight delays and jumping patterns
	_animate_character_movement(enemy1, start_x + 300, middle_x + 100, move_speed, 0.5, true)
	_animate_character_movement(enemy2, start_x + 350, middle_x + 150, move_speed, 1.0, true)
	_animate_character_movement(enemy3, start_x + 400, middle_x + 200, move_speed, 1.5, true)

func _animate_character_movement(character: Node2D, start_x: float, end_x: float, speed: float, jump_delay: float, should_jump: bool = true):
	# Set initial position
	character.position.x = start_x
	
	# Create movement tween (no looping - stops at destination)
	var move_tween = create_tween()
	
	# Calculate movement duration based on speed
	var distance = end_x - start_x
	var duration = distance / speed
	
	# Move from start to end
	move_tween.tween_property(character, "position:x", end_x, duration)
	
	# Only create jumping animation if character should jump
	if should_jump:
		var jump_tween = create_tween()
		jump_tween.set_loops()  # Loop forever
		
		# Wait for initial delay using tween_callback
		if jump_delay > 0:
			jump_tween.tween_callback(func(): pass).set_delay(jump_delay)
		
		# Jump up and down continuously
		jump_tween.tween_property(character, "position:y", character.position.y - 30, 0.5)
		jump_tween.tween_property(character, "position:y", character.position.y, 0.5)
		
		# Flip enemy sprites to face Master Chief when they reach the middle
		var sprite = character.get_node("Sprite")
		if sprite and sprite.scale.x > 0:  # Only flip if it's an enemy (positive scale)
			var flip_tween = create_tween()
			flip_tween.tween_callback(func(): pass).set_delay(duration)  # Wait until movement is complete
			flip_tween.tween_property(sprite, "scale:x", -0.3, 0.3)  # Flip to face left (negative scale)

func _input(event):
	# Allow ESC key to quit
	if event.is_action_pressed("ui_cancel"):
		_on_quit_button_pressed() 
