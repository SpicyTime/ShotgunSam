extends Node
class_name Stopwatch
var time = 0.0
var stopped: bool = true
func _process(delta: float) -> void:
	if stopped:
		return
	time += delta
func reset():
	#print("Resetting stopwatch")
	time = 0.0
func start():
	#print("Starting stopwatch")
	stopped = false
func stop():
	#print("Stopping stopwatch")
	stopped = true
