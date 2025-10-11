extends CanvasLayer

var moulding_scene = preload("res://scenes/moulding_minigame_3.tscn")
var done : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.done_button_pressed and not Global.baked_item_formed:
		show()
		done = false
	if Global.baked_item_formed and not done:
		hide()
		Global.can_move = true
		get_child(0).queue_free()
		var instance = moulding_scene.instantiate()
		add_child(instance)
		done = true
