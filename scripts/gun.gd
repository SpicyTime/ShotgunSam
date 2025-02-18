extends Sprite2D
@export var shake_power = 0.3
@export var power: int = 500
@export var charge_cap: int = 350
@export var max_bullet_capacity: int = 10
@export var reload_speed: float = 1.5
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var marker_2d: Marker2D = $Marker2D
@onready var game = get_tree().get_root().get_node("Game")
@onready var parent = get_parent()
@onready var game_camera = get_node("/root/Game/Camera")
@onready var blast_particles = preload("res://particles/gun_blast_particles.tscn")
@onready var bullet_particles = preload("res://particles/shotgun_bullet_particles.tscn")
@onready var reload_time: Timer = $ReloadTime
@onready var sprite_dimensions : Vector2 = get_texture().get_size()
@onready var charge_stopwatch: Stopwatch = $ChargeStopwatch
signal shot
signal bullet_count_changed(new_value: int) 
var direction
var distance: float
var bullet_count: int = 10: set = _on_bullets_set
var charge_power: int = 0
var cancel_charge: bool = false
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
func get_recoil() -> int:
	return power + charge_power
func is_empty():
	return bullet_count <= 0
func shoot():
	if bullet_count <= 0:
		return
	 
	var time = charge_stopwatch.time
	shot.emit()
	cancel_charge = true
	charge_power = time * 75
	bullet_count -= 1
	$HitBox/CollisionShape2D.disabled = false
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
	if not charge_stopwatch.stopped:
		charge_stopwatch.reset()
		charge_stopwatch.stop()
func charge():
	if bullet_count > 0:
		charge_stopwatch.start()
func reload():
	reload_time.start()
func add_bullets(value: int):
	
	bullet_count += value
	if bullet_count > max_bullet_capacity:
		bullet_count = max_bullet_capacity
func _process(delta: float):
	reload_time.wait_time = reload_speed
#Not a signal
func _on_particles_finished(particles):
	particles.queue_free()
func begin_shoot():
	$ChargeDelay.start()
func _ready():
	bullet_count_changed.emit(bullet_count)
func _on_charge_delay_timeout() -> void:
	if cancel_charge:
		cancel_charge = false
		return
	print("Charging")
	charge()
func _on_reload_time_timeout() -> void:
	#print("Reloaded")
	add_bullets(5)
func _on_bullets_set(new_value: int):
	bullet_count = new_value
	bullet_count_changed.emit(bullet_count)
	
