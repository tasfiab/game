extends CanvasLayer

const TOPPING_SCENE_INDEX := 0
const TOPPING_SCENE := preload("res://scenes/toppings_minigame.tscn")
const INTERACT_BIND := "interact"

var done : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Hides minigame when game is first playing
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.toppings_minigame_start and Global.baking_done:
		if Input.is_action_just_pressed(INTERACT_BIND):
			Global.in_topping_minigame = true
			show()
			done = false
			
			# When item is finished being made, closes out of toppings minigame
			if Global.toppings_done and not done:
				hide()
				get_child(TOPPING_SCENE_INDEX).queue_free() 
				var instance = TOPPING_SCENE.instantiate()
				add_child(instance)
				Global.in_topping_minigame = false
				Global.can_move = true
				done = true
