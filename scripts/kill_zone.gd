extends Area2D
@onready var player: CharacterBody2D =get_node("/root/Game/Player")
@onready var kill_zone: Area2D = $"."



func _on_body_entered(body: Node2D) -> void:
	if body == player:
		get_tree().reload_current_scene()
	elif body is CharacterBody2D and body != kill_zone or body.has_method("is_obstacle"):
		body.queue_free()
