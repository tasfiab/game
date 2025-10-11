extends TextureButton

var paused : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause()
		


func pause():
	if get_tree().paused:
		get_tree().paused = false
	else:
		get_tree().paused = true
		

		
	
func _on_pause_button_pressed() -> void:
	pause()
