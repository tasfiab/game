extends HSlider

@export var bus_name: String

var bus_index : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Sets bus index to index of sliders audio bus.
	bus_index = AudioServer.get_bus_index(bus_name)
	
	# Sets value of slider when volume is changed.
	value_changed.connect(_on_value_changed)
	
	# Makes initial volume same as volume of specific audio server
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))


# When volume slider is moved, changes value accordingly so sound is louder/quieter.
func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	
