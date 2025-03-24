extends Node
var dialogue_lines: Array = []
var current_dialogue_index = 0
var text_box_scene = preload("res://scenes/text_box.tscn")
var text_box
var all_dialogue_lines: Dictionary
var can_advance_line: bool = false
var is_dialogue_active
var current_dialogue_key
var node_name = "dialogue"
var swapping_text_box: bool
func get_node_name():
	return node_name;
func load_dialogue_from_file():
	var file = FileAccess.open("res://dialogue.json", FileAccess.READ)
	if not file:
		return
	var json_string = file.get_as_text()
	file.close()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result == OK:
		var data = json.get_data()
		all_dialogue_lines = data
# Called when the node enters the scene tree for the first time.
func start_dialogue(dialogue_key: String):
	if is_dialogue_active or not all_dialogue_lines.has(dialogue_key):
		return
	load_dialogue(dialogue_key)
	show_text_box()
	Signals.dialogue_toggled.emit(true)
	is_dialogue_active = true
	Signals.text_display_finished.connect(_on_text_box_display_finished)
func show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.global_position = Vector2( 0, 304)
	get_tree().root.add_child(text_box)
	text_box.display_text(dialogue_lines[current_dialogue_index])
	can_advance_line = false
func swap_text_box():
	if is_instance_valid(text_box):
		text_box.queue_free()
	current_dialogue_index += 1
	if current_dialogue_index >= dialogue_lines.size():
		is_dialogue_active = false
		Signals.dialogue_toggled.emit(false)
		current_dialogue_index = 0
		print("Dialogue unactive")
		return
	show_text_box()
func save()->Dictionary:
	var data: Dictionary
	data["current_dialogue"] = current_dialogue_key
	data["current_line"] = current_dialogue_index
	return data
func load(data: Dictionary):
	if data.has("current_dialogue"):
		var key = data.get("current_dialogue")
		if key == "":
			return	
		load_dialogue(data.get("current_dialogue"))
	if data.has("current_line"):
		current_dialogue_index = data.get("current_line")
func stop()->void:
	can_advance_line = false
	is_dialogue_active = false
	if is_instance_valid(text_box):
		text_box.queue_free()
	print("freeing")
	
func load_dialogue(dialogue_key: String):
	current_dialogue_key = dialogue_key
	dialogue_lines = all_dialogue_lines[dialogue_key]
	
func _on_text_box_display_finished():
	can_advance_line = true
	if is_dialogue_active:
		var next = current_dialogue_index + 1
		await get_tree().create_timer(3).timeout
		if next != current_dialogue_index && is_dialogue_active:
			swap_text_box()
 
func _ready():
	add_to_group("game_savables")

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") && is_dialogue_active && can_advance_line:
		swap_text_box()
