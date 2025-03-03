extends Area2D


 

func _on_body_entered(body: Node2D) -> void:
	get_tree().get_node("Stopwatch").stop()
	get_tree().change_scene_to_file("res://scenes/menus/game_end_screen.tscn")
