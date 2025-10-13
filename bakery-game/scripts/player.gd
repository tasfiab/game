extends CharacterBody2D
# Order signals
signal order_taken
signal order_complete

@export var animations : AnimatedSprite2D
@export var bread_hamster : AnimatedSprite2D

@export var order : Sprite2D

@export var day_end : CanvasLayer

@export var player_camera : Camera2D
@export var main_room : Marker2D
@export var kitchen : Marker2D


@export var background_music : AudioStreamPlayer2D
@export var day_end_music : AudioStreamPlayer2D
@export var cash_register_sound : AudioStreamPlayer2D
@export var door_sound : AudioStreamPlayer2D
@export var bin_sound : AudioStreamPlayer2D

@export var customer_sprite : AnimatedSprite2D

var animation_direction : String

var current_dialogue : String
var can_get_order : bool = false

var can_throw_away : bool = false

var in_main_counter_area : bool = false

var order_received := false
var order_completed := false

var game_end := false

const SPEED := 300.0

const CAMERA_TWEEN_TIME := 0.75
const DOWN_ANIMATION := "down"
const UP_ANIMATION := "up"
const LEFT_ANIMATION := "left"
const RIGHT_ANIMATION := "right"

func _ready() -> void:
	var customer_scene 
	var customer_scene_instance
	const FIRST_DAY := 1
	const FIRST_CUSTOMER_NUMBER := 0
	const FINAL_DAY := 3
	_reset()
	Global.money = Global.day_money
	Global.tutorial_box_number = 0
	player_camera.global_position = main_room.global_position # Changes camera position to main room
	animation_direction = 'down'
	var player_original_position : Vector2 = global_position
	background_music.play()
	get_tree().paused = false # Makes game unpaused when 'play' pressed
	
	# Intro dialogue.
	if Global.current_day == FIRST_DAY:
		Global.can_move = false
		bread_hamster.show()
		bread_hamster.play('up')
		DialogueManager.show_dialogue_balloon(load("res://addons/dialogue_manager/dialogue_scripts/bread_hamster.dialogue"))
		await DialogueManager.dialogue_ended
		bread_hamster.play('down')
		var tween = create_tween()
		tween.tween_property(bread_hamster ,"global_position", Vector2(570,680), 1.75)
		Global.can_move = true
		await tween.finished
		bread_hamster.hide()
		door_sound.play()
		
	
	while not game_end:
		Global.customers.shuffle()
		Global.customer_number = 0
	# For loop that runs through customers in Global array 'customers'.
		for customer in Global.customers:
			order_received = false
			await get_tree().create_timer(1.0).timeout
			
			# Gives customer the correct sprite, scale and starting position.
			const CUSTOMER_SPRITE_KEY = "customer_sprite"
			customer_scene = Global.customer_dictionaries[customer][CUSTOMER_SPRITE_KEY]
			customer_scene_instance = customer_scene.instantiate()
			customer_sprite = customer_scene_instance
			add_sibling(customer_sprite)
			customer_sprite.global_position = Vector2(570,640)
			customer_sprite.scale = Vector2(3,3)
			
			# Customer enters bakery and walks up to counter.
			door_sound.play()
			customer_sprite.show()
			customer_sprite.play(UP_ANIMATION)
			var up_tween = create_tween()
			up_tween.tween_property(customer_sprite, "global_position", Vector2(570,350),1.5)
			await up_tween.finished
			customer_sprite.stop()
			can_get_order = true
			
			# Waits for player to interact, once done customer gives their order.
			await order_taken
			DialogueManager.show_dialogue_balloon(Global.customer_dictionaries[customer]["customer_dialogue"])
			Global.can_move = false
			await DialogueManager.dialogue_ended
			Global.order_start = true
			Global.can_move = true
			
			# Tutorial for first customer.
			if Global.customer_number == FIRST_CUSTOMER_NUMBER and Global.current_day == FIRST_DAY:
				for tutorial_box in get_tree().get_nodes_in_group('tutorial_boxes'):
					Global.tutorial_box_number += 1
					tutorial_box.show()
					await Global.tutorial
					tutorial_box.hide()
			
			# Waits for order to be complete, once completed customer gives money.
			await order_complete
			cash_register_sound.play()
			Global.money_given = true
			
			# Grades item made depending on order meter score.
			if Global.order_meter > 65 and Global.order_meter < 85:
				DialogueManager.show_dialogue_balloon(load("res://addons/dialogue_manager/dialogue_scripts/good_reaction.dialogue"))
				Global.can_move = false
				await DialogueManager.dialogue_ended
				Global.can_move = true
		
			elif Global.order_meter >= 85:
				DialogueManager.show_dialogue_balloon(load("res://addons/dialogue_manager/dialogue_scripts/great reaction.dialogue"))
				Global.can_move = false
				await DialogueManager.dialogue_ended
				Global.can_move = true
			
			elif Global.order_meter <= 65:
				DialogueManager.show_dialogue_balloon(load("res://addons/dialogue_manager/dialogue_scripts/bad_reaction.dialogue"))
				Global.can_move = false
				await DialogueManager.dialogue_ended
				Global.can_move = true

			Global.order_start = false
			
			# Customer leaves bakery and resets order completely.
			customer_sprite.play(DOWN_ANIMATION)
			var down_tween = create_tween()
			down_tween.tween_property(customer_sprite, "global_position", Vector2(570,610),1.5)
			await down_tween.finished
			customer_sprite.stop()
			customer_sprite.queue_free()
			door_sound.play()
			await get_tree().create_timer(1.0).timeout
			_reset()
			can_get_order = false
			
			# When day ends, and it's not the final day, game stops and day end screen shown.
			if Global.day_end and not Global.current_day == FINAL_DAY:
				Global.day_money = Global.money # Saves money made in day in case player leaves game.
				day_end.show()
				background_music.stop()
				day_end_music.play()
				get_tree().paused = true
				
				# Resets player to orignal state for next day.
				animation_direction = DOWN_ANIMATION
				global_position = player_original_position
				await Global.next_day
				day_end_music.stop()
				background_music.play()
			
			# Endings for final day.
			elif Global.day_end and Global.current_day == FINAL_DAY:
				const GOOD_MONEY = 200
				const ORIGINAL_MONEY = 0
				
				# Hamster comes to counter.
				Global.can_move = false
				bread_hamster.show()
				bread_hamster.play(UP_ANIMATION)
				var tween = create_tween()
				tween.tween_property(bread_hamster ,"global_position", Vector2(570,290), 1.75)
				await tween.finished
				
				# Good ending.
				if Global.money >= GOOD_MONEY:
					DialogueManager.show_dialogue_balloon(load("res://addons/dialogue_manager/dialogue_scripts/good_ending.dialogue"))
					await DialogueManager.dialogue_ended
				
				# Bad ending.
				else:
					background_music.stop()
					var Bad_Ending = load("res://addons/dialogue_manager/dialogue_scripts/bad_ending.dialogue")
					DialogueManager.show_dialogue_balloon(Bad_Ending)
					await DialogueManager.dialogue_ended
				
				# Resets game to orignal state and changes scene to main menu.
				Global.day_money = ORIGINAL_MONEY
				Global.current_day = FIRST_DAY
				game_end = true
				const MAIN_MENU := "res://scenes/main_menu.tscn"
				get_tree().change_scene_to_file(MAIN_MENU)
				break
				
			Global.customer_number += 1

func _process(_delta: float) -> void:
	if not order_received and in_main_counter_area and can_get_order:
		if Input.is_action_just_pressed("interact"):
			order_taken.emit()
			order_received = true
	if Global.order_done and in_main_counter_area:
		if Input.is_action_just_pressed("interact"):
			Global.tutorial.emit()
			order_complete.emit()
			Global.order_done = false
			
	# When player interacts with rubbish bin.
	if can_throw_away:
		if Input.is_action_just_pressed("interact"):
			bin_sound.play()
			_reset()
			print("thrown away")
			
	# Hides day end screen during daytime.
	if not Global.day_end:
		day_end.hide()
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if Global.can_move:
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Get the input direction and handle the movement/deceleration.
		var v_direction := Input.get_axis(UP_ANIMATION, DOWN_ANIMATION)
		var h_direction := Input.get_axis(LEFT_ANIMATION, RIGHT_ANIMATION)
		
		var direction: Vector2 = Vector2(h_direction, v_direction).normalized()
		
		velocity = direction * SPEED

		move_and_slide()
		_handle_animations()

# Function to handle player animations.
func _handle_animations():
	# Handles idle animations.
	if velocity.length() == 0:
		animations.play('idle_' + animation_direction)
	
	# Handles walking animations.
	else:
		if velocity.x < 0:
			animation_direction = LEFT_ANIMATION
			animations.flip_h = true
		elif velocity.x > 0:
			animation_direction = RIGHT_ANIMATION
			animations.flip_h = false
		elif velocity.y < 0:
			animation_direction = UP_ANIMATION
			animations.flip_h = false
		elif velocity.y > 0:
			animation_direction = DOWN_ANIMATION
			animations.flip_h = false
		
		animations.play('walk_' + animation_direction)

# Function to reset all values back to original state.
func _reset():
	Global.ingredient_chosen = false
	Global.dough_taste_added = false 
	Global.flavour_taste_added = false
	Global.flavour_2_taste_added = false
	
	Global.dough_chosen = false
	Global.flavour_chosen = false
	Global.flavour_2_chosen = false
	
	Global.dough_formed = false
	Global.making_done = false
	Global.moulding_done = false
	Global.baking_done = false
	Global.toppings_done = false
	
	Global.chosen_ingredients[0] = ""
	Global.chosen_ingredients[1] = ""
	Global.chosen_ingredients[2] = ""
	
	Global.shape = ''
	
	Global.topping_number = 0
	
	Global.order_item = []
	
	Global.order_meter = 0
	
# Function for when player enters area where they can interact.
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
		

# Function for when player exits area where they can interact.
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

# Moves camera to main room camera position when main room entered.
func _on_main_room_area_entered(_area: Area2D) -> void:
	var tween = create_tween()
	tween.tween_property(player_camera, "global_position", main_room.global_position, CAMERA_TWEEN_TIME)

# Moves camera to kitchen camera position when kitchen entered.
func _on_room_2_entered(_area: Area2D) -> void:
	var tween = create_tween()
	tween.tween_property(player_camera, "global_position", kitchen.global_position, CAMERA_TWEEN_TIME)
