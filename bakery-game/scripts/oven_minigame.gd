extends Control

@export var rating : Label
@export var rating_panel : Panel

@export var animations : AnimationPlayer

const RATING_INITIAL_SCALE :=  Vector2(0.1,0.1)
const TWEEN_TIME := 0.1

# Variables that turn true when oven hand is in green area
var in_green: bool = false
var in_yellow: bool = false

var can_click = false

var rating_done = false

signal minigame_done


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide() # Hides timer on ready.
	rating_panel.hide() # Hides rating panel on ready.
	rating_panel.scale = RATING_INITIAL_SCALE # Gives rating panel right scale.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# When moulding minigame is done, allows player to interact with oven for oven minigame.
	if Global.moulding_done and not Global.baking_done:
		
		# When player interacts as timer is running, gives player score based on where the hand is.
		if animations.is_playing():
			if Input.is_action_just_pressed("interact"):
				minigame_done.emit()
				animations.stop()
				hide() # Hides timer.
				
				# Timer is stopped when hand is in green area, adds order points accordingly.
				if in_green:
					const PERFECT_TEXT := "perfect!"
					rating.text = PERFECT_TEXT
					in_green = false
					Global.baking_done = true
					
					const GREAT_ORDER_POINTS : int = 15
					Global.order_meter += GREAT_ORDER_POINTS
					print(str(Global.order_meter))
				
				# Timer is stopped when hand is in yellow area, adds order points accordingly.
				elif in_yellow:
					const CLOSE_TEXT := "close!"
					rating.text = CLOSE_TEXT
					
					in_yellow = false
					Global.baking_done = true
					
					const GOOD_ORDER_POINTS : int = 10
					Global.order_meter += GOOD_ORDER_POINTS
					print(str(Global.order_meter))
				
				# Timer is stopped when hand is not in green or yellow ara, bad rating given.
				else:
					const UMM_TEXT := "umm..."
					rating.text = UMM_TEXT
					Global.baking_done = true
					print(str(Global.order_meter))
		
		# If minigame hasn't been started yet, starts minigame after player interacts with oven.
		elif Global.can_start_oven:
			if Input.is_action_just_pressed("interact"):
				show() # Shows timer.
				
				const TIMER_ANIMATION := "oven_timer_hand"
				animations.play(TIMER_ANIMATION)


# Function gives bad rating if timer animation ends without player interacting.
func _on_oven_timer_animation_finished(anim_name: StringName) -> void:
	hide()
	const UMM_TEXT := "umm..."
	rating.text = UMM_TEXT
	
	Global.baking_done = true
	minigame_done.emit()


# Function for when hand is in green area.
func _on_green_area_entered(area: Area2D) -> void:
	in_green = true


# Function for when hand exits green area.
func _on_green_area_exited(area: Area2D) -> void:
	in_green = false


# Function for when hand is in yellow area.
func _on_yellow_area_entered(area: Area2D) -> void:
	in_yellow = true


# Funtion for when minigame is done.
func _on_minigame_done() -> void:
	const CURRENT_TUTORIAL_NUMBER = 2
	
	# Emits signal to change tutorial box as this minigame is complete.
	if Global.customer_number == 0 and Global.tutorial_box_number == CURRENT_TUTORIAL_NUMBER:
			Global.tutorial_given.emit()
			
	# Shows rating panel to player.
	rating_panel.show()
	
	var tween := create_tween()
	const TWEEN_SCALE := Vector2(1,1)
	tween.tween_property(rating_panel, "scale", TWEEN_SCALE,TWEEN_TIME)
	
	const RATING_SHOW_TIME : float = 1.0
	await get_tree().create_timer(RATING_SHOW_TIME).timeout
	
	# Hides rating panel from player.
	var tween_back := create_tween()
	tween_back.tween_property(rating_panel, "scale", RATING_INITIAL_SCALE,TWEEN_TIME)
	await tween_back.finished
	
	rating_panel.hide()
