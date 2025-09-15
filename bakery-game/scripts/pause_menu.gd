extends Node2D

@export var layer : CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_pressed() -> void:
	get_tree().paused = false
	layer.hide()


func _on_pause_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
