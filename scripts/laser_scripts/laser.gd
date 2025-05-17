extends Node2D
class_name Laser
@onready var line_2d: Line2D = $Line2D
@onready var collision_shape_2d: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var ray: RayCast2D = $RayCast2D
@onready var id  = get_parent().id
var direction: Vector2 = Vector2(-1.0, 0.0)
var tip_point: int = 1
var ray_collision_point = Vector2.ZERO
var prev_collision_pos
func start(start_pos):
	 
	line_2d.add_point(start_pos)
	line_2d.add_point(start_pos)
	 
func remove_laser() -> void:
	line_2d.clear_points()
	collision_shape_2d.shape.extents.x = 0
func get_ray_end_point():
	return ray.global_position + ray.target_position

func sync_collision_with_line():
	var shape := collision_shape_2d.shape as RectangleShape2D
	
	var start_point := line_2d.points[0]
	var end_point := line_2d.points[tip_point]
	
	var delta := end_point - start_point
	var length := delta.length()
	var angle := delta.angle()
	
	# Set the size of the rectangle to match the line length
	shape.extents = Vector2(length / 2.0, shape.extents.y)
	
	# Position the shape at the center of the line
	collision_shape_2d.position = (start_point + end_point) / 2.0
	
	# Rotate the collision shape to match the line's angle
	collision_shape_2d.rotation = angle

	 
func extend(speed: float) -> void:
	
	 
	if ray.is_colliding():
		 
		 
		sync_collision_with_line()
		return
		
	var tip = get_tip()
	var extend_amount = tip + speed * direction
	prev_collision_pos = ray.target_position
	ray.target_position = extend_amount
	
	 
	# Extend the line visually
	#print(speed* direction)
	line_2d.points[tip_point] += speed * direction
	sync_collision_with_line()
	 
	
func get_line() -> Line2D:
	return line_2d
	 
func get_tip() -> Vector2:
	return line_2d.points[tip_point]

 

	 
	 
