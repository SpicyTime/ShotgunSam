extends Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	GameData.coin_picked_up = true
	if body.has_method("add_coins"):
		body.add_coins(1)
	 
	animation_player.play("pickup")
