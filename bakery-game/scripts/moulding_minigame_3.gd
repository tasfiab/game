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

const GREAT_SCORE : int = 15
const GOOD_SCORE : int = 10

const TWEEN_TIME : float = 0.1


signal minigame_done


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mould_meter.hide() # Hides mould meter.
	mould_meter.value = 0 # Resets meter value.
	shape_chosen = false 
	
	# Sets item scale to original scale.
	const ITEM_ORIGINAL_SCALE := Vector2(0.44,0.44)
	order_item_sprite.scale = ITEM_ORIGINAL_SCALE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	# Makes sure item sprite doesn't change until dough type has been added to order item array.
	if Global.order_item.is_empty():
		pass
	
	# Makes order item sprite the sprite of the dough player made from making minigame.
	elif not Global.order_item.has(Global.shape):
		order_item_sprite.texture = Global.dough_sprites[Global.order_item[DOUGH_TYPE_INDEX]]
	
	
	const PERFECT_ORDER_KEY := "perfect_order"
	
	# Sets current customer and order dictionary for current customer.
	current_customer = Global.customers[Global.customer_number]
	order_dictionary = Global.customer_dictionaries[current_customer][PERFECT_ORDER_KEY]
	
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
			const MOULD_METER_INCREASE : int = 1
			mould_meter.value += MOULD_METER_INCREASE
		
		# On release, grades how well player completed minigame.
		if Input.is_action_just_released(SPACE_BIND) and can_mould:
			minigame_done.emit() 
			
			const TUTORIAL_NUMBER : int = 1
			
			# Emits signal to show next tutorial box as moulding is complete.
			if Global.customer_number == 0 and Global.tutorial_box_number == TUTORIAL_NUMBER:
					Global.tutorial_given.emit()
			
			# Constants for boundaries of mould meter ratings.
			const PERFECT_MIN : int = 72
			const PERFECT_MAX : int = 80
			const OK_MIN : int = 67
			const OK_MAX : int = 85
			
			# If player is in boundaries of perfect mould, adds order points accordingly.
			if mould_meter.value <= PERFECT_MAX and mould_meter.value >= PERFECT_MIN:
				Global.order_meter += GREAT_SCORE
				const PERFECT_TEXT := "perfect!"
				rating.text = PERFECT_TEXT
			
			# If player is in boundaries of ok mould but not perfect mould, adds points accordingly.
			elif mould_meter.value <= OK_MAX and mould_meter.value >= OK_MIN:
				Global.order_meter += GOOD_SCORE
				const GOOD_TEXT := "good!"
				rating.text = GOOD_TEXT
			
			# If player is below boundaries of ok mould, no order points added.
			elif mould_meter.value < OK_MIN:
				const LOW_MAGIC_AMOUNT : int = 10
				magic.amount = LOW_MAGIC_AMOUNT # Makes little magic particles.
				
				const TOO_LITTLE_TEXT := "too little!"
				rating.text = TOO_LITTLE_TEXT
			
			# If player is above boundary of ok_mould, no order points added.
			elif mould_meter.value > OK_MAX:
				const HIGH_MAGIC_AMOUNT : int = 150
				const HIGH_MAGIC_SPEED : int = 4
				magic.amount = HIGH_MAGIC_AMOUNT # Makes too many magic particles.
				magic.speed_scale = HIGH_MAGIC_SPEED # Makes magic particles quick.
				
				const TOO_MUCH_TEXT := "too much!"
				rating.text = TOO_MUCH_TEXT
			
			# Checks if shape matches customer's order dictionary and adds points accordingly.
			if order_dictionary[SHAPE_KEY] == Global.shape:
				const ORDER_POINTS : int = 10
				Global.order_meter += ORDER_POINTS
			
			can_mould = false # Stops player from moulding more.


# When loaf button is pressed, chooses shape 'loaf'
func _on_loaf_button_pressed() -> void:
	_choosing_shape(LOAF)


# When croissant button is pressed, chooses shape 'croissant'
func _on_croissant_button_pressed() -> void:
	_choosing_shape(CROISSANT)


# When square button is pressed, chooses shape 'square'
func _on_square_button_pressed() -> void:
	_choosing_shape(SQUARE)


# When circle button is pressed, chooses shape 'circle'
func _on_circle_button_pressed() -> void:
	_choosing_shape(CIRCLE)


# Function for player choosing shape.
func _choosing_shape(shape : String):
	if not shape_chosen:
		Global.shape = shape
		Global.order_item.append(Global.shape) # Adds shape to order item list.
		shape_chosen = true


# Function for when minigame is complete.
func _on_minigame_done() -> void:
	magic.emitting = true # Emits magic particles from item.
	
	# Changes item sprite according to dough and shape.
	order_item_sprite.texture = Global.item_sprites[Global.order_item] 
	
	# Tweens item to make it bigger after moulding.
	var item_tween = create_tween()
	const ITEM_TWEEN_SCALE := Vector2(0.5,0.5)
	item_tween.tween_property(order_item_sprite, "scale", ITEM_TWEEN_SCALE, TWEEN_TIME)
	
	# Rating panel shown to player now that minigame is done.
	rating_panel.show()
	var rating_tween := create_tween()
	const RATING_TWEEN_SCALE_UP := Vector2(1,1)
	rating_tween.tween_property(rating_panel, "scale", RATING_TWEEN_SCALE_UP, TWEEN_TIME)
	
	const RATING_SHOW_TIME : float = 1.0
	await get_tree().create_timer(RATING_SHOW_TIME).timeout # Panel is shown for a second.
	
	# Rating panel hidden from player once it's finished being shown.
	var rating_tween_back = create_tween()
	const RATING_TWEEN_SCALE_DOWN := Vector2(0.1,0.1)
	rating_tween_back.tween_property(rating_panel, "scale", RATING_TWEEN_SCALE_DOWN,TWEEN_TIME)
	await rating_tween_back.finished
	rating_panel.hide()

	Global.moulding_done = true # Now true, moulding minigame layer can now close.
