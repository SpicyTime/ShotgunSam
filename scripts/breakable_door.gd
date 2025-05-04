extends StaticBody2D
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var health: Health = $Health

func crack():
	animations.frame += 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.health_changed.connect(_on_health_changed)
	Signals.health_depleted.connect(_on_health_depleted)

func _on_health_changed(_diff: int, sender):
	if sender == health:
		crack()
func _on_health_depleted(sender):
	if sender == health:
		queue_free()
	
	
