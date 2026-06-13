extends CharacterBody2D

@export var speed: float = 80.0
@export var max_hp: int = 50
@export var dmg: int = 10
@export var dmg_cd: float = 1.0
@export var radius: float = 10000.0


var can_attack: bool = true
var health: int = max_hp
var player: Node2D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(_delta: float) -> void:
	if player == null:
		return
	var dist = global_position.distance_to(player.global_position)
	if dist < radius:
		var dir = (player.global_position - global_position).normalized()
		velocity = dir * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()

	if can_attack && $Area2D.has_overlapping_bodies():
		for body in $Area2D.get_overlapping_bodies():
			if body.is_in_group("Player"):
				body.take_damage(dmg)
				_cooldown()
				break


func take_damage(amount: int) -> void:
	health -= amount
	print(health)
	if health <= 0:
		die()

func _cooldown() -> void:
	can_attack = false
	await get_tree().create_timer(dmg_cd).timeout
	can_attack = true

func die() -> void:
	queue_free()
