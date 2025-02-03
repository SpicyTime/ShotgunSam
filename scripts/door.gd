extends AnimatableBody2D


# Called when the node enters the scene tree for the first time.
func _on_health_changed(diff: int) -> void:
	if diff == 0:
		return
	var next_texture = $Sprite2D.texture.get_path().to_int() + 1
	var next_texture_path  = "res://assets/art/DoorCracked" + str(next_texture) + ".png"
	var new_texture = load(next_texture_path)
	if new_texture:
		$Sprite2D.texture = new_texture
func open_door():
	$Sprite2D.visible = false
	$DoorCollider.disabled = true
	$NextLevel/NextLevelCollider.disabled = false
	$HurtBox/CollisionShape2D.disabled = true
func _on_health_depleted() -> void:
	call_deferred("open_door")
