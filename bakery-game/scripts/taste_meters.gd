extends Node2D

@export var sweet_UI: Node
@export var bitter_UI: Node

const EMPTY_STRING := ""

const DOUGH_TYPE_INDEX := 0
const FLAVOUR_INDEX := 1
const FLAVOUR_2_INDEX := 2

const TASTE_RESET := 0

const SWEETNESS_KEY := "sweetness"
const BITTERNESS_KEY := "bitterness"

var sweetness: int = 0
var bitterness: int = 0

var has_graded_taste : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.chosen_ingredients[DOUGH_TYPE_INDEX] != EMPTY_STRING and not Global.dough_taste_added:
		add_taste(Global.chosen_ingredients[DOUGH_TYPE_INDEX])
		Global.dough_taste_added = true
	
	if Global.chosen_ingredients[FLAVOUR_INDEX] != EMPTY_STRING and not Global.flavour_taste_added:
		add_taste(Global.chosen_ingredients[FLAVOUR_INDEX])
		Global.flavour_taste_added = true
	
	if Global.chosen_ingredients[FLAVOUR_2_INDEX] != EMPTY_STRING and not Global.flavour_2_taste_added:
		add_taste(Global.chosen_ingredients[FLAVOUR_2_INDEX])
		Global.flavour_2_taste_added = true
	
	if not Global.chosen_ingredients.has(EMPTY_STRING) and not has_graded_taste and not Global.done_button_pressed:
		grade_taste(SWEETNESS_KEY, sweetness)
		grade_taste(BITTERNESS_KEY, bitterness)
		sweetness = TASTE_RESET
		bitterness =  TASTE_RESET
		has_graded_taste = true

func add_taste(ingredient : String):
	var taste_dictionary = Global.ingredients[ingredient]
	if taste_dictionary.has(SWEETNESS_KEY):
		sweetness += taste_dictionary[SWEETNESS_KEY]
		sweet_UI.value = sweetness
	
	if taste_dictionary.has(BITTERNESS_KEY):
		bitterness += taste_dictionary[BITTERNESS_KEY]
		bitter_UI.value =  bitterness 

func grade_taste(taste_key : String, taste_value : int):
		const PERFECT_ORDER_KEY = "perfect_order"
		var current_customer = Global.customers[Global.customer_number]
		var order_dictionary = Global.customer_dictionaries[current_customer][PERFECT_ORDER_KEY]
		
		if order_dictionary[taste_key] == taste_value:
			Global.order_meter += 15
		elif abs(order_dictionary[taste_key] - taste_value) == 1:
			Global.order_meter += 10
		elif abs(order_dictionary[taste_key] - taste_value) == 2:
			Global.order_meter += 5
		
		print(Global.order_meter)
