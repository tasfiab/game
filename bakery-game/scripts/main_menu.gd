extends Node2D

@export var background_music : AudioStreamPlayer2D
@export var options_menu : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background_music.play()

# When play button is pressed, changes file to main bakery scene.
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/bakery.tscn")

# Quits game when quit is pressed.
func _on_quit_pressed() -> void:
	get_tree().quit()

# Shows option menu when options button pressed.
func _on_options_pressed() -> void:
	options_menu.show()
