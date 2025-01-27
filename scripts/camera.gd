extends Camera2D
@export var decay : float  = 0.8
@export var max_offset : Vector2 = Vector2(100, 75)
@export var max_roll : float = 0.1
@export var follow_node : Node2D
@onready var player: CharacterBody2D = %Player
 
const TILE_SIZE = 48
var trauma : float = 0.0
var trauma_power : int = 2

func shake()->void:
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)
# Called when the node enters the scene tree for the first time.
func get_camera_screen_rect() -> Rect2:
	var half_size = get_viewport().get_visible_rect().size * 0.5 * zoom
	var top_left = global_position - half_size
	return Rect2(top_left, half_size * 2) 
func add_trauma(amount: float)-> void:
	trauma = min(trauma + amount, 1.0)
func is_player_in_view(player_position)->bool:
	var camera_rect = get_camera_screen_rect()
	return camera_rect.has_point(player_position)
func move_camera():
	var camera_rect = get_camera_screen_rect()
	var dir: String = ""
	if player.global_position.x < camera_rect.position.x :
		dir = "left"
		global_position -= Vector2(camera_rect.size.x, 0)
	elif player.global_position.x > camera_rect.position.x + camera_rect.size.x:
		dir = "right"
		global_position += Vector2(camera_rect.size.x, 0)
	elif player.global_position.y > camera_rect.position.y + camera_rect.size.y:
		global_position += Vector2(0, camera_rect.size.y - TILE_SIZE)
		dir = "bottom"
	elif player.global_position	.y < camera_rect.position.y:
		print(camera_rect.size.y)
		global_position -= Vector2(0, camera_rect.size.y - TILE_SIZE) 
		dir = "top"
	print(dir)
func _ready() -> void:
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_player_in_view(player.global_position):
		pass
		 
	else:
		move_camera()
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
