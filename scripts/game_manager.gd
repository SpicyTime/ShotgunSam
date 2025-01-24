extends Node
@onready var bullet_count_label: Label = %BulletCountLabel

@onready var player: CharacterBody2D = %Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player:
		player.shots_changed.connect(_on_player_shots_changed)
		_on_player_shots_changed(player.current_shot_count)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_player_shots_changed(new_value: int):
	bullet_count_label.text = str("Shot count: ", new_value)
