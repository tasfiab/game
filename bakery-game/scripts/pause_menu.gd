extends Node2D

@export var pause_layer : CanvasLayer
@export var options_menu : Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_layer.hide()


# Unpauses game when resume pressed.
func _on_resume_pressed() -> void:
	get_tree().paused = false
	pause_layer.hide()


# Changes scene to main menu when quit pressed.
func _on_pause_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


# Shows options menu when options button pressed.
func _on_options_pressed() -> void:
	pause_layer.hide()
	options_menu.show()


# Shows pause menu when options menu is exited.
func _on_options_menu_hidden() -> void:
	pause_layer.show()
	
