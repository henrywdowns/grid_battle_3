extends Node2D

@export var group: ButtonGroup
var char_choice = null
@onready var char_select_buttons = group.get_buttons()

# Called when the node enters the scene tree for the first time.
func _ready():
	print(char_select_buttons)
	for i in len(char_select_buttons):
		var iterable_button = char_select_buttons[i]
		iterable_button.pressed.connect(func():button_behavior(i))
		print(iterable_button)
		print(i)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func button_behavior(index):
	index +=1
	char_choice = "character_%s" % index
	print(char_select_buttons[index-1])
	print("Char choice: ",char_choice)
	Global.selected_character = char_choice
	Global.selected_character_scene = "characters/%s.tscn" % char_choice
	$DebugChosenChar/DebugCharText.text = char_choice
	$Confirm.disabled = false

func _on_confirm_pressed():
	print(Global.selected_character)
	print(Global.selected_character_scene)
	send_char_info_to_global()
	Global.goto_scene("res://scenes/map.tscn")
	
func send_char_info_to_global():
	var char_res = load("res://characters/%s.tres" % char_choice)
	var char_stats = {}
	var basic_attack_card = char_res.basic_attack
	char_stats["HP"] = char_res.HP
	char_stats["basic_attack"] = char_res.basic_attack
	char_stats["move_delay"] = char_res.move_delay
	Global.meta_character_stats = char_stats
	Deck.basic_attack = basic_attack_card
	print(Global.meta_character_stats)
	print(Deck.basic_attack)
