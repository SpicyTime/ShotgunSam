extends Node
@onready var player : CharacterBody2D = %Player
@onready var stopwatch: Stopwatch = $"../Stopwatch"
@onready var music: AudioStreamPlayer2D = $"../Music"
@onready var hud : Control = %Hud
var meter: Control 
var meter_bar: ColorRect
var swapped: bool = false
func remove_level(level_root):
	var tree = get_tree()
	if not tree:
		return
	 
	tree.root.remove_child(level_root)
	level_root.queue_free()
	
func spawn_player(level_root):
	var spawn_marker:Marker2D = level_root.find_child("LevSpawnPos")
	if spawn_marker:
		player.global_position = spawn_marker.global_position
			 
func add_level(level_root):
	get_tree().root.add_child(level_root)
	
	
func load_level(path : String):
	while get_tree().get_node_count_in_group("Level") > 0:
		unload_level(get_tree().get_first_node_in_group("Level").get_path())
	var packed_level = load(path)
	var level_root = packed_level.instantiate()
	 
	 
	if not GameData.coin_picked_up and GameData.coin_positions.has(path):
		var coin: Area2D = load("res://scenes/coin.tscn").instantiate()
		coin.global_position = GameData.coin_positions[path]
		level_root.add_child(coin)
	level_root.add_to_group("Level")
	DialogueManager.start_dialogue(level_root.name)
	spawn_player(level_root)
	call_deferred("add_level", level_root)
	if swapped:
		var anim_player = level_root.find_child("AnimationPlayer")
		if anim_player:
			anim_player.play("move")
	else:
		var anim_player:AnimationPlayer = level_root.find_child("AnimationPlayer")
		if anim_player: 
			anim_player.play("move")
			anim_player.seek(anim_player.current_animation_length, true)
			anim_player.stop(true)  # Freeze at the end frame
func unload_level(path : String):
	player.global_position = Vector2(0, 0)
	 
	var level_root = get_node(path)
	level_root.remove_from_group("Level")
	
	call_deferred("remove_level", level_root)
func save() -> Dictionary:
	var data = {
		"current_level" : GameData.current_level,
		"game_run_time" : GameData.game_run_time,
		"current_music_place":  music.get_playback_position(),
		"game_won": GameData.game_won,
		"coin_picked_up": GameData.coin_picked_up
	}
	return data
# Called when the node enters the scene tree for the first time.

func get_node_name() -> String:
	return "game"
	
func _ready() -> void:
	GameData.load_game()
	if "11" in GameData.current_level && GameData.game_won:
		GameData.reset_game()
	 
	#load_level(GameData.current_level)
	load_level("res://levels/test_scene.tscn")
	Signals.swap_level.connect(_on_swap_level)
	stopwatch.start()
	stopwatch.time = GameData.game_run_time
	 
	Signals.game_stopwatch_changed.emit(stopwatch.time)
	Signals.reset_level.connect(_on_reset_level)
	music.play(GameData.saved_music_position)
	meter = hud.get_charge_meter()
	meter_bar = hud.get_charge_bar()
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mainmenu"):
		DialogueManager.stop()
		GameData.save_game()
		var tree = get_tree()
		unload_level(tree.get_first_node_in_group("Level").get_path())
		tree.call_deferred("change_scene_to_file", "res://scenes/menus/main_menu.tscn")
 
func _process(_delta: float) -> void:
	GameData.game_run_time = stopwatch.time
	Signals.game_stopwatch_changed.emit(stopwatch.time)
	if  player.gun_charging:
		meter.visible = true
		meter.position = Vector2(player.global_position.x + get_viewport().size.x / 2 - 15, player.global_position.y + get_viewport().size.y / 2 - 100 )
		meter_bar.size.x = min(player.gun.current_charge_power / 7.16, 40)

	else:
		meter.visible = false
		
func _on_swap_level(next_level_scene_path):
	swapped = true
	GameData.coin_picked_up = false
	var tree = get_tree()
	unload_level(tree.get_first_node_in_group("Level").get_path())
	load_level(next_level_scene_path)
	GameData.current_level = next_level_scene_path
	GameData.save_game()
	

func _on_reset_level():
	var current_level = get_tree().get_first_node_in_group("Level")
	spawn_player(current_level)
	await get_tree().create_timer(0.001).timeout
	 
	if 	GameData.coin_picked_up:
		var packed_coin = load("res://scenes/coin.tscn")
		var coin = packed_coin.instantiate()
		coin.position = GameData.coin_positions[GameData.current_level]
		coin.z_index = 10
		coin.set_name("Coin")
		current_level.add_child(coin)
		GameData.player_coin_count -= 1
		player.coin_count -= 1
		GameData.coin_picked_up = false
