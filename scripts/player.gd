extends CharacterBody2D
@onready var camera: Camera2D = %Camera
@onready var gun: Sprite2D = $Gun
@onready var screen_size = get_viewport().size
@onready var CAMERA_SIZE = camera.get_viewport_rect().size
@onready var player_sprite: Sprite2D = $PlayerSprite
@export var gun_radius := 50

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var gun_rotate_speed = 4
var direction: float
var coin_count: int = 0: set = _on_coins_set
signal coin_count_changed(new_value: int)
func add_coins(amount: int):
	coin_count += amount
func _on_coins_set(new_value: int):
	coin_count = new_value
	coin_count_changed.emit(coin_count)
func handle_flip():
	if direction == 1:
		player_sprite.flip_h = false
	elif direction == -1:
		player_sprite.flip_h = true
func handle_input():      
	$Gun/HitBox/CollisionShape2D.disabled = true
	if Input.is_action_just_released("shoot"):
		gun.shoot()
		var gun_position = gun.global_position
		var direction_to_mouse = (get_global_mouse_position()  - gun_position).normalized()
		if gun.distance <= gun_radius:
			velocity = (direction_to_mouse * gun.gun_power)
				
		else:
			velocity = - (direction_to_mouse * gun.gun_power)
		gun.gun_power = gun.base_power
	elif Input.is_action_just_pressed("shoot"):
		gun.power_up()
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

func reset():
	var tree = get_tree()
	if tree:
		tree.reload_current_scene()
func _on_health_health_depleted() -> void:
	call_deferred("reset")
