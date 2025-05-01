extends Node2D
@onready var line_2d: Line2D = $Line2D
@onready var collision_shape_2d: CollisionShape2D = $Hitbox/CollisionShape2D

func start():
	
	line_2d.add_point(Vector2(0, 0))
	line_2d.add_point(Vector2(0, 0))
 	
func remove_laser() -> void:
	line_2d.clear_points()
	collision_shape_2d.shape.extents.x = 0
	
func extend(amount: float) -> void:
	 
	# Extend the line visually
	line_2d.points[1].x += amount

	# Update the collision shape
	var shape := collision_shape_2d.shape as RectangleShape2D
	shape.extents.x += abs(amount)

	# Move the shape forward to match visual extension
	collision_shape_2d.position.x = shape.extents.x
func get_line() -> Line2D:
	return line_2d
	 
func get_tip():
	return line_2d.points[1]
func is_colliding_with_map() -> bool:
	var terrain: TileMapLayer = get_tree().get_first_node_in_group("Level").find_child("Terrain")
	
	var tip = get_tip()
	var global_pos = to_global(tip)
	var x: int = global_pos.x / Constants.TILE_SIZE
	var y: int = round(global_pos.y / Constants.TILE_SIZE)
	print("X: ", x)
	print("Y: ", y)
	var source_id = terrain.get_cell_source_id(Vector2i(x, y))
	print(source_id)
	return source_id != -1
	 
	 
