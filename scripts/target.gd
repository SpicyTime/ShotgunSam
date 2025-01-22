extends Area2D
var linked_body: Node2D
signal target_hit(target)
func link(body: Node2D):
	linked_body = body
func destroy():
	target_hit.emit(self)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tree_exiting() -> void:
	destroy()
