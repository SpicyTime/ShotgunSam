extends CharacterBody2D
@onready var camera: Camera2D = %Camera
@onready var gun: Sprite2D = $Gun
@onready var screen_size = get_viewport().size
@onready var CAMERA_SIZE = camera.get_viewport_rect().size
@export var gun_radius := 100
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_SHOT_COUNT: int = 10
@export var current_shot_count: int  = MAX_SHOT_COUNT: set = _on_shots_set
var d:int
var gun_rotate_speed = 4
var direction: float
signal shots_changed(new_value: int)
func add_bullets(amount: int):
	current_shot_count += amount
	if current_shot_count > MAX_SHOT_COUNT:
		current_shot_count = MAX_SHOT_COUNT
		
		
func _on_shots_set(new_value: int) ->void:
	current_shot_count = new_value
	shots_changed.emit(current_shot_count)
	
func handle_input():
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("shoot"):
		if current_shot_count <= 0:
			current_shot_count = MAX_SHOT_COUNT
			 
		var gun_position = gun.global_position
		var direction_to_mouse = (get_global_mouse_position()  - gun_position).normalized()
		if gun.distance <= gun_radius:
			velocity = (direction_to_mouse * gun.gun_power)
		else:
			velocity = - (direction_to_mouse * gun.gun_power)
		gun.shoot()
		current_shot_count -= 1
func rotate_gun():
	gun.rotate_around(gun_radius)
func _physics_process(delta: float) -> void:
	 
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	rotate_gun()
	 
	handle_input()
	 
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)
	 
	move_and_slide()
	#screen_wrap()
func screen_wrap() ->void:
	position.x = wrapf(position.x, 0 - CAMERA_SIZE.x / 2, screen_size.x  - CAMERA_SIZE.x / 2)
