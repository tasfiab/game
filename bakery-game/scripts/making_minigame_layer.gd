extends CanvasLayer

var minigame_scene = preload("res://scenes/mixing_minigame.tscn")

var done : bool = false

const SCENE_INDEX :int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide() # Hides layer when play pressed.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Shows and starts minigame to player when player has interacted with making minigame counter.
	if Global.making_minigame_start and Global.order_start and not Global.making_done:
		if Input.is_action_just_pressed("interact"):
			Global.can_move = false
			show()
			done = false
	
	# Deletes instance of minigame scene and creates new instance to reset scene to original state when player is done making.
	if Global.making_done and not done:
		hide()
		get_child(SCENE_INDEX).queue_free()
		var scene_instance = minigame_scene.instantiate() 
		add_child(scene_instance)
		done = true
