extends Control
func load_best_time():
	var file = FileAccess.open(Constants.BEST_TIMES_SAVE_PATH, FileAccess.READ)
	if not file:
		return
	var json = JSON.new()
	var json_string = file.get_as_text()
	file.close()
	var parse_result = json.parse(json_string)
	if parse_result == OK:
		var data = json.get_data()
		var best_time_data = data.get("best_time")
		return best_time_data
func save_best_time(time: float):
	var file = FileAccess.open(Constants.BEST_TIMES_SAVE_PATH, FileAccess.WRITE)
	if not file:
		return
	var data = {}
	data["best_time"] = time
	file.store_string(JSON.stringify(data, "\t"))
func update_best_time() ->float:
	var best_time = load_best_time()
	var rounded = round(best_time * 100) / 100.0
	var rounded_game_time = round(GameData.game_run_time * 100) / 100.0
	if  rounded_game_time < rounded:
		save_best_time(rounded_game_time)
		best_time= rounded_game_time
	return best_time
func _ready():
	var rounded_time = round(GameData.game_run_time * 100) / 100.0
	GameData.game_won = true
	 
	GameData.save_single_data("game",  "game_won", true)
	$Labels/VBoxContainer/TimeLabel.text = "Your Time: " + str(rounded_time)
	$Labels/VBoxContainer/BestTimeLabel.text = "Best Time: " + str(update_best_time())
	$Labels/VBoxContainer/CoinsCollectedLabel.text = "Coins Collected: " + str(GameData.player_coin_count)
func _on_exit_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
	
func _on_restart_button_pressed() -> void:
	GameData.reset_game()
	get_tree().change_scene_to_file("res://scenes/game.tscn")
