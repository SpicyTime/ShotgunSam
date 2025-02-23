extends Control
@onready var coin_label: Label = $HudCanvas/CoinDisplay/CoinLabel
func _ready():
	Signals.player_coin_change.connect(_on_player_coin_change)
	 
func _on_player_coin_change(new_value: int):
	coin_label.text = str(new_value)
