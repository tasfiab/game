extends Timer

var minutes: int = 0
var hours: int = 9

var PM : String = "pm"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#Every time clock timer runs out, in game clock goes up by 15 mins
func _on_timeout() -> void:
	minutes += 15
	$"../minutes".text = str(minutes)
	$".".start()
	# If it is 60 minutes in game, minutes will reset to 0 and hours will go up by 1
	if minutes == 60:
		minutes = 0
		hours += 1
		$"../minutes".text = str(minutes) + str(minutes)
		$"../hours".text = str(hours)
		
	if hours == 12:
		$"../a_m".text = PM
	
	if hours == 13:
		hours = 1
		$"../hours".text = str(hours)
		
	if hours == 7:
		$".".stop()
		
	
		
		
