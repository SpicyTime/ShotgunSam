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
		print("Stopped")
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
		laser.extend( -delta * 1000)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is HitBox and area.get_parent() is Laser  and receiver:
		#stop_emitting()
		print("Hit")
		Signals.laser_receiver_hit.emit(id)
		
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is HitBox and area.get_parent() is Laser and receiver:
		print("Unhit")
		Signals.laser_receiver_unhit.emit(id)
		 
		
