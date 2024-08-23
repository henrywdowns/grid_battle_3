extends Node

### Events Bus ###
# Autoload that holds signals so that they can easily be read across disparate nodes.

### CARD SIGNALS ###
var card_placeholder: Card

signal card_played(card: Card)
signal card_requested(card_name: Card)
signal draft_card_toggled(card:Card)
signal card_chosen()
signal draft_over()
signal emit_node(some_node)
signal card_ui_card_clicked(card:Card)

### PLAYER SIGNALS ###
signal entity_moved(new_pos: Marker2D,old_pos: Marker2D)

### SETTERS ###
signal partition_updated(new_value)

### ENEMY SIGNALS ### 
signal i_died(dead_enemy)

### BATTLE SIGNALS ###
signal you_win()
signal card_ui_available()
