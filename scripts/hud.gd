extends Control
@onready var coin_label: Label = $HudCanvas/CoinDisplay/CoinLabel
@onready var bullet_1: Sprite2D = $HudCanvas/BulletDisplay/Bullet1
@onready var bullet_2: Sprite2D = $HudCanvas/BulletDisplay/Bullet2
@onready var bullet_display: Control = $HudCanvas/BulletDisplay
@onready var level_stopwatch_label: Label = $HudCanvas/LevelStopwatchDisplay/LevelStopwatchLabel
var last_count: int
func _ready():
	Signals.player_coin_change.connect(_on_player_coin_change)
	Signals.player_bullet_change.connect(_on_player_bullet_change)
	Signals.game_stopwatch_changed.connect(_on_game_stopwatch_changed)
	last_count = 2
func _on_player_coin_change(new_value: int):
	coin_label.text = str(new_value)
	
func _on_player_bullet_change(player_bullets: int):
	 
	if player_bullets > last_count:
		increase(player_bullets)
	elif player_bullets < last_count:
		decrease(player_bullets)
	last_count = player_bullets
func increase(new_value: int):
	var bullet_uis = bullet_display.get_children()
	for i in range(bullet_uis.size()):
		bullet_uis[i].visible = true
func decrease(new_value: int):
	var bullet_uis = bullet_display.get_children()
	for i in range(last_count - 1, new_value - 1, -1):
		if i >= bullet_uis.size():
			continue
		bullet_uis[i].visible = false
func _on_game_stopwatch_changed(new_value: float):
	level_stopwatch_label.text = str(new_value)


 
