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
@export var c_timer_running: bool = false # just use one of these usually, but some enemies may need to track multiple kinds of actions at once
@export var m_timer_running: bool = false
@export var e_timer_running: bool = true
var combat_timer: float = 0.0 # how long should it take?
var combat_elapsed: float = 0.0 # the actual timer that counts up to timer
var movement_timer: float = 0.0
var movement_elapsed: float = 0.0
var execute_interval: float = 0.5 # time *in between* execute steps, not the timer length
var execute_timer: float = 2.0
var execute_elapsed: float = 0.0

func stop_timers() -> void:
	c_timer_running = false
	m_timer_running = false
	e_timer_running = false

func start_timers() -> void:
	c_timer_running = true
	m_timer_running = true
	e_timer_running = true

func reset_timers() -> void:
	combat_elapsed = 0.0
	movement_elapsed = 0.0
	execute_elapsed = 0.0

### COMBAT & MOVEMENT VARS ###
var execution_patterns: Array[EnemyExecution] # if several combat patterns or want to incorporate movement, use this
var movement_pattern: MovementBehavior
var combat_pattern: CombatBehavior

func _ready():
	call_deferred("_assign_movement_and_combat")
	
func _process(_delta):
	if c_timer_running:
		combat_elapsed += _delta
	if m_timer_running:
		movement_elapsed += _delta
	if e_timer_running:
		execute_elapsed += _delta
		$ExeTimer.text = str(snapped(execute_elapsed,0.01))
	if enemy_data.execution_logic and execute_elapsed > execute_timer:
		print_debug("executing...")
		stop_timers()
		reset_timers()
		### THIS NEEDS TO CHANGE TO BE MORE MODULAR ###
		execution_patterns[0].execute_combat_and_movement(self)
		await execution_patterns[0].execute_complete # i don't think this is necessary since i'm stopping the timers
		start_timers()
	elif enemy_data.combat_logic and combat_elapsed > combat_timer:
		combat_elapsed = 0.0
		enemy_data.combat_logic._action_pattern(self)
		await enemy_data.combat_logic.attack_complete
	elif enemy_data.movement_logic and movement_elapsed > movement_timer:
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
		movement_pattern = enemy_data.movement_logic
		enemy_data.movement_logic.enemy_node = self
	if enemy_data.combat_logic:
		combat_pattern = enemy_data.combat_logic
		enemy_data.combat_logic.enemy_node = self
	if enemy_data.execution_logic:
		assert(enemy_data.execution_logic is Array)
		execution_patterns = enemy_data.execution_logic
		for pattern in execution_patterns:
			pattern.enemy_node = self
	combat_timer = enemy_data.combat_wait_time
	movement_timer = enemy_data.movement_wait_time
