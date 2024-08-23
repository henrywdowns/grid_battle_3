extends Control

@export var group: ButtonGroup
var char_choice = null
@onready var char_select_buttons = group.get_buttons()


func _ready():
	for i in len(char_select_buttons):
		var iterable_button = char_select_buttons[i]
		iterable_button.pressed.connect(func():button_behavior(i))

func _process(_delta):
	pass

func button_behavior(index):
	index +=1
	char_choice = "character_%s" % index
	print_debug("Char choice: ",char_choice)
	Global.selected_character = char_choice
	Global.selected_character_tres = "characters/%s.tres" % char_choice
	$DebugChosenChar/DebugCharText.text = char_choice
	$Confirm.disabled = false

func _on_confirm_pressed():
	print_debug(Global.selected_character," selected.")
	send_char_info_to_global()
	Global.goto_scene("res://scenes/map.tscn")
	
func send_char_info_to_global(): # this is obsolete and I should be passing the character resource
	var char_res = load("res://characters/%s.tres" % char_choice)
	var char_stats = {}
	var basic_attack_card = char_res.basic_attack
	char_stats["HP"] = char_res.HP
	char_stats["basic_attack"] = char_res.basic_attack
	char_stats["move_delay"] = char_res.move_delay
	Deck.draft_pool = char_res.default_deck
	Deck.reward_draftable_pool = char_res.draftable_pool
	Global.meta_character_stats = char_stats
	Global.char_res = char_res
	Deck.basic_attack = basic_attack_card
