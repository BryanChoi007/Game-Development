extends Control

@onready var scrolling_text = $ScrollingTextContainer/ScrollingText
@onready var continue_prompt = $ContinuePrompt

var chapter_stories = {
	1: """Once upon a time, in a clandestine genetics lab, a scientist named Dr. Marcus Fruitan was on the brink of a breakthrough. He was splicing fruit and plant DNA with human DNA, aiming to create beings that could photosynthesize and sustain themselves.

Every day, after his rigorous experiments, Marcus would return home to his young daughter, Bella. They shared a unique bond, their love for each other mirrored in their shared love for fruits and vegetables.

Bella would eagerly wait for her father's return, a basket full of fresh produce ready at the dining table. Their meals were a colorful array of fruits and veggies, each delicately prepared by Bella. She was a young prodigy in the kitchen, her knife skills rivaling those of professional chefs.

"Dad, try this," Bella would say, offering him a slice of perfectly cut watermelon or pineapple. Marcus would smile, savoring the sweetness of the fruit, the joy in Bella's eyes more delightful than any flavor.

These were the moments they cherished the most - the laughter, the stories shared over a meal, the simple joy of being together.

But one fateful night, everything changed. Marcus was working late at the lab, a critical experiment at its peak. Bella was home, waiting for her father to return for their nightly ritual. But Marcus never came home.

The lab exploded in a burst of foliage and fire, and Marcus was presumed dead. Bella was left alone, her world shattered. The joyous meals, the shared laughter, the love they had for each other - all were replaced with a heart-wrenching void. Little did Bella know, this was just the beginning of a journey that would change her life forever.""",
	
	2: """In the wake of the explosion, something strange happened. Half-human, half-fruit creatures began to rise - the fruit zombies were born. Their heads were grotesque hybrids of fruits like watermelons and pineapples, and their bodies were alarmingly human. Marcus's young daughter, Bella, was heartbroken by her father's presumed death, and the world she knew was replaced with one full of these monstrous hybrids.

The fruit zombies began to spread, their numbers growing with each passing day. They were not mindless - they were intelligent, organized, and dangerous. The world was in chaos as these creatures emerged from the shadows, their fruit-like heads a constant reminder of the experiment that had gone so terribly wrong.""",
	
	3: """Ten years later, Bella had become a world-renowned chef, known for her extraordinary knife skills and inventive use of fruit and vegetables. She hosted a popular cooking show on the local PBS station, where she inspired people to find joy in cooking amidst the chaos.

Bella stood in her familiar kitchen set, surrounded by an array of vibrant fruits. The camera lights glowed warmly, casting a spotlight on her and her culinary craft.

"Hello, everyone!" she greeted with a bright smile, looking directly into the camera. "Today, we're going to create something beautiful and delicious—a fruit flower bouquet. Now, I know what you're thinking... 'Bella, isn't this just a fruit salad on a stick?' Well, let's not judge the fruit by its skin, shall we?"

She laughed at her own pun, her eyes sparkling with enthusiasm. Bella picked up a ripe, juicy watermelon. "Now, this is the real melon-choly part," she joked, "we have to slice this beauty up."

As she expertly carved the watermelon into delicate petals, she continued to sprinkle her instructions with fruit puns. "Remember to carve gently. We wouldn't want to squash the melon's dreams of becoming a beautiful flower, would we?"

Next, she picked up an apple. "Now, the apple doesn't fall far from the tree, and in our bouquet, it's no different. It's going to be right next to our watermelon flower, providing a beautiful contrast."

As the show progressed, Bella crafted a stunning bouquet of fruit flowers. Each fruit was delicately carved and arranged, turning into a work of art under her skilled hands.

Towards the end, she held up a pineapple. "Now, this is the prickly part. But don't worry, if you take it slow and steady, you won't end up in a pineapple jam," she said, laughing at her own wit.

Finally, she stepped back to admire her creation. The fruit flower bouquet was a riot of colors and shapes, a true testament to Bella's culinary artistry.

"And voila! Here's our fruit flower bouquet," Bella announced, her eyes twinkling with pride and satisfaction. "Remember, folks, life's a fruit. You have to peel it to find the sweetness."

With that, the camera lights dimmed, signaling the end of another successful episode of Bella's cooking show.

As Bella's show concluded, the scene shifted away from her vibrant kitchen set to a stark, dimly lit room. There, two figures sat, their eyes fixated on the screen that had just showcased Bella's culinary prowess.

One of them, a tall man with a stern expression, leaned back in his chair, stroking his chin thoughtfully. "She's good," he mused, his gaze never leaving the now blank screen. "Her precision, her creativity, her ability to handle those knives..."

The other, a woman with sharp eyes and anime-like blonde hair, nodded. "More than that, she has a rapport with the audience. People trust her, they listen to her."

The man turned to look at his partner, his eyes gleaming with a determined light. "Yes," he agreed, a slow smile spreading across his face. "I think we've found our weapon."

As they sat in the shadowy room, the echoes of Bella's laughter and fruit puns still lingering in the air, a new chapter was about to begin. The world of fruit ninjas was about to meet its match in the form of a charismatic, pun-loving chef.""",
	
	4: """One day, government agents arrived at Bella's doorstep. One was tall, imposing figure in a black suit, The other looked like a member of the KPOP girl group 2NE1. The leader specifically. She had blond hair and dark eye makeup. She looked like she invented girl boss energy. Their expressions were grim.

"Bella Fruitan?" one of them asked, flashing an ID.

"That's me," Bella replied, her gaze steady. "What can I do for you?"

"We've seen your skills, Ms. Fruitan," the second agent said, his voice gruff. "Your... unique culinary talents."

"My culinary talents?" Bella raised an eyebrow. "I didn't realize the government was in need of a chef."

"Not exactly," the first agent replied. "We're here because of your proficiency with knives."

Bella's looked perplexed. My knife skills. Why does the NSA need a chef with knife skills?

The agents exchanged glances. "We believe you could be a valuable asset in combating the fruit zombie menace," the second agent admitted.

Bella was silent for a long moment. Then, finally, she nodded. "Alright," she said. "I'll do it."

The agents let out a sigh of relief. "Thank you, Ms. Fruitan," the first agent said. "You won't regret this."

As the agents left, Bella stood there, a determined look in her eyes. She was about to embark on a journey that would change her life forever.""",
	
	5: """Armed with her trusty set of knives, Bella embarked on a perilous journey. As she slashed through a watermelon-headed zombie, she quipped, "You seem a little ripe." Her knives moved like lightning, slicing through the fruit zombies with precision and efficiency. Each swing of her blade was accompanied by a witty one-liner, bringing a spark of humanity to the grim task.

Their watermelon heads and pineapple faces were monstrous, yet strangely poignant reminders of her father's warm gaze. As she diced a pineapple-headed creature, she retorted, "Guess you're not as sweet as you look."

When an apple-headed zombie lunged at her, she chuckled and countered, "An apple a day might keep the doctor away, but it won't keep me at bay."

A banana-headed zombie slipped towards her, and Bella skillfully dodged it, saying, "I find your tactics un-peeling."

A horde of grape-headed zombies surrounded her, and she grinned, "I guess it's time for me to wine about the situation."

Bella's journey was not just about combat - it was about finding her father, about understanding what had happened that fateful night, and about bringing justice to the world that had been torn apart by the fruit zombie menace.""",
	
	6: """As Bella fought her way closer to the leader of the fruit zombies, she made a horrifying discovery. The leader was not just another fruit-human hybrid. He was different, more powerful, and eerily familiar.

His head, a grotesque fusion of a human face and a pineapple, was a chilling sight. His eyes, once full of warmth, were now cold and green. But they still held a glimmer of humanity, a glimmer Bella couldn't ignore.

As she stood in front of him, ready for a fight, he spoke. His voice was distorted by the pineapple that made up half his face, but there was a strange familiarity to it.

"Bella," he rasped. The sound of her name, spoken with such familiarity, sent chills down her spine.

"How do you know my name?" she demanded, her grip tightening on her knives.

"Bella, I..." he began, his voice faltering. He looked at her, his green eyes filled with sorrow. "I am your father."

Bella staggered back, her eyes wide. "No... that's not true," she muttered, shaking her head in disbelief. "That's impossible."

"Search your feelings, Bella. You know it to be true."

Tears welled up in Bella's eyes. The truth was harder to accept than any fight she had faced. Her father, the man she had mourned, the man whose memory she had kept alive, was the leader of the fruit zombies.

"No... No!" she cried out, her voice echoing in the silence. But as she looked into his eyes, she saw the truth. The man before her was her father. And with that realization, her world shattered once again.""",
	
	7: """In a tense duel, Bella faced her father. Their eyes met, and the world around them seemed to slow.

"I never wanted this for you, Bella," Marcus rasped, his voice distorted by the pineapple that made up half his face.

"And I never wanted this for you, Dad!" Bella retorted, her grip tightening on her knives.

With a swift move, she aimed for the plant stem protruding from his chest. As she slashed, she shouted, "I am not your enemy! But if taking you down means saving humanity, then so be it!"

Marcus dodged, his movements still agile despite his transformation. "You've grown strong, Bella," he observed, his cold green eyes gleaming with a mix of pride and sorrow.

"I learned from the best," Bella replied, her voice steely. With a quick feint, she maneuvered around him, slicing the stem on her second attempt. "And it's time to prune!"

His green blood spilled, and as it did, Marcus slowly regained his humanity. As he staggered, he reached out to Bella, clutching her hand with a strength that belied his weakening state.

"Bella..." he gasped, the coldness in his eyes dissipating, replaced by the warmth Bella remembered from her childhood. "I'm... I'm sorry. I love you baby girl…aaarrgg!!!!"

The battle was over, but the cost was immeasurable. Bella had defeated the fruit zombie leader, but in doing so, she had lost her father once again.""",
	
	8: """Tears streamed down Bella's face as she held her father's hand, whispering back, "I love you too, Dad." Marcus's eyes closed, and he was gone. Bella was left in a world rid of fruit zombies but forever marked by their existence. Her journey had just begun.

As she stood there, holding her father's lifeless hand, Bella knew that her life would never be the same again. But she also knew that she had the strength to face whatever came her way, fueled by love, loss, and her incredible gift with a knife.

In the silence that followed, Bella looked up at the sky, the stars seemingly brighter than ever. "This is not the end," she murmured, her voice a mix of determination and sorrow. "This is just the beginning."

And with that, Bella walked away from the battlefield, her heart heavy but her resolve unbroken. The tale of fruit and flesh, of love and loss, would continue. And Bella, with her knives and wit, would face it head-on.

The world was safe from the fruit zombie menace, but Bella's personal battle was far from over. She had to find a way to move forward, to honor her father's memory, and to find her own path in a world that had been forever changed.""",
	
	9: """After the great fruit battle, Bella found herself in a world that was just starting to peel itself from the painful rind of a traumatic past. Her life too had been squeezed out of its usual zest, and she decided to make a change. She decided to turn the tables and said, "Enough of these fruitless endeavors."

She hung up her fruit knives, proudly stating, "I'm done playing fruit ninja," and opted for the cleaver instead. She swapped her apple corer for a meat tenderizer, her citrus juicer for a meat thermometer, and said, "It's time to meat my destiny."

Diving headfirst into the world of meats, Bella became a butcher, a grill master, a meat chef. She handled each cut of meat with the same precision she once used for fruits, saying, "Every meat has its own marbling, just like every fruit has its seeds."

Soon, her name was seasoned across the culinary world, her unique meat dishes becoming the talk of the town. She introduced the world to the Carnivore Diet, stating, "I've had my fill of fruit salads; it's time for some meat and greet."

Bella found solace in her new life. The sizzle of a steak, the aroma of roasting chicken, the art of filleting a fish - it was a different kitchen, but Bella was still the chef. "From fruit tarts to hearty parts," she'd say with a smile, "cooking is an art."

As Bella stood in her kitchen one day, a sizzling steak in front of her, she looked out at the world that was healing and said, "We've all been in a bit of a pickle, but it's time to ketchup."

She raised her glass and said, "Here's to new beginnings, and may our lives be as well-done as this steak."

Bella's story continued, not as a fruit ninja, but as a meat chef, carving her own path in the world, one meat dish at a time. She had found her peace, her purpose, and her new beginning in the world of culinary arts."""
}

var current_chapter = 1
var scroll_speed = 50  # pixels per second
var scroll_tween: Tween

func _ready():
	# Get the current chapter from the GameManager
	current_chapter = GameManager.current_chapter
	
	# Set up the chapter transition
	setup_chapter(current_chapter)
	
	# Start the scrolling animation
	start_scrolling()
	
	# Start the continue prompt animation
	_animate_continue_prompt()

func setup_chapter(chapter_number: int):
	current_chapter = chapter_number
	var chapter_info = get_chapter_info(chapter_number)
	
	# Create the full text with chapter info at the beginning
	var full_text = "[center][b]CHAPTER %d: %s[/b][/center]\n\n%s" % [
		chapter_number, 
		chapter_info.name, 
		chapter_stories[chapter_number]
	]
	
	scrolling_text.text = full_text
	
	# Set up the storyboard background based on chapter
	setup_storyboard_background(chapter_number)

func get_chapter_info(chapter_number: int):
	# Use GameManager's chapter data instead of local data
	return GameManager.get_chapter_info(chapter_number)

func setup_storyboard_background(chapter_number: int):
	# Hide all background elements first

	var story_background = $StoryBackground
	for child in story_background.get_children():
		if child is ColorRect:
			child.visible = false
		elif child is Node2D:
			child.visible = false
			# Also hide children of Node2D
			for grandchild in child.get_children():
				if grandchild is ColorRect:
					grandchild.visible = false
	
	# Show appropriate background based on chapter
	match chapter_number:
		1:  # The Accident - Lab explosion
			story_background.get_node("LabBackground").visible = true
			story_background.get_node("LabEquipment").visible = true
			story_background.get_node("LabEquipment2").visible = true
			
		2:  # Fruit zombies rise - Dark battlefield
			story_background.get_node("BattlefieldBackground").visible = true
			story_background.get_node("BattlefieldDebris").visible = true
			story_background.get_node("BattlefieldDebris2").visible = true
			
		3:  # Bella's cooking show - Kitchen
			story_background.get_node("KitchenBackground").visible = true
			story_background.get_node("KitchenCounter").visible = true
			story_background.get_node("KitchenCounter2").visible = true
			story_background.get_node("FruitDecorations").visible = true
			
		4:  # Government agents - Office
			story_background.get_node("GovernmentOffice").visible = true
			story_background.get_node("OfficeDesk").visible = true
			story_background.get_node("OfficeChair").visible = true
			
		5:  # Combat journey - Battlefield
			story_background.get_node("BattlefieldBackground").visible = true
			story_background.get_node("BattlefieldDebris").visible = true
			story_background.get_node("BattlefieldDebris2").visible = true
			
		6:  # Father discovery - Dark battlefield
			story_background.get_node("BattlefieldBackground").visible = true
			story_background.get_node("BattlefieldDebris").visible = true
			story_background.get_node("BattlefieldDebris2").visible = true
			
		7:  # Final battle - Battlefield
			story_background.get_node("BattlefieldBackground").visible = true
			story_background.get_node("BattlefieldDebris").visible = true
			story_background.get_node("BattlefieldDebris2").visible = true
			
		8:  # Aftermath - Battlefield
			story_background.get_node("BattlefieldBackground").visible = true
			story_background.get_node("BattlefieldDebris").visible = true
			story_background.get_node("BattlefieldDebris2").visible = true
			
		9:  # Meat kitchen - New kitchen
			story_background.get_node("MeatKitchen").visible = true
			story_background.get_node("MeatCounter").visible = true
			story_background.get_node("MeatCounter2").visible = true

func start_scrolling():
	# Wait a moment for the text to be set
	await get_tree().process_frame
	
	# Set initial position at the bottom (text starts below the continue prompt area)
	var start_pos = scrolling_text.position
	scrolling_text.position = start_pos + Vector2(0, 1000)  # Start 1000 pixels below to clear the continue prompt area
	
	# Wait another frame for the text to be properly laid out
	await get_tree().process_frame
	
	# Create a tween to move the text upward (like Star Wars crawl)
	scroll_tween = create_tween()
	var end_pos = start_pos + Vector2(0, -1400)  # Move up 1400 pixels to clear the top
	scroll_tween.tween_property(scrolling_text, "position", end_pos, 60.0)  # 60 seconds duration (slower)
	scroll_tween.tween_callback(_on_scroll_complete)

func _on_scroll_complete():
	# When scrolling is complete, show the continue prompt
	continue_prompt.visible = true

func _input(event):
	if event.is_action_pressed("ui_accept"):  # Enter key
		_continue_to_level()

func _continue_to_level():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _animate_continue_prompt():
	# Show the continue prompt from the start
	continue_prompt.visible = true
	
	# Create a blinking effect for the continue prompt
	var tween = create_tween()
	tween.set_loops()  # Loop forever
	tween.tween_property(continue_prompt, "modulate", Color(0.5, 0.5, 0.5, 1), 0.8)
	tween.tween_property(continue_prompt, "modulate", Color(1, 1, 1, 1), 0.8) 
