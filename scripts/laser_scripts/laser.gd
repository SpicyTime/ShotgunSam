extends Node2D
class_name Laser
@onready var line_2d: Line2D = $Line2D
@onready var collision_shape_2d: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var ray: RayCast2D = $RayCast2D
@onready var id  = get_parent().id
var direction: Vector2 = Vector2(-1.0, 0.0)
var tip_point: int = 1
func start(start_pos):
	line_2d.add_point(start_pos)
	line_2d.add_point(start_pos)
	 
func remove_laser() -> void:
	line_2d.clear_points()
	collision_shape_2d.shape.extents.x = 0
	
func sync_collision_with_line():
	var shape := collision_shape_2d.shape as RectangleShape2D
	var width := line_2d.points[tip_point].x
	var half_width: float= abs(width) / 2.0
	
	shape.extents = Vector2(half_width, shape.extents.y)  # Always positive size

	# Center the collision shape between the two points
	collision_shape_2d.position.x = width / 2.0
	
func extend(speed: float) -> void:
	var tip = get_tip()
	ray.target_position = tip + speed * direction
	if ray.is_colliding():
		 
		line_2d.points[tip_point] = to_local(ray.get_collision_point())
		sync_collision_with_line()
		return
	# Extend the line visually
	#print(speed* direction)
	line_2d.points[tip_point] += speed * direction
	sync_collision_with_line()
	 
	
func get_line() -> Line2D:
	return line_2d
	 
func get_tip() -> Vector2:
	return line_2d.points[tip_point]

 

	 
	 
