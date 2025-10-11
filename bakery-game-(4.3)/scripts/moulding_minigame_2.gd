extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.done_button_pressed:
		show()


func _on_loaf_pressed() -> void:
	print("u made a loaf :)")
	Global.baked_item_formed = true

func _on_croissant_pressed() -> void:
	print("u made a croissant :)")
	Global.baked_item_formed = true


func _on_baguette_pressed() -> void:
	print("u made a baguette :)")
	Global.baked_item_formed = true
