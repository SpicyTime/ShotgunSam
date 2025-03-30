extends Control
func load_file(from_path: String, into_path: String) ->void:
	var from_file = FileAccess.open(from_path, FileAccess.READ)
	var json_contents = from_file.get_as_text()
	print(json_contents)
	from_file.close()
	var json = JSON.new()
	var parse_result = json.parse(json_contents)
	 
	if parse_result == OK:
		var into_file = FileAccess.open(into_path, FileAccess.WRITE)
		into_file.store_string(json_contents)
		 
		into_file.close()
 
	
func switch_scene(path: String):
	get_tree().change_scene_to_file(path)
	
func _ready() ->void:
	 
 	 
	if not FileAccess.file_exists(Constants.EMPTY_GAME_SAVE_PATH):
		print("Loading Empty Game Save File")
		load_file("res://save_file_templates/empty_game_save_file.json", Constants.EMPTY_GAME_SAVE_PATH)
	if not FileAccess.file_exists(Constants.GAME_SAVE_PATH):
		$Buttons/VBoxContainer/LoadGameButton.disabled = true
	else:
		$Buttons/VBoxContainer/LoadGameButton.disabled = false
	if not FileAccess.file_exists(Constants.SETTINGS_SAVE_PATH):
		load_file("res://save_file_templates/settings_save_file.json", Constants.SETTINGS_SAVE_PATH)
	if not FileAccess.file_exists(Constants.BEST_TIMES_SAVE_PATH):
		load_file("res://save_file_templates/best_times.json", Constants.BEST_TIMES_SAVE_PATH)
		print("loading best times json")
	DialogueManager.load_dialogue_from_file()
	 
func _on_new_game_button_pressed() -> void:
	GameData.reset_game()
	call_deferred("switch_scene", "res://scenes/intro.tscn")
	
func _on_load_game_button_pressed() -> void:
	call_deferred("switch_scene", "res://scenes/game.tscn")
func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	call_deferred("switch_scene", "res://scenes/menus/settings_menu.tscn")
	
