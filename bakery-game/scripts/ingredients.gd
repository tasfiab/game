extends Node2D


var mynode = preload("res://scenes/mixing_minigame.tscn")

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
			$strawberry.hide()
			$lemon.hide()
			$chocolate.hide()
			$vanilla.hide()
		elif ingredient_number == 1:
			$vanilla.show()
			$chocolate.show()
		elif ingredient_number == 2:
			$strawberry.show()
			$lemon.show()
			$vanilla.hide()
			$chocolate.hide()
		
		await ingredient_clicked
		ingredient_number += 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.chosen_ingredients[0] == BREAD:
		$cake_essence.hide()
	if Global.chosen_ingredients[0] == CAKE:
		$bread_essence.hide()
	
	if Global.chosen_ingredients[0] == "":
		$Label.text = ""
		$cake_essence.show()
		$bread_essence.show()
		
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
	



func _on_cake_essence_mouse_entered() -> void:
	can_click_cake = true


func _on_cake_essence_mouse_exited() -> void:
	can_click_cake = false


func _on_bread_essence_mouse_entered() -> void:
	can_click_bread = true


func _on_bread_essence_mouse_exited() -> void:
	can_click_bread = false


func _on_strawberry_mouse_entered() -> void:
	can_click_strawberry = true


func _on_strawberry_mouse_exited() -> void:
	can_click_strawberry = false


func _on_lemon_mouse_entered() -> void:
	can_click_lemon = true


func _on_lemon_mouse_exited() -> void:
	can_click_lemon = false


func _on_vanilla_mouse_entered() -> void:
	can_click_vanilla = true


func _on_vanilla_mouse_exited() -> void:
	can_click_vanilla = false 


func _on_chocolate_mouse_entered() -> void:
	can_click_chocolate = true
	

func _on_chocolate_mouse_exited() -> void:
	can_click_chocolate = false


func _on_done_button_pressed() -> void:
	if Global.dough_formed:
		if not Global.chosen_ingredients[0] == Global.chosen_ingredients[1] and Global.chosen_ingredients[0] == Global.chosen_ingredients[2]:
			Global.acquired_taste = true
			
		var current_customer = Global.customers[Global.customer_number]
		var order_dictionary = (Global.perfect_orders[current_customer])
		if Global.acquired_taste and order_dictionary.has(Global.acquired_taste):
			Global.order_meter += 5
			print('acquired taste' + str(Global.order_meter))
		
		elif not Global.acquired_taste and not order_dictionary.has(Global.acquired_taste):
			Global.order_meter += 5
			print('not acquired taste' + str(Global.order_meter))
			
		if Global.chosen_ingredients[0] == order_dictionary[Global.dough_type] and not dough_type_meter_added:
			Global.order_meter += 15
			print('ingredients: ' + str(Global.order_meter))
			dough_type_meter_added = true
			
		ingredient_number = 0
		Global.type.append(Global.doughs[Global.chosen_ingredients])
		Global.done_button_pressed = true
		



#func _on_ingredient_clicked():
	#Global.ingredient_chosen = true
