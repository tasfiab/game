extends Control

@export var day : Label 
@export var money: HBoxContainer
@export var money_text : Label

@export var pause_layer : CanvasLayer

@export var order_check_layer : CanvasLayer
@export var order_ui : TextureRect
@export var order_ui_text : Label

@export var clock_timer : Timer
@export var clock_hours : Label
@export var clock_minutes : Label
@export var a_m_text : Label


var can_check_order : bool = false

var order_hidden : bool = true

var minutes: int = 0
var hours: int = 9

const PM : String = "pm"
const HOUR_END : int = 60
const DAY_START_TIME : int = 9
const DAY_END_TIME : int = 5

const EMPTY_STRING : String = ""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	day.text = str(Global.current_day)
	money_text.text = str(Global.day_money)
	pause_layer.hide()
	order_check_layer.hide()
	clock_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	day.text = str(Global.current_day)
	if can_check_order and Input.is_action_just_pressed("interact"):
			if order_hidden:
				order_check_layer.show()
				Global.can_move = false
				order_hidden = false
			
	elif not order_hidden and Input.is_action_just_pressed("interact"):
			order_check_layer.hide()
			Global.can_move = true
			order_hidden = true
				
	if Global.new_day:
		hours = DAY_START_TIME
		clock_hours.text = str(hours)
		clock_timer.start()
		Global.new_day = false
	
	if Global.order_start:
		order_ui_text.text = Global.customer_dictionaries[Global.customers[Global.customer_number]]["customer_order"]
	else: 
		order_ui_text.text = EMPTY_STRING
			
	if Global.money_given:
		Global.money += round(Global.order_meter/4)
		money_text.text = str(Global.money)
		Global.money_given = false



func pause():
	get_tree().paused = true
	pause_layer.show()


#Every time clock timer runs out, in game clock goes up by 15 mins
func _on_timeout() -> void:
	minutes += 15
	clock_minutes.text = str(minutes)
	clock_timer.start()
	# If it is 60 minutes in game, minutes will reset to 0 and hours will go up by 1
	if minutes == HOUR_END:
		minutes = 0
		hours += 1
		clock_minutes.text = str(minutes) + str(minutes)
		clock_hours.text = str(hours)
		
	if hours == 12:
		a_m_text.text = PM
	
	if hours == 13:
		hours = 1
		clock_hours.text = str(hours)
		
	if hours == DAY_END_TIME:
		clock_timer.stop()
		Global.day_end = true
	
		


func _on_pause_button_pressed() -> void:
	pause()


func _on_order_pressed() -> void:
	if order_hidden:
		order_check_layer.show()
		Global.can_move = false
		order_hidden = false


func _on_order_ui_mouse_entered() -> void:
	can_check_order = true
	var tween = create_tween()
	tween.tween_property(order_ui, "scale", Vector2(1.1,1.1),0.1)


func _on_order_ui_mouse_exited() -> void:
	can_check_order = false
	var tween = create_tween()
	tween.tween_property(order_ui, "scale", Vector2(1,1),0.1)
