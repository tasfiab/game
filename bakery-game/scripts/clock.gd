extends Control

@export var day : Label 

var can_check_order : bool = false

var order_hidden : bool = true

var minutes: int = 0
var hours: int = 9

var PM : String = "pm"

var money : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$pause_layer.hide()
	$CanvasLayer.hide()
	$clock_container/clock_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	day.text = str(Global.current_day)
	if can_check_order and Input.is_action_just_pressed("interact"):
			if order_hidden:
				$CanvasLayer.show()
				Global.can_move = false
				order_hidden = false
			
	elif not order_hidden and Input.is_action_just_pressed("interact"):
			$CanvasLayer.hide()
			Global.can_move = true
			order_hidden = true
				
	if Global.new_day:
		hours = 9
		$clock_container/hours.text = str(hours)
		$clock_container/clock_timer.start()
		Global.new_day = false
	
	if Global.order_start:
		$CanvasLayer/Label.text = Global.current_dialogue[Global.customers[Global.customer_number]]
	else: 
		$CanvasLayer/Label.text = ""
			
	if Global.money_given:
		money += round(Global.order_meter/4)
		$HBoxContainer/money.text = str(money)
		Global.money_given = false



func pause():
	get_tree().paused = true
	$pause_layer.show()


#Every time clock timer runs out, in game clock goes up by 15 mins
func _on_timeout() -> void:
	minutes += 15
	$clock_container/minutes.text = str(minutes)
	$clock_container/clock_timer.start()
	# If it is 60 minutes in game, minutes will reset to 0 and hours will go up by 1
	if minutes == 60:
		minutes = 0
		hours += 1
		$clock_container/minutes.text = str(minutes) + str(minutes)
		$clock_container/hours.text = str(hours)
		
	if hours == 12:
		$clock_container/a_m.text = PM
	
	if hours == 13:
		hours = 1
		$clock_container/hours.text = str(hours)
		
	if hours == 5:
		$clock_container/clock_timer.stop()
		Global.day_end = true
		Global.day_money = money
		if Global.current_day == 2:
			Global.game_end = true
	
		


func _on_pause_button_pressed() -> void:
	pause()


func _on_order_pressed() -> void:
	if order_hidden:
		$CanvasLayer.show()
		Global.can_move = false
		order_hidden = false


func _on_order_ui_mouse_entered() -> void:
	can_check_order = true


func _on_order_ui_mouse_exited() -> void:
	can_check_order = false
