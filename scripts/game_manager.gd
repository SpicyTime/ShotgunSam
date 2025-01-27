extends Node
@onready var player: CharacterBody2D = %Player
@onready var coin_label: Label = get_node("GameUI/Coin/CanvasLayer/Label")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	if player:
		player.coin_count_changed.connect(_on_player_coins_changed)
		_on_player_coins_changed(player.coin_count)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_player_coins_changed(new_value: int):
	if coin_label:
		coin_label.text = str(new_value)
