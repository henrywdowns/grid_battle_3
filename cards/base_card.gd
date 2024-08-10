extends Control

var card_data:Card

func _ready():
	#make_card("res://cards/attack_1.tres")
	pass

func make_card(carddata):
	card_data = carddata
	var card_colors = {
		0:"#7c2327",
		1:"#104624",
		2:"#6891b7",
		3:"#e3d5eb"
	}
	$ColorRect.color = card_colors[card_data.card_type]
	$CardName.text = card_data.card_name
	$CardDesc.text = card_data.card_desc
	$CardArc.text = card_data.card_arcana_str
	# $CardType.text = card.card_type_list[card.card_type] for some reason this doesn't work

func _on_card_select_toggled(_toggled_on):
	Events.draft_card_toggled.emit(card_data)
