extends Node2D
@onready var viewport = get_viewport()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.start_dialogue("Intro")
	Signals.dialogue_toggled.connect(_on_dialogue_toggled)
	
func _process(delta: float):
	$TileMapLayer.global_position.y -= 1000 * delta
	if $TileMapLayer.global_position.y < -viewport.size.y:
		$TileMapLayer.global_position = Vector2(0, 0)
func _on_dialogue_toggled(showing: bool):
	#changes to the game scene when the intro dialogue ends
	if not showing:
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	 
	
	
