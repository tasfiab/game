extends Node2D

@export var mould_meter : TextureProgressBar

@export var bread_types_panel : Panel
@export var cake_types_panel : Panel

@export var rating : Label
@export var rating_panel : Panel

@export var order_item_sprite : TextureRect

@export var magic : CPUParticles2D

var loaf_chosen : bool = false
var croissant_chosen : bool = false
var baguette_chosen : bool = false

var square_chosen : bool = false
var circle_chosen : bool = false

var type_chosen : bool = false
var hold_pressed : bool = false

		
var current_customer = Global.customers[Global.customer_number]
var order_dictionary = (Global.perfect_orders[current_customer])



const DOUGH_TYPE_INDEX := 0
const PERFECT_MIN := 74
const PERFECT_MAX := 76
const OK_MIN := 67
const OK_MAX := 83

const GREAT_SCORE := 15
const GOOD_SCORE := 10

const LOAF := 'loaf'
const CROISSANT := 'croissant'
const CIRCLE := 'circle'
const SQUARE := 'square'

signal minigame_done


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mould_meter.hide()
	mould_meter.value = 0
	type_chosen = false
	order_item_sprite.scale = Vector2(0.44,0.44)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.order_item.is_empty():
		pass
	
	elif not Global.order_item.has(Global.shape):
		order_item_sprite.texture = Global.dough_sprites[Global.order_item[DOUGH_TYPE_INDEX]]
		
	current_customer = Global.customers[Global.customer_number]
	order_dictionary = (Global.perfect_orders[current_customer])
	if Global.chosen_ingredients[DOUGH_TYPE_INDEX] == 'cake':
		bread_types_panel.hide()
		cake_types_panel.show()
	elif Global.chosen_ingredients[DOUGH_TYPE_INDEX] == 'bread':
		bread_types_panel.show()
		cake_types_panel.hide()
	
	if type_chosen:
		bread_types_panel.hide()
		cake_types_panel.hide()
		mould_meter.show()
		if Input.is_action_pressed("space"):
			mould_meter.value += 0.5
		if Input.is_action_just_released("space"):
			minigame_done.emit()
			
			if Global.customer_number == 0 and Global.tutorial_box_number == 1:
					Global.tutorial.emit()
				
			if mould_meter.value <= PERFECT_MAX and mould_meter.value >= PERFECT_MIN:
				Global.order_meter += GREAT_SCORE
				print('mould meter' + str(Global.order_meter))
				rating.text = 'perfect!'
									
			elif mould_meter.value <= OK_MAX and mould_meter.value >= OK_MIN:
				Global.order_meter += GOOD_SCORE
				print('mould meter' + str(Global.order_meter))
				rating.text = 'good!'
				
			elif mould_meter.value < OK_MIN:
				print("too little")
				magic.amount = 10
				print('mould meter' + str(Global.order_meter))
				rating.text = 'too little!'
				
			elif mould_meter.value > OK_MAX:
				magic.amount = 150
				magic.speed_scale = 4
				print("too much!")
				rating.text = 'too much!'
			
			if order_dictionary['shape'] == Global.shape:
				Global.order_meter += 10
				print('shape' + str(Global.order_meter))

func _on_loaf_button_pressed() -> void:
	_choosing_shape(LOAF)


func _on_croissant_button_pressed() -> void:
	_choosing_shape(CROISSANT)


func _on_hold_button_pressed() -> void:
	hold_pressed = true
	

func _on_square_button_pressed() -> void:
	_choosing_shape(SQUARE)
	

func _on_circle_button_pressed() -> void:
	_choosing_shape(CIRCLE)

func _choosing_shape(shape : String):
	if not type_chosen:
		print(shape)
		Global.shape = shape
		Global.order_item.append(Global.shape)
		type_chosen = true


func _on_minigame_done() -> void:
	magic.emitting = true
	var item_tween = create_tween()
	order_item_sprite.texture = Global.item_sprites[Global.order_item]
	item_tween.tween_property(order_item_sprite, "scale", Vector2(0.5,0.5),0.1)
	
	rating_panel.show()
	var tween = create_tween()
	tween.tween_property(rating_panel, "scale", Vector2(1,1),0.1)
	
	await get_tree().create_timer(1).timeout
	var tween_back = create_tween()
	tween_back.tween_property(rating_panel, "scale", Vector2(0.1,0.1),0.1)
	await tween_back.finished
	rating_panel.hide()
	Global.baked_item_formed = true
