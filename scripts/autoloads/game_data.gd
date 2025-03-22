extends Node
var player_bullet_count: int = 2
var player_coin_count: int = 0
var player_position: Vector2 = Vector2(0, 0)
var current_level: String = "res://levels/l_1.tscn"
var game_run_time: float = 0.0
func save_game() -> void:
	var savables  = get_tree().get_nodes_in_group("game_savables")
	var save_data: Dictionary
	for savable in savables:
		if not savable.has_method("save"):
			continue
		if not savable.has_method("get_node_name"):
			continue
		save_data[savable.get_node_name()] = savable.save()
	var file = FileAccess.open(Constants.GAME_SAVE_PATH, FileAccess.WRITE)
	if not file:
		print("Failed to save")
		return
	var json_string = JSON.stringify(save_data, "\t")
	file.store_string(json_string)
	file.close()
func load_game():
	 
	var file = FileAccess.open(Constants.GAME_SAVE_PATH, FileAccess.READ)
	if not FileAccess.file_exists(Constants.GAME_SAVE_PATH):
		return
	var json_string = file.get_as_text()
	file.close()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result == OK:
		var save_data = json.get_data()
		var player_data = save_data.get("player", {})
		for node in get_tree().get_nodes_in_group("game_savables"):
			if node.has_method("load"):
				node.load(save_data.get(node.get_node_name().to_lower()))
		var game_data = save_data.get("game", {})
		current_level =  game_data.get("current_level")
		game_run_time = game_data.get("game_run_time")
		Signals.player_bullet_change.emit(player_bullet_count)
 
	
func reset_game():
	#print("Resetting game")
	var empty_game_save_file = FileAccess.open(Constants.EMPTY_GAME_SAVE_PATH, FileAccess.READ)
	var json_string = empty_game_save_file.get_as_text()
	 
	
	
	
	
	
	
	empty_game_save_file.close()
	var game_save_file = FileAccess.open(Constants.GAME_SAVE_PATH, FileAccess.WRITE)
	if game_save_file == null:
		print("Failed to open", Constants.GAME_SAVE_PATH)
		return
	game_save_file.store_string(json_string)
	game_save_file.close()
