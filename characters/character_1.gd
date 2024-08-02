extends Node2D

### I've got a big (for me) rework ahead of me here. Now that I'm using the balance sheet paradigm,
### I don't need to store stats in the character. instead, I'll be using "character" scenes as a 
### directory to various assets. select a character, pull up requisite scene, find locations for 
### assets, store them in PlayerCharacter singleton for use throughout the game. 

var character_gridpoint: Marker2D
var character_coords: Vector2
var stats: Dictionary = {"HP":100,"basic_attack":"res://cards/basic_attacks/basic_attack.tres","move_delay":0.1}
var char_meta_data: Dictionary = {"Name":"Character 1","filename":"character_1"}
# Called when the node enters the scene tree for the first time.
@onready var current_health: int = stats.HP

func _ready() -> void:
	print("Starting Health: %s" % stats.HP)
	print("Basic Attack: %s" % stats.basic_attack)
	print("Move Delay: %s" % stats.move_delay)



### below pattern involves loading stats from central char location (PlayerCharacter.gd)... I want to store stats in each character when char is ###
### loaded, *send* those stats to central char location ###
#func load_stats() -> void:
	#stats.HP = CharacterStats.stat_list.HP
	#stats.basic_attack = CharacterStats.stat_list.basic_attack
	#stats.move_delay = CharacterStats.stat_list.move_delay
