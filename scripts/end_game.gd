extends Node

func _ready() ->void:
	Signals.dialogue_toggled.connect(_on_text_display_finished)
	get_tree().current_scene.get_node("Stopwatch").stop()
	
func _on_text_display_finished(showing):
	if not showing:
		get_tree().change_scene_to_file("res://scenes/menus/game_end_screen.tscn")
 
