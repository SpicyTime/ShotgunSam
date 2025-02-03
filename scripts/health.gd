class_name Health
extends Node
@export var health : int = 10 : set = set_health, get = get_health
@export var max_health: int = 10 : set = set_max_health, get = get_max_health
signal health_changed(diff : int)
signal max_health_changed(diff : int)
signal health_depleted
func set_health(value : int):
	health = value
	health_changed.emit(health)
	if health <= 0:
		health_depleted.emit()
func set_max_health(value : int):
	max_health = value
	max_health_changed.emit(max_health)
func get_health() -> int:
	return health
func get_max_health() -> int:
	return max_health
