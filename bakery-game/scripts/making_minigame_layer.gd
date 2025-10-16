extends CanvasLayer

const INTERACT_BIND := "interact"
var done : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide() # Hides layer when play pressed.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Allows game to start when player interacts with making counter after getting order.
	if Global.can_start_making and Global.order_start and not Global.making_done:
		if Input.is_action_just_pressed(INTERACT_BIND):
			Global.can_move = false
			show() # Shows minigame.
			done = false
	
	# When dough is finished being made, closes out of making minigame and resets minigame.
	if Global.making_done and not done:
		hide()
		get_child(0).queue_free() # Deletes current minigame node.
		
		# Adds instance of minigame node to reset minigame to original state.
		const MINIGAME_SCENE := preload("res://scenes/mixing_minigame.tscn")
		var scene_instance := MINIGAME_SCENE.instantiate() 
		add_child(scene_instance)
		done = true # Stops code from continuing to process.
