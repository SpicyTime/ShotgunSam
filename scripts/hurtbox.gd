class_name HurtBox
extends Area2D
@export var health : Health
func _ready()->void:
	connect("area_entered", _on_area_entered)
	
	
func _on_area_entered(area):
	
	if not area is HitBox or not health or not area:
		return
	print("HELLO")
	var new_health = health.health - area.damage
	health.set_health(new_health)
	Signals.received_damage.emit(area.damage)
 
