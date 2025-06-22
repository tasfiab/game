extends CharacterBody2D


const SPEED = 300.0


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


# Function when player enters area where they can interact with minigame
func _on_minigame_entered(area: Area2D) -> void:
	if area.has_meta("oven"):
		Global.oven_minigame_start = true
	if area.has_meta("making_area"):
		Global.making_minigame_start = true


func _on_minigame_exited(area: Area2D) -> void:
		if area.has_meta("oven"):
			Global.oven_minigame_start = false
		if area.has_meta("making_area"):
			Global.making_minigame_start = false
	
	
