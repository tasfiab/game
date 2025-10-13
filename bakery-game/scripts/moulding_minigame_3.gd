extends Node2D

@export var mould_meter : TextureProgressBar

# Variables for items panels containing shape buttons.
@export var bread_types_panel : Panel
@export var cake_types_panel : Panel

# Variables for rating popup
@export var rating : Label
@export var rating_panel : Panel

@export var order_item_sprite : TextureRect

@export var magic : CPUParticles2D

var shape_chosen : bool = false
var can_mould : bool = true

var current_customer : String
var order_dictionary : Dictionary

const SPACE_BIND := "space"

const CAKE := "cake"
const BREAD := "bread"
const DOUGH_TYPE_INDEX := 0

const SHAPE_KEY := "shape"
const LOAF := 'loaf'
const CROISSANT := 'croissant'
const CIRCLE := 'circle'
const SQUARE := 'square'

const PERFECT_MIN := 72
const PERFECT_MAX := 80
const OK_MIN := 67
const OK_MAX := 85

const GREAT_SCORE := 15
const GOOD_SCORE := 10

const TWEEN_TIME = 0.1


signal minigame_done


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mould_meter.hide() # Hides mould meter.
	mould_meter.value = 0 # Resets meter value.
	shape_chosen = false 
	
	const ITEM_ORIGINAL_SCALE = Vector2(0.44,0.44)
	order_item_sprite.scale = ITEM_ORIGINAL_SCALE
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 

	# Makes sure nothing changes in moulding minigame until dough type has been added to order item array.
	if Global.order_item.is_empty():
		pass
	
	# Makes order item sprite the sprite of the dough player made from making minigame.
	elif not Global.order_item.has(Global.shape):
		order_item_sprite.texture = Global.dough_sprites[Global.order_item[DOUGH_TYPE_INDEX]]
	
	
	const PERFECT_ORDER_KEY := "perfect_order"
	current_customer = Global.customers[Global.customer_number] # Sets current customer
	order_dictionary = Global.customer_dictionaries[current_customer][PERFECT_ORDER_KEY] # Sets order dictionary for current customer.
	
	# Shows cake shape types if the dough type is cake.
	if Global.chosen_ingredients[DOUGH_TYPE_INDEX] == CAKE:
		bread_types_panel.hide()
		cake_types_panel.show()
	
	# Shows bread shape types if the dough type is bread.
	elif Global.chosen_ingredients[DOUGH_TYPE_INDEX] == BREAD:
		bread_types_panel.show()
		cake_types_panel.hide()
	
	# Hides panels completely if shape has been chosen.
	if shape_chosen:
		bread_types_panel.hide()
		cake_types_panel.hide()
		mould_meter.show()
		
		# Increases mould meter as space is held.
		if Input.is_action_pressed(SPACE_BIND) and can_mould:
			const MOULD_METER_INCREASE = 0.5
			mould_meter.value += MOULD_METER_INCREASE
		
		# On release, grades how well player completed minigame.
		if Input.is_action_just_released(SPACE_BIND) and can_mould:
			minigame_done.emit() 
			
			# Changes tutorial box to next box when player is on their first customer.
			const TUTORIAL_NUMBER := 1
			if Global.customer_number == 0 and Global.tutorial_box_number == TUTORIAL_NUMBER:
					Global.tutorial.emit()
			
			# If player is in boundaries of perfect mould.
			if mould_meter.value <= PERFECT_MAX and mould_meter.value >= PERFECT_MIN:
				Global.order_meter += GREAT_SCORE
				rating.text = 'perfect!'
			
			# If player is in boundaries of ok mould but not perfect mould.
			elif mould_meter.value <= OK_MAX and mould_meter.value >= OK_MIN:
				Global.order_meter += GOOD_SCORE
				rating.text = 'good!'
			
			# If player is below boundaries of ok mould.
			elif mould_meter.value < OK_MIN:
				const LOW_MAGIC_AMOUNT = 10
				magic.amount = LOW_MAGIC_AMOUNT # Makes little magic particles.
				rating.text = 'too little!'
			
			# If player is above boundary of ok_mould.
			elif mould_meter.value > OK_MAX:
				const HIGH_MAGIC_AMOUNT = 150
				const HIGH_MAGIC_SPEED = 4
				magic.amount = HIGH_MAGIC_AMOUNT # Makes too many magic particles.
				magic.speed_scale = HIGH_MAGIC_SPEED # Makes magic particles quick.
				rating.text = 'too much!'
			
			# Checks shape and adds points accordingly.
			if order_dictionary[SHAPE_KEY] == Global.shape:
				const ORDER_POINTS := 10
				Global.order_meter += ORDER_POINTS
			
			can_mould = false # Stops player from moulding more.


# Functions for each shape being pressed.
func _on_loaf_button_pressed() -> void:
	_choosing_shape(LOAF)

func _on_croissant_button_pressed() -> void:
	_choosing_shape(CROISSANT)

func _on_square_button_pressed() -> void:
	_choosing_shape(SQUARE)
	
func _on_circle_button_pressed() -> void:
	_choosing_shape(CIRCLE)

# Function for player choosing shape.
func _choosing_shape(shape : String):
	if not shape_chosen:
		Global.shape = shape
		Global.order_item.append(Global.shape)
		shape_chosen = true

# Function for when minigame is complete.
func _on_minigame_done() -> void:
	magic.emitting = true # Emits magic particles from item.
	
	# Changes item sprite according to dough and shape.
	order_item_sprite.texture = Global.item_sprites[Global.order_item] 
	
	# Tweens item to make it bigger.
	var item_tween = create_tween()
	const ITEM_TWEEN_SCALE := Vector2(0.5,0.5)
	item_tween.tween_property(order_item_sprite, "scale", ITEM_TWEEN_SCALE, TWEEN_TIME)
	
	# Rating panel shown to player.
	rating_panel.show()
	var rating_tween := create_tween()
	const RATING_TWEEN_SCALE_UP := Vector2(1,1)
	rating_tween.tween_property(rating_panel, "scale", RATING_TWEEN_SCALE_UP, TWEEN_TIME)

	await get_tree().create_timer(1.0).timeout # Panel is shown for a second.
	
	# Rating panel hides from player.
	var rating_tween_back = create_tween()
	const RATING_TWEEN_SCALE_DOWN := Vector2(0.1,0.1)
	rating_tween_back.tween_property(rating_panel, "scale", RATING_TWEEN_SCALE_DOWN,TWEEN_TIME)
	await rating_tween_back.finished
	rating_panel.hide()

	Global.moulding_done = true # Now true, moulding minigame layer can now close.
