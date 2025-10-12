extends Node2D
var main_scene = preload("res://scenes/bakery.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# When player presses button to start next day
func _on_next_day_pressed() -> void:
	get_tree().paused = false
	Global.next_day.emit()
	Global.new_day = true
	Global.day_end = false
	Global.current_day += 1
	
