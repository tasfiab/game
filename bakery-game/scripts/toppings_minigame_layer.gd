extends CanvasLayer

const INTERACT_BIND := "interact"
var done : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide() # Hides minigame when play pressed.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Allows game to start when player interacts with toppings counter after baking dough.
	if (
		Global.can_start_toppings and Global.baking_done 
		and Input.is_action_just_pressed(INTERACT_BIND)
	):
		Global.can_move = false # Stops player movement in minigame.
		show() # Shows minigame.
		done = false
			
	# When item is finished being made, closes out of toppings minigame and resets minigame.
	if Global.toppings_done and not done:
		hide()
		get_child(0).queue_free() # Deletes current minigame node.
		
		# Adds instance of minigame node to reset minigame to original state.
		const TOPPING_SCENE := preload("res://scenes/toppings_minigame.tscn")
		var instance := TOPPING_SCENE.instantiate()
		add_child(instance)
		Global.can_move = true # Allows movement after minigame.
		done = true # Stops code from continuing to process.
