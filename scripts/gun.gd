extends Sprite2D
@export var gun_power = 10
@onready var bullet = load("res://scenes/bullet.tscn")
@onready var game = get_tree().get_root().get_node("Game")
var direction
var distance: float
func rotate_around(radius):
	# Get the global position of the mouse
	var mouse_global_pos = get_global_mouse_position()
	look_at(mouse_global_pos)
	# Get the parent's global position
	var parent_global_pos = get_parent().global_position 
	distance = sqrt(pow((parent_global_pos.x - mouse_global_pos.x), 2) + 
	pow((parent_global_pos.y - mouse_global_pos.y), 2))

	# Calculate the direction vector from the parent to the mouse
	direction = mouse_global_pos - parent_global_pos
	var angle = direction.angle()
	# Calculate the position based off of the angle and the radius
	var new_position = Vector2(cos(angle), sin(angle)) * radius
	 
	
	# Set the child's position relative to the parent
	position = new_position
 
func shoot():
	var instance = bullet.instantiate()
	instance.dir = direction.normalized()
	instance.spawn_pos = $Marker2D.global_position
	instance.spawn_rot = rotation 
	game.add_child.call_deferred(instance)
