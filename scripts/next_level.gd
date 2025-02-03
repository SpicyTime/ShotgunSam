extends Area2D
signal change_scene(next_level_scene_path)
const FILE_BEGIN: String= "res://levels/l_"
func _on_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return
	var level_name:String = get_parent().get_parent().get_name()
	var next_level_number: int = level_name.to_int() + 1
	var next_level_path: String = FILE_BEGIN + str(next_level_number) + ".tscn"
	change_scene.emit(next_level_path)
	
