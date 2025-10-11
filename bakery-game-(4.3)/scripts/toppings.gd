extends Node2D

@export var topping_marker : Marker2D
@export var type : String
@export var square_sprite : Sprite2D
@export var circle_sprite : Sprite2D
@export var loaf_sprite : Sprite2D
@export var croissant_sprite : Sprite2D
@export var item : Sprite2D

@export var toppings_counter : Label

var current_customer = Global.customers[Global.customer_number]
var order_dictionary = Global.customer_dictionaries[current_customer]["perfect_order"]

var topping_added : bool = false
var draggable: bool = false
var in_baked_item : bool = false

var offset : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.in_topping_minigame:
		Global.can_move = false
	current_customer = Global.customers[Global.customer_number]
	order_dictionary = Global.customer_dictionaries[current_customer]["perfect_order"]
	#Checks topping is draggable
	if Global.order_item.size() == 2:
		item.texture = Global.item_sprites[Global.order_item]
	if draggable and not Global.topping_number == 3:
		if Input.is_action_just_pressed("interact"):
			offset = get_global_mouse_position() - global_position
			Global.is_dragging = true
		if Input.is_action_pressed("interact"):
			global_position = get_global_mouse_position()
		elif Input.is_action_just_released("interact"):
			Global.is_dragging = false
			if in_baked_item:
				self.hide()
				if self.type == "vanilla_icing":
					$"../chocolate_icing".hide()
				if self.type == "choco_icing":
					$"../vanilla_icing".hide()
				Global.topping_number += 1
				toppings_counter.text = "toppings " + str(Global.topping_number) + "/3"
				if Global.shape == 'square':
					self.square_sprite.show()
				elif Global.shape == 'circle':
					self.circle_sprite.show()
				elif Global.shape == 'loaf':
					self.loaf_sprite.show()
				elif Global.shape == 'croissant':
					self.croissant_sprite.show()
					
				if order_dictionary.has('best topping'):
					if self.type == order_dictionary['best topping']:
						Global.order_meter += 10
						print('topping good' + str(Global.order_meter))
					
					elif self.type ==  order_dictionary['ok topping']:
						Global.order_meter += 5
						print('topping ok' + str(Global.order_meter))
						
			elif not in_baked_item:
				var tween = create_tween()
				tween.tween_property(self,"global_position",topping_marker.global_position,0.2).set_ease(Tween.EASE_OUT)
				#global_position = topping_marker.global_position
	
				
				
				#position = global_position
				#var toppings = topping_scene.instantiate()
				#toppings.global_position = original_position
		
				
			#var tween = get_tree().create_tween()
			#if in_baked_item:
				#tween.tween_property(self,"position",body_ref.position,0.2).set_ease(Tween.EASE_OUT)
			#else:
				#tween.tween_property(self,"global_position",initialPos,0.2).set_ease(Tween.EASE_OUT)
		

func tween_in(topping):
	var tween = create_tween()
	tween.tween_property(topping,"scale",Vector2(0,0),0.05).set_ease(Tween.EASE_OUT)


func _on_toppings_mouse_entered() -> void:
	if not Global.is_dragging and not topping_added:
		draggable = true
		#scale = Vector2(1.05,1.05)


func _on_toppings_mouse_exited() -> void:
	if not Global.is_dragging and not topping_added:
		draggable = false
		#scale = Vector2(1,1)


func _on_toppings_body_entered(body: Node2D) -> void:
	in_baked_item = true

func _on_toppings_body_exited(body: Node2D) -> void:
	in_baked_item = false



func _on_done_button_pressed() -> void:
	Global.baked_item_finished = true
	Global.can_move = true
	print("can move!!")
	Global.order_done = true
	if not order_dictionary.has('best topping'):
		if Global.topping_number == 0:
			Global.order_meter += 15
			print('no topping' + str(Global.order_meter))
	if Global.customer_number == 0 and Global.tutorial_box_number == 3:
				Global.tutorial.emit()


func _on_reset_button_pressed() -> void:
	topping_added = false
	for topping in get_tree().get_nodes_in_group('topping'):
		topping.show()
		if Global.shape == 'square':
			topping.square_sprite.hide()
		elif Global.shape == 'circle':
			topping.circle_sprite.hide()
		elif Global.shape == 'loaf':
			topping.loaf_sprite.hide()
		elif Global.shape == 'croissant':
			topping.croissant_sprite.hide()
		topping.global_position = topping.topping_marker.global_position
