extends Node

### THIS SHOULD BE OBSOLETE! TIME TO PACK THIS ALL INTO A .TRES ###

### Still thinking about this one. I like the idea of manipulating your draft pool,
### then having to draft a deck out of it. Every battle feels tedious. Maybe every
### map stage though. Three stages, three drafts, three decks? Maybe the possibility
### to adjust your deck during the map, and everything goes back into your draft pool
### at the next stage?

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

var basic_attack: Card
var meta_deck: Array[Card] = []
func print_deck():
	print(meta_deck)
