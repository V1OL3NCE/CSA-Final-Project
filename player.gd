extends CharacterBody2D

@export var speed: float = 200.0
@export var max_hp: int = 100
@export var dmg_cd: float = 0.5
@export var shoot_dmg: int = 10
@export var raycast_length: float = 1000.0

var hp: int = max_hp
var can_take_dmg: bool = true

func _ready() -> void:
	add_to_group("Player")

func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
		shoot()

func shoot() -> void:
	var space = get_world_2d().direct_space_state
	var mouse_pos = get_global_mouse_position()

	var query = PhysicsRayQueryParameters2D.create(global_position, mouse_pos)
	query.exclude = [ self ]
	query.collide_with_areas = true
	query.collide_with_bodies = false

	var result = space.intersect_ray(query)

	if result:
			print(result.collider.name)
			result.collider.get_parent().take_damage(shoot_dmg)

func take_damage(amount: int) -> void:
	if not can_take_dmg:
		return
	hp -= amount
	print(hp)
	hp = clamp(hp, 0, max_hp)
	can_take_dmg = false
	await get_tree().create_timer(dmg_cd).timeout
	can_take_dmg = true
	if hp <= 0:
		die()

func die() -> void:
	print("Player died!")
	get_tree().reload_current_scene()
