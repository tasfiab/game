extends Node

var oven_minigame_start : bool = false
var making_minigame_start : bool = false

var dough_type : String
var flavour : String
var flavour_2 : String

var dough_formed : bool = false

var range = RandomNumberGenerator.new()
var order_index = range.randi_range(0,7)


var doughs = {
	['bread', 'vanilla', 'strawberry']: 'strawberry bread dough',
	['bread', 'vanilla', 'lemon']: 'lemon bread dough',
	['bread', 'chocolate', 'strawberry']: 'choco-strawberry bread dough',
	['bread', 'chocolate', 'lemon']: 'sour chocoalate bread dough',
	['cake', 'vanilla', 'strawberry']: 'strawberry cake dough',
	['cake', 'vanilla', 'lemon']: 'lemon cake dough',
	['cake', 'chocolate', 'strawberry']: 'choco-strawberry cake dough',
	['cake', 'chocolate', 'lemon']: 'lemony chocolate cake dough',
	}

var dough_sprites = {
	'strawberry bread dough': preload("res://assets/strawberry_cake_dough.png"),
	'lemon bread dough': preload("res://assets/lemony_bread_dough.png"),
	'choco-strawberry bread dough': preload("res://assets/choco_strawberry_cake_dough.png"),
	'sour chocolate bread dough':preload("res://assets/lemon_chocolate_bread_dough.png"),
	
	'strawberry cake dough': preload("res://assets/strawberry_cake_dough.png"),
	'lemon cake dough': preload("res://assets/lemony_bread_dough.png"),
	'choco-strawberry cake dough': preload("res://assets/choco_strawberry_cake_dough.png"),
	'lemony chocolate cake dough':preload("res://assets/lemon_chocolate_bread_dough.png"),
	
	
}

var chosen_ingredients = [dough_type, flavour, flavour_2]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
