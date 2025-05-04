class_name LaserBox
extends Sprite2D
@export var receiver: bool = false
@export var id: int = 0
@export var flip_sprite: bool = false
@onready var laser: Node2D = $Laser
@export var paired_laser_box: LaserBox = null
var is_emitting: bool = false
 
func start_laser():
	is_emitting = true
	
func emit_laser() -> void:
	if not receiver:
		start_laser()
		laser.start()
func stop_emitting() -> void:
	if not receiver: 
	 
		is_emitting = false
func extend_laser(amount):
	laser.extend(amount)
func _ready() -> void:
	if not receiver:
		
		emit_laser()
	else:
		remove_child(get_node("Laser"))
	if flip_sprite:
		flip_h = true
	 
 
func _physics_process(delta: float) -> void:
	if is_emitting:
		if laser.is_colliding_with_map() or laser.stop:
			is_emitting = false
			return
			
		laser.extend( -delta * 1000)
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is HitBox and receiver and area != self:
		Signals.laser_receiver_hit.emit(id) 
		stop_emitting()
