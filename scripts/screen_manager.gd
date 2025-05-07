class_name ScreenManager extends Node

var screens: Dictionary[String, String] = {
	"World": "uid://tvjagjqqldps",
	"TittleScreen": "uid://nvxsgva526cb"
}

func change_screen_to_node(node_name: String) -> void:
	if not screens.has(node_name):
		print("can't find its path")
		return
	get_tree().change_scene_to_file(screens[node_name])
