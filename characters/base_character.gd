extends Node2D

### I've got a big (for me) rework ahead of me here. Now that I'm using the balance sheet paradigm,
### I don't need to store stats in the character. instead, I'll be using "character" scenes as a 
### directory to various assets. select a character, pull up requisite scene, find locations for 
### assets, store them in PlayerCharacter singleton for use throughout the game. 

@onready var character_gridpoint: Marker2D
@onready var character_coords: Vector2 = Vector2(1,1)

func _ready() -> void:
	pass



### below pattern involves loading stats from central char location (PlayerCharacter.gd)... I want to store stats in each character when char is ###
### loaded, *send* those stats to central char location ###
#func load_stats() -> void:
	#stats.HP = CharacterStats.stat_list.HP
	#stats.basic_attack = CharacterStats.stat_list.basic_attack
	#stats.move_delay = CharacterStats.stat_list.move_delay
