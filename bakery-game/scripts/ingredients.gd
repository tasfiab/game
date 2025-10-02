extends Node2D

@export var strawberry : TextureRect
@export var lemon : TextureRect
@export var chocolate : TextureRect
@export var vanilla : TextureRect
@export var cake : TextureRect
@export var bread : TextureRect


var can_click_cake : bool = false
var can_click_bread : bool = false
var can_click_strawberry : bool = false
var can_click_lemon : bool = false
var can_click_vanilla : bool = false
var can_click_chocolate : bool = false

var ingredient_chosen : bool = false

var dough_type_index = 0
var flavour_index = 1
var flavour_2_index = 2

var CAKE = 'cake'
var BREAD = 'bread'
var VANILLA = 'vanilla'
var CHOCOLATE = 'chocolate'
var LEMON = 'lemon'
var STRAWBERRY = 'strawberry'

var dough_type_meter_added : bool = false


var ingredient_number = 0

signal ingredient_clicked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dough_type_meter_added = false
	for ingredient in Global.chosen_ingredients:
		Global.ingredient_chosen = false
		if ingredient_number == 0:
			strawberry.hide()
			lemon.hide()
			chocolate.hide()
			vanilla.hide()
		elif ingredient_number == 1:
			vanilla.show()
			chocolate.show()
		elif ingredient_number == 2:
			strawberry.show()
			lemon.show()
			vanilla.hide()
			chocolate.hide()
		
		await ingredient_clicked
		ingredient_number += 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.chosen_ingredients[0] == BREAD:
		cake.hide()
	if Global.chosen_ingredients[0] == CAKE:
		bread.hide()
	
	if Global.chosen_ingredients[0] == "":
		$Label.text = ""
		cake.show()
		bread.show()
		
	if Input.is_action_just_pressed("interact") and Global.chosen_ingredients.has(""):
		if can_click_cake:
			_choosing_ingredients(CAKE, ingredient_number)
			ingredient_clicked.emit()
			Global.dough_type == CAKE
			
		elif can_click_bread:
			_choosing_ingredients(BREAD, ingredient_number)
			ingredient_clicked.emit()
			Global.dough_type == BREAD
			
		elif can_click_vanilla:
			_choosing_ingredients(VANILLA, ingredient_number)
			ingredient_clicked.emit()
			
		elif can_click_chocolate:
			_choosing_ingredients(CHOCOLATE, ingredient_number)
			ingredient_clicked.emit()
			
		elif can_click_strawberry:
			_choosing_ingredients(STRAWBERRY, ingredient_number)
			ingredient_clicked.emit()
			
		elif can_click_lemon:
			_choosing_ingredients(LEMON,ingredient_number)
			ingredient_clicked.emit()
			
			
# Checks if all chosen_ingredients have been chosen.
# Looks at dough dictionary and finds what dough is formed from the chosen ingredients.
	if not Global.chosen_ingredients.has(""):
		var dough_formed = (Global.doughs[Global.chosen_ingredients])
		Global.dough_formed = true
		$Label.text = String(Global.doughs[Global.chosen_ingredients])
			
		
			
				

func _choosing_ingredients(ingredient : String, index : int):
	Global.chosen_ingredients[index] = ingredient
	
func _hover_tween(ingredient):
	var tween = create_tween()
	tween.tween_property(ingredient, "scale", Vector2(1.1,1.1),0.1)
	pass

func _not_hover_tween(ingredient):
	var tween = create_tween()
	tween.tween_property(ingredient, "scale", Vector2(1,1),0.1)
	pass
	



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


func _on_done_button_pressed() -> void:
	if Global.dough_formed:			
		var current_customer = Global.customers[Global.customer_number]
		var order_dictionary = (Global.perfect_orders[current_customer])
			
		if Global.chosen_ingredients[0] == order_dictionary[Global.dough_type] and not dough_type_meter_added:
			Global.order_meter += 15
			print('ingredients: ' + str(Global.order_meter))
			dough_type_meter_added = true
			
		ingredient_number = 0
		Global.type.append(Global.doughs[Global.chosen_ingredients])
		Global.done_button_pressed = true
