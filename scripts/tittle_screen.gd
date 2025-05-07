class_name TittleScreen extends Control

func _on_play_button_pressed() -> void:
	GlobalManager.screen_manager.change_screen_to_node("World")
