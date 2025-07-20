extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.done_button_pressed:
		show()
		if Global.baked_item_formed:
			hide()
