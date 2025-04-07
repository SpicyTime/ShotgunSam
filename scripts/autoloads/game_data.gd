extends Node
var player_bullet_count: int = 2
var player_coin_count: int = 0
var player_position: Vector2 = Vector2(0, 0)
var current_level: String = "res://levels/l_11.tscn"
var game_run_time: float = 0.0
var saved_music_position = 0.0
var game_won: bool = false
var coin_picked_up: bool = false
var coin_positions: Dictionary = {"res://levels/l_1.tscn": Vector2(0, 85), "res://levels/l_2.tscn" : Vector2(24.21513, -172.0905),
"res://levels/l_3.tscn" : Vector2(24, 170), "res://levels/l_4.tscn" : Vector2(-395., -162), "res://levels/l_5.tscn" : Vector2(25, 110),
"res://levels/l_6.tscn": Vector2(24, 192),  "res://levels/l_7.tscn": Vector2(241, -54), "res://levels/l_8.tscn": Vector2(-84, -220), "res://levels/l_9.tscn" : Vector2(70, -174),
"res://levels/l_10.tscn" : Vector2(458, 28)
}
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
		saved_music_position = game_data.get("current_music_place")
		game_won = game_data.get("game_won")
		coin_picked_up = game_data.get("coin_picked_up")
		Signals.player_bullet_change.emit(player_bullet_count)
func save_single_data(section_key: String, key: String, value) -> void:
	var file_path = Constants.GAME_SAVE_PATH

	# Load existing save data if the file exists
	var save_data: Dictionary = {}
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var json_string = file.get_as_text()
		file.close()

		var json = JSON.new()
		if json.parse(json_string) == OK:
			save_data = json.get_data()

	# Update only the specified key
	var section_data = save_data[section_key]
	section_data[key] = value

	# Save the updated data back to the file
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if not file:
		return
	file.store_string(JSON.stringify(save_data, "\t"))
	file.close()

	
func reset_game():
	game_won = false
	var empty_game_save_file = FileAccess.open(Constants.EMPTY_GAME_SAVE_PATH, FileAccess.READ)
	var json_string = empty_game_save_file.get_as_text()
	empty_game_save_file.close()
	var game_save_file = FileAccess.open(Constants.GAME_SAVE_PATH, FileAccess.WRITE)
	current_level = "res://levels/l_1.tscn"
	if game_save_file == null:
		return
	game_save_file.store_string(json_string)
	game_save_file.close()
