extends Control

@onready var card_container = $Panel/CardContainer

var draft_pool = {
	"attack_1":{
		"path":"res://cards/attack_1.tres",
		"quantity":3
	},
	"attack_2":{
		"path":"res://cards/attack_2.tres",
		"quantity":3
	},
	"defense_1":{
		"path":"res://cards/defense_1.tres",
		"quantity":3
	},
	"defense_2":{
		"path":"res://cards/defense_2.tres",
		"quantity":3
	},
	"support_1":{
		"path":"res://cards/support_1.tres",
		"quantity":3
	},
	"support_2":{
		"path":"res://cards/support_2.tres",
		"quantity":3
	},
	"other_1":{
		"path":"res://cards/other_1.tres",
		"quantity":3
	},
	"other_2":{
		"path":"res://cards/other_2.tres",
		"quantity":3
	}
}

var toggled_card: Card
var draft_multiple_enabled = true

func _ready():
	#gen_card("other_1")
	#draft_cards()
	draft_multiple(3)
	Events.draft_card_toggled.connect(reserve_toggled_card)

func _process(delta):
	pass

func gen_card(card_name: String):
	var card_path = draft_pool[card_name]["path"]
	var card_res = load(card_path)
	if card_res:
		var card_instance = preload("res://cards/base_card.tscn").instantiate()
		card_container.add_child(card_instance)
		card_instance.make_card(card_path)

func draft_cards():
	var card_list = draft_pool.keys()
	for i in 3:
		var random_card = randi_range(0,len(card_list)-1)
		gen_card(card_list[random_card])

func draft_multiple(rounds: int=1):
	var card_count = 0
	while card_count < rounds:
		if card_count > 5:
			return
		card_count += 1
		draft_cards()
		await Events.card_chosen
	Events.draft_over.emit()
	$".".queue_free()

func add_card_to_deck(card_res: Card):
	Deck.meta_deck.append(card_res.card_name)
	print(Deck.meta_deck)

func reserve_toggled_card(toggled_card_button: Card):
	toggled_card = toggled_card_button
	print("Toggled card: ",toggled_card.card_name)

func _on_confirm_card_button_up():
	if toggled_card:
		add_card_to_deck(toggled_card)
		var open_cards = $Panel/CardContainer.get_children()
		for cards in open_cards:
			cards.queue_free()
		Events.card_chosen.emit()
	
