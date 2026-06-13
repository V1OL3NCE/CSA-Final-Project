extends TileMap

@export var chunk_size: int = 16
@export var render_distance: int = 3
@export var terrain_set: int = 0
@export var terrain: int = 0

var loaded_chunks: Dictionary = {}
var player: Node2D = null
var source_id: int = -1
var available_tiles: Array = []
var noise: FastNoiseLite

func _ready() -> void:
	noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.frequency = 0.15

	source_id = tile_set.get_source_id(0)
	var atlas = tile_set.get_source(source_id) as TileSetAtlasSource
	for i in atlas.get_tiles_count():
		available_tiles.append(atlas.get_tile_id(i))

	while player == null:
		player = get_tree().get_first_node_in_group("Player")
		if player == null:
			await get_tree().process_frame
	_update_chunks()

func _process(_delta: float) -> void:
	if player == null:
		return
	_update_chunks()

func _update_chunks() -> void:
	var player_tile = local_to_map(to_local(player.global_position))
	var player_chunk = Vector2i(
		floori(float(player_tile.x) / chunk_size),
		floori(float(player_tile.y) / chunk_size)
	)

	var vel_chunk = Vector2i(
		floori(float(player_tile.x + sign(player.velocity.x) * chunk_size) / chunk_size),
		floori(float(player_tile.y + sign(player.velocity.y) * chunk_size) / chunk_size)
	)

	var needed_chunks: Dictionary = {}
	for x in range(player_chunk.x - render_distance, player_chunk.x + render_distance + 1):
		for y in range(player_chunk.y - render_distance, player_chunk.y + render_distance + 1):
			var chunk = Vector2i(x, y)
			needed_chunks[chunk] = true
			if not loaded_chunks.has(chunk):
				_load_chunk(chunk)

	for x in range(vel_chunk.x - 1, vel_chunk.x + 2):
		for y in range(vel_chunk.y - 1, vel_chunk.y + 2):
			var chunk = Vector2i(x, y)
			needed_chunks[chunk] = true
			if not loaded_chunks.has(chunk):
				_load_chunk(chunk)

	for chunk in loaded_chunks.keys():
		if not needed_chunks.has(chunk):
			_unload_chunk(chunk)

func _load_chunk(chunk: Vector2i) -> void:
	loaded_chunks[chunk] = true
	var start = chunk * chunk_size
	for x in range(start.x, start.x + chunk_size):
		for y in range(start.y, start.y + chunk_size):
			var n = noise.get_noise_2d(x, y)
			var index = int((n + 1.0) / 2.0 * available_tiles.size()) % available_tiles.size()
			set_cell(0, Vector2i(x, y), source_id, available_tiles[index])

func _unload_chunk(chunk: Vector2i) -> void:
	loaded_chunks.erase(chunk)
	var start = chunk * chunk_size
	for x in range(start.x, start.x + chunk_size):
		for y in range(start.y, start.y + chunk_size):
			erase_cell(0, Vector2i(x, y))
