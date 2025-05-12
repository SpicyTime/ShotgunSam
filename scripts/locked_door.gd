extends AnimatableBody2D
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var receiver_id: int = 0
@export var required_receivers: int = 0
func unlock():
	animation_player.play("move")
	animations.frame = 1
func lock():
	animation_player.play_backwards("move")
	animations.frame = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.laser_receiver_hit.connect(_on_laser_receiver_hit)
	Signals.laser_receiver_unhit.connect(_on_laser_receiver_unhit)
	 
func _on_laser_receiver_hit(id: int):
	if id == receiver_id:
		required_receivers -= 1
		if required_receivers == 0:
			unlock()
func _on_laser_receiver_unhit(id: int):
	if id == receiver_id:
		lock()
		required_receivers += 1
		 
	 
 	
