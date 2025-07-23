extends Node

signal chapter_completed(chapter_number)
signal game_completed
signal stage_cleared

var current_chapter = 1
var enemies_killed_in_chapter = 0
var is_game_over = false
var is_scene_changing = false
var total_chapters = 7
var player_death_requested = false
var is_completing_chapter = false

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
	
	print("GameManager _ready() called - Current chapter: ", current_chapter)
	print("GameManager: Required kills for chapter ", current_chapter, ": ", enemies_required_per_chapter)


	


func enemy_killed():
	print("GameManager: enemy_killed() called")
	# Don't process enemy deaths if game is over or scene is changing
	if is_game_over or is_scene_changing:
		print("GameManager: Ignoring enemy kill - game over: ", is_game_over, ", scene changing: ", is_scene_changing)
		return
		
	enemies_killed_in_chapter += 1
	print("GameManager: Enemy killed! Progress: ", enemies_killed_in_chapter, "/", enemies_required_per_chapter)
	print("GameManager: Current chapter: ", current_chapter)
	print("GameManager: Enemies required: ", enemies_required_per_chapter)
	print("GameManager: Will complete chapter: ", enemies_killed_in_chapter >= enemies_required_per_chapter)
	
	if enemies_killed_in_chapter >= enemies_required_per_chapter and not is_completing_chapter:
		print("GameManager: Final enemy killed! Showing stage cleared text...")
		print("GameManager: Completion check - killed: ", enemies_killed_in_chapter, ", required: ", enemies_required_per_chapter, ", is_completing: ", is_completing_chapter)
		print("GameManager: About to emit stage_cleared signal")
		is_completing_chapter = true
		
		# Emit signal to show "Stage Cleared" text first
		print("GameManager: Emitting stage_cleared signal")
		stage_cleared.emit()
		print("GameManager: stage_cleared signal emitted")
		
		# Wait a moment for the text to appear before pausing
		print("GameManager: Waiting 0.5 seconds for text to appear...")
		await get_tree().create_timer(0.5).timeout
		
		# Now pause the game for 5 seconds
		print("GameManager: Pausing game for 5 seconds...")
		get_tree().paused = true
		await get_tree().create_timer(5.0).timeout
		get_tree().paused = false
		print("GameManager: 5-second pause complete, calling complete_chapter()")
		complete_chapter()
	elif enemies_killed_in_chapter >= enemies_required_per_chapter and is_completing_chapter:
		print("GameManager: Chapter completion already in progress, ignoring kill")
		print("GameManager: Completion check - killed: ", enemies_killed_in_chapter, ", required: ", enemies_required_per_chapter, ", is_completing: ", is_completing_chapter)

func complete_chapter():
	print("GameManager: complete_chapter() called!")
	print("GameManager: Chapter ", current_chapter, " completed!")
	print("GameManager: Total chapters: ", total_chapters)
	
	if current_chapter >= total_chapters:
		print("Game completed! Congratulations!")
		game_completed.emit()
		# Load ending screen directly
		_load_ending_screen()
	else:
		var old_chapter = current_chapter
		current_chapter += 1
		enemies_killed_in_chapter = 0
		print("GameManager: Moving from chapter ", old_chapter, " to chapter: ", current_chapter)
		print("GameManager: Chapter progression - old: ", old_chapter, ", new: ", current_chapter)
		print("GameManager: Required kills for new chapter ", current_chapter, ": ", enemies_required_per_chapter)
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
	print("GameManager: Scene changing flag reset to false")

func reset_chapter_completion():
	is_completing_chapter = false
	print("GameManager: Chapter completion flag reset to false")

func _load_chapter_transition():
	print("Loading Chapter ", current_chapter, ": ", chapter_data[current_chapter]["name"])
	is_scene_changing = true
	var tree = get_tree()
	if tree:
		var result = tree.change_scene_to_file("res://scenes/ChapterTransition.tscn")
		print("Chapter transition scene change result: ", result)
	else:
		print("Tree is null in GameManager, cannot change scene")
		is_scene_changing = false

func _load_ending_screen():
	print("Loading ending screen...")
	is_scene_changing = true
	var tree = get_tree()
	if tree:
		var result = tree.change_scene_to_file("res://scenes/EndingScreen.tscn")
		print("Ending screen scene change result: ", result)
	else:
		print("Tree is null in GameManager, cannot change scene")
		is_scene_changing = false

 
