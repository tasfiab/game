extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.toppings_minigame_start and Global.is_baked:
		if Input.is_action_just_pressed("interact"):
			show()
			if Global.baked_item_finished:
				hide()
