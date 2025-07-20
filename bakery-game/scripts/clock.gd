extends Control

var minutes: int = 0
var hours: int = 9

var PM : String = "pm"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$clock_container/clock_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
		
	if hours == 7:
		$".".stop()
		
	
		
		
