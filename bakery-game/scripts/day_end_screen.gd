extends Node2D


# When player presses button to start next day.
func _on_next_day_pressed() -> void:
	get_tree().paused = false # Makes game unpaused.
	
	Global.next_day.emit() # Signal to player script for new day.
	
	Global.new_day = true
	Global.day_end = false
	Global.current_day += 1
	
