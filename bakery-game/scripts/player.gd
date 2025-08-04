extends CharacterBody2D

@export var making_minigame : CanvasLayer
@export var moulding_minigame : CanvasLayer
@export var toppings_minigame : CanvasLayer

@export var baked_item : StaticBody2D

@export var order : Sprite2D

var making_minigame_start : bool = false
var oven_minigame_start : bool = false 
var toppings_minigame_start : bool = false

const SPEED = 300.0

signal order_complete


func _ready() -> void:
	#making_minigame.hide() 
	#moulding_minigame.hide() 
	#toppings_minigame.hide() 
	
	for customer in Global.customers:
		$"../CharacterBody2D/AnimationPlayer".play("customer")
		await $"../CharacterBody2D/AnimationPlayer".animation_finished
		DialogueManager.show_dialogue_balloon(Global.customer_dialogue[customer])
		await DialogueManager.dialogue_ended
		await order_complete
		Global.customer_number += 1

func _process(delta: float) -> void:
	#_minigame_start()
	if Global.order_done:
		order_complete.emit()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var v_direction := Input.get_axis("up", "down")
	var h_direction := Input.get_axis("left", "right")
	
	var direction: Vector2 = Vector2(h_direction, v_direction).normalized()
	
	velocity = direction * SPEED

	move_and_slide()
	
	#for customer in Global.customers:
		#await Input.is_action_just_pressed("interact")
		


# Function when player enters area where they can interact with minigame.
func _on_minigame_entered(area: Area2D) -> void:
	if area.has_meta("oven"):
		Global.oven_minigame_start = true
	if area.has_meta("making_area"):
		Global.making_minigame_start = true
	if area.has_meta("toppings"):
		Global.toppings_minigame_start = true


func _on_minigame_exited(area: Area2D) -> void:
		if area.has_meta("oven"):
			oven_minigame_start = false
		if area.has_meta("making_area"):
			making_minigame_start = false
		if area.has_meta("toppings"):
			toppings_minigame_start = false
	
func _minigame_start():
	if making_minigame_start:
		if Input.is_action_just_pressed("interact"):
			making_minigame.show()
			if Global.done_button_pressed:
				making_minigame.hide()
				making_minigame_start = false
	
	if Global.done_button_pressed:
		moulding_minigame.show()
	if Global.baked_item_formed:
		moulding_minigame.hide()
		
	if Global.toppings_minigame_start:
		if Input.is_action_just_pressed("interact"):
			toppings_minigame.show()
			
	


func _on_order_complete() -> void:
	pass # Replace with function body.
