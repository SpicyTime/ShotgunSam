extends Camera2D
@export var decay : float  = 0.8
@export var max_offset : Vector2 = Vector2(100, 75)

@export var max_roll : float = 0.1
var trauma : float = 0.0
var trauma_power : int = 2
 
func shake()->void:
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1) + 16
# Called when the node enters the scene tree for the first time
func add_trauma(amount: float)-> void:
	trauma = min(trauma + amount, 1.0)
func _ready() -> void:
	randomize()
	Signals.shake_camera.connect(_on_camera_shake)
	 
	 
	 
	 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	 
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
	else:
		offset.y = 16
 
func _on_camera_shake(trauma: float):
	add_trauma(trauma)
