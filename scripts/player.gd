extends CharacterBody2D
@onready var camera: Camera2D = %Camera
@onready var gun: Sprite2D = $Gun
@onready var screen_size = get_viewport().size
@onready var CAMERA_SIZE = camera.get_viewport_rect().size
@onready var player_sprite: Sprite2D = $PlayerSprite
@export var gun_radius := 50
@export var max_y_velocity := 600
@export var max_x_velocity := 650

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var gun_rotate_speed = 4
var direction: float
var has_shot: bool = false
var coin_count: int = 0: set = _on_coins_set

func add_coins(amount: int):
	coin_count += amount
func reload(value: int):
	gun.add_bullets(value)
func _on_coins_set(new_value: int):
	coin_count = new_value
	Signals.player_coin_change.emit(coin_count)

func handle_flip():
	if direction == 1:
		player_sprite.flip_h = false
	elif direction == -1:
		player_sprite.flip_h = true
 
	 
func rotate_gun():
	gun.rotate_around(gun_radius)
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	#rotate_gun()
	if is_on_floor() and not has_shot:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		has_shot = false
	
	move_and_slide()
	#screen_wrap()
func screen_wrap() ->void:
	position.x = wrapf(position.x, 0 - CAMERA_SIZE.x / 2, screen_size.x  - CAMERA_SIZE.x / 2)
 
func _unhandled_input(event: InputEvent) -> void:
	print(event)
	if event is InputEventMouseButton:
		$Gun/HitBox/CollisionShape2D.disabled = true
		if Input.is_action_just_pressed("shoot"):
			gun.begin_shoot() 
		if Input.is_action_just_released("shoot"):
			if gun.is_empty():
				return
			gun.cancel_charge()
			gun.shoot()
			Signals.player_shot.emit(gun.bullet_count)
			has_shot = true
			var gun_position = gun.global_position
			var direction_to_mouse = (get_global_mouse_position()  - gun_position).normalized() 
			var recoil = gun.get_recoil()
			var new_velocity =  direction_to_mouse * recoil
			if gun.distance <= gun_radius:
				velocity = new_velocity  
			else:
				velocity = - new_velocity
	elif event is InputEventMouseMotion:
		rotate_gun()
	 
func _unhandled_key_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("reload"):
		gun.reload()
	if event.is_action_just_pressed("mainmenu"):
		pass
func reset():
	var tree = get_tree()
	if tree:
		tree.reload_current_scene()
func _ready():
	Signals.player_coin_change.emit(0)
	Signals.health_depleted.connect(_on_health_depleted)
	Signals.gun_reload.connect(_on_gun_reload)
	Signals.gun_charge.connect(_on_gun_charge)
	set_process_input(false)
	set_process_shortcut_input(false)
func _on_gun_reload(sender):
	 
	if sender != gun:
		return
	Signals.player_reload.emit(gun.bullet_count)
func _on_health_depleted(sender) -> void:
	 
	if sender.get_parent() != self:
		return
	call_deferred("reset")

func _on_gun_charge(sender):
	if sender != gun:
		return
	Signals.player_gun_charge.emit()

 
 
 
