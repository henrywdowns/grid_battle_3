extends MovementBehavior
class_name ProjectileStraightShot

enum ProjectileDirection { UP, DOWN, LEFT, RIGHT }

@export var projectile_direction: ProjectileDirection

func _action_pattern(_projectile):
	if projectile_direction == ProjectileDirection.UP:
		move_up(_projectile)
	if projectile_direction == ProjectileDirection.DOWN:
		move_down(_projectile)
	if projectile_direction == ProjectileDirection.LEFT:
		move_left(_projectile)
	if projectile_direction == ProjectileDirection.RIGHT:
		move_right(_projectile)
