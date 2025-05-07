class_name WorldLevelManager extends Node

signal level_changed(level: int)

var enabled: bool:
	set(e):
		enabled = e
		set_process(enabled)
		set_physics_process(enabled)
var level: int:
	set(l):
		level = l
		print(level)
		before_level_changes()
		level_changed.emit(level)
		after_level_changes()

func _ready() -> void:
	enabled = false
	
	call_deferred("post_ready")

func post_ready() -> void:
	level = 0
	
	enabled = true

func set_level(lv: int) -> void:
	level = lv

func get_level() -> int:
	return level

func set_to_next_level() -> void:
	level += 1

func before_level_changes() -> void:
	pass

func after_level_changes() -> void:
	pass
