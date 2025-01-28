extends Area2D
const NODE_PATH_BEGIN = "/root/Game/Levels/"
"res://scenes/next_level.tscn"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var parent = get_parent()
		if parent.is_in_group("Levels"):
			parent.visible = false
			var level_name = parent.get_name()
			var next_level_number = level_name.to_int() + 1
			print(next_level_number)
			var next_level_node_path = NODE_PATH_BEGIN + "L" + str(next_level_number)
			var next_level = get_node(next_level_node_path)
			next_level.visible = true
			var next_level_spawn_position = next_level.get_child(4)
			if next_level_spawn_position:
				body.global_position =next_level_spawn_position.global_position
			
