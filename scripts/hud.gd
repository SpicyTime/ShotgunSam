extends Control
@onready var ammo_label: Label = $HudCanvas/AmmoDisplay/AmmoLabel
@onready var coin_label: Label = $HudCanvas/CoinDisplay/CoinLabel


func _on_game_manager_player_coin_change(value: int) -> void:
	coin_label.text = str(value)



func _on_game_manager_player_bullet_change(value: int) -> void:
	ammo_label.text = str(value)
