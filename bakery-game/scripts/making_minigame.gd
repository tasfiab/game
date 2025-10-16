extends Node2D

signal ingredient_clicked

@export var strawberry : TextureRect
@export var lemon : TextureRect
@export var chocolate : TextureRect
@export var vanilla : TextureRect
@export var cake : TextureRect
@export var bread : TextureRect
@export var bowl : TextureRect

var can_click_cake : bool = false
var can_click_bread : bool = false
var can_click_strawberry : bool = false
var can_click_lemon : bool = false
var can_click_vanilla : bool = false
var can_click_chocolate : bool = false

var dough_type_meter_added := false

var ingredient_number : int = 0

const DOUGH_TYPE_INDEX : int = 0
const FLAVOUR_INDEX : int = 1
const FLAVOUR_2_INDEX : int = 2

const INTERACT_BIND := "interact"

const CAKE := 'cake'
const BREAD := 'bread'
const VANILLA := 'vanilla'
const CHOCOLATE := 'chocolate'
const LEMON := 'lemon'
const STRAWBERRY := 'strawberry'

const BOWL_ORIGINAL_TEXTURE := preload("res://assets/mixing_bowl.webp")

const EMPTY_STRING := ""
const TWEEN_TIME : float = 0.1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dough_type_meter_added = false
	
	# Hides ingredients according to which ingredient tyoe is currently being chosen.
	for ingredient in Global.chosen_ingredients:
		if ingredient_number == DOUGH_TYPE_INDEX:
			strawberry.hide()
			lemon.hide()
			chocolate.hide()
			vanilla.hide()
		elif ingredient_number == FLAVOUR_INDEX:
			vanilla.show()
			chocolate.show()
		elif ingredient_number == FLAVOUR_2_INDEX:
			strawberry.show()
			lemon.show()
			vanilla.hide()
			chocolate.hide()
		
		await ingredient_clicked
		ingredient_number += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Depending on which dough type player chooses, will hide the other one.
	if Global.chosen_ingredients[DOUGH_TYPE_INDEX] == BREAD:
		cake.hide()
	elif Global.chosen_ingredients[DOUGH_TYPE_INDEX] == CAKE:
		bread.hide()
	
	# While no dough type is chosen, both dough types are shown.
	else:
		cake.show()
		bread.show()
	
	# When player interacts with ingredients, stores them in chosen ingredients list.
	if Input.is_action_just_pressed(INTERACT_BIND) and Global.chosen_ingredients.has(EMPTY_STRING):
		if can_click_cake:
			_choosing_ingredients(CAKE)
			
		elif can_click_bread:
			_choosing_ingredients(BREAD)
			
		elif can_click_vanilla:
			_choosing_ingredients(VANILLA)
			
		elif can_click_chocolate:
			_choosing_ingredients(CHOCOLATE)
			
		elif can_click_strawberry:
			_choosing_ingredients(STRAWBERRY)
			
		elif can_click_lemon:
			_choosing_ingredients(LEMON)
			
			
# Checks if all chosen_ingredients have been chosen.
# Looks at dough dictionary and finds what dough is formed from the chosen ingredients.
	if not Global.chosen_ingredients.has(EMPTY_STRING):
		var dough = Global.doughs[Global.chosen_ingredients]
		bowl.texture = (Global.dough_sprites[dough]) # Sets bowl texture to dough texture.
	
	# Keeps bowl texture original, empty texture unless all ingredients are chosen.
	else:
		bowl.texture = BOWL_ORIGINAL_TEXTURE


# Function for adding ingredient chosen to ingredients array.
func _choosing_ingredients(ingredient : String):
	Global.chosen_ingredients[ingredient_number] = ingredient
	ingredient_clicked.emit()


# Function for tween that changes scale of ingredient when hovering over it.
func _hover_tween(ingredient):
	var ingredient_tween = create_tween()
	const TWEEN_SCALE := Vector2(1.1,1.1)
	ingredient_tween.tween_property(ingredient, "scale", TWEEN_SCALE,TWEEN_TIME)

# Function for tween that changes scale of ingredient when not hovering over it.
func _not_hover_tween(ingredient):
	var ingredient_tween = create_tween()
	const ORIGINAL_SCALE := Vector2(1,1)
	ingredient_tween.tween_property(ingredient, "scale", ORIGINAL_SCALE,TWEEN_TIME)


# Allows player to select ingredient 'cake' when hovering over it.
func _on_cake_essence_mouse_entered() -> void:
	can_click_cake = true
	_hover_tween(cake)


# Stops allowing player to select ingredient 'cake' when no longer hovering over it.
func _on_cake_essence_mouse_exited() -> void:
	can_click_cake = false
	_not_hover_tween(cake)


# Allows player to select ingredient 'bread' when hovering over it.
func _on_bread_essence_mouse_entered() -> void:
	can_click_bread = true
	_hover_tween(bread)


# Stops allowing player to select ingredient 'bread' when no longer hovering over it.
func _on_bread_essence_mouse_exited() -> void:
	can_click_bread = false
	_not_hover_tween(bread)


# Allows player to select ingredient 'strawberry' when hovering over it.
func _on_strawberry_mouse_entered() -> void:
	can_click_strawberry = true
	_hover_tween(strawberry)


# Stops allowing player to select ingredient 'strawberry' when no longer hovering over it.
func _on_strawberry_mouse_exited() -> void:
	can_click_strawberry = false
	_not_hover_tween(strawberry)


# Allows player to select ingredient 'lemon' when hovering over it.
func _on_lemon_mouse_entered() -> void:
	can_click_lemon = true
	_hover_tween(lemon)


# Stops allowing player to select ingredient 'lemon' when no longer hovering over it.
func _on_lemon_mouse_exited() -> void:
	can_click_lemon = false
	_not_hover_tween(lemon)


# Allows player to select ingredient 'vanilla' when hovering over it.
func _on_vanilla_mouse_entered() -> void:
	can_click_vanilla = true
	_hover_tween(vanilla)


# Stops allowing player to select ingredient 'vanilla' when no longer hovering over it.
func _on_vanilla_mouse_exited() -> void:
	can_click_vanilla = false 
	_not_hover_tween(vanilla)


# Allows player to select ingredient 'chocolate' when hovering over it.
func _on_chocolate_mouse_entered() -> void:
	can_click_chocolate = true
	_hover_tween(chocolate)


# Stops allowing player to select ingredient 'chocolate' when no longer hovering over it.
func _on_chocolate_mouse_exited() -> void:
	can_click_chocolate = false
	_not_hover_tween(chocolate)


# Function for when player presses done button.
func _on_done_button_pressed() -> void:
	# If all ingredients have been chosen, adds order points if earned and closes minigame.
	if not Global.chosen_ingredients.has(""):
		const PERFECT_ORDER_KEY := "perfect_order"
		const DOUGH_TYPE_KEY := "dough type"
		
		# Sets current customer and order dictionary to current customer's order dictionary.
		var current_customer = Global.customers[Global.customer_number]
		var order_dictionary = Global.customer_dictionaries[current_customer][PERFECT_ORDER_KEY]
		
		# Checks if dough is what customer wanted, and adds order meter score accordingly.
		if (
			Global.chosen_ingredients[DOUGH_TYPE_INDEX] == order_dictionary[DOUGH_TYPE_KEY]
			and not dough_type_meter_added
		):
			const GOOD_ORDER_SCORE : int = 15
			Global.order_meter += GOOD_ORDER_SCORE
			print("dough right" + str(Global.order_meter))
			dough_type_meter_added = true
			
		ingredient_number = 0 # Resets item number.
		
		# Adds dough to item list, so later correct item sprite can be found in item sprites dict.
		Global.order_item.append(Global.doughs[Global.chosen_ingredients])
		Global.making_done = true # Allows minigame to change.
