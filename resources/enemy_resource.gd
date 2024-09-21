extends Resource
class_name Enemy


@export var enemy_name: String
@export var enemy_hp: int

### COMBAT / MOVEMENT PARAMS ###
@export var combat_logic: Resource
@export var movement_logic: Resource
@export var combat_wait_time: float
@export var movement_wait_time: float
@export var execution_logic: EnemyExecution
@export var attacks: Array[Card]
