extends Node2D

@export var progress : ProgressBar

var loaf_chosen : bool = false
var croissant_chosen : bool = false
var baguette_chosen : bool = false

var square_chosen : bool = false
var circle_chosen : bool = false

var type_chosen : bool = false
var hold_pressed : bool = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(Global.order_meter)
	$Panel.hide()
	progress.value = 0
	if Global.dough_type == 'cake':
		$ColorRect2.hide()
		$ColorRect4.show()
	elif Global.dough_type == 'bread':
		$ColorRect2.show()
		$ColorRect4.hide()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		if type_chosen:
			$Panel.show()
			if Input.is_action_pressed("space"):
				progress.value += 0.4
			if Input.is_action_just_released("space"):
				Global.baked_item_formed = true
				if progress.value >= 70 and progress.value <= 73:
					print("perfect")
				elif (progress.value < 67 and progress.value > 65) or (progress.value > 73 and progress.value < 75):
					print("good!")
				elif progress.value < 67:
					print("ok")
				elif progress.value > 75:
					print("too much!")


func _on_loaf_button_pressed() -> void:
	if not type_chosen:
		print ('loaf')
		loaf_chosen = true
		type_chosen = true


func _on_croissant_button_pressed() -> void:
	if not type_chosen:
		print ('croissant')
		croissant_chosen = true
		type_chosen = true


func _on_baguette_button_pressed() -> void:
	if not type_chosen:
		print('baguette')
		baguette_chosen = true
		type_chosen = true


func _on_hold_button_pressed() -> void:
	hold_pressed = true
	#if Input.is_action_pressed("interact"):
		#progress.value += 2
	#if Input.is_action_just_released("interact"):
		#if progress.value == 70:
			#print("perfect")
		#elif progress.value < 70 and progress.value > 50:
			#print("ok!")
		#elif progress.value < 50:
			#print("too little!")
		#elif progress.value > 70:
			#print("too much!")
		#
	

func _on_square_button_pressed() -> void:
	if not type_chosen:
		print('square')
		baguette_chosen = true
		type_chosen = true


func _on_circle_button_pressed() -> void:
	if not type_chosen:
		print('circle')
		circle_chosen = true
		type_chosen = true
