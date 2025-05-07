class_name World extends Node2D

@onready var tile_map: TileMapNode = $TileMap
@onready var paddle: Paddle = $Paddle
@onready var ball: Ball = $Ball

func _ready() -> void:
	ball.tile_collided.connect(_on_ball_tile_collided)
	tile_map.tile_destroyed.connect(_on_tile_map_tile_destroyed)
	GlobalManager.world_level_manager.level_changed.connect(_on_world_level_manager_level_changed)
	
	#tile_map.generate_tile_map_by_world_level(GlobalManager.world_level_manager.get_level())

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		var tile_coordinate: Vector2i = tile_map.get_tile_coordinate(get_global_mouse_position(), tile_map.brick)
		tile_map.set_tile_to_next_level(tile_coordinate, tile_map.brick)
	if Input.is_action_just_pressed("ui_cancel"):
		GlobalManager.screen_manager.change_screen_to_node("TittleScreen")

func _on_ball_tile_collided(global_pos: Vector2, normal: Vector2, layer: TileMapLayer) -> void:
	var collided_tile_coordinate: Vector2i = tile_map.find_collided_tile_coordinate(tile_map.get_tile_coordinate(global_pos, layer), normal, layer)
	tile_map.set_tile_to_next_level(collided_tile_coordinate, layer)

func _on_tile_map_tile_destroyed(remaining_tile_count: int, layer: TileMapLayer) -> void:
	if remaining_tile_count == 0 and layer == tile_map.brick:
		GlobalManager.world_level_manager.set_to_next_level()

func _on_world_level_manager_level_changed(world_level: int) -> void:
	tile_map.generate_tile_map_by_world_level(world_level)
