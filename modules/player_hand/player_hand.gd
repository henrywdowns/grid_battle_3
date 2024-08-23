extends Node


### INTENT ###
# When hand is submitted in card_ui, this takes the submitted hand and makes it available in battle.

@onready var player_hand: Array[Card]

func _ready():
	print_debug("	player_hand node is ready.")
	print_debug("	Player hand at ready -- ",player_hand)
	call_deferred("_initialize")

func _initialize():
	Events.card_played.connect(card_played)

### CARD BEHAVIOR ###

func card_played(card):
	print_debug(card.card_name)
	if player_hand and player_hand[0]:
		print_debug(player_hand[0])
		if player_hand[0] == card:
			player_hand.pop_front()
			print_debug("Hand after card played: ", player_hand)
	else:
		print_debug("No hand")
