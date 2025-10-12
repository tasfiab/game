extends Node2D

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

var ingredient_number := 0

const DOUGH_TYPE_INDEX := 0
const FLAVOUR_INDEX := 1
const FLAVOUR_2_INDEX = 2

const CAKE := 'cake'
const BREAD := 'bread'
const VANILLA := 'vanilla'
const CHOCOLATE := 'chocolate'
const LEMON := 'lemon'
const STRAWBERRY := 'strawberry'

const BOWL_ORIGINAL_TEXTURE := preload("res://assets/mixing_bowl.webp")

const EMPTY_STRING = ""

signal ingredient_clicked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dough_type_meter_added = false
	# Hides ingredients according to which ingredient tyoe is currently being chosen.
	for ingredient in Global.chosen_ingredients:
		Global.ingredient_chosen = false
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
	
	else:
		cake.show()
		bread.show()
	
	# When player interacts with ingredients, stores them in chosen ingredients list.
	if Input.is_action_just_pressed("interact") and Global.chosen_ingredients.has(EMPTY_STRING):
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
		var dough_formed = Global.doughs[Global.chosen_ingredients]
		Global.dough_formed = true
		bowl.texture = (Global.dough_sprites[dough_formed])
	else:
		bowl.texture = BOWL_ORIGINAL_TEXTURE

# Function for adding ingredient chosen to ingredients array.
func _choosing_ingredients(ingredient : String):
	Global.chosen_ingredients[ingredient_number] = ingredient
	ingredient_clicked.emit()

# Tweens that change scale of ingredient when hovering and not hovering.
func _hover_tween(ingredient):
	var tween = create_tween()
	tween.tween_property(ingredient, "scale", Vector2(1.1,1.1),0.1)

func _not_hover_tween(ingredient):
	var tween = create_tween()
	tween.tween_property(ingredient, "scale", Vector2(1,1),0.1)
	


# Functions for when player is hovering and not hovering over specific ingredients.
func _on_cake_essence_mouse_entered() -> void:
	can_click_cake = true
	_hover_tween(cake)


func _on_cake_essence_mouse_exited() -> void:
	can_click_cake = false
	_not_hover_tween(cake)

func _on_bread_essence_mouse_entered() -> void:
	can_click_bread = true
	_hover_tween(bread)

func _on_bread_essence_mouse_exited() -> void:
	can_click_bread = false
	_not_hover_tween(bread)


func _on_strawberry_mouse_entered() -> void:
	can_click_strawberry = true
	_hover_tween(strawberry)


func _on_strawberry_mouse_exited() -> void:
	can_click_strawberry = false
	_not_hover_tween(strawberry)


func _on_lemon_mouse_entered() -> void:
	can_click_lemon = true
	_hover_tween(lemon)


func _on_lemon_mouse_exited() -> void:
	can_click_lemon = false
	_not_hover_tween(lemon)

func _on_vanilla_mouse_entered() -> void:
	can_click_vanilla = true
	_hover_tween(vanilla)


func _on_vanilla_mouse_exited() -> void:
	can_click_vanilla = false 
	_not_hover_tween(vanilla)

func _on_chocolate_mouse_entered() -> void:
	can_click_chocolate = true
	_hover_tween(chocolate)
	

func _on_chocolate_mouse_exited() -> void:
	can_click_chocolate = false
	_not_hover_tween(chocolate)

# When player presses done.
func _on_done_button_pressed() -> void:
	if Global.dough_formed:
		var current_customer = Global.customers[Global.customer_number]
		var order_dictionary = Global.customer_dictionaries[current_customer]["perfect_order"]
		
		# Checks if dough is what customer wanted, and adds order meter score accordingly
		if Global.chosen_ingredients[DOUGH_TYPE_INDEX] == order_dictionary[Global.dough_type] and not dough_type_meter_added:
			Global.order_meter += 15
			dough_type_meter_added = true

		ingredient_number = 0
		Global.order_item.append(Global.doughs[Global.chosen_ingredients])
		Global.done_button_pressed = true
