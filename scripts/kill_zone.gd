extends Area2D
@onready var player: CharacterBody2D =get_node("/root/Game/Player")
@onready var kill_zone: Area2D = $"."


func reset():
	get_tree().reload_current_scene()
func _on_body_entered(body: Node2D) -> void:
	if body == get_parent():
		return
	if body == player:
		call_deferred("reset") 
	elif body is CharacterBody2D and body != kill_zone:
		body.queue_free()
	elif body.has_method("is_obstacle"):
		body.queue_free()

func _on_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area.has_signal("target_hit"):
		area.queue_free()
