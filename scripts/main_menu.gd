extends Control
func _unhandled_input(event: InputEvent) -> void:
	print(event)
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
