extends Node
@onready var player : CharacterBody2D = %Player
@onready var slow_timer: Timer = $"../SlowTimer"
@onready var game : Node2D = $".."
@export var start_level: String = "1"

func remove_level(level_root):
	get_tree().get_root().remove_child(level_root)
	level_root.queue_free()
func spawn_player(level_root):
	var spawn_marker:Marker2D = level_root.find_child("LevSpawnPos")
	if spawn_marker:
		player.global_position = spawn_marker.global_position
			 
func add_level(level_root):
	get_tree().get_root().add_child(level_root)
func load_level(path : String):
	var packed_level = load(path)
	var level_root = packed_level.instantiate()
	level_root.add_to_group("Level")
	spawn_player(level_root)
	call_deferred("add_level", level_root)
	
	 
func unload_level(path : String):
	player.global_position = Vector2(0, 0)
	print(player.global_position)
	var level_root = get_node(path)
	level_root.remove_from_group("Level")
	
	call_deferred("remove_level", level_root)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().get_node_count_in_group("Level") > 0:
		var level = get_tree().get_first_node_in_group("Level")
		remove_level(level) 
		level.remove_from_group("Level")
	load_level("res://levels/l_" + str(start_level) + ".tscn")
	#load_level("res://levels/test_scene.tscn")
	Signals.change_scene.connect(_on_change_scene)
		 
 
func _on_change_scene(next_level_scene_path):
	print("Changing Scene")
	unload_level(get_tree().get_first_node_in_group("Level").get_path())
	load_level(next_level_scene_path)
	#Engine.time_scale = 0.5
	#slow_timer.start()
	#player.add_ammo()
	
func _on_slow_timer_timeout() -> void:
	Engine.time_scale = 1

 
