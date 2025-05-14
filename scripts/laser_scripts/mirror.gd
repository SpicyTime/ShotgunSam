extends StaticBody2D
var hit: bool = false
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Laser:
		if not hit:
			Signals.mirror_hit.emit(area.get_parent(), self)
