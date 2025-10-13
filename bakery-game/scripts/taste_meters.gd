extends Node2D

@export var sweet_UI: Node
@export var bitter_UI: Node

const EMPTY_STRING := ""

const DOUGH_TYPE_INDEX := 0
const FLAVOUR_INDEX := 1
const FLAVOUR_2_INDEX := 2

const SWEETNESS_KEY := "sweetness"
const BITTERNESS_KEY := "bitterness"

const TASTE_RESET := 0

var sweetness: int = 0
var bitterness: int = 0

var has_graded_taste : bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Adds taste to taste meter when dough type is chosen.
	if Global.chosen_ingredients[DOUGH_TYPE_INDEX] != EMPTY_STRING and not Global.dough_taste_added:
		add_taste(Global.chosen_ingredients[DOUGH_TYPE_INDEX])
		Global.dough_taste_added = true
	
	# Adds taste to taste meter when flavour is chosen.
	if Global.chosen_ingredients[FLAVOUR_INDEX] != EMPTY_STRING and not Global.flavour_taste_added:
		add_taste(Global.chosen_ingredients[FLAVOUR_INDEX])
		Global.flavour_taste_added = true
	
	# Adds taste to taste meter when flavour 2 is chosen.
	if Global.chosen_ingredients[FLAVOUR_2_INDEX] != EMPTY_STRING and not Global.flavour_2_taste_added:
		add_taste(Global.chosen_ingredients[FLAVOUR_2_INDEX])
		Global.flavour_2_taste_added = true
	
	# Once all ingredients chosen, grades taste.
	if not Global.chosen_ingredients.has(EMPTY_STRING) and not has_graded_taste and not Global.making_done:
		grade_taste(SWEETNESS_KEY, sweetness)
		grade_taste(BITTERNESS_KEY, bitterness)
		
		# Resets taste meters values.
		sweetness = TASTE_RESET
		bitterness =  TASTE_RESET
		has_graded_taste = true

# Function for adding taste to taste meter.
func add_taste(ingredient):
	var taste_dictionary = (Global.ingredients[ingredient])
	
	if taste_dictionary.has('sweetness'):
		sweetness += (taste_dictionary['sweetness'])
		sweet_UI.value = sweetness
	
	if taste_dictionary.has('bitterness'):
		bitterness += (taste_dictionary['bitterness'])
		bitter_UI.value = bitterness

#func add_taste(ingredient : String, key : String, value: int, UI : TextureProgressBar ):
	#var taste_dictionary = Global.ingredients[ingredient]
	#if taste_dictionary.has(key):
		#value += taste_dictionary[key]
		#UI.value = value

# Function for grading taste in comparison to perfect order dictionary.
func grade_taste(taste_key : String, taste_value : int):
		const PERFECT_ORDER_KEY = "perfect_order"
		const OK_TASTE := 2
		var current_customer = Global.customers[Global.customer_number]
		var order_dictionary = Global.customer_dictionaries[current_customer][PERFECT_ORDER_KEY]
		
		# When taste matches order dictionary taste perfectly.
		if order_dictionary[taste_key] == taste_value:
			const PERFECT_ORDER_POINTS = 15
			Global.order_meter += PERFECT_ORDER_POINTS
		
		# When taste is one away from matching order taste.
		elif abs(order_dictionary[taste_key] - taste_value) == 1:
			const GOOD_ORDER_POINTS = 10
			Global.order_meter += GOOD_ORDER_POINTS
		
		# When taste is two away from matching order taste.
		elif abs(order_dictionary[taste_key] - taste_value) == OK_TASTE:
			const OK_ORDER_POINTS := 5
			Global.order_meter += OK_ORDER_POINTS
		
		print(Global.order_meter)
