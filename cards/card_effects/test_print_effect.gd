extends CardEffect
class_name attack_1

func trigger_effect(arguments: Array,wildcard_dict: Dictionary={}) -> void:
	for arg in arguments:
		if arg is Node2D and wildcard_dict['damage']: #TODO: Once Enemies are properly classed, change Node2D to Enemy
			arg.receive_damage(wildcard_dict['damage'])
		else:
			print_debug("Damage Assignment Error -- incorrect target or wildcard type")
	print_debug("Attack_1 effect was triggered!")
