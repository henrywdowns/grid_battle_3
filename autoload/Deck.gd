extends Node

### THIS SHOULD BE OBSOLETE! TIME TO PACK THIS ALL INTO A .TRES ###

### Still thinking about this one. I like the idea of manipulating your draft pool,
### then having to draft a deck out of it. Every battle feels tedious. Maybe every
### map stage though. Three stages, three drafts, three decks? Maybe the possibility
### to adjust your deck during the map, and everything goes back into your draft pool
### at the next stage?

### CHARACTER BASE STATS ###
var basic_attack: Card
var meta_deck: Array[Card] = []

### DRAFT POOLS ###
var draft_pool: Array[Card] = []
var reward_draftable_pool: Array[Card] = [] 

### DYNAMIC DECK STATS ###
var cards_per_hand := 5

func print_deck():
	print_debug(meta_deck)
