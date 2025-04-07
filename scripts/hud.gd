extends Control
@onready var coin_label: Label = $HudCanvas/CoinDisplay/CoinLabel
@onready var gun_display: Control = $HudCanvas/GunDisplay
@onready var level_stopwatch_label: Label = $HudCanvas/LevelStopwatchDisplay/LevelStopwatchLabel
@onready var charge_rect: ColorRect = $HudCanvas/ChargeEffect/ChargeRect
@onready var bullet_holder: AnimatedSprite2D = $HudCanvas/GunDisplay/BulletHolder
@onready var gun_body: AnimatedSprite2D = $HudCanvas/GunDisplay/GunBody


 
var stopwatch: Stopwatch
var charge_start_pos  
var move_charge_rect: bool = false
 
func charge_rect_move():
	var offset: float = (stopwatch.time ) * 100 / 3 
	 
	if offset >= 66:
		charge_rect.global_position =  Vector2(charge_start_pos.x, charge_start_pos.y - 66)
		return
	 
	charge_rect.global_position = Vector2(charge_start_pos.x, charge_start_pos.y - offset)
	 
func _ready():
	Signals.player_coin_change.connect(_on_player_coin_change)
	Signals.player_bullet_change.connect(_on_player_bullet_change)
	Signals.game_stopwatch_changed.connect(_on_game_stopwatch_changed)
	Signals.player_gun_charge.connect(_on_player_charge)
	charge_rect.global_position = Vector2(13, 188)
	charge_start_pos = charge_rect.global_position
	
func _process(delta: float) -> void:
	if move_charge_rect:
		charge_rect_move()
	else:
		charge_rect.position = charge_start_pos
		
func _on_player_coin_change(new_value: int):
	coin_label.text = str(new_value)
	
func _on_player_bullet_change(player_bullets: int):
	move_charge_rect = false
	 
	bullet_holder.animation = "change"
	bullet_holder.frame = player_bullets
	bullet_holder.play("change")
	
func _on_player_charge(charge_stopwatch: Stopwatch):
	move_charge_rect = true
	stopwatch = charge_stopwatch
	 
	 
func _on_game_stopwatch_changed(new_value: float):
	level_stopwatch_label.text = str(new_value)


 
