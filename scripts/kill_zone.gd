extends Area2D
@onready var player: CharacterBody2D =get_node("/root/Game/Player")
@onready var kill_zone: Area2D = $"."
@onready var game: Node2D = get_node("/root/Game")

 
func _on_body_entered(body: Node2D) -> void:
	if body == get_parent():
		return
	if body.has_method("get_name"):
 
		if body.get_name() == "Player":
			Signals.reset_level.emit()
			 
	 

func _on_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area.has_signal("target_hit"):
		area.queue_free()


 


 
