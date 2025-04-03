extends Node
class_name Stopwatch
var time = 0.0
var stopped: bool = true
func _process(delta: float) -> void:
	if stopped:
		return
	time += delta
func reset():
	 
	time = 0.0
func start():
 
	stopped = false
func stop():
	 
	stopped = true
