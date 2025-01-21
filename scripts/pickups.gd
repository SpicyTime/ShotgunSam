extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_bullets"):
		body.add_bullets(2)
	queue_free()
