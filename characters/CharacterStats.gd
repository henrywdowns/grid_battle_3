class_name CharacterStats
extends Resource

@export var HP: int = 100
@export var basic_attack: int = 5
@export var move_delay: float = 0.1
@export var starting_health: int = HP

enum stat_list {HP,basic_attack,move_delay,starting_health}

func reset_char():
	HP = 100
	basic_attack = 5
	move_delay = 0.1
	starting_health = HP
