#godot official movement guide
extends CharacterBody2D
@export var speed: float = 300.0

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_up", "move_right", "move_down", "move_left")
	velocity = direction * speed
	move_and_slide()
