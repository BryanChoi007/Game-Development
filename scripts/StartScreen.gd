extends Control

@onready var start_button = $ButtonContainer/StartButton
@onready var quit_button = $ButtonContainer/QuitButton
@onready var halo_ring = $HaloRing

func _ready():
	# Connect button signals
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
	# Start the halo ring animation
	_animate_halo_ring()

func _on_start_button_pressed():
	print("Starting game...")
	# Change to the main game scene
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_quit_button_pressed():
	print("Quitting game...")
	# Quit the game
	get_tree().quit()

func _animate_halo_ring():
	# Create a simple rotation animation for the halo ring
	var tween = create_tween()
	tween.set_loops()  # Loop forever
	tween.tween_property(halo_ring, "rotation", TAU, 20.0)  # Full rotation in 20 seconds

func _input(event):
	# Allow ESC key to quit
	if event.is_action_pressed("ui_cancel"):
		_on_quit_button_pressed() 