extends Camera2D
@export var decay : float  = 0.8
@export var max_offset : Vector2 = Vector2(100, 75)
@export var max_roll : float = 0.1
@export var lerp_speed: float = 0.1
@onready var player: CharacterBody2D = %Player

const TILE_SIZE = 48
var trauma : float = 0.0
var trauma_power : int = 2
var player_charging_gun: bool = false
var prezoom_position: Vector2  
var lerp_pos
func shake()->void:
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)
# Called when the node enters the scene tree for the first time
func add_trauma(amount: float)-> void:
	trauma = min(trauma + amount, 1.0)
	
func _ready() -> void:
	randomize()
	Signals.shake_camera.connect(_on_camera_shake)
	Signals.player_gun_charge.connect(_on_player_gun_charge)
	Signals.player_shot.connect(_on_player_shoot)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
	if  player_charging_gun:
		lerp_zoom(Vector2(1.06, 1.06))
		lerp_position(lerp_pos)
func calc_lerp_pos(pos1: Vector2, pos2: Vector2)->Vector2:
	return Vector2((pos1.x + pos2.x) / 4, (pos1.y + pos2.y) / 4)
func lerp_zoom(target_zoom: Vector2):
	var new_zoom: Vector2 = lerp(zoom, target_zoom, lerp_speed) 
	zoom = new_zoom 
func lerp_position( target_position: Vector2):
	var new_position = lerp(transform.origin, target_position, lerp_speed)
	var int_new_position_x: int = new_position.x
	var int_new_position_y: int = new_position.y
	global_translate(Vector2(int_new_position_x, int_new_position_y) - transform.origin)
	 
func reset_zoom():
	zoom = Vector2(1, 1)
func reset_position():
	global_position = prezoom_position
func _on_camera_shake(trauma: float):
	add_trauma(trauma)

func _on_player_gun_charge():
	player_charging_gun = true
	prezoom_position = global_position
	lerp_pos = calc_lerp_pos(prezoom_position, player.global_position)
func _on_player_shoot(bullets_left: int):
	player_charging_gun = false
	reset_zoom()
	reset_position()
	 
 
