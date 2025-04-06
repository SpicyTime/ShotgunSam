extends AnimatedSprite2D
@export var shake_power: float = 0.3
@export var power: int = 500
@export var charge_cap: int = 350
@export var reload_speed: float = 1.5
@export var charge_mult: float = 75
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var empty_gun_sound: AudioStreamPlayer2D = $EmptyGunSound
@onready var marker_2d: Marker2D = $Marker2D
@onready var blast_particles = preload("res://particles/gun_blast_particles.tscn")
@onready var bullet_particles = preload("res://particles/shotgun_bullet_particles.tscn")
@onready var charge_stopwatch: Stopwatch = $ChargeStopwatch
var bullet_count: int = Constants.MAX_BULLET_COUNT: set = _on_bullets_set
var charge_power: int = 0
var stop_charge: bool = false
var is_reloading: bool = false
var distance: float
var node_name: String = "gun"

func get_node_name():
	return node_name
func get_recoil() -> int:
	return power + charge_power
	
func is_empty() -> bool:
	return bullet_count <= 0
func handle_flip(right: bool):
	flip_v = right
	marker_2d.position.y = -marker_2d.position.y
func shoot():
	if is_empty():
		return
	 
	var time = charge_stopwatch.time
	var extra: int = 1
	var parent = get_parent()
	if parent.has_method("is_on_floor"):
		if not parent.is_on_floor():
			extra = 3
	charge_power = time * charge_mult * extra
	if charge_power > charge_cap:
		charge_power = charge_cap
	bullet_count -= 1
 
	shoot_sound.play()
	var particles = blast_particles.instantiate()
	var bullets = bullet_particles.instantiate()
	bullets.emitting = true
	particles.emitting = true
	particles.finished.connect(func(): _on_particles_finished(particles))
	bullets.finished.connect(func(): _on_particles_finished(bullets))
	marker_2d.add_child(particles)
	marker_2d.add_child(bullets)
	Signals.shake_camera.emit(shake_power)
	if not charge_stopwatch.stopped:
		charge_stopwatch.reset()
		charge_stopwatch.stop()
func charge():
	if bullet_count > 0:
		Signals.gun_charge.emit(self)
		charge_stopwatch.start()
func cancel_charge():
	stop_charge = true
	
func reload():
	$ReloadSound.play()
	is_reloading = true
	
	play("reload")
	await get_tree().create_timer(reload_speed).timeout
	add_bullets(2)
func add_bullets(value: int):
	is_reloading = false
	bullet_count += value
	Signals.gun_reload.emit(self)
	if bullet_count > Constants.MAX_BULLET_COUNT:
		bullet_count = Constants.MAX_BULLET_COUNT
func fast_reload():
	$ReloadSound.play()
	get_tree().create_timer(0.25).timeout
	add_bullets(2)
func save() ->Dictionary:
	var data: Dictionary
	data["bullet_count"] = bullet_count
	return data
func load(data: Dictionary):
	if data.has("bullet_count"):
		bullet_count = data.get("bullet_count");
 
#Not a signal
func _on_particles_finished(particles):
	particles.queue_free()
	
func begin_shoot():
	stop_charge = false
	 
	$ChargeDelay.start()
	
func _on_charge_delay_timeout() -> void:
	if stop_charge:
		return
	 
	charge()
 
func _on_bullets_set(new_value: int):
	bullet_count = new_value
	if is_empty() and SettingsData.auto_reload:
		reload()
func _on_animation_finished() -> void:
	play("idle")
