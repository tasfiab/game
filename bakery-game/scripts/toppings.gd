extends Node2D
@onready var choco_icing = $"../chocolate_icing"
@onready var vanilla_icing = $"../vanilla_icing"

@export var topping_marker : Marker2D
@export var type : String

@export var square_sprite : Sprite2D
@export var circle_sprite : Sprite2D
@export var loaf_sprite : Sprite2D
@export var croissant_sprite : Sprite2D

@export var item : Sprite2D

@export var toppings_counter : Label

const MAX_TOPPINGS := 3

const INTERACT_BIND := "interact"

const BEST_TOPPING_KEY := "best topping"
const OK_TOPPING_KEY := "ok topping"
const PERFECT_DRDER_KEY := "perfect_order"

const VANILLA_ICING := "vanilla_icing"
const CHOCO_ICING := "choco_icing"

const LOAF := 'loaf'
const CROISSANT := 'croissant'
const CIRCLE := 'circle'
const SQUARE := 'square'

const GOOD_ORDER_POINTS := 10
const OK_ORDER_POINTS := 5

var current_customer : String
var order_dictionary : Dictionary

var draggable: bool = false
var in_baked_item : bool = false

var offset : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Stops player movement when minigame start.
	if Global.in_topping_minigame:
		Global.can_move = false 
		
	# Makes customer and order dictionary accurate to current customer.
	current_customer = Global.customers[Global.customer_number]
	order_dictionary = Global.customer_dictionaries[current_customer][PERFECT_DRDER_KEY]
	
	# Makes item texture the same as what player has made to this point.
	if Global.order_item.has(Global.shape):
		item.texture = Global.item_sprites[Global.order_item]

	# Allows player to click on and drag toppings to item.
	if draggable and not Global.topping_number == MAX_TOPPINGS:
		if Input.is_action_just_pressed(INTERACT_BIND):
			offset = get_global_mouse_position() - global_position
			Global.is_dragging = true
		
		# Makes topping follow mouse when dragged.
		if Input.is_action_pressed(INTERACT_BIND):
			global_position = get_global_mouse_position()
			
		# When mouse click is released, topping is released.
		elif Input.is_action_just_released(INTERACT_BIND):
			Global.is_dragging = false
			
			# When topping is in item, adds topping.
			if in_baked_item:
				self.hide()
				Global.topping_number += 1
				const TOPPINGS_TEXT := "toppings "
				const TOPPINGS_COUNT_TEXT := "/3"
				
				toppings_counter.text =  TOPPINGS_TEXT + str(Global.topping_number) + TOPPINGS_COUNT_TEXT
				
				# Hides chocolate icing if vanilla icing used.
				if self.type == VANILLA_ICING:
					choco_icing.hide()
				
				# Hides vanilla icing if chocolate icing is used.
				elif self.type == CHOCO_ICING:
					vanilla_icing.hide()
				
				# Shows topping sprite for square cakes.
				if Global.shape == SQUARE:
					self.square_sprite.show()
				
				# Shows topping sprite for circle cakes.
				elif Global.shape == CIRCLE:
					self.circle_sprite.show()
				
				# Shows topping sprite for loafs.
				elif Global.shape == LOAF:
					self.loaf_sprite.show()
				
				# Shows topping sprite for croissants.
				elif Global.shape == CROISSANT:
					self.croissant_sprite.show()
				
				# Checks if topping matches 'ok topping' or 'best topping' in order dictionary
				if order_dictionary.has(BEST_TOPPING_KEY):
					if self.type == order_dictionary[BEST_TOPPING_KEY]:
						Global.order_meter += GOOD_ORDER_POINTS
					
					elif self.type ==  order_dictionary[OK_TOPPING_KEY]:
						Global.order_meter += OK_ORDER_POINTS
			
			# Makes topping return to origingal position if not in the item area.
			else:
				var tween = create_tween()
				const TWEEN_TIME = 0.2
				tween.tween_property(self,"global_position",topping_marker.global_position,TWEEN_TIME).set_ease(Tween.EASE_OUT)


# Makes topping draggable when hovered over.
func _on_toppings_mouse_entered() -> void:
	if not Global.is_dragging:
		draggable = true


# Makes topping not draggable when no longer hovered over.
func _on_toppings_mouse_exited() -> void:
	if not Global.is_dragging:
		draggable = false


# Checks if topping is in baked item, or not.
func _on_toppings_body_entered(body: Node2D) -> void:
	in_baked_item = true


func _on_toppings_body_exited(body: Node2D) -> void:
	in_baked_item = false


# When done button pressed, closes out of minigame
func _on_done_button_down() -> void:
	print(Global.order_meter)
	const CURRENT_TUTORIAL_NUMBER : int = 3
	const NO_TOPPINGS : int = 0
	
	Global.toppings_done = true # Turned true, minigame layer can now close.
	Global.order_done = true
	
	# Checks if the customer prefers no toppings, and if no toppings were added, adding points accordingly
	if not order_dictionary.has(BEST_TOPPING_KEY):
		if Global.topping_number == NO_TOPPINGS:
			Global.order_meter += GOOD_ORDER_POINTS + OK_ORDER_POINTS
			
	# Changes tutorial box to the next box if this is the first customer.
	if Global.customer_number == 0 and Global.tutorial_box_number == CURRENT_TUTORIAL_NUMBER:
				Global.tutorial.emit()
