extends Node2D

@export var sweet_UI: Node
@export var soft_UI: Node

var sweet: int = 0
var soft: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.chosen_ingredients[0] != "" and not Global.dough_taste_added:
		add_taste(Global.chosen_ingredients[0])
		Global.dough_taste_added = true
	
	if Global.chosen_ingredients[1] != "" and not Global.flavour_taste_added:
		add_taste(Global.chosen_ingredients[1])
		Global.flavour_taste_added = true	
	
	if Global.chosen_ingredients[2] != "" and not Global.flavour_2_taste_added:
		add_taste(Global.chosen_ingredients[2])
		Global.flavour_2_taste_added = true
			
	
	

func add_taste(ingredient):
	#if not ingredient == "":
		var taste_dictionary = (Global.ingredients[ingredient])
		
		if taste_dictionary.has('sweetness'):
			sweet += (taste_dictionary['sweetness'])
			sweet_UI.value = sweet

		if taste_dictionary.has('softness'):
			soft += (taste_dictionary['softness'])
			soft_UI.value = soft
