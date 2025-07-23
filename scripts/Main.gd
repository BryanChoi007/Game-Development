extends Node2D

@onready var player = $Player
@onready var ui = $UI
@onready var tilemap = $TileMap

func _ready():
	# Reset scene changing flag when new level starts
	GameManager.reset_scene_changing()
	GameManager.reset_chapter_completion()
	print("Main scene loaded - reset scene changing flag and chapter completion flag")
	
	# Hide stage cleared text on new level
	if ui:
		ui.hide_stage_cleared()
	
	# Connect player signals
	player.health_changed.connect(_on_player_health_changed)
	
	# Connect GameManager signals
	GameManager.chapter_completed.connect(_on_chapter_completed)
	GameManager.game_completed.connect(_on_game_completed)
	GameManager.stage_cleared.connect(_on_stage_cleared)
	print("Main: Connected stage_cleared signal to _on_stage_cleared")
	
	# Test signal connection
	print("Main: Testing stage_cleared signal connection...")
	if GameManager.stage_cleared.get_connections().size() > 0:
		print("Main: stage_cleared signal is connected to ", GameManager.stage_cleared.get_connections().size(), " functions")
	else:
		print("Main: ERROR - stage_cleared signal has no connections!")
	
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
	print("Main: UI node: ", ui)
	if ui:
		print("Main: UI node found and initialized")
		update_ui()
		update_chapter_ui()
	else:
		print("Main: ERROR - UI node not found!")

func _on_player_health_changed(new_health: int, max_health: int):
	update_ui()

func update_ui():
	if ui and player:
		ui.update_health(player.current_health, player.max_health)

func update_chapter_ui():
	if ui:
		var progress = GameManager.get_progress()
		var chapter_info = GameManager.get_current_chapter_info()
		ui.update_chapter_info(progress.chapter, chapter_info.name)
		ui.update_progress(progress.enemies_killed, progress.enemies_required)

func _on_chapter_completed(chapter_number: int):
	print("Chapter completed signal received: ", chapter_number)
	var chapter_info = GameManager.get_current_chapter_info()
	ui.show_message("Chapter %d Complete! %s" % [chapter_number, chapter_info.name])
	# GameManager will handle scene transition

func _on_game_completed():
	print("Game completed signal received!")
	ui.show_message("Congratulations! You've completed Watermelon Hunter!")
	# GameManager will handle scene transition

func _on_stage_cleared():
	print("Main: Stage cleared signal received!")
	if ui:
		print("Main: UI found, calling show_stage_cleared()")
		ui.show_stage_cleared()
	else:
		print("Main: ERROR - UI not found!")



func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit() 