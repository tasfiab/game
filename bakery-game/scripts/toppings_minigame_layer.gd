extends CanvasLayer

var topping_scene = preload("res://scenes/toppings_minigame.tscn")
var done : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.toppings_minigame_start and Global.is_baked:
		done = false
		if Input.is_action_just_pressed("interact"):
			show()
			if Global.baked_item_finished and not done:
				hide()
				get_child(0).queue_free()
				var instance = topping_scene.instantiate()
				add_child(instance)
				done = true
