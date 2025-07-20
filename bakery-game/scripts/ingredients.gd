extends Node2D

var can_click_cake : bool = false
var can_click_bread : bool = false
var can_click_strawberry : bool = false
var can_click_lemon : bool = false
var can_click_vanilla : bool = false
var can_click_chocolate : bool = false

var ingredient_chosen : bool = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

# If user tries to interact with ingredients
	if Input.is_action_just_pressed("interact"):
		if can_click_cake and not Global.dough_chosen:
			_choosing_ingredients('cake', 0)
			Global.dough_chosen = true
			Global.ingredient_chosen = true
			Global.dough_taste_added = false
		
		elif can_click_bread and not Global.dough_chosen:
			_choosing_ingredients('bread', 0)
			Global.dough_chosen = true
			Global.ingredient_chosen = true
			Global.dough_taste_added = false
			
		elif can_click_vanilla and not Global.flavour_chosen:
			_choosing_ingredients('vanilla', 1)
			Global.flavour_chosen = true
			Global.ingredient_chosen = true
			Global.flavour_taste_added = false
			
		elif can_click_chocolate and not Global.flavour_chosen:
			_choosing_ingredients('chocolate', 1)
			Global.flavour_chosen = true
			Global.ingredient_chosen = true
			Global.flavour_taste_added = false
			
		elif can_click_strawberry and not Global.flavour_2_chosen:
			_choosing_ingredients('strawberry', 2)
			Global.flavour_2_chosen = true
			Global.ingredient_chosen = true
			Global.flavour_2_taste_added = false
		
		elif can_click_lemon and not Global.flavour_2_chosen:
			_choosing_ingredients('lemon', 2)
			Global.flavour_2_chosen = true
			Global.ingredient_chosen = true
			Global.flavour_2_taste_added = false

# Checks if all chosen_ingredients have been chosen.
# Looks at dough dictionary and finds what dough is formed from the chosen ingredients.
	if not Global.chosen_ingredients.has(""):
		var dough_formed = (Global.doughs[Global.chosen_ingredients])
		Global.dough_formed = true
		


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
		Global.done_button_pressed = true
		
