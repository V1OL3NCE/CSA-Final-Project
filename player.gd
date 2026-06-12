
extends CharacterBody2D
@export var speed: float = 10000.0
var health : int = 100

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed * delta
	move_and_slide()

# This will trigger whenever another physics body enters the Area2D
func _on_body_entered(body: CharacterBody2D) -> void:
	# Check if the colliding object is the player
	if body.is_in_group("Player"):
		print("The player has entered the zone!")
		# Add your destruction or game-state logic here
