extends Node2D

@export var background_music : AudioStreamPlayer2D
@export var options_menu : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background_music.play()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/bakery.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	options_menu.show()
