extends Control

@export var rating : Label
@export var rating_panel : Panel

@export var animations : AnimationPlayer

var in_green: bool = false
var in_yellow: bool = false

var can_click = false

var rating_done = false

signal minigame_done
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	rating_panel.hide()
	rating_panel.scale = Vector2(0.1,0.1)
	#rating_panel.position = Vector2(6,3)
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.baked_item_formed and not Global.is_baked:
		if animations.is_playing():
			if Input.is_action_just_pressed("interact"):
				minigame_done.emit()
				animations.stop()
				hide()
				if in_green:
					rating.text = "perfect!"
					in_green = false
					Global.is_baked = true
					Global.order_meter += 15
					print('mm perfect' + str(Global.order_meter))
				
				elif in_yellow:
					rating.text = "close!"
					in_yellow = false
					Global.is_baked = true
					Global.order_meter += 10
				else:
					rating.text = 'umm...'
					Global.is_baked = true
						
		elif Global.oven_minigame_start:
			if Input.is_action_just_pressed("interact"):
				show()
				animations.play("oven_timer_hand")			
#func _on_oven_timer_animation_started(anim_name: StringName) -> void:
	#can_click = true

#func _on_oven_timer_animation_finished(anim_name: StringName) -> void:
	#hide()
	#Global.is_baked = true
	#rating.show()
	##await get_tree().create_timer(1).timeout
	##rating.hide()


func _on_green_area_entered(area: Area2D) -> void:
	in_green = true


func _on_green_area_exited(area: Area2D) -> void:
	in_green = false


func _on_yellow_area_entered(area: Area2D) -> void:
	in_yellow = true


func _on_minigame_done() -> void:
	if Global.customer_number == 0 and Global.tutorial_box_number == 2:
			Global.tutorial.emit()

	rating_panel.show()
	var tween = create_tween()
	tween.tween_property(rating_panel, "scale", Vector2(1,1),0.1)
	
	await get_tree().create_timer(0.5).timeout
	var tween_back = create_tween()
	tween_back.tween_property(rating_panel, "scale", Vector2(0.1,0.1),0.1)
	await tween_back.finished
	rating_panel.hide()
