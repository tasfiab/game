extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide() # Hides options menu on ready.

# Hides menu when back button is pressed.
func _on_back_pressed() -> void:
	hide()
