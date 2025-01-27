extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_coins"):
		body.add_coins(1)
	queue_free()
