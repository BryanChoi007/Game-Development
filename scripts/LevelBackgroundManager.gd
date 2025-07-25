extends Node2D

# Preload different background scenes
var background_scenes = {
	1: preload("res://scenes/backgrounds/LabBackground.tscn"),
	2: preload("res://scenes/backgrounds/BattlefieldBackground.tscn"),
	3: preload("res://scenes/backgrounds/KitchenBackground.tscn"),
	4: preload("res://scenes/backgrounds/OfficeBackground.tscn"),
	5: preload("res://scenes/backgrounds/BattlefieldBackground.tscn"),
	6: preload("res://scenes/backgrounds/BattlefieldBackground.tscn"),
	7: preload("res://scenes/backgrounds/BattlefieldBackground.tscn"),
	8: preload("res://scenes/backgrounds/BattlefieldBackground.tscn"),
	9: preload("res://scenes/backgrounds/MeatKitchenBackground.tscn")
}

var current_background: Node2D
var game_manager = null

func _ready():
	# Get GameManager autoload
	game_manager = get_node_or_null("/root/GameManager")
	
	# Get current chapter from GameManager
	if game_manager:
		var current_chapter = game_manager.current_chapter
		load_background_for_chapter(current_chapter)
	else:
		print("GameManager not found, using default chapter 1")
		load_background_for_chapter(1)

func load_background_for_chapter(chapter_number: int):
	# Remove current background if it exists
	if current_background:
		current_background.queue_free()
	
	# Load new background
	if background_scenes.has(chapter_number):
		current_background = background_scenes[chapter_number].instantiate()
		add_child(current_background)
		print("Loaded background for Chapter ", chapter_number)
	else:
		print("No background found for Chapter ", chapter_number) 