extends Node2D

@export var topping_marker : Marker2D

var draggable: bool = false
var in_baked_item : bool = false
var body_ref
var offset : Vector2
var initialPos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#for topping in get_tree().get_nodes_in_group('topping'):
		#topping.original_position = self.topping_marker.global_position
		#original_position = global_position
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Checks topping is draggable
	if draggable:
		if Input.is_action_just_pressed("interact"):
			offset = get_global_mouse_position() - global_position
			Global.is_dragging = true
		if Input.is_action_pressed("interact"):
			global_position = get_global_mouse_position()
		elif Input.is_action_just_released("interact"):
			Global.is_dragging = false
			if in_baked_item:
				self.hide()
				#position = global_position
				#var toppings = topping_scene.instantiate()
				#toppings.global_position = original_position
				
			if not in_baked_item:
				global_position = topping_marker.global_position
				
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


func _on_button_pressed() -> void:
	Global.baked_item_finished = true
	Global.order_done = true


func _on_reset_button_pressed() -> void:
	for topping in get_tree().get_nodes_in_group('topping'):
		topping.show()
		topping.global_position = topping.topping_marker.global_position
