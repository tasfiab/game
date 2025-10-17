extends Control

@export var day : Label 
@export var money_text : Label

@export var pause_layer : CanvasLayer

# Order UI variables.
@export var order_check_layer : CanvasLayer
@export var order_ui : TextureRect
@export var order_ui_text : Label

# Variables for in-game clock.
@export var clock_timer : Timer
@export var clock_hours : Label
@export var clock_minutes : Label
@export var a_m_text : Label

var can_check_order : bool = false

var order_hidden : bool = true

# Variables for time.
var minutes: int = 0
var hours: int = 9


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Makes current day/money accurate to current day/money, even if player quits to main menu.
	day.text = str(Global.current_day) 
	money_text.text = str(Global.day_money) 
	
	# Hides menu layers.
	pause_layer.hide()
	order_check_layer.hide()
	
	clock_timer.start() # Starts timer for clock.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	const INTERACT_BIND := "interact"
	# Shows the order UI when it is clicked on.
	if can_check_order and Input.is_action_just_pressed(INTERACT_BIND):
			if order_hidden:
				order_check_layer.show()
				Global.can_move = false
				order_hidden = false
	
	# Closes order UI when player clicks out of it.
	elif not order_hidden and Input.is_action_just_pressed(INTERACT_BIND):
			order_check_layer.hide()
			Global.can_move = true
			order_hidden = true
	
	# Starts a new day by changing time back to 9:00am and day to new current day.
	if Global.new_day:
		const DAY_START_TIME : int = 9
		hours = DAY_START_TIME
		clock_hours.text = str(hours)
		clock_timer.start() # Starts timer for clock.
		day.text = str(Global.current_day)
		Global.new_day = false
	
	# Makes order UI text match customer order in customer dictionary.
	if Global.order_start:
		const ORDER_UI_KEY := "customer_order"
		order_ui_text.text = Global.customer_dictionaries[Global.customers[Global.customer_number]][ORDER_UI_KEY]
	
	# Makes order UI empty if no customer is currently available.
	else: 
		order_ui_text.text = ""
	
	# Adds money when order is given to customer.
	if Global.give_money:
		Global.money += round(Global.order_meter/3.3)
		money_text.text = str(Global.money)
		Global.give_money = false


# Pauses game when pause button is pressed
func _on_pause_button_pressed() -> void:
	_pause()


# Function to pause game when required.
func _pause():
	if Global.can_pause:
		get_tree().paused = true
		pause_layer.show() # Shows pause menu.


# Makes in game clock go up by 15 mins every time clock timer runs out.
func _on_timeout() -> void:
	minutes += 15
	clock_minutes.text = str(minutes)
	clock_timer.start()
	
	# Changes minutes to 0 and adds 1 hour when 60 minutes pass.
	const HOUR_END : int = 60
	if minutes == HOUR_END:
		minutes = 0
		hours += 1
		clock_minutes.text = str(minutes) + str(minutes)
		clock_hours.text = str(hours)
	
	# Changes AM text to PM when it is 12:00.
	const NOON : int = 12
	if hours == NOON:
		const PM := "pm"
		a_m_text.text = PM
	
	# Changes time to 1:00 rather than 13:00 when at 13 hours.
	const ONE_PM : int = 13
	if hours == ONE_PM:
		hours = 1
		clock_hours.text = str(hours)
		
	# Stops clock when its the end of the day.
	const DAY_END_TIME : int = 5
	if hours == DAY_END_TIME:
		clock_timer.stop()
		Global.day_end = true


# When order UI is hovered over, allows order to be checked
func _on_order_ui_mouse_entered() -> void:
	can_check_order = true
	const TWEEN_SCALE := Vector2(1.1,1.1)
	_order_tween(TWEEN_SCALE)


# When order UI is no longer being hovered over, stops allowing order to be checked
func _on_order_ui_mouse_exited() -> void:
	can_check_order = false
	const ORIGINAL_SCALE := Vector2(1,1)
	_order_tween(ORIGINAL_SCALE)


# Function for tweening order UI.
func _order_tween(scale_value):
	var tween := create_tween()
	const TWEEN_TIME : float = 0.1
	tween.tween_property(order_ui, "scale", scale_value, TWEEN_TIME)
