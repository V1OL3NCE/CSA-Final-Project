extends CharacterBody2D

@export var speed = 90.0
@onready var player = get_node("../Player") # Target node

func _process(delta):
	# Moves this sprite's position towards the player's position
	global_position = global_position.move_toward(player.global_position, speed * delta)
