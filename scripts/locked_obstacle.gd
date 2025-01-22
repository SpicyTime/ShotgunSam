extends StaticBody2D

var linked_targets: Array[Area2D]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child.has_signal("target_hit"):
			child.target_hit.connect(_on_target_hit)
			 
			linked_targets.append(child)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
func _on_target_hit(target: Area2D):
	if target in linked_targets:
		linked_targets.erase(target)
	if not linked_targets.size():
		queue_free()
