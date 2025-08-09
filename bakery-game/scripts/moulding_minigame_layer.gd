extends CanvasLayer

var moulding_scene = preload("res://scenes/moulding_minigame_3.tscn")
var done : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.done_button_pressed:
		show()
		done = false
		if Global.baked_item_formed and not done:
			hide()
			var instance = moulding_scene.instantiate()
			add_child(instance)
			done = true
