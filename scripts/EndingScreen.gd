extends Control

@onready var scrolling_text = $ScrollingText
@onready var quit_button = $QuitButton
@onready var player_character = $PlayerCharacter

var scroll_speed = 30.0  # pixels per second
var initial_scroll_position = 0.0

func _ready():
	# Connect quit button
	quit_button.pressed.connect(_on_quit_pressed)
	
	# Start character jumping animation
	_start_character_jumping()
	
	# Start scrolling animation after a short delay
	await get_tree().create_timer(1.0).timeout
	_start_scrolling()

func _start_scrolling():
	# Create a tween for smooth scrolling by moving the text upward
	var tween = create_tween()
	tween.set_loops()  # Loop infinitely
	
	# Move the text upward over 60 seconds (much slower)
	var start_pos = scrolling_text.position
	var end_pos = start_pos + Vector2(0, -1200)  # Move up 1200 pixels for 1080p
	tween.tween_property(scrolling_text, "position", end_pos, 60.0)

func _start_character_jumping():
	# Create a tween for the character jumping up and down
	var jump_tween = create_tween()
	jump_tween.set_loops()  # Loop infinitely
	
	# Get the original position
	var original_pos = player_character.position
	
	# Jump up and down animation
	jump_tween.tween_property(player_character, "position", original_pos + Vector2(0, -50), 0.5)  # Jump up
	jump_tween.tween_property(player_character, "position", original_pos, 0.5)  # Land back down

func _on_quit_pressed():
	get_tree().quit() 
