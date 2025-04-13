extends CharacterBody2D
@onready var gun: AnimatedSprite2D = $Gun
@onready var screen_size = get_viewport().size
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
var was_in_air: bool = false
var pseudo_mouse_pos = Vector2(0, 0)
var max_radius: int = 100
var min_radius: int = 65
var charge_threshold := 0.5
var mouse_held_duration := 0.0
var charge_gun: bool = false
var gun_charging: bool = false
func get_node_name() -> String:
	return node_name
	
func add_coins(amount: int) -> void:
	coin_count += amount
	
func handle_flip() -> void:
	if direction == 1:
		player_sprite.flip_h = false
	elif direction == -1:
		player_sprite.flip_h = true
		
func rotate_node_around_player(node: Node2D, offset: Vector2 = Vector2(0, 0))-> void:
	# Get the global position of the mouse
	var mouse_global_pos = get_global_mouse_position()
   
	var direction =  pseudo_mouse_pos
	 
	var angle = direction.angle()
	# Rotates the sprite to face the mouse
	node.rotation = angle
	 
	# Calculate the position based off of the angle and the radius
	var new_position = Vector2(cos(angle), sin(angle)) * gun_radius
	# Set the child's position relative to the parent
	node.position = new_position + offset 
	if node is AnimatedSprite2D or node is Sprite2D:
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
	$Health.health = 1
	velocity *= 0
	Signals.reset_level.emit()
func _process(delta: float) -> void:
	if charge_gun:
		mouse_held_duration += delta
		if mouse_held_duration >= charge_threshold:
			gun.charge()
			charge_gun = false
			mouse_held_duration = 0.0
			gun_charging = true
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		was_in_air = true
		
	else:
		if was_in_air:
			$LandingSFX.play(0.18)
			$LandingDust.emitting = true
			was_in_air = false
			$Arms.play("idle")
			gun.reload()
	if is_on_floor() and not has_shot:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		has_shot = false
	
	move_and_slide()
	
 	  
func _ready() -> void:
	#Connect Signals
	Signals.player_coin_change.emit(0)
	Signals.health_depleted.connect(_on_health_depleted)
	coin_count = GameData.player_coin_count
	  
	 
	rotate_gun()
	rotate_arms()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_motion = event.relative
		pseudo_mouse_pos += mouse_motion
		var offset = pseudo_mouse_pos - Vector2(0, 0)
		if offset.length() > max_radius:
			offset = offset.normalized() * max_radius
			pseudo_mouse_pos =  offset
		if offset.length() < min_radius:
			offset = offset.normalized() * min_radius
			pseudo_mouse_pos =  offset
		rotate_arms()
		rotate_gun()
	if Input.is_action_just_pressed("shoot"):
		mouse_held_duration = 0.0
		charge_gun = true
	if Input.is_action_just_released("shoot"):
		if not is_on_floor():
			if not gun.can_shoot():
				return
			else:
				$Arms.play("idle_red")
		var recoil = gun.get_recoil()
		velocity = -pseudo_mouse_pos.normalized() * recoil
		has_shot = true
		gun_charging = false
		gun.shoot(is_on_floor())
		charge_gun = false
		mouse_held_duration = 0.0
	

	
func _on_coins_set(new_value: int):
	coin_count = new_value
	Signals.player_coin_change.emit(coin_count)
	GameData.player_coin_count = new_value
func _on_health_depleted(sender) -> void:
	if sender.get_parent() != self:
		return
	$DeathSFX.play()
	call_deferred("reset")
	
 
	
func _on_arms_animation_finished() -> void:
	if $Arms.animation == "reload":
		$Arms.play("idle")
 
	
