extends Node2D
@onready var line_2d: Line2D = $Line2D
@onready var collision_shape_2d: CollisionShape2D = $Hitbox/CollisionShape2D

func start():
	
	line_2d.add_point(Vector2(0, 0))
	line_2d.add_point(Vector2(0, 0))
 
	

func stop() -> void:
	line_2d.clear_points()
	collision_shape_2d.shape.extents.x = 0
func extend(amount: float) -> void:
	 
	# Extend the line visually
	line_2d.points[1].x += amount

	# Update the collision shape
	var shape := collision_shape_2d.shape as RectangleShape2D
	shape.extents.x += amount

	# Move the shape forward to match visual extension
	collision_shape_2d.position.x = shape.extents.x
func get_line() -> Line2D:
	return line_2d
	 
