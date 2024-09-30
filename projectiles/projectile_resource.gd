extends Resource
class_name Projectile

@export var movement_speed: float = 0.0
@export var damage: int = 0
@export var sprite: Texture
@export var contact_animation: Texture
@export var applied_effect: CardEffect
@export var movement_pattern: MovementBehavior


### MOVEMENT ###
# I have some math to do here. Need to find a way to equate sprite movement to
# panel movement. it might mean taking panel width as a constant and dividing that
# by sprite_movement speed, and then updating the coords every so many frames?
func sprite_movement() -> void:
	pass

func grid_movement() -> void:
	pass

### COLLISION ###

func check_collision() -> void:
	pass
