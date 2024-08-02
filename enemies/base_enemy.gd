extends Node2D

var enemy_data:Enemy
var enemy_hp: int
var enemy_name: String
var has_death_trigger: bool = false

func _ready():
	pass

func generate_enemy(enemy_tres):
	var enemy = load("res://enemies/%s.tres" % enemy_tres)
	enemy_data = enemy
	enemy_hp = enemy_data.enemy_hp
	enemy_name = enemy_data.enemy_name
	$EnemyRect.color = enemy_data.enemy_color
	$EnemyHP.text = str(enemy_hp)
	print("Enemy -- Name: %s -- HP: %s" % [enemy_name,enemy_hp])

func receive_damage(damage_amount):
	if enemy_hp-damage_amount <= 0:
		enemy_hp = 0
		enemy_killed()
	else:
		enemy_hp -= damage_amount
	$EnemyHP.text = str(enemy_hp)
	
func enemy_killed():
	if $DeathTrigger:
		$DeathTrigger.trigger_death()
	Events.i_died.emit(self)
	self.queue_free()
