extends Control
func _ready():
	$TimeLabel.text = "Your Time: " + str(GameData.game_run_time)
	
func _on_exit_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/mainmenu.tscn")
	
func _on_restart_button_pressed() -> void:
	GameData.reset_game()
	get_tree().change_scene_to_file("res://scenes/game.tscn")
