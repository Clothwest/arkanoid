class_name TileMapNode extends Node2D

signal tile_destroyed(remaining_tiles_count: int, layer: TileMapLayer)

const DEFAULT_GENERATION_COORDINATE: Vector2i = Vector2i(-1, -1)

@onready var tile_level_recorder: TileLevelRecorder = $TileLevelRecorder
@onready var backgound: TileMapLayer = $Backgound
@onready var brick: TileMapLayer = $Brick
@onready var wall: TileMapLayer = $Wall

@export var block_datas: Dictionary[String, BlockData] = {}

func _process(delta: float) -> void:
	pass

func generate_tile_map_by_world_level(world_level: int) -> void:
	for child in get_children():
		if child is TileMapLayer:
			var layer: TileMapLayer = child
			tile_level_recorder.clear_record()
			generate_layer_by_world_level(world_level, layer)

func generate_layer_by_world_level(world_level: int, layer: TileMapLayer) -> void:
	if layer.tile_set.get_patterns_count() == 0:
		layer.set_cell(DEFAULT_GENERATION_COORDINATE, layer.get_cell_source_id(layer.get_used_cells()[0]), layer.get_cell_atlas_coords(layer.get_used_cells()[0]), layer.get_cell_alternative_tile(layer.get_used_cells()[0]))
		var pattern: TileMapPattern = layer.get_pattern(layer.get_used_cells())
		layer.tile_set.add_pattern(pattern)
	layer.clear()
	var pattern_index: int = mini(world_level, layer.tile_set.get_patterns_count() - 1)
	layer.set_pattern(DEFAULT_GENERATION_COORDINATE, layer.tile_set.get_pattern(pattern_index))

func get_tile_coordinate(global_pos: Vector2, layer: TileMapLayer) -> Vector2i:
	return layer.local_to_map(layer.to_local(global_pos))

func set_tile_level(tile_coordinate: Vector2i, layer: TileMapLayer, level: int = 0) -> void:
	var tile_identifiers: Array[TileIdentifier] = get_tile_identifiers(tile_coordinate, layer)
	if tile_identifiers.is_empty():
		return
	level = -1 if ((level < 0 or level > tile_identifiers.size() - 1) and layer == brick) else level
	if level == -1:
		layer.erase_cell(tile_coordinate)
		tile_destroyed.emit(layer.get_used_cells().size() - 1, layer)
	else:
		layer.set_cell(tile_coordinate, tile_identifiers[level].source_id, tile_identifiers[level].atlas_coordinate, tile_identifiers[level].alternative_tile)
	tile_level_recorder.record_tile_level(tile_coordinate, layer, level)

func get_tile_level(tile_coordinate: Vector2i, layer: TileMapLayer) -> int:
	return tile_level_recorder.get_tile_level(tile_coordinate, layer)

func set_tile_to_next_level(tile_coordinate: Vector2i, layer: TileMapLayer) -> void:
	var tile_identifiers: Array[TileIdentifier] = get_tile_identifiers(tile_coordinate, layer)
	if tile_identifiers.is_empty():
		return
	var current_level: int = get_tile_level(tile_coordinate, layer)
	var target_level: int = current_level + 1
	set_tile_level(tile_coordinate, layer, target_level)

func find_collided_tile_coordinate(tile_coordinate: Vector2i, normal: Vector2, layer: TileMapLayer) -> Vector2i:
	var neighbour_tile_offsets: Array[Vector2i] = [Vector2i.ZERO, Vector2i(-1 * normal.slide(Vector2.DOWN).sign()), Vector2i(-1 * normal.slide(Vector2.RIGHT).sign()), Vector2i(-1 * normal.sign())]
	for offset in neighbour_tile_offsets:
		var tile_data: TileData = layer.get_cell_tile_data(tile_coordinate + offset)
		if tile_data != null:
			return (tile_coordinate + offset)
	print("ERROR: can't find collided_tile_coordinate")
	return Vector2i.ZERO

func get_tile_identifiers(tile_coordinate: Vector2i, layer: TileMapLayer) -> Array[TileIdentifier]:
	var tile_data: TileData = layer.get_cell_tile_data(tile_coordinate)
	if tile_data == null:
		return []
	if tile_data.has_custom_data("tile_name"):
		var tile_name: String = tile_data.get_custom_data("tile_name")
		if not block_datas.has(tile_name):
			return []
		return block_datas[tile_name].tile_identifiers
	else:
		return []
