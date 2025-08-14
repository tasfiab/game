extends Control

@export var rating : Label

var in_green: bool = false
var in_yellow: bool = false

var can_click = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.baked_item_formed and not Global.is_baked:
		if Global.oven_minigame_start:
			if Input.is_action_just_pressed("interact"):
				show()
				$OvenTimerHand/oven_timer_animation.play("oven_timer_hand")

			if $OvenTimerHand/oven_timer_animation.is_playing():
				if Input.is_action_just_pressed("space"):
					if in_green:
						#rating.text = 'perfect!'
						$OvenTimerHand/oven_timer_animation.stop()
						hide()
						in_green = false
						Global.is_baked = true
						Global.order_meter += 15
						print('mm perfect' + str(Global.order_meter))
					
					elif in_yellow:
						#rating.text = "close!"
						#await get_tree().create_timer(1).timeout
						#rating.hide()
						$OvenTimerHand/oven_timer_animation.stop()
						hide()
						in_yellow = false
						Global.is_baked = true
						Global.order_meter += 10
					else:
						$OvenTimerHand/oven_timer_animation.stop()
						hide()
						Global.is_baked = true
						
						
#func _on_oven_timer_animation_started(anim_name: StringName) -> void:
	#can_click = true

func _on_oven_timer_animation_finished(anim_name: StringName) -> void:
	hide()
	Global.is_baked = true


func _on_green_area_entered(area: Area2D) -> void:
	in_green = true


func _on_green_area_exited(area: Area2D) -> void:
	in_green = false


func _on_yellow_area_entered(area: Area2D) -> void:
	in_yellow = true
