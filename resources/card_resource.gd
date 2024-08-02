extends Resource
class_name Card

enum CardType { ATTACK, DEFENSE, SUPPORT, OTHER }
enum CardArcana {
	FOOL,
	MAGICIAN,
	HIGH_PRIESTESS,
	EMPRESS,
	EMPEROR,
	HIEROPHANT,
	LOVERS,
	CHARIOT,
	STRENGTH,
	HERMIT,
	WHEEL_OF_FORTUNE,
	JUSTICE,
	HANGED_MAN,
	DEATH,
	TEMPERANCE,
	DEVIL,
	TOWER,
	STAR,
	MOON,
	SUN,
	JUDGEMENT,
	WORLD
}

enum TargetType { 
	HITSCAN, 
	PROJECTILE, 
	AREA, 
	SELF, 
	NONE, 
	PIERCE, 
	TARGET_ALREADY_PROVIDED, 
	MULTI_TARGETS_PROVIDED, 
	CHAIN, 
	LINE, 
	SPLIT, 
	RANDOM, 
	NEAREST, 
	FURTHEST }

var card_arcana_list = [
	"fool",
	"magician",
	"high_priestess",
	"empress",
	"emperor",
	"hierophant",
	"lovers",
	"chariot",
	"strength",
	"hermit",
	"wheel_of_fortune",
	"justice",
	"hanged_man",
	"death",
	"temperance",
	"devil",
	"tower",
	"star",
	"moon",
	"sun",
	"judgement",
	"world"
]

var card_type_list = [
	"attack",
	"defense",
	"support",
	"other"
]

@export var card_name: String
@export var card_desc: String
@export var card_type: CardType
@export var card_arcana: CardArcana
@export var card_filename: String
@export var arguments: Array
@export var targeting: TargetType
@export var flex_dict: Dictionary = {
	'damage': 0,
	'healing':0,
	'block':0
}

var card_type_str = card_type_list[card_type]
var card_arcana_str = card_arcana_list[card_arcana]

@export var unique_card_effects: Array[CardEffect]

func unique_effect(targets: Array):
	print("	### UNIQUE_EFFECT ###")
	arguments = targets
	print("Unique card effects -- ",unique_card_effects," -- Targets -- ",arguments)
	if len(unique_card_effects) > 0:
		for effect in unique_card_effects:
			print("effect: ",effect)
			if effect.has_method("trigger_effect"):
				effect.trigger_effect(arguments,flex_dict)
			else:
				print("Error card has no trigger")
	else:
		print("No effects!")
