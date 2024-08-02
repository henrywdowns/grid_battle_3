extends Node


### THIS IS JUST A PLACEHOLDER - SHOULD BE RESET AFTER CARD SELECTION ###
@onready var player_hand = Deck.meta_deck

func _ready():
	print("	player_hand node is ready.")
	print("	Player hand at ready -- ",player_hand)
	call_deferred("_initialize")

func _initialize():
	Events.card_played.connect(card_played)

func card_played(card):
	print(card.card_name)
	print(player_hand[0])
	if player_hand[0] == card.card_filename:
		player_hand.pop_front()
		print("Hand after card played: ", player_hand)
