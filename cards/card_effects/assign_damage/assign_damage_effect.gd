extends CardEffect
class_name assign_damage

### Arguments Array Requirements:
	# Target Node2D
	# Damage int

func trigger_effect(arguments: Array,wildcard_dict: Dictionary={}) -> void:
	print("it's happening")
	print(arguments)
	for arg in arguments:
		print(arg)
		if arg is Node2D and wildcard_dict['damage']: #TODO: Once Enemies are properly classed, change Node2D to Enemy
			arg.receive_damage(wildcard_dict['damage'])
		else:
			print("Damage Assignment Error -- incorrect target or wildcard type")
