extends Node2D

const BEST_TOPPING_KEY := "best topping"
const OK_TOPPING_KEY := "ok topping"

const GOOD_ORDER_POINTS : int = 10
const OK_ORDER_POINTS : int = 5

@export var topping_marker : Marker2D
@export var type : String

@export var square_sprite : Sprite2D
@export var circle_sprite : Sprite2D
@export var loaf_sprite : Sprite2D
@export var croissant_sprite : Sprite2D

@export var item : Sprite2D

@export var toppings_counter : Label

var current_customer : String
var order_dictionary : Dictionary

var draggable: bool = false
var in_baked_item : bool = false

@onready var choco_icing = $"../chocolate_icing"
@onready var vanilla_icing = $"../vanilla_icing"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Sets current customer and order dictionary to be accurate to current customer.
	const PERFECT_ORDER_KEY := "perfect_order"
	current_customer = Global.customers[Global.customer_number]
	order_dictionary = Global.customer_dictionaries[current_customer][PERFECT_ORDER_KEY]
	
	# Makes item texture the same as what player has made to this point.
	if Global.order_item.has(Global.shape):
		item.texture = Global.item_sprites[Global.order_item]

	# Allows player to click on and drag toppings to item.
	const MAX_TOPPINGS : int = 3
	if draggable and not Global.topping_number == MAX_TOPPINGS:
		const INTERACT_BIND := "interact"
		
		# Makes topping follow mouse when pressed.
		if Input.is_action_just_pressed(INTERACT_BIND):
			var offset : Vector2
			offset = get_global_mouse_position() - global_position 
			Global.is_dragging = true
		
		# Makes topping follow mouse while dragged.
		if Input.is_action_pressed(INTERACT_BIND):
			global_position = get_global_mouse_position()
			
		# When mouse click is released, topping is released.
		elif Input.is_action_just_released(INTERACT_BIND):
			Global.is_dragging = false
			
			# Adds topping when topping is dragged into item.
			if in_baked_item:
				self.hide() # Hides topping.
				Global.topping_number += 1
				
				const TOPPINGS := "toppings "
				const TOPPINGS_COUNT_TEXT := "/3"
				toppings_counter.text =  TOPPINGS + str(Global.topping_number) + TOPPINGS_COUNT_TEXT
				
				# Hides chocolate icing if vanilla icing added.
				const VANILLA_ICING := "vanilla_icing"
				const CHOCO_ICING := "choco_icing"
				const SQUARE := "square"
				const CIRCLE := "circle"
				const LOAF := "loaf"
				const CROISSANT := "croissant"
				
				if self.type == VANILLA_ICING:
					choco_icing.hide()
				
				# Hides vanilla icing if chocolate icing is added.
				elif self.type == CHOCO_ICING:
					vanilla_icing.hide()
				
				# Topping added, shows topping sprite for square cakes, if item is a square cake.
				if Global.shape == SQUARE:
					self.square_sprite.show()
				
				# Topping added, shows topping sprite for circle cake, if item is a circle cake.
				elif Global.shape == CIRCLE:
					self.circle_sprite.show()
				
				# Shows topping sprite for loafs.
				elif Global.shape == LOAF:
					self.loaf_sprite.show()
				
				# Topping added, shows topping sprite for croissants, if item is a croissant.
				elif Global.shape == CROISSANT:
					self.croissant_sprite.show()
				
				# Checks if topping matches 'best topping' or 'ok topping' in order dictionary.
				if order_dictionary.has(BEST_TOPPING_KEY):
					if self.type == order_dictionary[BEST_TOPPING_KEY]:
						Global.order_meter += GOOD_ORDER_POINTS
					
					elif self.type ==  order_dictionary[OK_TOPPING_KEY]:
						Global.order_meter += OK_ORDER_POINTS
			
			# Makes topping return to original position if not in the item area.
			else:
				var tween = create_tween()
				const TWEEN_TIME = 0.2
				tween.tween_property(self, "global_position", topping_marker.global_position, 
						TWEEN_TIME).set_ease(Tween.EASE_OUT)


# Makes topping draggable when hovered over.
func _on_toppings_mouse_entered() -> void:
	if not Global.is_dragging:
		draggable = true


# Makes topping not draggable when no longer hovered over.
func _on_toppings_mouse_exited() -> void:
	if not Global.is_dragging:
		draggable = false


# Function to check if topping is in baked item.
func _on_baked_item_entered(body: Node2D) -> void:
	const ITEM_META := "baked_item"
	if body.has_meta(ITEM_META):
		in_baked_item = true


# Function to check that topping is no longer in baked item..
func _on_baked_item_exited(body: Node2D) -> void:
	const ITEM_META := "baked_item"
	if body.has_meta(ITEM_META):
		in_baked_item = false


# Function for when done button is pressed.
func _on_done_button_down() -> void:
	const CURRENT_TUTORIAL_NUMBER : int = 3
	const NO_TOPPINGS : int = 0
	
	Global.toppings_done = true # Turned true, minigame layer can now close.
	Global.order_done = true
	
	# Checks if the customer prefers no toppings, and if no toppings were added, adds max points.
	if not order_dictionary.has(BEST_TOPPING_KEY):
		if Global.topping_number == NO_TOPPINGS:
			Global.order_meter += GOOD_ORDER_POINTS + OK_ORDER_POINTS
	
	print(Global.order_meter)
	
	# Emits signal to change tutorial box to the next box, as toppings have been added.
	if Global.customer_number == 0 and Global.tutorial_box_number == CURRENT_TUTORIAL_NUMBER:
				Global.tutorial_given.emit()
