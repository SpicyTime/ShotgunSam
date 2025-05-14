extends AnimatedSprite2D
@onready var shoot_sound: AudioStreamPlayer2D = $Sounds/ShootSound
@onready var bullet_particles: PackedScene = preload("res://scenes/gun_bullet_particles.tscn")
@onready var blast_particles: PackedScene = preload("res://scenes/gun_blast_particles.tscn")
@onready var collision_shape_2d: CollisionShape2D = $HitBox/CollisionShape2D
 
var charge_cap: int = 350
var power: int = 400
var current_charge_power: float = 0
var charging: bool = false
var barrel_exit: Vector2 = Vector2(44, -7)
var air_shots: int = 1
var parent  = null
# Called when the node enters the scene tree for the first time.
func handle_flip(right: bool):
	flip_v = right
	barrel_exit.y = -barrel_exit.y
func get_recoil() -> float:
	if current_charge_power > charge_cap:
		current_charge_power = charge_cap
	return power + current_charge_power
	
func charge() -> void:
	$Sounds/GunChargeStartSound.play()
	charging = true
func reload() -> void:
	air_shots = 1
	
func stop_charge() -> void:
	charging = false
	current_charge_power = 0

func add_particle(particle) -> void:
	particle = particle.instantiate()
	 
	particle.emitting = true
	 
	particle.finished.connect(func(): _on_particles_finished(particle))
	 
	particle.position = barrel_exit
	 
	add_child(particle)
	 
func can_shoot() -> bool:
	return air_shots > 0
func shoot(on_ground: bool):
	if not on_ground:
		if air_shots <= 0:
			$Sounds/EmptyGunSound.play()
			return
		else:
			air_shots -= 1
	collision_shape_2d.disabled = false
	$Sounds/ShootSound.play()
	add_particle(blast_particles)
	add_particle(bullet_particles)
	Signals.shake_camera.emit(0.3)
	stop_charge()
func _ready() -> void:
	parent = get_parent()
	 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if collision_shape_2d.disabled == false:
		collision_shape_2d.disabled = true
	if charging:
		
		if not  parent.is_on_floor(): 
			current_charge_power += delta * 100 * 5.25
		else:
			current_charge_power += delta * 100 * 1.85
		if current_charge_power > charge_cap:
			current_charge_power = charge_cap
	 
func _on_particles_finished(particles):
	particles.queue_free()

func _on_animation_finished() -> void:
	play("idle")
