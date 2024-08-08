extends Control

#TODO: Add a skip button. Limit number of drafts to length of draft pool

@onready var card_container = $Panel/CardContainer
@onready var temp_draft_pool: Array[Card]
var temp_pool_determined = false

var toggled_card: Card
var draft_multiple_enabled = true

func _ready():
	print("### DRAFT SCENE ###")
	print("Cards in deck: ",len(Deck.meta_deck))
	Events.draft_card_toggled.connect(reserve_toggled_card)
	if !temp_pool_determined:
		determine_pool()

func _process(_delta):
	pass

### BASE CARD BEHAVIOR ###

func gen_card(card: Card):
	var card_res = card
	if card_res:
		var card_instance = preload("res://cards/base_card.tscn").instantiate()
		card_container.add_child(card_instance)
		card_instance.make_card(card_res)

### ACTUAL DRAFT BEHAVIOR ###

func draft_cards():
	var cards_left = len(temp_draft_pool)
	# Right now if there are less than 3 cards, the same card populates several times. Need to set
	# a max of 3, but if fewer than 3 cards in the pool, I need to lower that max to cards left.
	if cards_left > 2:
		cards_left = 3
	if cards_left > 0:
		var card_pack = [] # hold previously selected cards for the pack
		for i in cards_left:
			var random_card := randi_range(0,len(temp_draft_pool)-1)
			var safeguard = 0
			while random_card in card_pack:
				safeguard += 1
				if safeguard == 5:
					print("error")
					return
				random_card = randi_range(0,len(temp_draft_pool)-1)
			card_pack.append(random_card)
			gen_card(temp_draft_pool[random_card])
	else:
		print("This would have probably thrown an error")

func draft_multiple(rounds: int=1):
	print("### DRAFT MULTIPLE ###")
	var card_count = 0
	var max_rounds = rounds
	if rounds > len(temp_draft_pool):
		max_rounds = len(temp_draft_pool)
	while card_count < max_rounds:
		#if card_count > len(temp_draft_pool): # This is probably totally unnecessary safeguarding against an infinite loop
			#return
		card_count += 1
		draft_cards()
		await Events.card_chosen
	Events.draft_over.emit()
	print("### END DRAFT ###")
	$".".queue_free()

func add_card_to_deck(card_res: Card):
	Deck.meta_deck.append(card_res)
	Deck.draft_pool.append(card_res)

func determine_pool(selected_pool = "draft_reward"):
	match selected_pool:
		"draft_reward":
			temp_draft_pool = Deck.reward_draftable_pool.duplicate()
		"map_draft":
			temp_draft_pool = Deck.draft_pool.duplicate()
		_:
			print("Error -- invalid draft pool")
	temp_pool_determined = true
	print("### POOL DETERMINED ### ",temp_draft_pool)

### CONFIRM BUTTON BEHAVIOR ###

func reserve_toggled_card(toggled_card_button: Card):
	print(toggled_card_button)
	toggled_card = toggled_card_button
	print("Toggled card: ",toggled_card.card_name)

func _on_confirm_card_button_up():
	if toggled_card:
		add_card_to_deck(toggled_card)
		temp_draft_pool.erase(toggled_card)
		print("Cards in deck: ",len(Deck.meta_deck))
		var open_cards = $Panel/CardContainer.get_children()
		for cards in open_cards:
			cards.queue_free()
		Events.card_chosen.emit()
	
