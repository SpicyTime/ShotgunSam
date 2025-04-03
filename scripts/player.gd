extends CharacterBody2D
@onready var camera: Camera2D = %Camera
@onready var gun: AnimatedSprite2D = $Gun
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
var node_name: String = "player"
var distance_to_mouse: float
var was_in_air: bool =false
func get_node_name() -> String:
	return node_name
	
func add_coins(amount: int) -> void:
	coin_count += amount
	
func reload(value: int) -> void: 
	gun.add_bullets(value)

func handle_flip() -> void:
	if direction == 1:
		player_sprite.flip_h = false
	elif direction == -1:
		player_sprite.flip_h = true
func rotate_node_around_player(node: Node2D, offset: Vector2 = Vector2(0, 0))-> void:
	# Get the global position of the mouse
	var mouse_global_pos = get_global_mouse_position()
 	# Get the parent's global position
	 
	distance_to_mouse = sqrt(pow((global_position.x - mouse_global_pos.x), 2) + 
	pow((global_position.y - mouse_global_pos.y), 2))

	# Calculate the direction vector from the parent to the mouse
	var direction = mouse_global_pos - global_position
		 
	var angle = direction.angle()
	# Rotates the sprite to face the mouse
	node.rotation = angle
	 
	# Calculate the position based off of the angle and the radius
	var new_position = Vector2(cos(angle), sin(angle)) * gun_radius
	# Set the child's position relative to the parent
	node.position = new_position + offset 
	if node is AnimatedSprite2D or node is Sprite2D:
		#print(typeof(node))
		pass
	else:
		return
	if node.rotation < - 1.5  || node.rotation > 1.5:
		$PlayerSprite.flip_h = true
		if node.has_method("handle_flip"):
			node.handle_flip(true)
		else:
			node.flip_v = true
	else:
		$PlayerSprite.flip_h = false
		if node.has_method("handle_flip"):
			node.handle_flip(false)
		else:
			node.flip_v = false
	
func rotate_gun() -> void:
	rotate_node_around_player(gun)
func rotate_arms() -> void:
	rotate_node_around_player($Arms, Vector2(3, 5))
func save() -> Dictionary: 
	var data = {
		"player_coin_count" : coin_count,
		"player_position" : global_position
	}
	return data
func load(data: Dictionary):
	 
	if data.has("player_coin_count"):
		coin_count = data.get("player_coin_count")
		
	if data.has("player_position"):
		#global_position = data.get("player_position")
		pass
func reset() -> void:
	GameData.player_bullet_count = 2
	$Health.health = 1
	velocity *= 0
	Signals.reset_level.emit()
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		was_in_air = true
	else:
		if was_in_air:
			$LandingSFX.play(0.18)
			was_in_air = false
	
	if is_on_floor() and not has_shot:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		has_shot = false
	
	move_and_slide()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_released("shoot"):
			if gun.is_empty():
				gun.empty_gun_sound.play()
				return
			gun.cancel_charge()
			gun.shoot()
			 
			GameData.player_bullet_count = gun.bullet_count
			Signals.player_shot.emit()
			Signals.player_bullet_change.emit(gun.bullet_count)
			has_shot = true
			var gun_position = gun.global_position
			var direction_to_mouse = (get_global_mouse_position()  - gun_position).normalized() 
			var recoil = gun.get_recoil()
			var new_velocity =  direction_to_mouse * recoil
			if distance_to_mouse <= gun_radius:
				velocity = new_velocity
			else:
				velocity = -new_velocity
			camera.reset_zoom()
			 
			camera.reset_position()
		elif Input.is_action_just_pressed("shoot"):
			gun.begin_shoot() 
			 
	elif event is InputEventMouseMotion:
		rotate_gun()
		rotate_arms()
		#Signals.mouse_on_edge.emit()
		var pan_bounds = camera.get_pan_bounds()
		var mouse_global_pos = get_global_mouse_position()
		if mouse_global_pos.x < pan_bounds[1] or mouse_global_pos.x >  pan_bounds[0] or mouse_global_pos.y < pan_bounds[2] or  mouse_global_pos.y  > pan_bounds[3]  :
			Signals.mouse_on_edge.emit()

		#Resets the x when it is not in the pan bounds
		if mouse_global_pos.x > pan_bounds[1] && mouse_global_pos.x < pan_bounds[0] && camera.is_panned_hor:
			camera.is_panned_hor = false
			camera.lerp_pos.x = camera.prev_lerp_pos.x
			if camera.player_charging_gun:
				camera.global_position.x = camera.lerp_pos.x
			else:
				camera.global_position.x = 0
			
		#Resets the y when it is not in the pan bounds
		if mouse_global_pos.y > pan_bounds[2] && mouse_global_pos.y < pan_bounds[3] && camera.is_panned_vert:
			camera.is_panned_vert = false
			camera.lerp_pos.y = camera.prev_lerp_pos.y
			if camera.player_charging_gun:
				camera.global_position.y = camera.lerp_pos.y
				print("")
			else:
				camera.global_position.y = 0
				print("Zeroing")
			
		
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("reload"):
		gun.reload()
		$Arms.play("reload")
	 
		#print("Escaping to main menu")
func _ready() -> void:
	#Connect Signals
	Signals.player_coin_change.emit(0)
	Signals.health_depleted.connect(_on_health_depleted)
	Signals.gun_reload.connect(_on_gun_reload)
	Signals.gun_charge.connect(_on_gun_charge)
	coin_count = GameData.player_coin_count
	gun.bullet_count = GameData.player_bullet_count
	rotate_gun()
	rotate_arms()
	
func _on_gun_reload(sender) -> void:
	 
	if sender != gun:
		return
	Signals.player_bullet_change.emit(gun.bullet_count)
	
func _on_coins_set(new_value: int):
	coin_count = new_value
	Signals.player_coin_change.emit(coin_count)
	GameData.player_coin_count = new_value
func _on_health_depleted(sender) -> void:
	if sender.get_parent() != self:
		return
	$DeathSFX.play()
	call_deferred("reset")
	
func _on_gun_charge(sender) -> void:
	if sender != gun:
		return
	Signals.player_gun_charge.emit()
	
func _on_arms_animation_finished() -> void:
	$Arms.play("idle")
 
	
