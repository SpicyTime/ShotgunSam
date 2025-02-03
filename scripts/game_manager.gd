extends Node
@onready var player: CharacterBody2D = %Player
@onready var coin_label: Label = get_node("GameUI/Coin/CanvasLayer/Label")
@onready var game: Node2D = $".."
func remove_level(level_root):
	get_tree().get_root().remove_child(level_root)
func spawn_player(level_root):
	var spawn_marker:Marker2D = level_root.find_child("LevSpawnPos")
	if spawn_marker:
		player.global_position = spawn_marker.global_position
		var door_node = level_root.find_child("Door")
		if not door_node:
			return
		var next_level_node = door_node.find_child("NextLevel")
		if next_level_node:
			print("Next level pos : " + str(next_level_node.global_position))
			 
func connect_change_scene_signal(node):
	var next_level_node = node.find_child("NextLevel")
	if not next_level_node :
		return
	if next_level_node.has_signal("change_scene"):
		next_level_node.change_scene.connect(_on_change_scene)
func add_level(level_root):
	get_tree().get_root().add_child(level_root)
func load_level(path : String):
	 
	
	var packed_level = load(path)
	var level_root = packed_level.instantiate()
	level_root.add_to_group("Level")
	spawn_player(level_root)
	call_deferred("add_level", level_root)
	call_deferred("connect_change_scene_signal", level_root)
	 
func unload_level(path : String):
	var level_root = get_node(path)
	level_root.remove_from_group("Level")
	player.global_position = Vector2(0, 0)
	#Removes all of the bullets that are in the current level
	while get_tree().get_node_count_in_group("Bullets") > 0:
		var node = get_tree().get_first_node_in_group("Bullets")
		node.remove_from_group("Bullets")
		game.remove_child(node)
	call_deferred("remove_level", level_root)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().get_node_count_in_group("Level") > 0:
		var level = get_tree().get_first_node_in_group("Level")
		remove_level(level) 
		level.remove_from_group("Level")
	load_level("res://levels/l_1.tscn")
	if player:
		player.coin_count_changed.connect(_on_player_coins_changed)
		_on_player_coins_changed(player.coin_count)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_player_coins_changed(new_value: int):
	if coin_label:
		coin_label.text = str(new_value)
func _on_change_scene(next_level_scene_path):
	unload_level(get_tree().get_first_node_in_group("Level").get_path())
	load_level(next_level_scene_path)


	 
