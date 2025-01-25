extends Camera2D
@onready var player: CharacterBody2D = %Player


# Called when the node enters the scene tree for the first time.
func get_camera_screen_rect() -> Rect2:
	var half_size = get_viewport().get_visible_rect().size * 0.5 * zoom
	var top_left = global_position - half_size
	return Rect2(top_left, half_size * 2) 
func is_player_in_view(player_position):
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
		global_position += Vector2(0, camera_rect.size.y)
		dir = "bottom"
	elif player.global_position	.y < camera_rect.position.y:
		global_position -= Vector2(0, camera_rect.size.y)
		dir = "top"
	print(dir)
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_player_in_view(player.global_position):
		pass
		#print("Yes")
	else:
		move_camera()
		#print("No")
