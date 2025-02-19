extends Area2D
const FILE_BEGIN: String= "res://levels/l_"
func _on_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return
	var path_string = get_path() as String
	var elements = path_string.split("/")
	var level_name:String = elements[2]
	print(path_string + "Hit")
	var next_level_number: int = level_name.to_int() + 1
 
	var next_level_path: String = FILE_BEGIN + str(next_level_number) + ".tscn"
	Signals.change_scene.emit(next_level_path)
	print(path_string + " Emitting " + next_level_path)
	
