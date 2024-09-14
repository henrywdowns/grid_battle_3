extends AIBehavior
class_name MovementBehavior

func _ready():
	combat_or_movement = CombatOrMovement.MOVEMENT

func move_up(_enemy):
	_enemy.enemy_coords += Vector2.UP
	_enemy.global_position = Global.translate_coords_to_points(_enemy.enemy_coords).global_position

func move_down(_enemy):
	_enemy.enemy_coords += Vector2.DOWN
	_enemy.global_position = Global.translate_coords_to_points(_enemy.enemy_coords).global_position

func move_left(_enemy):
	_enemy.enemy_coords += Vector2.LEFT
	_enemy.global_position = Global.translate_coords_to_points(_enemy.enemy_coords).global_position

func move_right(_enemy):
	_enemy.enemy_coords += Vector2.RIGHT
	_enemy.global_position = Global.translate_coords_to_points(_enemy.enemy_coords).global_position

func move_to(_enemy,target_coords: Vector2):
	_enemy.enemy_coords = target_coords
	_enemy.global_position = Global.translate_coords_to_points(_enemy.enemy_coords).global_position
