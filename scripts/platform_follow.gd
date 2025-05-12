extends PathFollow2D
@onready var parent: Path2D = get_parent()

@export var speed: float = 1.0
func _ready() ->void:
	var siblings = parent.get_children()
	for sibling in siblings:
		if sibling is MovingPlatform:
			parent.remove_child.call_deferred(sibling)
			add_child.call_deferred(sibling)
	 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void: 
	progress_ratio += delta * speed
