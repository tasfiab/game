extends CharacterBody2D

@export var animations : AnimatedSprite2D
@export var customer_animations : AnimationPlayer

@export var order : Sprite2D

@export var day_end : CanvasLayer

@export var player_camera : Camera2D
@export var main_room : Marker2D
@export var kitchen : Marker2D

@export var cash_register_UI : Label

@export var background_music : AudioStreamPlayer2D
@export var day_end_music : AudioStreamPlayer2D
@export var cash_register_sound : AudioStreamPlayer2D
@export var door_sound : AudioStreamPlayer2D
@export var bin_sound : AudioStreamPlayer2D

var animation_direction : String

var current_dialogue : String
var can_get_order : bool = false

var can_throw_away : bool = false

var in_main_counter_area : bool = false

var order_received = false
var order_completed = false

var game_end := false

const SPEED = 300.0

# Order signals
signal order_taken
signal order_complete


func _ready() -> void:
	Global.money = Global.day_money
	player_camera.global_position = main_room.global_position # Changes camera position to main room
	animation_direction = 'down'
	$"../customer".hide()
	var player_position : Vector2 = global_position
	background_music.play()
	get_tree().paused = false # Makes game unpaused when 'play' pressed
	if Global.current_day == 1:
		Global.can_move = false
		DialogueManager.show_dialogue_balloon(load("res://addons/dialogue_manager/dialogue_scripts/bread_hamster.dialogue"))
		await DialogueManager.dialogue_ended
		Global.can_move = true
		
	
	while not game_end:
		Global.customers.shuffle()
		Global.customer_number = 0
	# For loop that runs through customers in Global array 'customers'
		for customer in Global.customers:
			$"../customer".show()
			print(Global.customer_number)
			order_received = false
			# Customer enters, walking up to counter animation plays
			# Await for customer to reach counter before allowing player to interact with them
			customer_animations.play("customer")
			door_sound.play()
			await customer_animations.animation_finished
			
			# Waits for player to interact with customer and get order
			can_get_order = true
			await order_taken
			DialogueManager.show_dialogue_balloon(Global.customer_dialogue[customer])
			Global.can_move = false
			await DialogueManager.dialogue_ended
			
			# Can now go and make customer's order
			# Await for order to be made and brought back to counter
			Global.order_start = true
			Global.can_move = true
			
			#Tutorial
			if Global.customer_number == 0 and Global.current_day == 1:
				for tutorial_box in get_tree().get_nodes_in_group('tutorial_boxes'):
					Global.tutorial_box_number += 1
					tutorial_box.show()
					await Global.help
					tutorial_box.hide()
					
			await order_complete
			cash_register_sound.play()
			#cash_register_UI.text = "+" + str(Global.money)
			#await get_tree().create_timer(0.5).timeout
			#cash_register_UI.text = ""
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
			
			customer_animations.play_backwards("customer")
			await customer_animations.animation_finished
			$"../customer".hide()
			door_sound.play()
			await get_tree().create_timer(2.0).timeout
			
			_reset()
			
			can_get_order = false
			
			if Global.day_end and not Global.current_day == 3:
				day_end.show()
				animation_direction = 'down'
				background_music.stop()
				day_end_music.play()
				get_tree().paused = true
				global_position = player_position
				await Global.next_day
				day_end_music.stop()
				background_music.play()
				
			elif Global.day_end and Global.current_day == 3:
				Global.can_move = false
				if Global.money >= 150:
					DialogueManager.show_dialogue_balloon(load("res://addons/dialogue_manager/dialogue_scripts/good_ending.dialogue"))
					await DialogueManager.dialogue_ended
				else:
					DialogueManager.show_dialogue_balloon(load("res://addons/dialogue_manager/dialogue_scripts/bad_ending.dialogue"))
					await DialogueManager.dialogue_ended
				get_tree().change_scene_to_file("res://scenes/end_screen.tscn")
				game_end = true
				
			Global.customer_number += 1

func _process(_delta: float) -> void:
	if Global.day_end and not Global.current_day == 3:
		Global.day_money = Global.money
	if not order_received and in_main_counter_area and can_get_order:
		if Input.is_action_just_pressed("interact"):
			order_taken.emit()
			order_received = true
	if Global.order_done and in_main_counter_area:
		if Input.is_action_just_pressed("interact"):
			Global.help.emit()
			order_complete.emit()
			Global.order_done = false

	if can_throw_away:
		if Input.is_action_just_pressed("interact"):
			bin_sound.play()
			_reset()
			print("thrown away")
	if not Global.day_end:
		day_end.hide()
	
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
		animations.play('idle_' + animation_direction)
	else:
		if velocity.x < 0:
			animation_direction = 'left'
			animations.flip_h = true
		elif velocity.x > 0:
			animation_direction = 'right'
			animations.flip_h = false
		elif velocity.y < 0:
			animation_direction = 'up'
			animations.flip_h = false
		elif velocity.y > 0:
			animation_direction = 'down'
			animations.flip_h = false
		
		animations.play('walk_' + animation_direction)
	
func _reset():
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


func _on_main_room_area_entered(_area: Area2D) -> void:
	player_camera.global_position = main_room.global_position
#
func _on_room_2_entered(_area: Area2D) -> void:
	player_camera.global_position = kitchen.global_position
