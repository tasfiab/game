extends Node2D

@export var progress : ProgressBar
@export var bread_types_panel : Panel
@export var cake_types_panel : Panel


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
	progress.hide()
	$ColorRect3.hide()
	progress.value = 0
	type_chosen = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_customer = Global.customers[Global.customer_number]
	order_dictionary = (Global.perfect_orders[current_customer])
	if Global.chosen_ingredients[0] == 'cake':
		bread_types_panel.hide()
		cake_types_panel.show()
	elif Global.chosen_ingredients[0] == 'bread':
		bread_types_panel.show()
		cake_types_panel.hide()
	
	if type_chosen:
		bread_types_panel.hide()
		cake_types_panel.hide()
		$Panel.show()
		$ColorRect3.show()
		progress.show()
		if Input.is_action_pressed("space"):
			progress.value += 0.4
		elif Input.is_action_just_released("space"):
			Global.baked_item_formed = true
			
			if Global.customer_number == 0 and Global.tutorial_box_number == 1:
					Global.help.emit()
				
			if progress.value >= 70 and progress.value <= 73:
				print("perfect")
				Global.order_meter += 15
				print('mould meter' + str(Global.order_meter))
									
			elif (progress.value < 70 and progress.value > 65) or (progress.value > 73 and progress.value < 75):
				print("good!")
				Global.order_meter += 10
				print('mould meter' + str(Global.order_meter))
				
			elif progress.value < 65:
				print("ok")
				Global.order_meter += 5
				print('mould meter' + str(Global.order_meter))
				
			elif progress.value > 75:
				print("too much!")
			
			if order_dictionary['shape'] == Global.shape:
				Global.order_meter += 10
				print('shape' + str(Global.order_meter))

func _on_loaf_button_pressed() -> void:
	_choosing_shape('loaf')


func _on_croissant_button_pressed() -> void:
	_choosing_shape('croissant')


func _on_hold_button_pressed() -> void:
	hold_pressed = true
	

func _on_square_button_pressed() -> void:
	_choosing_shape('square')
	

func _on_circle_button_pressed() -> void:
	_choosing_shape('circle')
	
#func _progress():
	#await get_tree().create_timer(0.5).timeout
	#progress.value += 20

func _choosing_shape(shape : String):
	if not type_chosen:
		print(shape)
		Global.shape = shape
		Global.type.append(shape)
		type_chosen = true
	
