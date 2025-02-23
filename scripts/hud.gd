extends Control
@onready var coin_label: Label = $HudCanvas/CoinDisplay/CoinLabel
@onready var bullet_1: Sprite2D = $HudCanvas/BulletDisplay/Bullet1
@onready var bullet_2: Sprite2D = $HudCanvas/BulletDisplay/Bullet2
@onready var bullet_display: Control = $HudCanvas/BulletDisplay

func _ready():
	Signals.player_coin_change.connect(_on_player_coin_change)
	Signals.player_shot.connect(_on_player_shot)
	Signals.player_reload.connect(_on_player_reload)
func _on_player_coin_change(new_value: int):
	coin_label.text = str(new_value)

func _on_player_shot(player_bullets_left: int):
	var bullet_uis = bullet_display.get_children()
	bullet_uis[player_bullets_left].visible = false

func _on_player_reload(player_bullet_count):
	var bullet_uis = bullet_display.get_children()
	for i in range(player_bullet_count):
		bullet_uis[i].visible = true
