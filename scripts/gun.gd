extends Sprite2D
@export var gun_power = 500
@export var shake_power = 0.3
@export var power_up_cap: int = 300
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var power_up_timer: Timer = $PowerUpTimer
@onready var bullet = load("res://scenes/bullet.tscn")
@onready var game = get_tree().get_root().get_node("Game")
@onready var parent = get_parent()
@onready var game_camera = get_node("/root/Game/Camera")

var base_power = gun_power
var direction
var distance: float
var power_up_amount = 0
var is_powered = false
func _process(_delta: float):
	pass
func _ready():
	pass
func rotate_around(radius):
	# Get the global position of the mouse
	var mouse_global_pos = get_global_mouse_position()
 	# Get the parent's global position
	var parent_global_pos = get_parent().global_position 
	distance = sqrt(pow((parent_global_pos.x - mouse_global_pos.x), 2) + 
	pow((parent_global_pos.y - mouse_global_pos.y), 2))

	# Calculate the direction vector from the parent to the mouse
	direction = mouse_global_pos - parent_global_pos
		 
	var angle = direction.angle()
	# Rotates the sprite to face the mouse
	rotation = angle
	# Calculate the position based off of the angle and the radius
	var new_position = Vector2(cos(angle), sin(angle)) * radius
	 
	
	# Set the child's position relative to the parent
	position = new_position
func power_up():
	power_up_timer.start()
	is_powered = true
func shoot():
	 
	if power_up_amount == 0 and is_powered:
		var time = power_up_timer.wait_time - power_up_timer.time_left
		power_up_amount = time * 150
		if power_up_amount > power_up_cap:
			power_up_amount = power_up_cap
	gun_power += power_up_amount
	print(power_up_amount)
	power_up_timer.stop()
	var instance = bullet.instantiate()
	instance.dir = direction.normalized()
	instance.spawn_pos = $Marker2D.global_position
	instance.spawn_rot = rotation 
	game.add_child.call_deferred(instance)
	power_up_amount = 0
	shoot_sound.play()
	game_camera.add_trauma(shake_power)


func _on_power_up_timer_timeout() -> void:
	power_up_amount = power_up_cap
