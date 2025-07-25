extends Node

signal chapter_completed(chapter_number)
signal game_completed
signal stage_cleared
signal enemy_killed_signal

var current_chapter = 1
var enemies_killed_in_chapter = 0
var is_game_over = false
var is_scene_changing = false
var total_chapters = 7
var player_death_requested = false
var is_completing_chapter = false
var player_health = 100  # Store player health between levels

# Calculate required kills based on chapter number
var enemies_required_per_chapter: int:
	get:
		return current_chapter * 5

var chapter_data = {
	1: {"name": "The Accident", "description": "The beginning of Bella's journey"},
	2: {"name": "The Rise of the Fruit Zombies", "description": "Fruit zombies emerge"},
	3: {"name": "Bella's New Life", "description": "Bella becomes a famous chef"},
	4: {"name": "The Government's Request", "description": "Government agents recruit Bella"},
	5: {"name": "The Hunt", "description": "Bella hunts fruit zombies"},
	6: {"name": "The Revelation", "description": "Bella discovers the truth"},
	7: {"name": "The Final Duel", "description": "Bella faces her father"}
}

var ending_text = {
	"chapter8": "Farewell\n\nAfter the final battle, Bella stood victorious. The world was safe from the fruit zombie menace, but at a great cost. Her father, once a brilliant scientist, had been consumed by his own creation. As the sun set over the mountains, Bella knew this was not just the end of a battle, but the beginning of a new chapter in her life.",
	"chapter9": "New Beginnings\n\nWith the fruit zombie threat eliminated, Bella returned to her roots as a chef. But now, she was not just any chef - she was the hero who saved the world. Her restaurant became famous not just for its delicious meat dishes, but for the incredible story behind its owner. Bella had found her true calling, combining her culinary skills with her newfound purpose. The world was safe, and Bella had finally found peace."
}

func _ready():
	# Make this node persistent across scene changes
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Ensure this node doesn't get freed when scenes change
	set_meta("_edit_group_", true)


	


func enemy_killed():
	# Don't process enemy deaths if game is over or scene is changing
	if is_game_over or is_scene_changing:
		return
		
	enemies_killed_in_chapter += 1
	
	# Emit signal to update UI
	enemy_killed_signal.emit()
	
	if enemies_killed_in_chapter >= enemies_required_per_chapter and not is_completing_chapter:
		is_completing_chapter = true
		
		# Emit signal to show "Stage Cleared" text first
		stage_cleared.emit()
		
		# Wait a moment for the text to appear before pausing
		await get_tree().create_timer(0.5).timeout
		
		# Now pause the game for 5 seconds
		get_tree().paused = true
		await get_tree().create_timer(5.0).timeout
		get_tree().paused = false
		complete_chapter()
	elif enemies_killed_in_chapter >= enemies_required_per_chapter and is_completing_chapter:
		# Chapter completion already in progress, ignore kill
		pass

func complete_chapter():
	if current_chapter >= total_chapters:
		game_completed.emit()
		# Load ending screen directly
		_load_ending_screen()
	else:
		var old_chapter = current_chapter
		current_chapter += 1
		enemies_killed_in_chapter = 0
		chapter_completed.emit(current_chapter)
		# Load chapter transition
		_load_chapter_transition()



func get_current_chapter_info():
	return chapter_data[current_chapter]

func get_chapter_info(chapter_number: int):
	return chapter_data[chapter_number]

func get_progress():
	return {
		"chapter": current_chapter,
		"enemies_killed": enemies_killed_in_chapter,
		"enemies_required": enemies_required_per_chapter,
		"total_chapters": total_chapters
	}

func reset_game():
	current_chapter = 1
	enemies_killed_in_chapter = 0
	is_game_over = false
	is_scene_changing = false
	is_completing_chapter = false

func set_game_over(value: bool):
	is_game_over = value

func is_game_over_state() -> bool:
	return is_game_over

func reset_scene_changing():
	is_scene_changing = false

func reset_chapter_completion():
	is_completing_chapter = false

func save_player_health(health: int):
	player_health = health

func get_player_health() -> int:
	return player_health

func reset_player_health():
	player_health = 100

func _load_chapter_transition():
	is_scene_changing = true
	var tree = get_tree()
	if tree:
		tree.change_scene_to_file("res://scenes/ChapterTransition.tscn")
	else:
		is_scene_changing = false

func _load_ending_screen():
	is_scene_changing = true
	var tree = get_tree()
	if tree:
		tree.change_scene_to_file("res://scenes/EndingScreen.tscn")
	else:
		is_scene_changing = false

 
