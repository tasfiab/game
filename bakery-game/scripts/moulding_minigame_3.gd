extends Node2D

@export var progress : ProgressBar

var loaf_chosen : bool = false
var croissant_chosen : bool = false
var baguette_chosen : bool = false

var square_chosen : bool = false
var circle_chosen : bool = false

var type_chosen : bool = false
var hold_pressed : bool = false

		
var current_customer = Global.customers[Global.customer_number]
var order_dictionary = (Global.perfect_orders[current_customer])


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Panel.hide()
	$progress_bar.hide()
	progress.value = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		if Global.chosen_ingredients[0] == 'cake':
			$ColorRect2.hide()
			$ColorRect4.show()
		elif Global.chosen_ingredients[0] == 'bread':
			$ColorRect2.show()
			$ColorRect4.hide()
		
		if type_chosen:
			$Panel.show()
			$progress_bar.show()
			if Input.is_action_pressed("space"):
				progress.value += 0.4
			if Input.is_action_just_released("space"):
				Global.baked_item_formed = true
				if progress.value >= 70 and progress.value <= 73:
					print("perfect")
					Global.order_meter += 15
										
				elif (progress.value < 67 and progress.value > 65) or (progress.value > 73 and progress.value < 75):
					print("good!")
					Global.order_meter += 10
					
				elif progress.value < 65:
					print("ok")
					Global.order_meter += 5
					
				elif progress.value > 75:
					print("too much!")


func _on_loaf_button_pressed() -> void:
	if not type_chosen:
		print ('loaf')
		Global.shape = 'loaf'
		Global.type.append('loaf')
		if order_dictionary['shape'] == 'loaf':
			Global.order_meter += 10
		type_chosen = true

func _on_croissant_button_pressed() -> void:
	if not type_chosen:
		print ('croissant')
		Global.shape = 'croissant'
		Global.type.append('croissant')
		if order_dictionary['shape'] == 'croissant':
			Global.order_meter += 10
		type_chosen = true


#func _on_baguette_button_pressed() -> void:
	#if not type_chosen:
		#print('baguette')
		#baguette_chosen = true
		#if order_dictionary['shape'] == 'baguette':
			#Global.order_meter += 10
		#type_chosen = true


func _on_hold_button_pressed() -> void:
	hold_pressed = true
	

func _on_square_button_pressed() -> void:
	if not type_chosen:
		print('square')
		Global.shape = 'square'
		Global.type.append('square')
		if order_dictionary['shape'] == 'square':
			Global.order_meter += 10
		type_chosen = true

func _on_circle_button_pressed() -> void:
	if not type_chosen:
		print('circle')
		Global.shape = 'circle'
		Global.type.append('circle')
	
		if order_dictionary['shape'] == 'circle':
			Global.order_meter += 10
			print(Global.order_meter)
		type_chosen = true
