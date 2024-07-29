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
@export var effect_string: String
@export var effect_int: int

var card_type_str = card_type_list[card_type]
var card_arcana_str = card_arcana_list[card_arcana]

@export var unique_card_effects: Array[CardEffect]
func unique_effect():
	print(unique_card_effects)
	print("Triggering unique effect (card_resource.gd)")
	for effect in unique_card_effects:
		print("effect: ",effect)
		#print(effect.get_method_list())
		#if effect.has_method("trigger_effect"):
		print("effect detected")
		effect.trigger_effect(self,effect_int)
