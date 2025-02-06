extends Sprite2D
@export var gun_power = 500
@export var shake_power = 0.3
@export var power_up_cap: int = 300
@export var multiplier = 150
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var power_up_timer: Timer = $PowerUpTimer
@onready var marker_2d: Marker2D = $Marker2D
@onready var game = get_tree().get_root().get_node("Game")
@onready var parent = get_parent()
@onready var game_camera = get_node("/root/Game/Camera")
@onready var blast_particles = preload("res://particles/gun_blast_particles.tscn")
@onready var bullet_particles = preload("res://particles/shotgun_bullet_particles.tscn")

var sprite_dimensions : Vector2 = get_texture().get_size()
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
	var parent_sprite = parent.get_node("PlayerSprite")
	if rotation < - 1.5  || rotation > 1.5:
		parent_sprite.flip_h = true
		flip_v = true
		#flips bullet spawn position
		if marker_2d.position.y == -13:
			marker_2d.position.y = -marker_2d.position.y
	else:
		parent_sprite.flip_h = false
		flip_v = false
		#flips bullet spawn position
		if marker_2d.position.y == 13:
			marker_2d.position.y = -marker_2d.position.y
	# Set the child's position relative to the parent
	position = new_position
func power_up():
	power_up_timer.start()
	is_powered = true
func shoot():
	 
	if power_up_amount == 0 and is_powered:
		var time = power_up_timer.wait_time - power_up_timer.time_left
		power_up_amount = time * multiplier
		if power_up_amount > power_up_cap:
			power_up_amount = power_up_cap
	gun_power += power_up_amount
	 
	power_up_timer.start()
	power_up_timer.stop()
	$HitBox/CollisionShape2D.disabled = false
	is_powered = false
	power_up_amount = 0
	shoot_sound.play()
	var particles = blast_particles.instantiate()
	var bullets = bullet_particles.instantiate()
	bullets.emitting = true
	particles.emitting = true
	particles.finished.connect(func(): _on_particles_finished(particles))
	bullets.finished.connect(func(): _on_particles_finished(bullets))
	marker_2d.add_child(particles)
	marker_2d.add_child(bullets)
	game_camera.add_trauma(shake_power)


func _on_power_up_timer_timeout() -> void:
	power_up_amount = power_up_cap
func _on_particles_finished(particles):
	particles.queue_free()
	 
