extends AnimatableBody2D
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var receiver_id: int = 0
func unlock():
	animations.frame = 0
	animation_player.play("move")
func lock():
	animations.frame = 1
	animation_player.play_backwards("move")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.laser_receiver_hit.connect(_on_laser_receiver_hit)
	Signals.laser_receiver_hit.connect(_on_laser_receiver_unhit)
func _on_laser_receiver_hit(id: int):
	if id == receiver_id:
		unlock()
func _on_laser_receiver_unhit(id: int):
	if id == receiver_id:
		lock()
	 
 	
