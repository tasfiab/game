extends Node2D

@export var progress : ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("interact"):
		pass


func _on_loaf_button_pressed() -> void:
	pass # Replace with function body.


func _on_crossaint_button_pressed() -> void:
	pass # Replace with function body.


func _on_baguette_button_pressed() -> void:
	pass # Replace with function body.


func _on_hold_button_pressed() -> void:
	pass # Replace with function body.
