extends Control
@onready var ammo_label: Label = $HudCanvas/AmmoDisplay/AmmoLabel
@onready var coin_label: Label = $HudCanvas/CoinDisplay/CoinLabel

func _ready():
	Signals.player_coin_change.connect(_on_player_coin_change)
	Signals.player_bullet_change.connect(_on_player_bullet_change)
func _on_player_coin_change(new_value: int):
	coin_label.text = str(new_value)
func _on_player_bullet_change(new_value: int):
	ammo_label.text = str(new_value)
