class_name TileLevelRecorder extends Node

enum { DEFAULT = 0, NONEXISTENT = -1, ERROR = -2}

var recorder: Dictionary[TileMapLayer, TileLevels] = {}

class TileLevels:
	var tile_levels: Dictionary[Vector2i, int] = {}
	var can_recover: bool = false
	

func record_tile_level(tile_coordinate: Vector2i, layer: TileMapLayer, level: int = DEFAULT) -> void:
	if not recorder.has(layer):
		recorder[layer] = TileLevels.new()
	if level <= DEFAULT:
		if recorder[layer].tile_levels.has(tile_coordinate):
			recorder[layer].tile_levels.erase(tile_coordinate)
		return
	recorder[layer].tile_levels[tile_coordinate] = level

func get_tile_level(tile_coordinate: Vector2i, layer: TileMapLayer) -> int:
	if layer.get_cell_tile_data(tile_coordinate) == null:
		return NONEXISTENT
	if not recorder.has(layer):
		return DEFAULT
	if recorder[layer] == null:
		print("ERROR: record[layer] == null")
		return ERROR
	if not recorder[layer].tile_levels.has(tile_coordinate):
		return DEFAULT
	return recorder[layer].tile_levels[tile_coordinate]

func clear_record() -> void:
	if not recorder.is_empty():
		recorder.clear()
