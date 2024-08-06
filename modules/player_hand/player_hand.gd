extends Node


### THIS IS A PLACEHOLDER FOR HAND SELECTION - PLAYER SHOULD CHOOSE CARDS LIKE MMBN CHIPS ###
@onready var player_hand = Deck.meta_deck.duplicate()

func _ready():
	print("	player_hand node is ready.")
	print("	Player hand at ready -- ",player_hand)
	call_deferred("_initialize")

func _initialize():
	Events.card_played.connect(card_played)

func card_played(card):
	print(card.card_name)
	if player_hand and player_hand[0]:
		print(player_hand[0])
		if player_hand[0] == card:
			player_hand.pop_front()
			print("Hand after card played: ", player_hand)
	else:
		print("No hand")

func refill_hand():
	pass
	# Right now the plan is to force player to wait a whole turn with no cards in hand.
	# Deck will be back to full the turn after. 
