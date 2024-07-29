extends CardEffect
class_name attack_1

func trigger_effect(card,optional_param: Variant = null) -> void:
	print("Triggered by %s -- the resource script works!" % card.card_name)
	if optional_param is int:
		print("int: ",optional_param)
	if optional_param is String:
		print("string: ",optional_param)
	else:
		print("no optional param")
