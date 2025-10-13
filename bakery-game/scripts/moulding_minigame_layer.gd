extends CanvasLayer

var moulding_scene = preload("res://scenes/moulding_minigame_3.tscn")
var done : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Shows and starts minigame for player when player has pressed done for making minigame.
	if Global.making_done and not Global.moulding_done:
		show()
		done = false
	
	# Deletes instance of minigame scene and creates new instance to reset scene to original state when player is done moulding.
	if Global.moulding_done and not done:
		hide()
		Global.can_move = true
		get_child(0).queue_free()
		var instance = moulding_scene.instantiate()
		add_child(instance)
		done = true
