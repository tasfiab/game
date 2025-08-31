extends CharacterBody2D

@export var animations : AnimatedSprite2D

@export var order : Sprite2D

@export var in_main_counter_area : bool = false

@export var day_end : CanvasLayer

@export var player_camera : Camera2D
@export var main_room : Marker2D
@export var kitchen : Marker2D

@export var cash_register_UI : Label

var direction : String

var current_dialogue : String
var can_get_order : bool = false

var can_throw_away : bool = false

var order_received = false
var order_completed = false

const SPEED = 300.0

signal order_taken
signal order_complete

func _ready() -> void:
	get_tree().paused = false
	player_camera.global_position = main_room.global_position

	for customer in Global.customers:
		order_received = false
		Global.order_meter = 0
		$"../customer/AnimationPlayer".play("customer")
		await $"../customer/AnimationPlayer".animation_finished
		can_get_order = true
		await order_taken
		DialogueManager.show_dialogue_balloon(Global.customer_dialogue[customer])
		print('its working')
		Global.can_move = false
		await DialogueManager.dialogue_ended
		Global.order_start = true
		Global.can_move = true
		await order_complete
		print(Global.order_meter)
		if Global.order_meter > 65 and Global.order_meter <= 85:
			DialogueManager.show_dialogue_balloon(load("res://addons/dialogue_manager/dialogue_scripts/good_reaction.dialogue"))
			Global.can_move = false
			await DialogueManager.dialogue_ended
			Global.can_move = true
	
		elif Global.order_meter > 85:
			DialogueManager.show_dialogue_balloon(load("res://addons/dialogue_manager/dialogue_scripts/great reaction.dialogue"))
			Global.can_move = false
			await DialogueManager.dialogue_ended
			Global.can_move = true
		
		elif Global.order_meter <= 65:
			DialogueManager.show_dialogue_balloon(load("res://addons/dialogue_manager/dialogue_scripts/bad_reaction.dialogue"))
			Global.can_move = false
			await DialogueManager.dialogue_ended
			Global.can_move = true
		
		Global.money_given = true
		Global.order_start = false
		
		$"../customer/AnimationPlayer".play_backwards("customer")
		await $"../customer/AnimationPlayer".animation_finished
		$"../customer".hide()
		await get_tree().create_timer(2.0).timeout
		
		Global.ingredient_chosen = false
		Global.dough_taste_added = false 
		Global.flavour_taste_added = false
		Global.flavour_2_taste_added = false
		
		Global.dough_chosen = false
		Global.flavour_chosen = false
		Global.flavour_2_chosen = false
		
		
		Global.dough_formed = false
		Global.done_button_pressed = false
		Global.baked_item_formed = false
		Global.is_baked = false
		Global.baked_item_finished = false
		
		Global.chosen_ingredients[0] = ""
		Global.chosen_ingredients[1] = ""
		Global.chosen_ingredients[2] = ""
		
		Global.shape = ''
		
		Global.topping_number = 0
		
		Global.type = []
		
		can_get_order = false
		
		if Global.day_end:
			day_end.show()
			get_tree().paused = true
		
		Global.customer_number += 1
		$"../customer".show()

func _process(delta: float) -> void:
	#_minigame_start()
	if not order_received and in_main_counter_area and can_get_order:
		if Input.is_action_just_pressed("interact"):
			order_taken.emit()
			order_received = true
	if Global.order_done and in_main_counter_area:
		if Input.is_action_just_pressed("interact"):
			order_complete.emit()
			Global.order_done = false
			
			
	if can_throw_away:
		if Input.is_action_just_pressed("interact"):
			Global.ingredient_chosen = false
			Global.dough_taste_added = false 
			Global.flavour_taste_added = false
			Global.flavour_2_taste_added = false
			
			Global.dough_chosen = false
			Global.flavour_chosen = false
			Global.flavour_2_chosen = false
			
			
			Global.dough_formed = false
			Global.done_button_pressed = false
			Global.baked_item_formed = false
			Global.is_baked = false
			Global.baked_item_finished = false
			
			Global.chosen_ingredients[0] = ""
			Global.chosen_ingredients[1] = ""
			Global.chosen_ingredients[2] = ""
			
			Global.shape = ''
			
			Global.topping_number = 0
			
			Global.type = []
			
			Global.order_meter = 0
			print("thrown away")
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if Global.can_move:
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var v_direction := Input.get_axis("up", "down")
		var h_direction := Input.get_axis("left", "right")
		
		var direction: Vector2 = Vector2(h_direction, v_direction).normalized()
		
		
		velocity = direction * SPEED

		move_and_slide()
		_handle_animations()
	
func _handle_animations():
	if velocity.length() == 0:
		animations.play('idle_' + direction)
	else:
		if velocity.x < 0:
			direction = 'left'
			animations.flip_h = true
		elif velocity.x > 0:
			direction = 'right'
			animations.flip_h = false
		elif velocity.y < 0:
			direction = 'up'
			animations.flip_h = false
		elif velocity.y > 0:
			direction = 'down'
			animations.flip_h = false
		
		animations.play('walk_' + direction)
	
	
# Function when player enters area where they can interact with minigame.
func _on_minigame_entered(area: Area2D) -> void:
	if area.has_meta("oven"):
		Global.oven_minigame_start = true
	if area.has_meta("making_area"):
		Global.making_minigame_start = true
	if area.has_meta("toppings"):
		Global.toppings_minigame_start = true
		
	if area.has_meta("main_counter"):
		in_main_counter_area = true
		
	if area.has_meta("bin"):
		can_throw_away = true
		


func _on_minigame_exited(area: Area2D) -> void:
		if area.has_meta("oven"):
			Global.oven_minigame_start = false
		if area.has_meta("making_area"):
			Global.making_minigame_start = false
		if area.has_meta("toppings"):
			Global.toppings_minigame_start = false
		
		if area.has_meta("main_counter"):
			in_main_counter_area = false
			
		if area.has_meta("bin"):
			can_throw_away = false


func _on_main_room_area_entered(area: Area2D) -> void:
	player_camera.global_position = main_room.global_position
#
func _on_room_2_entered(area: Area2D) -> void:
	player_camera.global_position = kitchen.global_position
