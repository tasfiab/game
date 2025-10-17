extends CharacterBody2D

# Order signals
signal order_taken
signal order_complete

const SPEED := 300.0

# Constant strings for animation directions.
const DOWN_ANIMATION := "down"
const UP_ANIMATION := "up"
const LEFT_ANIMATION := "left"
const RIGHT_ANIMATION := "right"

# Constant strings for area metadatas.
const OVEN_META := "oven"
const MAKING_AREA_META := "making_area"
const TOPPINGS_META := "toppings"
const MAIN_COUNTER_META := "main_counter"
const BIN_META := "bin"

const CAMERA_TWEEN_TIME : float = 0.75

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

# Variables storing dialogue used in game.
# Won't put these variables closer to when they are used in script as they are too long.
var intro_dialogue := load("res://addons/dialogue_manager/dialogue_scripts/bread_hamster.dialogue")
var great_reaction := load("res://addons/dialogue_manager/dialogue_scripts/great reaction.dialogue")
var good_reaction := load("res://addons/dialogue_manager/dialogue_scripts/good_reaction.dialogue")
var bad_reaction := load("res://addons/dialogue_manager/dialogue_scripts/bad_reaction.dialogue")
var good_ending := load("res://addons/dialogue_manager/dialogue_scripts/good_ending.dialogue")
var bad_ending := load("res://addons/dialogue_manager/dialogue_scripts/bad_ending.dialogue")

var can_get_order : bool = false
var can_throw_away : bool = false

var in_main_counter_area : bool = false

var order_received := false
var order_completed := false

var game_end := false


func _ready() -> void:
	# Makes game reset when player presses play in main menu.
	_reset()
	Global.order_start = false
	Global.day_end = false
	Global.tutorial_box_number = 0
	Global.can_pause = true # Allows pausing.
	Global.can_move = true # Allows movement.
	
	# Sets money to money made in the day before player quit game.
	Global.money = Global.day_money

	
	player_camera.global_position = main_room.global_position # Sets camera position to main room.
	animation_direction = DOWN_ANIMATION # Makes player face down.
	
	# Constants and variables for original positions of sprites and speeds.
	const CUSTOMER_SPAWN_POSITION := Vector2(570,640)
	const CUSTOMER_POSITION_2 :=  Vector2(570,350)
	const CUSTOMER_SPEED : float = 1.5
	const HAMSTER_EXIT_POSITION := Vector2(570,680)
	const HAMSTER_SPEED : float = 1.75
	var player_original_position : Vector2 = global_position
	var hamster_original_position : Vector2 = bread_hamster.global_position

	
	background_music.play()
	get_tree().paused = false # Makes game unpaused when 'play' pressed
	
	# Plays intro dialogue on day 1.
	if Global.current_day == 1:
		Global.can_move = false # Stops movement during intro.
		bread_hamster.show()
		bread_hamster.play(UP_ANIMATION)
		DialogueManager.show_dialogue_balloon(intro_dialogue)
		await DialogueManager.dialogue_ended
		
		# Hamster leaves after giving intro dialogue.
		bread_hamster.play(DOWN_ANIMATION)
		var tween : Tween = create_tween()
		tween.tween_property(bread_hamster ,"global_position", 
				HAMSTER_EXIT_POSITION, HAMSTER_SPEED)
		Global.can_move = true # Allows movement as hamster leaves.
		await tween.finished
		
		bread_hamster.hide()
		door_sound.play()
	
	var timer_time : float = 1.0
	await get_tree().create_timer(timer_time).timeout
	
	# Makes customers keep looping, even if all customers have been met, until game ends.
	while not game_end:
		Global.customers.shuffle() # Randomises customer order.
		Global.customer_number = 0
		
	# For loop that runs through customers in Global array 'customers'.
		for customer in Global.customers:
			order_received = false
			
			# Gives customer the correct sprite.
			const CUSTOMER_SPRITE_KEY = "customer_sprite"
			var customer_scene : PackedScene = (Global.customer_dictionaries[customer]
					[CUSTOMER_SPRITE_KEY])
			var customer_scene_instance := customer_scene.instantiate()
			customer_sprite = customer_scene_instance
			add_sibling(customer_sprite)
			
			# Gives customer the correct spawning position.
			customer_sprite.global_position = CUSTOMER_SPAWN_POSITION
			
			# Gives customer the correct scale.
			const CUSTOMER_SCALE :=  Vector2(3,3)
			customer_sprite.scale = CUSTOMER_SCALE
			
			# Customer enters bakery and walks up to counter.
			door_sound.play()
			customer_sprite.show()
			customer_sprite.play(UP_ANIMATION)
			var up_tween : Tween = create_tween()
			up_tween.tween_property(customer_sprite, "global_position", 
					CUSTOMER_POSITION_2, CUSTOMER_SPEED)
			await up_tween.finished
			
			customer_sprite.stop()
			can_get_order = true
			
			# Waits for player to interact, once done customer gives their order.
			await order_taken
			
			Global.order_start = true
			
			# Customer gives player their order after they interact with them.
			const DIALOGUE_KEY := "customer_dialogue"
			DialogueManager.show_dialogue_balloon(Global.customer_dictionaries[customer]
					[DIALOGUE_KEY])
			Global.can_move = false # Stops movement during dialogue.
			await DialogueManager.dialogue_ended
			
			Global.can_move = true # Allows movement after dialogue ends.
			
			# Gives tutorial for first customer.
			if Global.customer_number == 0 and Global.current_day == 1:
				const TUTORIAL_BOXES := "tutorial_boxes"
				# For loop goes through tutorial boxes.
				# Shows box and hides it once the tutorial box has fulfilled its purpose.
				for tutorial_box in get_tree().get_nodes_in_group(TUTORIAL_BOXES):
					Global.tutorial_box_number += 1
					tutorial_box.show() 
					await Global.tutorial_given
					tutorial_box.hide()
			
			# Waits for order to be complete, once completed customer gives money.
			await order_complete
			
			cash_register_sound.play()
			Global.give_money = true
			
			# Minimum values for good and great orders.
			const GREAT_ORDER_MIN : int = 85
			const GOOD_ORDER_MIN : int = 65
			
			# Gives good reaction if order meter is in boundaries of a good order.
			if Global.order_meter >= GOOD_ORDER_MIN and Global.order_meter < GREAT_ORDER_MIN:
				DialogueManager.show_dialogue_balloon(good_reaction)
				Global.can_move = false
				await DialogueManager.dialogue_ended
				Global.can_move = true
				
			# Gives great reaction if order meter is in boundaries of a great order.
			elif Global.order_meter >= GREAT_ORDER_MIN:
				DialogueManager.show_dialogue_balloon(great_reaction)
				Global.can_move = false
				await DialogueManager.dialogue_ended
				Global.can_move = true
			
			# Gives bad reaction if order meter is below good order boundary.
			elif Global.order_meter < GOOD_ORDER_MIN:
				DialogueManager.show_dialogue_balloon(bad_reaction)
				Global.can_move = false
				await DialogueManager.dialogue_ended
				Global.can_move = true

			Global.order_start = false
			
			# Makes customer leave bakery after order has been given and completed. 
			customer_sprite.play(DOWN_ANIMATION)
			var down_tween : Tween = create_tween()
			down_tween.tween_property(customer_sprite, "global_position", 
					CUSTOMER_SPAWN_POSITION, CUSTOMER_SPEED)
			await down_tween.finished
			
			customer_sprite.stop()
			customer_sprite.queue_free()
			door_sound.play() 
			
			timer_time = 2.0
			await get_tree().create_timer(timer_time).timeout # Wait after customer leaves.
			_reset() # Resets order.
			can_get_order = false
			
			const FINAL_DAY := 3
			
			# When day ends, and it's not the final day, game stops and day end screen shown.
			if Global.day_end and not Global.current_day == FINAL_DAY:
				Global.can_pause = false
				
				day_end.show() # Shows day end screen.
				
				# Stops bakery background music and starts day end music for day end screen.
				background_music.stop()
				day_end_music.play()
				Global.day_money = Global.money # Saves money made in day.
				get_tree().paused = true
				
				# Resets player to orignal position and direction for new day.
				animation_direction = DOWN_ANIMATION
				global_position = player_original_position
				await Global.next_day
				
				Global.can_pause = true 
				
				# Stops day end music and plays bakery background music.
				day_end_music.stop()
				background_music.play()
			
			# Gives game ending on final day at 5:00pm.
			elif Global.day_end and Global.current_day == FINAL_DAY:
				# Makes hamster come to counter to give ending dialogue.
				Global.can_move = false # Stops movement during ending.
				bread_hamster.global_position = HAMSTER_EXIT_POSITION
				
				bread_hamster.show()
				bread_hamster.play(UP_ANIMATION)
				
				var tween : Tween = create_tween()
				tween.tween_property(bread_hamster ,"global_position", 
						hamster_original_position, HAMSTER_SPEED)
				await tween.finished
				
				# Constant for amount of money required for good ending.
				const GOOD_MONEY : int = 200
				
				# Plays good ending dialogue if player makes $200 or more.
				if Global.money >= GOOD_MONEY:
					DialogueManager.show_dialogue_balloon(good_ending)
					await DialogueManager.dialogue_ended
				
				# Plays bad ending dialogue if player gets less than $200.
				else:
					background_music.stop()
					DialogueManager.show_dialogue_balloon(bad_ending)
					await DialogueManager.dialogue_ended
				
				# Resets to money and day to orignal state and changes scene to main menu.
				Global.day_money = 0
				Global.current_day = 1
				game_end = true
				const MAIN_MENU := "res://scenes/main_menu.tscn"
				get_tree().change_scene_to_file(MAIN_MENU)
				break
				
			Global.customer_number += 1 


func _process(_delta: float) -> void:
	const INTERACT_BIND := "interact"
	# When player hasn't received order and interacts with main counter.
	# Emits signal, allowing player to start making order.
	if not order_received and in_main_counter_area and can_get_order:
		if Input.is_action_just_pressed(INTERACT_BIND):
			order_taken.emit()
			order_received = true
	
	# When player interacts with main counter after completing order.
	# Emits signal allowing customer to get order.
	if Global.order_done and in_main_counter_area:
		if Input.is_action_just_pressed(INTERACT_BIND):
			Global.tutorial_given.emit() # Hides final tutorial box.
			order_complete.emit() 
			Global.order_done = false
			
	# When player interacts with rubbish bin, resets order.
	if can_throw_away and Global.order_start:
		if Input.is_action_just_pressed(INTERACT_BIND):
			bin_sound.play()
			_reset()
			
	# Hides day end screen during daytime.
	if not Global.day_end:
		day_end.hide()


func _physics_process(delta: float) -> void:
	# When player can move, allows them to with movement keys.
	if Global.can_move:
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Get the input direction and handle the movement/deceleration.
		var v_direction := Input.get_axis(UP_ANIMATION, DOWN_ANIMATION)
		var h_direction := Input.get_axis(LEFT_ANIMATION, RIGHT_ANIMATION)
		
		var direction: Vector2 = Vector2(h_direction, v_direction).normalized()
		
		velocity = direction * SPEED

		move_and_slide()
		_handle_animations() # Plays movement animations for player.


# Function to handle player animations.
func _handle_animations():
	# Handles idle sprite if player is not moving.
	if velocity.length() == 0:
		const IDLE_TEXT := "idle_"
		animations.play(IDLE_TEXT + animation_direction)
	
	# Handles walking animations for all directions.
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
		
		# Plays walk animation in animation direction.
		const WALK_TEXT := "walk_"
		animations.play(WALK_TEXT + animation_direction)


# Function to reset values of order back to original state when required.
func _reset():
	Global.dough_taste_added = false 
	Global.flavour_taste_added = false
	Global.flavour_2_taste_added = false
	
	Global.dough_chosen = false
	Global.flavour_chosen = false
	Global.flavour_2_chosen = false
	
	Global.making_done = false
	Global.moulding_done = false
	Global.baking_done = false
	Global.toppings_done = false
	
	Global.chosen_ingredients[0] = ""
	Global.chosen_ingredients[1] = ""
	Global.chosen_ingredients[2] = ""
	
	Global.shape = ""
	
	Global.topping_number = 0
	
	Global.order_item = []
	
	Global.order_meter = 0
	
	Global.order_done = false


# Function that allows player to interact with objects when they are in the objects area.
func _on_interactable_area_entered(area: Area2D) -> void:
	if area.has_meta(OVEN_META):
		Global.can_start_oven = true
	
	if area.has_meta(MAKING_AREA_META):
		Global.can_start_making = true
	
	if area.has_meta(TOPPINGS_META):
		Global.can_start_toppings = true
		
	if area.has_meta(MAIN_COUNTER_META):
		in_main_counter_area = true
		
	if area.has_meta(BIN_META):
		can_throw_away = true


# Function that stops allowing player to interact with object when player exits area.
func _on_interactable_area_exited(area: Area2D) -> void:
		if area.has_meta(OVEN_META):
			Global.can_start_oven = false
		
		if area.has_meta(MAKING_AREA_META):
			Global.can_start_making = false
		
		if area.has_meta(TOPPINGS_META):
			Global.can_start_toppings = false
		
		if area.has_meta(MAIN_COUNTER_META):
			in_main_counter_area = false
			
		if area.has_meta(BIN_META):
			can_throw_away = false


# Moves camera to main room camera position when main room entered.
func _on_main_room_area_entered(_area: Area2D) -> void:
	var tween : Tween = create_tween()
	tween.tween_property(player_camera, "global_position", 
			main_room.global_position, CAMERA_TWEEN_TIME)


# Moves camera to kitchen camera position when kitchen entered.
func _on_room_2_entered(_area: Area2D) -> void:
	var tween : Tween = create_tween()
	tween.tween_property(player_camera, "global_position", 
			kitchen.global_position, CAMERA_TWEEN_TIME)
