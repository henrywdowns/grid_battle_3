extends AIBehavior
class_name CombatBehavior

@export var attack_array: Array[Card] # if enemy has multiple attacks to cycle through, use this
@export var single_attack: Card # if enemy just repeats one attack, use this

func _ready():
	combat_or_movement = CombatOrMovement.COMBAT


### COMBAT METHODS ###
func _basic_attack(enemy_attack):
	
