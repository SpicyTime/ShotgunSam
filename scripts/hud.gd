extends Control
@onready var label: Label = $CanvasLayer/Timer/Label
@export var distance: float = 15
var max_digit_count := 0
func get_charge_meter() -> Control:
	return $CanvasLayer/ChargeMeter
func get_charge_bar() -> ColorRect:
	return $CanvasLayer/ChargeMeter/Meter
func get_total_digits(value: float) -> int:
	var str_val = str(value)
	str_val = str_val.replace(".", "") # remove decimal point
	
	return str_val.length()

func _ready():
	Signals.game_stopwatch_changed.connect(_on_game_stopwatch_changed)
	
func _on_game_stopwatch_changed(time):
	var cont_node = $CanvasLayer/Timer
	var time_string: String
	time = round(time * 100) / 100.0
	time_string = str(time)
	var current_digit_count = get_total_digits(time)
	while current_digit_count < max_digit_count:
		current_digit_count += 1
		time_string += "0"
	if current_digit_count > max_digit_count:
		max_digit_count = current_digit_count
	cont_node.global_position.x = get_viewport().size.x - distance * current_digit_count
	
	label.text = time_string
