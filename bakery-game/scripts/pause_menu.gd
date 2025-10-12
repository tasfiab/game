extends Node2D

@export var pause_layer : CanvasLayer
@export var options_menu : Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_resume_pressed() -> void:
	get_tree().paused = false
	pause_layer.hide()


func _on_pause_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_options_pressed() -> void:
	pause_layer.hide()
	options_menu.show()


func _on_options_menu_hidden() -> void:
	pause_layer.show()
	
