class_name LaserBox
extends Sprite2D
@export var receiver: bool = false
@export var id: int = 0
@export var flip_sprite: bool = false
@export var paired_laser_box: LaserBox = null
var is_emitting: bool = false
var lasers: Array = []
var current_laser

func emit_laser() -> void:
	if not receiver:
		is_emitting = true
	 	
		current_laser.start(current_laser.position)
func stop_emitting() -> void:
	if not receiver: 
		is_emitting = false
		 
func extend_laser(amount):
	current_laser.extend(amount)
	
func _ready() -> void:
	if not receiver:
		var packed_laser_scene = preload("res://scenes/laser.tscn")
		current_laser = packed_laser_scene.instantiate()
		add_child(current_laser)
 		
		await get_tree().process_frame
		current_laser.position = Vector2(-4, 0)
		lasers.append(current_laser)
		
		 
		emit_laser()
		Signals.mirror_hit.connect(_on_mirror_hit)
	if flip_sprite:
		flip_h = true
	 
 
func _physics_process(delta: float) -> void:
	if is_emitting:
		for laser in lasers:
			laser.extend( delta * 1000)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is HitBox and area.get_parent() is Laser  and receiver:
		Signals.laser_receiver_hit.emit(id)
		
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is HitBox and area.get_parent() is Laser and receiver:
		Signals.laser_receiver_unhit.emit(id)
		 
func _on_mirror_hit(laser, mirror):
	print(laser.id, id)
	if laser.id != id:
		return
	mirror.hit = true
	 
	var surface_direction = Vector2(cos(mirror.rotation), sin(mirror.rotation))
	var mirror_normal = surface_direction.rotated(PI / 2)
 
	 
	var new_direction = laser.direction - 2 * laser.direction.dot(mirror_normal) * mirror_normal
	var packed_laser_scene = load("res://scenes/laser.tscn")
	var new_laser = packed_laser_scene.instantiate()
	
	await get_tree().process_frame
	add_child(new_laser)
	new_laser.direction = new_direction
	new_laser.start(Vector2(-100, 100))
	
	lasers.append(new_laser)
