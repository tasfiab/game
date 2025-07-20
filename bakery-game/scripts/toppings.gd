extends Node2D

@export var topping_scene : PackedScene

var draggable: bool = false
var in_baked_item : bool = false
var body_ref
var offset : Vector2
var initialPos : Vector2

var original_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if draggable:
		if Input.is_action_just_pressed("interact"):
			offset = get_global_mouse_position() - global_position
			Global.is_dragging = true
		if Input.is_action_pressed("interact"):
			global_position = get_global_mouse_position()
		elif Input.is_action_just_released("interact"):
			Global.is_dragging = false
			if in_baked_item:
				var toppings = topping_scene.instantiate()
				
			if not in_baked_item:
				global_position = original_position
				
			#var tween = get_tree().create_tween()
			#if in_baked_item:
				#tween.tween_property(self,"position",body_ref.position,0.2).set_ease(Tween.EASE_OUT)
			#else:
				#tween.tween_property(self,"global_position",initialPos,0.2).set_ease(Tween.EASE_OUT)
		


func _on_toppings_mouse_entered() -> void:
	if not Global.is_dragging:
		draggable = true
		scale = Vector2(1.05,1.05)


func _on_toppings_mouse_exited() -> void:
	if not Global.is_dragging:
		draggable = false
		scale = Vector2(1,1)


func _on_toppings_body_entered(body: Node2D) -> void:
	in_baked_item = true
	body_ref = body

func _on_toppings_body_exited(body: Node2D) -> void:
	in_baked_item = false
	body_ref = body
