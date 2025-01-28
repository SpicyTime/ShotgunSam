extends Node
@onready var player: CharacterBody2D = %Player
@onready var coin_label: Label = get_node("GameUI/Coin/CanvasLayer/Label")

func load_level(path : String):
	var packed_level = load(path)
	var level_root = packed_level.instantiate()
	print(level_root)
	get_tree().get_root().add_child(level_root)
func unload_level(path : String):
	var packed_level = load(path)
	var level_root = packed_level.instantiate()
	get_tree().get_root().remove_child(level_root)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
