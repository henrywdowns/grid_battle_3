extends Node


### THIS IS JUST A PLACEHOLDER - SHOULD BE RESET AFTER CARD SELECTION ###
@onready var player_hand = Deck.meta_deck

func _ready():
	call_deferred("_initialize")

func _initialize():
	Events.card_played.connect(card_played)

func card_played(card):
	print("Player hand from before: %s" % player_hand)
	print(card.card_name)
	print(player_hand[0])
	if player_hand[0] == card.card_filename:
		player_hand.pop_front()
		print("Player hand from after: ", player_hand)
