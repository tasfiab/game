extends Node

var customer_number : int = 0

var making_minigame_start : bool = false
var oven_minigame_start : bool = false 
var toppings_minigame_start : bool = false

var dough_type : String
var flavour : String
var flavour_2 : String

var acquired_taste : bool
var simple : bool

var ingredient_chosen : bool = false
var dough_taste_added : bool 
var flavour_taste_added : bool
var flavour_2_taste_added : bool


var dough_chosen : bool = false
var flavour_chosen : bool = false
var flavour_2_chosen : bool = false

var dough_formed : bool = false
var done_button_pressed: bool = false
var baked_item_formed: bool = false
var is_baked : bool = false
var baked_item_finished : bool = false

var order_done : bool = false

var is_dragging = false

var range = RandomNumberGenerator.new()
var order_index = range.randi_range(0,7)


var order_meter : int = 0


var orders = ['strawberry bread', 'lemon bread', 'choco-strawberry bread', 'sour chocolate bread', 
		'strawberry cake', 'lemon cake', 'choco-strawberry cake', 'lemony chocolate cake']

var customers = ['Mini', 'Cat', 'Witch Siblings', 'Old lady']

var customer_dialogue = {
	customers[0] : load("res://addons/dialogue_manager/dialogue_scripts/dialogue.dialogue"),
	customers[1]: load("res://addons/dialogue_manager/dialogue_scripts/cat.dialogue"),
	customers[3]: load("res://addons/dialogue_manager/dialogue_scripts/old_lady.dialogue"),
	
}

var perfect_orders = {
	customers[0] : {
		'sweetness' : 5,
		'bitterness' : 0,
		dough_type : 'cake',
		acquired_taste : true,
	}
}


# Dictionary for ingredient combinations and their results
var doughs = {
	['bread','bread','bread'] : 'basic dough',
	
	['bread','vanilla','bread'] : 'vanilla bread dough',
	
	['bread', 'chocolate', 'bread'] : 'chocolate bread dough',
	
	['bread','bread','strawberry'] : 'strawberry bread dough',
	
	['bread','bread','lemon'] : 'lemon bread dough',
	
	['bread', 'vanilla', 'strawberry']: 'sweet strawberry dough',
	
	['bread', 'vanilla', 'lemon']: 'sweet lemon dough',
	
	['bread', 'chocolate', 'strawberry']: 'bitter strawberry bread dough',
	
	['bread', 'chocolate', 'lemon']: 'bitter bread dough',

	
	
	['cake','cake','cake'] : 'plain cake dough',
	
	['cake','vanilla','cake'] : 'vanilla cake dough',
	
	['cake','chocolate','cake'] : 'chocolate cake dough',
	
	['cake','cake','strawberry'] : 'strawberry cake dough',
	
	['cake','cake','lemon'] : 'lemon cake dough',
	
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

var ingredients = {
	'bread' : {
		'softness' : 3
	},
	'cake' : {
		'softness' : 1
	},
	'vanilla' : {
		'sweetness' : 2
	},
	'chocolate' : {
		'sweetness' : 2,
		'bitterness' : 1
	},
	'strawberry' : {
		'sweetness' : 3
	},
	'lemon' : {
		'sweetness' : 1,
		'bitterness' : 2
	}
}


var chosen_ingredients = [dough_type, flavour, flavour_2]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
