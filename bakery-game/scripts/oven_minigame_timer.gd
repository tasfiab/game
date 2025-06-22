extends Control

var in_green: bool = false
var in_yellow: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.dough_formed:
		if Global.oven_minigame_start:
			if Input.is_action_just_pressed("interact"):
				print("something")
				show()
				$OvenTimerHand/oven_timer_animation.play("oven_timer_hand")
				
				if $OvenTimerHand/oven_timer_animation.is_playing():
					if Input.is_action_just_pressed("interact"):
						if in_green:
							print("perfect!")
							$OvenTimerHand/oven_timer_animation.stop()
							hide()
							in_green = false
						
						elif in_yellow:
							print("close!")
							$OvenTimerHand/oven_timer_animation.stop()
							hide()
							in_yellow = false

func _on_oven_timer_animation_finished(anim_name: StringName) -> void:
	hide()


func _on_green_area_entered(area: Area2D) -> void:
	in_green = true


func _on_green_area_exited(area: Area2D) -> void:
	in_green = false


func _on_yellow_area_entered(area: Area2D) -> void:
	in_yellow = true
