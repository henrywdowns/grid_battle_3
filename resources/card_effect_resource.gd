extends Resource
class_name CardEffect

func trigger_effect(card,optional_param: Variant = null) -> void:
	print(card)
	if optional_param is int:
		print("int: ",optional_param)
	if optional_param is String:
		print("string: ",optional_param)
	else:
		print("no optional param")
