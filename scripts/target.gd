extends Area2D
var linked_body: Node2D
signal target_hit(target)
func link(body: Node2D):
	linked_body = body
func destroy():
	target_hit.emit(self)
# Called when the node enters the scene tree for the first time.


func _on_tree_exiting() -> void:
	destroy()
