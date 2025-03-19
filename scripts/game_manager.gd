extends Node
@onready var player : CharacterBody2D = %Player
@onready var game : Node2D = $".."
@onready var stopwatch: Stopwatch = $"../Stopwatch"

func remove_level(level_root):
	 
	var tree = get_tree()
	if not tree:
		 
		return
	#print("removing level")
	tree.root.remove_child(level_root)
	level_root.queue_free()
func spawn_player(level_root):
	var spawn_marker:Marker2D = level_root.find_child("LevSpawnPos")
	if spawn_marker:
		player.global_position = spawn_marker.global_position
			 
func add_level(level_root):
	#print("adding level")
	get_tree().root.add_child(level_root)
func load_level(path : String):
	while get_tree().get_node_count_in_group("Level") > 0:
		unload_level(get_tree().get_first_node_in_group("Level").get_path())
	var packed_level = load(path)
	var level_root = packed_level.instantiate()
	level_root.add_to_group("Level")
	DialogueManager.start_dialogue(level_root.name)
	spawn_player(level_root)
	call_deferred("add_level", level_root)
	 
func unload_level(path : String):
	player.global_position = Vector2(0, 0)
	 
	var level_root = get_node(path)
	level_root.remove_from_group("Level")
	
	call_deferred("remove_level", level_root)
func save() -> Dictionary:
	var data = {
		"current_level" : GameData.current_level,
		"game_run_time" : GameData.game_run_time
	}
	return data
# Called when the node enters the scene tree for the first time.fd

func get_node_name() -> String:
	return "game"
	
func _ready() -> void:
	GameData.load_game()
	load_level(GameData.current_level)
	#load_level("res://levels/test_scene.tscn")
	Signals.swap_level.connect(_on_swap_level)
	stopwatch.start()
	stopwatch.time = GameData.game_run_time
	Signals.game_stopwatch_changed.emit(stopwatch.time)
	 
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("mainmenu"):
		DialogueManager.stop()
		GameData.save_game()
		
		var tree = get_tree()
		unload_level(tree.get_first_node_in_group("Level").get_path())
		tree.call_deferred("change_scene_to_file", "res://scenes/menus/main_menu.tscn")
	 
func _process(_delta: float) -> void:
	GameData.game_run_time = stopwatch.time
	Signals.game_stopwatch_changed.emit(stopwatch.time)
	
func _on_swap_level(next_level_scene_path):
	var tree = get_tree()
	unload_level(tree.get_first_node_in_group("Level").get_path())
	load_level(next_level_scene_path)
	GameData.current_level = next_level_scene_path
	GameData.save_game()
	
func _on_slow_timer_timeout() -> void:
	Engine.time_scale = 1
	
