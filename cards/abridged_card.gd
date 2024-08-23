extends Control

var card_data:Card

func _ready():
	pass

func make_card(carddata):
	card_data = carddata
	var card_colors = {
		0:"#7c2327",
		1:"#104624",
		2:"#6891b7",
		3:"#e3d5eb"
	}
	$CardSelect.self_modulate = card_colors[card_data.card_type]
	$CardSelect/CardName.text = card_data.card_name
	#$CardSelect/CardDesc.text = card_data.card_desc
	$CardSelect/CardArc.text = card_data.card_arcana_str
	# $CardType.text = card.card_type_list[card.card_type] for some reason this doesn't work

func _on_card_select_button_up() -> void:
	print_debug("abridged card clicked")
	Events.card_ui_card_clicked.emit(self)
