extends Control

### TODO ###
# Make sure controls are inactive when window is closed
# Menu navigation should include keys and probably mouse
# Send drawn cards to tentative hand and vice versa
# Handle card zone changes between tentative hand, drawn cards, player hand, and discard pile
# Populate card nodes/images in UI when drawn

### INTENT ###
# MMBN-style card selection that pauses the battle every so often to "draw" new cards.
# This taps a duplicate of Deck.meta_deck for available cards, then draws 5 random cards. 
# player_hand.gd will depend on this node to pass hand info into battle

### UI VARIABLES ###
var open_hand_available := false
var current_time: float = 0.0
var card_ui_open := false
@onready var drawn_cards_container := $MainPanel/DrawnPContainer/DrawnCards

### CARD SELECTION/MANIPULATION VARIABLES ###
@onready var cards_in_deck = Deck.meta_deck.duplicate() # full list of cards in drafted deck
@onready var discard_pile: Array[Card] # cards that were spent or not chosen on submit
@onready var drawn_cards: Array[Card] # cards that were drawn but not yet selected
@onready var tentative_hand: Array[Card] # cards you've selected pre-submit
@export var refilling_hand: bool = false # changes to true on 0, preventing card draw for a turn.
@onready var base_card_scene = preload("res://cards/abridged_card.tscn")

### PLAYER HAND NODE ###
@onready var player_hand_node: Node

func _ready():
	z_index = 15
	$".".visible = false
	print("Visibility: ",$".".visible)
	$".".process_mode = Node.PROCESS_MODE_ALWAYS
	print_debug($".".process_mode)
	init_timer()
	open_selector()
	_init_deck_stuff()

func _input(_event):
	#if Input.is_action_just_pressed("Pause"):
		#print_debug("Pausing...")
		#pause_game()
	if Input.is_action_just_pressed("Open Hand") and open_hand_available:
		open_selector()

func _process(_delta):
	if !$CardTimer.is_stopped():
		$CardTimer/TimerLabel.text = str(snapped($CardTimer.time_left,0.01))

### CARD SELECTOR BEHAVIOR ###
func open_selector():
	print_debug("Opening selector")
	draw_cards()
	populate_cards_in_selector()
	pause()

func _on_card_timer_timeout():
	open_hand_available = true
	refill_hand()
	$CardTimer/TimerLabel.text = "Hand reset ready"

func populate_cards_in_selector():
	for drawn_card in drawn_cards: # iterate through drawn_cards array
		assert(drawn_card is Card) # confirming drawn_card is Card class
		var card_instance = base_card_scene.instantiate()
		card_instance.make_card(drawn_card)
		drawn_cards_container.add_child(card_instance)

func swap_containers(some_card: Node):
	print_debug("card signal received") # connected to Events.card_ui_card_clicked
	var destination: Container # anon variable. will be the drawn cards or chosen hand containers
	var tentative_hand_container = $MainPanel/ChosenPContainer/ChosenHand
	### TODO: CHECK_VALID() FUNC TO SEE IF CARD MEETS CONSTRAINTS BASED ON CHOSEN HAND
	match some_card.get_parent(): # wherever the card already is, set destination to the other, and then change card data zones accordingly
		tentative_hand_container:
			destination = $MainPanel/DrawnPContainer/DrawnCards
			change_card_zone(some_card,tentative_hand,drawn_cards)
		drawn_cards_container:
			destination = $MainPanel/ChosenPContainer/ChosenHand
			change_card_zone(some_card,drawn_cards,tentative_hand)
		_:
			print_debug("issue with container")
		
	some_card.reparent(destination) # send the card node to destination
	print_debug(some_card," has been reparented to ",some_card.get_parent().name)
	print_debug("Tentative Hand: ",tentative_hand,"\nDrawn Cards: ",drawn_cards,"\nDiscard Pile: ",discard_pile,"\nPlayer Hand: ",player_hand_node.player_hand)

### BUTTON BEHAVIOR ###

func _on_submit_hand_button_up():
	chosen_hand_cleanup()
	resume()
	Events.card_ui_debug_update_cards.emit()
	$CardTimer/TimerLabel.text = str($CardTimer.wait_time)
	print_debug($CardTimer.wait_time)
	$CardTimer.start()
	print_debug($CardTimer.is_stopped())
	print_debug("Timer started")
	open_hand_available = false

### TIMER BEHAVIOR ###

func init_timer():
	$CardTimer.wait_time = 5
	$CardTimer.one_shot = true
	print_debug("Timer initiated")

### PAUSE BEHAVIOR ###

func resume():
	print_debug("Resume game: ",get_tree().paused)
	$".".visible = false
	get_tree().paused = false
	print_debug("Resume game 2: ",get_tree().paused)
	print_debug("Visibility: ",$".".visible)
	card_ui_open = false

func pause():
	print_debug("Pause: ",get_tree().paused)
	$".".visible = true
	get_tree().paused = true
	print_debug("Pause 2: ",get_tree().paused)
	print_debug("Visibility: ",$".".visible)
	card_ui_open = true

func pause_game():
	print_debug("Pause game: ",get_tree().paused)
	if Input.is_action_just_pressed("Pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("Pause") and get_tree().paused:
		resume()
	print_debug("Pause game 2: ",get_tree().paused)
	print_debug("Visibility: ",$".".visible)

### CARD DRAW/MANIPULATION BEHAVIOR ###

func _init_deck_stuff():
		cards_in_deck.shuffle() # I think this will get called after i make cards_in_deck so need to find a better home
		Events.card_ui_card_clicked.connect(swap_containers)
		Events.card_played.connect(discard_played_card)

func draw_cards(hand_size = Deck.cards_per_hand):
	for drawn_card in hand_size:
		assert(len(cards_in_deck) >= 0)
		if refilling_hand == false:
			if len(cards_in_deck) > 0:
				var adding_card = cards_in_deck.pop_front()
				if adding_card != null:
					drawn_cards.append(adding_card)

	print_debug("Drawn cards: ",drawn_cards)

func shuffle_deck():
	print_debug("Cards in discard: ",len(discard_pile))
	for discarded_card in len(discard_pile):
		cards_in_deck.append(discard_pile.pop_front())
	cards_in_deck.shuffle()
	print_debug("Deck shuffled. Cards in deck: ",len(cards_in_deck)," Cards in discard: ",len(discard_pile))

func refill_hand():
	print("AAAAAAA REFILL PLEASE")
	if refilling_hand == true:
		shuffle_deck()
		refilling_hand = false
	else:
		refilling_hand = true
	print_debug(len(cards_in_deck))
	
	# Right now the plan is to force player to wait a whole turn with no cards in hand.
	# Deck will be back to full the turn after.

func discard_played_card(discarded_card:Card):
	discard_pile.append(discarded_card)
	print_debug(len(discard_pile))

func change_card_zone(some_card: Node, starting_location: Array[Card],destination: Array[Card]):
	var some_card_data: Card = some_card.card_data
	assert(destination in [drawn_cards,tentative_hand,player_hand_node.player_hand,discard_pile,cards_in_deck])
	assert(starting_location != destination)
	print_debug("Transferring card %s from starting location %s to destination %s" % [some_card.name,starting_location,destination])
	var temp_card_placeholder = some_card_data # hold some_card here so we can ensure no duplication
	#starting_location.erase(some_card_data)
	#destination.append(temp_card_placeholder)
	destination.append(starting_location.pop_at(starting_location.find(some_card_data))) # find index of chosen card and pop that into destination
	print_debug("Card in starting_location: ",some_card_data in starting_location,"\nCard in destination: ",some_card_data in destination)

func chosen_hand_cleanup():
	print_debug("Cleaning up hand. Tentative hand: ",tentative_hand)
	# Send chosen hand to actual hand, remove drawn cards from hand for next time. Trigger with submit button
	
	while tentative_hand.size()>0:
		var selected_card=tentative_hand.pop_front() # pop the first element
		assert(selected_card is Card)
		player_hand_node.player_hand.append(selected_card) # append to player_hand
	
	while drawn_cards.size()>0:
		var unselected_card=drawn_cards.pop_front() # pop the first element
		assert(unselected_card is Card)
		discard_pile.append(unselected_card) # append to discard_pile
	
	for card_inst in $MainPanel/ChosenPContainer/ChosenHand.get_children()+$MainPanel/DrawnPContainer/DrawnCards.get_children():
		assert(card_inst is AbridgedCardNode)
		card_inst.queue_free()
	
	print_debug("Player hand after cleanup: ",player_hand_node.player_hand)

func check_valid_card_choice(some_card:Card):
	pass
	# TODO: Need this to check arcana compatibility before changing card zones
