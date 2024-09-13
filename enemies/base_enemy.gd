extends Node2D
class_name BaseEnemy

### ENEMY INIT VARS ###
var enemy_data:Enemy
var enemy_hp: int
var enemy_name: String
var is_dead = false
var has_death_trigger: bool = false
var enemy_coords: Vector2 #TODO: UPDATE ENEMY_COORDS ON MOVE AND SPAWN
var can_combat: bool = true
var can_move: bool = true

### COMBAT & MOVEMENT VARS ###
@export var movement_pattern: MovementBehavior
@export var combat_pattern: CombatBehavior # may want to change how I do this so that I can have several combat patterns


func _ready():
	movement_pattern.enemy_node = self
	combat_pattern.enemy_node = self
	$CombatTimer.wait_time = enemy_data.combat_wait_time
	$MovementTimer.wait_time = enemy_data.movement_wait_time

func generate_enemy(enemy_tres):
	var enemy = load("res://enemies/%s.tres" % enemy_tres)
	enemy_data = enemy
	enemy_hp = enemy_data.enemy_hp
	enemy_name = enemy_data.enemy_name
	$EnemyHP.text = str(enemy_hp)
	print_debug("Enemy -- Name: %s -- HP: %s" % [enemy_name,enemy_hp])

func receive_damage(damage_amount):
	if enemy_hp-damage_amount <= 0:
		enemy_hp = 0
		enemy_killed()
	else:
		enemy_hp -= damage_amount
	$EnemyHP.text = str(enemy_hp)
	
func enemy_killed():
	is_dead = true
	$AnimationPlayer.play("death_animation")
	$AnimatedSprite2D.pause()
	await $AnimationPlayer.animation_finished
	if has_node("DeathTrigger"):
		$DeathTrigger.trigger_death()
	Events.i_died.emit(self)
	self.queue_free()


### COMBAT / MOVEMENT BEHAVIOR ###
func _on_combat_timer_timeout() -> void:
	combat_pattern._combat_pattern(self)

func _on_movement_timer_timeout() -> void:
	movement_pattern._movement_pattern(self)
