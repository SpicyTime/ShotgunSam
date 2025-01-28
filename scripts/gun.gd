extends Sprite2D
@export var gun_power = 10
@export var cooldown: float = 0.75
@export var shake_power = 0.3
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var bullet = load("res://scenes/bullet.tscn")
@onready var game = get_tree().get_root().get_node("Game")
@onready var shoot_cool_down: Timer = $ShootCoolDown
@onready var parent = get_parent()
@onready var game_camera = get_node("/root/Game/Camera")

var direction
var distance: float
var can_shoot: bool = true
func _process(_delta: float):
	shoot_cool_down.wait_time = cooldown
func _ready():
	shoot_cool_down.wait_time = cooldown
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

func shoot():
	if can_shoot:
		 
		print("Shooting")
		var instance = bullet.instantiate()
		instance.dir = direction.normalized()
		instance.spawn_pos = $Marker2D.global_position
		instance.spawn_rot = rotation 
		game.add_child.call_deferred(instance)
		shoot_cool_down.start()
		can_shoot = false
		shoot_sound.play()
		game_camera.add_trauma(shake_power)


func _on_shoot_cool_down_timeout() -> void:
	can_shoot = true
	
