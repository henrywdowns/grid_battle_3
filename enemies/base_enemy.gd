extends Node2D
class_name BaseEnemy

### TODO: IMPLEMENT TEST_PRINT_EXECUTION.TRES

### ENEMY INIT VARS ###
var enemy_data:Enemy
var enemy_hp: int
var enemy_name: String
var is_dead = false
var has_death_trigger: bool = false
var enemy_coords: Vector2 #TODO: UPDATE ENEMY_COORDS ON MOVE AND SPAWN
var can_combat: bool = true
var can_move: bool = true

### TIMER STUFF ###

var init_timer: bool = true
var combat_timer: float = 0.0
var combat_elapsed: float = 0.0
var movement_timer: float = 0.0
var movement_elapsed: float = 0.0

### COMBAT & MOVEMENT VARS ###
@export var execution_pattern: EnemyExecution
@export var movement_pattern: MovementBehavior
@export var combat_pattern: Array[CombatBehavior] # may want to change how I do this so that I can have several combat patterns

func _ready():
	call_deferred("_assign_movement_and_combat")
	
func _process(_delta):
	combat_elapsed += _delta
	movement_elapsed += _delta
	if enemy_data.combat_logic and combat_elapsed > combat_timer:
		combat_elapsed = 0.0
		enemy_data.combat_logic._action_pattern(self)
		await enemy_data.combat_logic.attack_complete
	if enemy_data.movement_logic and movement_elapsed > movement_timer:
		movement_elapsed = 0.0
		enemy_data.movement_logic._action_pattern(self)

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

func _assign_movement_and_combat():
	if enemy_data.movement_logic:
		enemy_data.movement_logic.enemy_node = self
		#print(enemy_data.movement_logic.test_node)
	if enemy_data.combat_logic:
		enemy_data.combat_logic.enemy_node = self
	#print(enemy_data.combat_wait_time)
	#print(enemy_data.movement_wait_time)
	combat_timer = enemy_data.combat_wait_time
	movement_timer = enemy_data.movement_wait_time
