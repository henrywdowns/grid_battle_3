extends Resource
class_name CardArray

enum CardCollectionType { DECK, PACK, POOL }

@export var card_collection_type: CardCollectionType
@export var cards: Array[Card] 
