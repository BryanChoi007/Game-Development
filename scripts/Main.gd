extends Node2D

@onready var player = $Player
@onready var ui = $UI
@onready var tilemap = $TileMap
@onready var background_music = $BackgroundMusic

# Try to get GameManager reference
var game_manager = null

# Level music references
var level_music = {
	1: preload("res://assets/level1.mp3"),
	2: preload("res://assets/level2.mp3"),
	3: preload("res://assets/level3.mp3"),
	4: preload("res://assets/level4.mp3"),
	5: preload("res://assets/level5.mp3"),
	6: preload("res://assets/level6.mp3"),
	7: preload("res://assets/level7.mp3")
}

func _ready():
	# Try to get GameManager reference
	game_manager = get_node_or_null("/root/GameManager")
	if not game_manager:
		game_manager = get_node_or_null("/root/GameManager")
	
	# Reset scene changing flag when new level starts
	if game_manager:
		game_manager.reset_scene_changing()
		game_manager.reset_chapter_completion()
	
	# Hide stage cleared text on new level
	if ui:
		ui.hide_stage_cleared()
	
	# Connect player signals
	player.health_changed.connect(_on_player_health_changed)
	
	# Connect GameManager signals
	if game_manager:
		game_manager.chapter_completed.connect(_on_chapter_completed)
		game_manager.game_completed.connect(_on_game_completed)
		game_manager.stage_cleared.connect(_on_stage_cleared)
		game_manager.enemy_killed_signal.connect(_on_enemy_killed)
	
	# Test UI directly (commented out to prevent immediate display)
	# print("Main: Testing UI show_stage_cleared() directly...")
	# if ui:
	# 	ui.show_stage_cleared()
	# 	print("Main: Called ui.show_stage_cleared() directly")
	# else:
	# 	print("Main: ERROR - UI not found for direct test!")
	
	# Set up camera to follow player
	player.camera.enabled = true
	
	# Initialize UI
	if ui:
		update_ui()
		update_chapter_ui()
	
	# Initialize level music
	initialize_level_music()

func _on_player_health_changed(new_health: int, max_health: int):
	update_ui()

func update_ui():
	if ui and player:
		ui.update_health(player.current_health, player.max_health)

func update_chapter_ui():
	if ui and game_manager:
		var progress = game_manager.get_progress()
		var chapter_info = game_manager.get_current_chapter_info()
		ui.update_chapter_info(progress.chapter, chapter_info.name)
		ui.update_progress(progress.enemies_killed, progress.enemies_required)

func _on_chapter_completed(chapter_number: int):
	var chapter_info = GameManager.get_current_chapter_info()
	ui.show_message("Chapter %d Complete! %s" % [chapter_number, chapter_info.name])
	# Stop music before transition
	stop_level_music()
	# GameManager will handle scene transition

func _on_game_completed():
	ui.show_message("Congratulations! You've completed Watermelon Hunter!")
	# Stop music before transition
	stop_level_music()
	# GameManager will handle scene transition

func _on_stage_cleared():
	if ui:
		ui.show_stage_cleared()

func _on_enemy_killed():
	update_chapter_ui()  # Update the enemy counter in UI



func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func initialize_level_music():
	if game_manager and background_music:
		var current_chapter = game_manager.current_chapter
		if current_chapter in level_music:
			background_music.stream = level_music[current_chapter]
			background_music.play()
		else:
			print("Warning: No music found for chapter ", current_chapter)

func stop_level_music():
	if background_music:
		background_music.stop() 