extends Node2D

var enemy_data:Enemy
var enemy_hp: int
var enemy_name: String

func _ready():
	pass

func generate_enemy(enemy_tres):
	print("res://enemies/%s.tres" % enemy_tres)
	var enemy = load("res://enemies/%s.tres" % enemy_tres)
	enemy_data = enemy
	enemy_hp = enemy_data.enemy_hp
	enemy_name = enemy_data.enemy_name
	$EnemyRect.color = enemy_data.enemy_color
	$EnemyHP.text = str(enemy_hp)
	print("Enemy -- Name: %s -- HP: %s" % [enemy_name,enemy_hp])
