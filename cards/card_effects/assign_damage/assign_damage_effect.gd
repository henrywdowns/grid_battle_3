extends CardEffect
class_name assign_damage

### Arguments Array Requirements:
	# Target Node2D
	# Damage int

func trigger_effect(arguments: Array,wildcard_dict: Dictionary={}) -> void:
	for arg in arguments:
		if arg is Node2D and wildcard_dict['damage']: #TODO: Once Enemies are properly classed, change Node2D to Enemy
			arg.receive_damage(wildcard_dict['damage'])
		else:
			print("Damage Assignment Error -- incorrect target or wildcard type")
