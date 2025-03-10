extends Node
var dialogue_lines: Array = []
var current_dialogue_index = 0
var text_box_scene = preload("res://scenes/text_box.tscn")
var text_box

var can_advance_line: bool = false
var is_dialogue_active
# Called when the node enters the scene tree for the first time.
func start_dialogue(dialogue_key: String):
	if is_dialogue_active:
		return
	load_dialogue(dialogue_key)
	show_text_box()
	Signals.dialogue_toggled.emit(true)
	is_dialogue_active = true
	Signals.text_display_finished.connect(_on_text_box_display_finished)
func show_text_box( ):
	text_box = text_box_scene.instantiate()
	 
	get_tree().root.add_child(text_box)
	text_box.display_text(dialogue_lines[current_dialogue_index])
	can_advance_line = false
func _on_text_box_display_finished():
	can_advance_line = true
func load_dialogue(dialogue_key: String) :
	var file = FileAccess.open("res://dialogue.json", FileAccess.READ)
	if not file:
		return
	var json_string = file.get_as_text()
	file.close()
 
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result == OK:
		var data = json.get_data()
 
		var dialogue = data.get(dialogue_key, [])
		if dialogue.is_empty():
			return
		else:
			dialogue_lines = dialogue
			
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") && is_dialogue_active && can_advance_line:
		text_box.queue_free()
		current_dialogue_index += 1
		if current_dialogue_index >= dialogue_lines.size():
			is_dialogue_active = false
			Signals.dialogue_toggled.emit(false)
			current_dialogue_index = 0
			return
		 
		show_text_box()
