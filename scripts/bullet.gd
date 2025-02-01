extends CharacterBody2D

@export var SPEED = 200
@onready var despawn_timer: Timer = $DespawnTimer

var dir: Vector2
var spawn_pos: Vector2
var spawn_rot: float
	
func _ready():
	global_position = spawn_pos
	global_rotation = spawn_rot
	despawn_timer.start()
	
func _physics_process(_delta: float) -> void:
	velocity = dir * SPEED
	move_and_slide()
 
func _on_despawn_timer_timeout() -> void:
	queue_free()


 


func _on_bullet_collider_body_entered(body: Node2D) -> void:
	queue_free()
