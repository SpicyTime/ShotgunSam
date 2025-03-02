extends Control

func _on_new_game_button_pressed() -> void:
	GameData.reset_game()
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
func _on_load_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/settings_menu.tscn")




 
