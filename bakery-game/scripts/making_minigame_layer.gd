extends CanvasLayer

var mynode = preload("res://scenes/mixing_minigame.tscn")

var done : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.making_minigame_start:
		if Input.is_action_just_pressed("interact"):
			show()
			done = false
			if Global.done_button_pressed and not done:
				hide()
				var instance = mynode.instantiate() 
				add_child(instance)
				done = true
