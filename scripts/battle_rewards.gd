extends Control
class_name CombatRewards

#@onready var pick_a_card: PackedScene = preload("res://modules/pick_a_card/pick_a_card.tscn")
@onready var reward_button: PackedScene = preload("res://modules/reward_screen_button/reward_button.tscn")

@onready var rewards_v_container: VBoxContainer = $RewardsVContainer
@onready var rewards: VBoxContainer = %Rewards

var current_open_reward: RewardButton

### ASSETS ###
var card_icon = preload("res://assets/Map/temp-card-reward-icon-small.png") 
var card_text = "Pick a card..."
var credit_icon = preload("res://assets/Map/temp-shop-icon_small.png") #TODO: CHANGE THIS LOL
var credit_text = "%s Credit"

var card_reward_total_weight := 0.0
var card_rarity_weights := {
	Card.CardRarity.COMMON: 0.0,
	Card.CardRarity.UNCOMMON: 0.0,
	Card.CardRarity.RARE: 0.0
}

func _ready() -> void:
	add_card_reward()

func add_card_reward():
	var card_reward_button = reward_button.instantiate()
	card_reward_button.reward_icon = card_icon
	card_reward_button.reward_text = card_text
	card_reward_button.pressed.connect(_show_card_rewards)
	rewards.add_child.call_deferred(card_reward_button)

func _show_card_rewards():
	$RewardsVContainer.visible = false
	$PickACard.run_draft()
	await Events.card_chosen
	$RewardsVContainer.visible = true

func _hide_card_rewards():
	pass


func _on_continue_pressed():
	Events.battle_reward_continue.emit()
