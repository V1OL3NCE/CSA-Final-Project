extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 3.0
@export var max_enemies: int = 10
@export var spawn_dist: float = 600.0

var spawn_timer: float = 0.0
var player: Node2D = null

func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	if player == null or enemy_scene == null:
		return
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		_try_spawn()

func _try_spawn() -> void:
	if get_tree().get_nodes_in_group("Enemy").size() >= max_enemies:
		return
	var angle = randf_range(0, TAU)
	var pos = player.global_position + Vector2(cos(angle), sin(angle)) * spawn_dist
	var enemy = enemy_scene.instantiate()
	get_parent().add_child(enemy)
	enemy.global_position = pos