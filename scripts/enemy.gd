extends CharacterBody2D
@onready var left: RayCast2D = $Left
@onready var right: RayCast2D = $Right
@onready var sprite: Sprite2D = $Sprite2D

@onready var pickup = load("res://scenes/pickups.tscn")
@onready var game = get_tree().get_root().get_node("Game")
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var direction = 1
func is_edge()->bool:
	 
	if not right.is_colliding() or not left.is_colliding():
		return true
	return false
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_edge():
		direction *= -1
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if direction == 1:
		sprite.flip_h = true
	elif direction == -1:
		sprite.flip_h = false
	move_and_slide()
	


func _on_child_exiting_tree(node: Node) -> void:
	var instance = pickup.instantiate()
	instance.global_position = global_position
	game.add_child.call_deferred(instance)
