extends Node2D

@onready var player = $Player
@onready var ui = $UI
@onready var tilemap = $TileMap

func _ready():
	# Connect player signals
	player.health_changed.connect(_on_player_health_changed)
	
	# Set up camera to follow player
	player.camera.enabled = true
	
	# Initialize UI
	update_ui()

func _on_player_health_changed(new_health: int, max_health: int):
	update_ui()

func update_ui():
	if ui and player:
		ui.update_health(player.current_health, player.max_health)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit() 