extends Control

#TODO: Add a skip button. Limit number of drafts to length of draft pool

@onready var card_container = $DraftStuffHolder/Panel/CardContainer
@onready var temp_draft_pool: Array[Card]
var temp_pool_determined = false
var which_pool: String
var pool_card_names: Array

var toggled_card: Card
var draft_multiple_enabled = true

func _ready():
	print_debug("### DRAFT SCENE ###")
	print_debug("Cards in deck: ",len(Deck.meta_deck))
	Events.draft_card_toggled.connect(reserve_toggled_card)
	$".".position = Vector2(Global.viewport_width/2,Global.viewport_height/2)
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
	var cards_left = len(temp_draft_pool) # set to actual number of cards in pool
	var max_cards = min(3, cards_left) # pick whichever is smaller. most options a draft can have
	print_debug("Cards left: ",cards_left,"\nMax cards: ",max_cards)
	if cards_left > 0:
		var card_pack = [] # hold previously selected cards for the pack
		for i in range(max_cards):
			var random_card := randi_range(0,len(temp_draft_pool)-1)
			var safeguard = 0
			while random_card in card_pack:
				safeguard += 1
				if safeguard == 20:
					print_debug("error: duplicate cards in pack")
					return
				random_card = randi_range(0,len(temp_draft_pool)-1)
			card_pack.append(random_card)
			gen_card(temp_draft_pool[random_card])
	else:
		print_debug("This would have probably thrown an error")

func draft_multiple(rounds: int=1):
	print_debug("### DRAFT MULTIPLE ###")
	var card_count = 0
	var max_rounds = rounds
	if rounds > len(temp_draft_pool):
		max_rounds = len(temp_draft_pool)
	while card_count < max_rounds:
		card_count += 1
		draft_cards()
		await Events.card_chosen
	Events.draft_over.emit()
	print_debug("### END DRAFT ###")
	$".".queue_free()

func add_card_to_deck(card_res: Card):
	Deck.meta_deck.append(card_res)
	if which_pool == "draft_reward": # add draft reward cards to the pool. don't add cards chosen from the pool into the pool as duplicates.
		Deck.draft_pool.append(card_res)

func determine_pool(selected_pool = "draft_reward"):
	match selected_pool:
		"draft_reward":
			which_pool = "draft_reward"
			temp_draft_pool = Deck.reward_draftable_pool.duplicate()
		"map_draft":
			temp_draft_pool = Deck.draft_pool.duplicate()
		_:
			print_debug("Error -- invalid draft pool")
	temp_pool_determined = true
	if len(temp_draft_pool) > 0:
		for cardname in temp_draft_pool:
			if cardname is Card:
				pool_card_names.append(cardname.card_name)
	print_debug("### POOL DETERMINED ###\n",len(temp_draft_pool))
	print_debug("	",pool_card_names)

### CONFIRM BUTTON BEHAVIOR ###

func reserve_toggled_card(toggled_card_button: Card):
	toggled_card = toggled_card_button
	print_debug("Toggled card: ",toggled_card.card_name, " -- Toggled card button: ",toggled_card_button)

func _on_confirm_card_button_up():
	if toggled_card:
		add_card_to_deck(toggled_card)
		if which_pool != "draft_reward": # ensures you can receive more than one of the same card, but you can't draft each card object twice
			temp_draft_pool.erase(toggled_card)
		print_debug("Cards in deck: ",len(Deck.meta_deck))
		var open_cards = card_container.get_children()
		for cards in open_cards:
			cards.queue_free()
		Events.card_chosen.emit()
		toggled_card = null
	
