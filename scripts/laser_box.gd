extends Sprite2D
@export var receiver: bool = false
@onready var laser: Node2D = $Laser
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

func _ready() -> void:
	emit_laser()
func _process(delta: float) -> void:
	if is_emitting:
		laser.extend( -delta * 100)
