extends Node
@export var root_path : NodePath
@onready var sounds = {
	&"UI_Hover" : AudioStreamPlayer.new(),
	&"UI_Pressed" : AudioStreamPlayer.new()
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(root_path != null, "Empty root path for Interface Sounds")
	
	for i in sounds.keys():
		sounds[i].stream = load("res://assets/SFX/" + str(i) + ".mp3")
		sounds[i].bus = &"Master"
		add_child(sounds[i])
		if sounds[i].has_method("add_to_group"):
			
			sounds[i].add_to_group("UI_SFX")
	install_sounds(get_node(root_path))
func install_sounds(node: Node):
	for i in node.get_children():
		if i is Button:
			i.mouse_entered.connect(_ui_sfx_play.bind(&"UI_Hover"))
			i.pressed.connect(_ui_sfx_play.bind(&"UI_Pressed"))
func _ui_sfx_play(sound: String):
	print("Playing", sound)
	sounds[sound].play()

 
