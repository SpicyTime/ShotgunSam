class_name HurtBox
extends Area2D
signal received_damage(damage: int)
@export var health : Health
func _ready()->void:
	connect("area_entered", _on_area_entered)
func _on_area_entered(hitbox : HitBox):
	if hitbox != null:
		var new_health = health.health - hitbox.damage
		health.set_health(new_health)
		received_damage.emit(hitbox.damage)
 
