extends Resource
class_name character

### STATS ###
@export var HP: int
@export var basic_attack: Card
@export var move_delay: float

### CARDPOOLS ###
@export var default_deck: Array[Card]
@export var draftable_pool: Array[Card]
