extends StaticBody2D
const MAX_HEALTH = 10
var health: int = MAX_HEALTH
# Called when the node enters the scene tree for the first time.
func is_obstacle():
	pass
func take_damage(amount: int):
	health -= amount
func heal(amount: int):
	health += amount
	if health > MAX_HEALTH:
		health = MAX_HEALTH
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
