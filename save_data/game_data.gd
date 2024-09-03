extends Node


### INTENT ###
# Where I want game data to live in-game. It can save and load data and it will back 
# itself up with the actual save data. Centralizing this should make it easier to 
# track what needs saving as well as allowing it to be accessed easily without abusing autoloads.

### CHARACTER ###
var selected_character: character
var meta_character_stats = {}
var basic_attack: Card

### GAME STATE ###
var run_seed
var current_encounter: int = 0
var current_level: int = 0
var elapsed_time

### INVENTORY ###
var current_draft_pool: Array[Card]
var current_drafted_deck: Array[Card]

func _ready():
	Events.character_selected.connect(update_character_data)

### IN-GAME DATA COLLECTION/MANAGEMENT ###
func update_character_data(char_res: character):
	assert(char_res is character)
	selected_character = char_res
	basic_attack = selected_character.basic_attack
	meta_character_stats["HP"] = char_res.HP
	meta_character_stats["basic_attack"] = char_res.basic_attack
	meta_character_stats["move_delay"] = char_res.move_delay

### SAVE/LOAD FUNCTIONALITY ###

func save_game(): ### WIP ### https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
	# 1: Initialize the save file
	var save_file = FileAccess.open("user://save_game.json", FileAccess.WRITE)
	# 2: Collect game data into a dictionary
	var save_data: Dictionary = {
		### CHARACTER ###
		"selected_character": selected_character,
		"meta_character_stats":meta_character_stats,
		"basic_attack":basic_attack,
		### GAME STATE ###
		"current_encounter":current_encounter,
		"current_level":current_level,
		"elapsed_time":elapsed_time,
		### INVENTORY ###
		"current_draft_pool":current_draft_pool,
		"current_drafted_deck":current_drafted_deck
	}
	# 3: Serialize dict into JSON
	var json_save_data = JSON.stringify(save_data)
	
	
func load_game():
	pass
