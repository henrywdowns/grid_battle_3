extends Node2D
class_name BaseProjectile

### INTENT ###
# Here's the idea: enemy or card spawns projectile object
# object contains movement, damage, effect data, performs its
# job, and frees itself from the queue.

# sprite should be able to spawn into the center of the tile in front.
# user some trickery to make the tail look like it's protruding from previous 
# tile as well as attack animation from character

var projectile_resource: Projectile
var movement_speed: float
var damage: int
var sprite: Texture
var entry_animation: Texture
var exit_animation: Texture
var applied_effect: CardEffect
var movement_pattern: MovementBehavior
var pixels_moved := Vector2(0,0)
var distance_traveled := 0
var projectile_coords: Vector2
var projectile_gridpoint: Marker2D

func _ready() -> void:
	if projectile_resource.movement_speed:
		movement_speed = projectile_resource.movement_speed
	if projectile_resource.damage:
		damage = projectile_resource.damage
	if projectile_resource.entry_animation:
		exit_animation = projectile_resource.contact_animation
	if projectile_resource.exit_animation:
		exit_animation = projectile_resource.contact_animation
	if projectile_resource.applied_effect:
		applied_effect = projectile_resource.applied_effect
	if projectile_resource.movement_pattern:
		movement_pattern = projectile_resource.movement_pattern
	if projectile_resource.sprite:
		sprite = projectile_resource.sprite
		$Sprite2D.texture = sprite

func _process(_delta: float) -> void:
	movement(movement_pattern)
	distance_traveled += 1
	if distance_traveled > 1000:
		print_debug("Travel Distance safeguard exceeded - freeing self from tree")
		self.free()

func set_stats():
	if projectile_resource:
		movement_speed = projectile_resource.movement_speed
		damage = projectile_resource.damage
		sprite = projectile_resource.sprite
		entry_animation = projectile_resource.entry_animation
		exit_animation = projectile_resource.exit_animation
		applied_effect = projectile_resource.applied_effect
		movement_pattern = projectile_resource.movement_pattern
	else:
		print_debug("ERROR - Projectile did not spawn. Resource missing.")

# not so simple - I'll need to manage sprite movement AND panel/coords movement
func movement(movement_res: MovementBehavior) -> void:
	movement_res._action_pattern(self)
