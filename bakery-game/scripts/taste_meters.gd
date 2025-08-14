extends Node2D

@export var sweet_UI: Node
@export var bitter_UI: Node
@export var soft_UI: Node

var sweet: int = 0
var bitter: int = 0
var soft: int = 0

var has_graded_taste : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


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
	
	if not Global.chosen_ingredients.has("") and not has_graded_taste and not Global.done_button_pressed:
		_grade_taste()
		sweet = 0
		bitter = 0
		soft = 0
		has_graded_taste = true

func add_taste(ingredient):
	#if not ingredient == "":
		var taste_dictionary = (Global.ingredients[ingredient])
		
		if taste_dictionary.has('sweetness'):
			sweet += (taste_dictionary['sweetness'])
			sweet_UI.value = sweet

		if taste_dictionary.has('softness'):
			soft += (taste_dictionary['softness'])
			soft_UI.value = soft
		
		if taste_dictionary.has('bitterness'):
			bitter += (taste_dictionary['bitterness'])
			bitter_UI.value = bitter
			
		 
func _grade_taste():
	var current_customer = Global.customers[Global.customer_number]
	var order_dictionary = (Global.perfect_orders[current_customer])
	
	if order_dictionary.has('sweetness'):
		if order_dictionary['sweetness'] == sweet:
			Global.order_meter += 15
		elif abs(order_dictionary['sweetness'] - sweet) == 1:
			Global.order_meter += 10
		elif abs(order_dictionary['bitterness'] - bitter) == 2:
			Global.order_meter += 5
		print('taste meter' + str(Global.order_meter))	
	
	if order_dictionary.has('bitterness'):
		if order_dictionary['bitterness'] == bitter:
			Global.order_meter += 15
		elif abs(order_dictionary['bitterness'] - bitter) == 1:
			Global.order_meter += 10
		elif abs(order_dictionary['bitterness'] - bitter) == 2:
			Global.order_meter += 5
		print('taste meter' + str(Global.order_meter))	
