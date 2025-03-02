extends Area2D
const FILE_BEGIN: String= "res://levels/l_"
func _ready():
	var collision_shape = get_child(0)
	if collision_shape:
		if collision_shape is CollisionShape2D:
			# Makes sure that the player does not hit it overlaps with the previous level's next level node
			await get_tree().create_timer(0.1).timeout
			collision_shape.disabled = false
func _on_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return
	var path_string = get_path() as String
	var elements = path_string.split("/")
	var level_name:String = elements[2]
	 
	var next_level_number: int = level_name.to_int() + 1
 
	var next_level_path: String = FILE_BEGIN + str(next_level_number) + ".tscn"
	Signals.swap_level.emit(next_level_path)
	
