extends CanvasLayer

var done : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Allows game to start when player presses done in making minigame.
	if Global.making_done and not Global.moulding_done:
		show() # Shows minigame.
		done = false
	
	# When dough is finished being moulded, closes out of moulding minigame and resets minigame.
	if Global.moulding_done and not done:
		hide()
		Global.can_move = true # Allows movement after minigame.
		get_child(0).queue_free() # Deletes current minigame node.
		
		# Adds instance of minigame node to reset minigame to original state.
		const MOULDING_SCENE := preload("res://scenes/moulding_minigame_3.tscn")
		var instance := MOULDING_SCENE.instantiate()
		add_child(instance)
		done = true # Stops code from continuing to process.
