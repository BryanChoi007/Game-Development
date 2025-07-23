extends Control

@onready var restart_button = $ButtonContainer/RestartButton
@onready var quit_button = $ButtonContainer/QuitButton
@onready var enemy_right = $EnemyRight

func _ready():
	restart_button.pressed.connect(_on_restart_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	# Start the right enemy jumping animation
	_start_enemy_jumping()

func _on_restart_pressed():
	print("Restarting game...")
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")

func _on_quit_pressed():
	print("Quitting game...")
	get_tree().quit()

func _start_enemy_jumping():
	# Create a tween for the right enemy jumping up and down
	var jump_tween = create_tween()
	jump_tween.set_loops()  # Loop infinitely
	
	# Get the original position
	var original_pos = enemy_right.position
	
	# Jump up and down animation
	jump_tween.tween_property(enemy_right, "position", original_pos + Vector2(0, -40), 0.6)  # Jump up
	jump_tween.tween_property(enemy_right, "position", original_pos, 0.6)  # Land back down 