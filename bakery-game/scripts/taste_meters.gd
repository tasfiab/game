extends Node2D

const EMPTY_STRING := ""

# Chosen ingredients indexes.
const DOUGH_TYPE_INDEX : int = 0
const FLAVOUR_INDEX : int = 1
const FLAVOUR_2_INDEX : int = 2

# Keys for taste dictionary.
const SWEETNESS_KEY := "sweetness"
const BITTERNESS_KEY := "bitterness"

const TASTE_RESET : int = 0

# Taste meters.
@export var sweet_UI: TextureProgressBar
@export var bitter_UI: TextureProgressBar

# Taste values.
var sweetness: int = 0
var bitterness: int = 0

var has_graded_taste : bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Adds taste to taste meter when dough type is chosen.
	if (
		not Global.chosen_ingredients[DOUGH_TYPE_INDEX] == EMPTY_STRING
		and not Global.dough_taste_added
	):
		_add_taste(Global.chosen_ingredients[DOUGH_TYPE_INDEX])
		Global.dough_taste_added = true
	
	# Adds taste to taste meter when flavour is chosen.
	if (
		not Global.chosen_ingredients[FLAVOUR_INDEX] == EMPTY_STRING
		and not Global.flavour_taste_added
	):
		_add_taste(Global.chosen_ingredients[FLAVOUR_INDEX])
		Global.flavour_taste_added = true
	
	# Adds taste to taste meter when flavour 2 is chosen.
	if (
		not Global.chosen_ingredients[FLAVOUR_2_INDEX] == EMPTY_STRING
		and not Global.flavour_2_taste_added
	):
		_add_taste(Global.chosen_ingredients[FLAVOUR_2_INDEX])
		Global.flavour_2_taste_added = true
	
	# Once all ingredients chosen, taste is graded.
	if (
		not Global.chosen_ingredients.has(EMPTY_STRING) and not has_graded_taste 
		and not Global.making_done
	):
		_grade_taste(SWEETNESS_KEY, sweetness)
		_grade_taste(BITTERNESS_KEY, bitterness)
		
		# Resets taste meters values as taste has already been graded.
		sweetness = TASTE_RESET
		bitterness =  TASTE_RESET
		has_graded_taste = true


# Function for adding taste to taste meter.
func _add_taste(ingredient):
	var taste_dictionary = (Global.ingredients[ingredient])
	
	# Checks that ingredient has a sweetness, and adds sweetness accordingly.
	if taste_dictionary.has(SWEETNESS_KEY):
		sweetness += (taste_dictionary[SWEETNESS_KEY])
		sweet_UI.value = sweetness
	
	# Checks that ingredient has a bitterness, and adds bitterness accordingly.
	if taste_dictionary.has(BITTERNESS_KEY):
		bitterness += (taste_dictionary[BITTERNESS_KEY])
		bitter_UI.value = bitterness


# Function for grading taste in comparison to order dictionary and adding ponts accordingly.
func _grade_taste(taste_key : String, taste_value : int):
		const PERFECT_ORDER_KEY = "perfect_order"
		const OK_TASTE : int = 2
		
		# Sets current customer and order dictionary to current customer's order dictionary.
		var current_customer = Global.customers[Global.customer_number]
		var order_dictionary = Global.customer_dictionaries[current_customer][PERFECT_ORDER_KEY]
		
		# Adds max amount of order points when taste matches order dictionary taste perfectly.
		if order_dictionary[taste_key] == taste_value:
			const PERFECT_ORDER_POINTS : int = 15
			Global.order_meter += PERFECT_ORDER_POINTS
			print(str(Global.order_meter))
		
		# Adds a good amount of order points when taste is one away from matching order taste.
		elif abs(order_dictionary[taste_key] - taste_value) == 1:
			const GOOD_ORDER_POINTS : int = 10
			Global.order_meter += GOOD_ORDER_POINTS
			print(str(Global.order_meter))
		
		# Adds an ok amount of order points when taste is two away from matching order taste.
		elif abs(order_dictionary[taste_key] - taste_value) == OK_TASTE:
			const OK_ORDER_POINTS : int = 5
			Global.order_meter += OK_ORDER_POINTS
			print(str(Global.order_meter))
