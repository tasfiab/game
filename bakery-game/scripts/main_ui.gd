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

const PM : String = "pm"
const HOUR_END : int = 60
const DAY_START_TIME : int = 9
const DAY_END_TIME : int = 5

const EMPTY_STRING : String = ""

var can_check_order : bool = false

var order_hidden : bool = true

var minutes: int = 0
var hours: int = 9


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
	
	# Shows the order UI when it is clicked on.
	if can_check_order and Input.is_action_just_pressed("interact"):
			if order_hidden:
				order_check_layer.show()
				Global.can_move = false
				order_hidden = false
	
	# Closes order UI when player clicks out of it.
	elif not order_hidden and Input.is_action_just_pressed("interact"):
			order_check_layer.hide()
			Global.can_move = true
			order_hidden = true
	
	# Starts a new day by changing time back to 9:00am.
	if Global.new_day:
		hours = DAY_START_TIME
		clock_hours.text = str(hours)
		clock_timer.start()
		Global.new_day = false
	
	# Makes order UI text match customer order in customer dictionary.
	if Global.order_start:
		order_ui_text.text = Global.customer_dictionaries[Global.customers[Global.customer_number]]["customer_order"]
	
	# Makes order UI empty if no customer is currently available
	else: 
		order_ui_text.text = EMPTY_STRING
	
	# Adds money when money is given
	if Global.money_given:
		Global.money += round(Global.order_meter/4)
		money_text.text = str(Global.money)
		Global.money_given = false


# Func to pause game
func pause():
	get_tree().paused = true
	pause_layer.show()


# Every time clock timer runs out, in game clock goes up by 15 mins
func _on_timeout() -> void:
	minutes += 15
	clock_minutes.text = str(minutes)
	clock_timer.start()
	
	# Changes minutes to 0 and adds 1 hour when 60 minutes pass
	if minutes == HOUR_END:
		minutes = 0
		hours += 1
		clock_minutes.text = str(minutes) + str(minutes)
		clock_hours.text = str(hours)
	
	# Changes AM text to PM when it is 12:00
	if hours == 12:
		a_m_text.text = PM
	
	# Changes time to 1:00 rather than 13:00 when at 13 hours
	if hours == 13:
		hours = 1
		clock_hours.text = str(hours)
		
	# Stops clock when end of day
	if hours == DAY_END_TIME:
		clock_timer.stop()
		Global.day_end = true
	
		

# Pauses game when pause button is pressed
func _on_pause_button_pressed() -> void:
	pause()

# When order UI is hovered over, allows order to be checked
func _on_order_ui_mouse_entered() -> void:
	can_check_order = true
	var tween = create_tween()
	tween.tween_property(order_ui, "scale", Vector2(1.1,1.1),0.1)

# When order UI is no longer being hovered over, stops allowing order to be checked
func _on_order_ui_mouse_exited() -> void:
	can_check_order = false
	var tween = create_tween()
	tween.tween_property(order_ui, "scale", Vector2(1,1),0.1)
