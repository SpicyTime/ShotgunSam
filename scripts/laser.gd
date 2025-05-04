extends Node2D
@onready var line_2d: Line2D = $Line2D
@onready var collision_shape_2d: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var ray: RayCast2D = $RayCast2D
var stop: bool = false
func start():
	
	line_2d.add_point(Vector2(0, 0))
	line_2d.add_point(Vector2(0, 0))
	stop = false
func remove_laser() -> void:
	line_2d.clear_points()
	collision_shape_2d.shape.extents.x = 0
func sync_collision_with_line():
	var shape := collision_shape_2d.shape as RectangleShape2D
	var width := line_2d.points[1].x
	var half_width: float= abs(width) / 2.0
	
	shape.extents = Vector2(half_width, shape.extents.y)  # Always positive size

	# Center the collision shape between the two points
	collision_shape_2d.position.x = width / 2.0
	
func extend(amount: float) -> void:
	var tip = get_tip()
	ray.target_position.x = tip.x + amount
	if ray.is_colliding():
		 
		line_2d.points[1] = to_local(ray.get_collision_point())
		stop = true
		return
		
	# Extend the line visually
	line_2d.points[1].x += amount
	sync_collision_with_line()
	 
	
func get_line() -> Line2D:
	return line_2d
	 
func get_tip() -> Vector2:
	return line_2d.points[1]

func is_colliding_with_map() -> bool:
	var terrain: TileMapLayer = get_tree().get_first_node_in_group("Level").find_child("Terrain")
	
	var tip = get_tip()
	var global_pos = to_global(tip)
	var x: int = global_pos.x / Constants.TILE_SIZE
	var y: int = round(global_pos.y / Constants.TILE_SIZE)
	 
	var source_id = terrain.get_cell_source_id(Vector2i(x, y))
	 
	return source_id != -1
	 
	 
