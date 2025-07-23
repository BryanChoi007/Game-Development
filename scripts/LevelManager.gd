extends Node

signal chapter_completed(chapter_number)
signal game_completed

var current_chapter = 1
var enemies_killed_in_chapter = 0
var enemies_required_per_chapter = 1
var total_chapters = 7

var chapter_data = {
	1: {"name": "The Accident", "description": "The beginning of Bella's journey"},
	2: {"name": "The Rise of the Fruit Zombies", "description": "Fruit zombies emerge"},
	3: {"name": "Bella's New Life", "description": "Bella becomes a famous chef"},
	4: {"name": "The Government's Request", "description": "Government agents recruit Bella"},
	5: {"name": "The Hunt", "description": "Bella hunts fruit zombies"},
	6: {"name": "The Revelation", "description": "Bella discovers the truth"},
	7: {"name": "The Final Duel", "description": "Bella faces her father"}
}

func _ready():
	print("LevelManager _ready() called")
	print("LevelManager current_chapter: ", current_chapter)
	# Connect to enemy death signals
	call_deferred("_connect_to_enemies")

func _exit_tree():
	print("LevelManager _exit_tree() called - node is being freed")

func _connect_to_enemies():
	# Connect to existing enemies
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		if not enemy.tree_exited.is_connected(_on_enemy_died):
			enemy.tree_exited.connect(_on_enemy_died)
	
	# Also connect to the EnemySpawner to catch new enemies
	var enemy_spawner = get_tree().get_first_node_in_group("enemy_spawner")
	if enemy_spawner:
		enemy_spawner.enemy_spawned.connect(_on_enemy_spawned)

func _on_enemy_spawned(enemy):
	if not enemy.tree_exited.is_connected(_on_enemy_died):
		enemy.tree_exited.connect(_on_enemy_died)

func _on_enemy_died():
	# Don't process enemy deaths if game is over or if we're being freed
	if GameManager and GameManager.is_game_over_state():
		return
		
	# Check if this node is still in the tree
	if not is_inside_tree():
		print("LevelManager: Node not in tree, ignoring enemy death")
		return
		
	print("LevelManager: Enemy died, calling GameManager.enemy_killed()")
	# Use GameManager to track enemy kills instead of duplicating logic
	GameManager.enemy_killed()





func get_current_chapter_info():
	return chapter_data[current_chapter]

func get_progress():
	return {
		"chapter": current_chapter,
		"enemies_killed": enemies_killed_in_chapter,
		"enemies_required": enemies_required_per_chapter,
		"total_chapters": total_chapters
	} 
