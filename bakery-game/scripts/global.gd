extends Node

signal help
signal next_day

var tutorial_box_number : int = 0

var game_end := false

var customer_number : int = 0

var current_day : int = 1
var day_end : bool = false
var new_day : bool = false

var day_money : int
var money : int = 0


var can_move : bool = true

var order_start : bool = false

var making_minigame_start : bool = false
var oven_minigame_start : bool = false 
var toppings_minigame_start : bool = false

var dough_type : String
var flavour : String
var flavour_2 : String
var shape : String

var ingredient_chosen : bool = false
var dough_taste_added : bool 
var flavour_taste_added : bool
var flavour_2_taste_added : bool


var dough_chosen : bool = false
var flavour_chosen : bool = false
var flavour_2_chosen : bool = false

var topping_number : int = 0
var max_toppings : bool = false

var dough_formed : bool = false
var done_button_pressed: bool = false
var baked_item_formed: bool = false
var is_baked : bool = false
var baked_item_finished : bool = false

var order_done : bool = false

var is_dragging = false

var in_topping_minigame = false

var range = RandomNumberGenerator.new()
var order_index = range.randi_range(0,7)


var order_meter : int = 0

var money_given : bool = false

# Dough strings
var BASIC_DOUGH : String = 'basic dough'
var VANILLA_BREAD_DOUGH : String = 'vanilla bread dough'
var CHOCOLATE_BREAD_DOUGH : String = 'chocolate bread dough'
var STRAWBERRY_BREAD_DOUGH : String = 'strawberry bread dough'
var LEMON_BREAD_DOUGH : String = 'lemon bread dough'
var VANILLA_STRAWBERRY_DOUGH : String = 'vanilla strawberry dough'
var CHOCO_STRAWBERRY_DOUGH : String = 'bitter strawberry bread dough'
var CHOCO_LEMON_DOUGH : String = 'strange bread dough'


var orders = ['strawberry bread', 'lemon bread', 'choco-strawberry bread', 'sour chocolate bread', 
		'strawberry cake', 'lemon cake', 'choco-strawberry cake', 'lemony chocolate cake']

var customers = ['Mini', 'Cat', 'Witch', 'Old lady', 'random_1', 'random_2', 'random_3', 'random_4', 'random_5', 'random_6', 'Strange Man', 'Witch_2']

var customer_dialogue = {
	customers[0] : load("res://addons/dialogue_manager/dialogue_scripts/dialogue.dialogue"),
	customers[1] : load("res://addons/dialogue_manager/dialogue_scripts/cat.dialogue"),
	customers[2] : load("res://addons/dialogue_manager/dialogue_scripts/witch_siblings.dialogue"),
	customers[3] : load("res://addons/dialogue_manager/dialogue_scripts/old_lady.dialogue"),
	customers[4] : load("res://addons/dialogue_manager/dialogue_scripts/random_1.dialogue"),
	customers[5] : load("res://addons/dialogue_manager/dialogue_scripts/random_2.dialogue"),
	customers[6] : load("res://addons/dialogue_manager/dialogue_scripts/random_3.dialogue"),
	customers[7] : load("res://addons/dialogue_manager/dialogue_scripts/random_4.dialogue"),
	customers[8] : load("res://addons/dialogue_manager/dialogue_scripts/random_5.dialogue"),
	customers[9] : load("res://addons/dialogue_manager/dialogue_scripts/random_6.dialogue"),
	customers[10] : load("res://addons/dialogue_manager/dialogue_scripts/strange_man.dialogue"),
	customers[11] : load("res://addons/dialogue_manager/dialogue_scripts/witch_2.dialogue"),
}

var current_dialogue = {
	customers[0] : '- cake
					- cute and sweet',
	customers[1] : '- bread
					- simple, no funny business!!',
	customers[2] : '- cake
					- PURELY white (vanilla?)
					- stardust',
	customers[3] : '- something nostalgic... 
					- a strawberry touch',
	customers[4] : '- bitter - like their soul hehe
					- bread' ,
	customers[5] : '- cake
					- pink (strawberrys?)',
	customers[6] : '- LEMON >:)
					- cake
					- vanilla icing',
	customers[7] : '- lemon
					- croissant',
	customers[8] : '- something strange
					- go wild I guess???',
	customers[9] : '- vanilla
					- croissant
					- strawberry top',
	customers[10] : '- magical (?) 
					 - strawberry and chocolate
					 - cake',
	customers[11] : '- chocolate
					 - cake
					 - circle
					 - stardust',
}


var perfect_orders = {
	customers[0] : {
		'sweetness' : 6,
		'bitterness' : 0,
		dough_type : 'cake',
		'shape': 'circle',
		'best topping': 'sprinkles',
		'ok topping': 'stardust'
	},
	customers[1] : {
		'sweetness' : 0,
		'bitterness' : 0,
		dough_type : 'bread',
		'shape': 'loaf',
	},
	customers[2] : {
		'sweetness' : 4,
		'bitterness': 0,
		dough_type: 'cake',
		'shape': 'square',
		'best topping': 'stardust',
		'ok topping': 'vanilla_icing'
	},
	customers[3] : {
		'sweetness' : 3,
		'bitterness': 0,
		dough_type: 'bread',
		'shape': 'loaf',
		'best topping': 'strawberry',
		'ok topping': 'choco_chips'
	},
		
	customers[4] : {
		'sweetness' : 1,
		'bitterness' : 2,
		dough_type: 'bread',
		'shape' : 'loaf',
	},
	customers[5] : {
		'sweetness' : 5,
		'bitterness' : 0,
		dough_type: 'cake',
		'shape' : 'square',
		'best topping' : 'strawberry',
		'ok topping' : 'vanilla_icing'
	},
	customers[6]: {
		'sweetness' : 3,
		'bitterness' : 3,
		dough_type: 'cake',
		'shape' : 'circle',
		'best topping' : 'vanilla_icing',
		'ok topping' : 'sprinkles'
	},
	customers[7] : {
		'sweetness' : 1,
		'bitterness' : 3,
		dough_type: 'bread',
		'shape' : 'croissant',
	},
	customers[8] : {
		'sweetness' : 3,
		'bitterness' : 5,
		dough_type: 'cake',
		'shape' : 'square',
		'best topping' : 'strawberry',
		'ok topping' : 'sprinkles'
	},
	customers[9] : {
		'sweetness' : 2,
		'bitterness' : 0,
		dough_type : 'bread',
		'shape' : 'croissant',
		'best topping' : 'strawberry',
		'ok topping' : 'choco_icing'
	},
	customers[10] : {
		'sweetness' : 5,
		'bitterness' : 2,
		dough_type : 'cake',
		'shape' : 'circle',
		'best topping' : 'stardust',
		'ok topping' : 'choco_icing'
	},
	customers[11] : {
		'sweetness' : 3,
		'bitterness': 2,
		dough_type : 'cake',
		'shape' : 'circle',
		'best topping' : 'stardust',
		'ok topping' : 'choco_chips'
	}
}


# Dictionary for ingredient combinations and their results
var doughs = {
	['bread','bread','bread'] : 'basic dough',
	
	['bread','vanilla','bread'] : 'vanilla bread dough',
	
	['bread', 'chocolate', 'bread'] : 'chocolate bread dough',
	
	['bread','bread','strawberry'] : 'strawberry bread dough',
	
	['bread','bread','lemon'] : 'lemon bread dough',
	
	['bread', 'vanilla', 'strawberry']: 'vanilla strawberry dough',
	
	['bread', 'vanilla', 'lemon']: 'sweet lemon dough',
	
	['bread', 'chocolate', 'strawberry']: 'bitter strawberry bread dough',
	
	['bread', 'chocolate', 'lemon']: 'strange bread dough',

	
	
	['cake','cake','cake'] : 'plain cake dough',
	
	['cake','vanilla','cake'] : 'vanilla cake dough',
	
	['cake','chocolate','cake'] : 'chocolate cake dough',
	
	['cake','cake','strawberry'] : 'strawberry cake dough',
	
	['cake','cake','lemon'] : 'lemon cake dough',
	
	['cake', 'vanilla', 'strawberry']: 'strawberry vanilla cake dough',
	
	['cake', 'vanilla', 'lemon']: 'lemon vanilla cake dough',
	
	['cake', 'chocolate', 'strawberry']: 'fruity chocolate cake dough',
	
	['cake', 'chocolate', 'lemon']: 'strange cake dough',

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

var item_sprites = {
	
	['basic dough', 'loaf']: preload("res://assets/plain_loaf.webp"),
	
	['vanilla bread dough','loaf'] : preload("res://assets/vanilla_loaf.webp"),
	
	['chocolate bread dough', 'loaf'] : preload("res://assets/choco_loaf.webp"),
	
	['strawberry bread dough', 'loaf'] : preload("res://assets/strawberry_loaf.webp"),
	
	['lemon bread dough', 'loaf'] : preload("res://assets/lemon_loaf.webp"),
	
	['vanilla strawberry dough', 'loaf'] : preload("res://assets/strawberry_loaf.webp"),
	
	['sweet lemon dough', 'loaf'] : preload("res://assets/lemon_loaf.webp"),
	
	['bitter strawberry bread dough', 'loaf']: preload("res://assets/strawberry_loaf.webp"),
	
	['strange bread dough', 'loaf'] : preload("res://assets/lemon_loaf.webp"),
	
	
	['basic dough', 'croissant']: preload("res://assets/plain_croissant.webp"),
	
	['vanilla bread dough','croissant'] : preload("res://assets/vanilla_croissant.webp"),
	
	['chocolate bread dough', 'croissant'] : preload("res://assets/choco_croissant.webp"),
	
	['strawberry bread dough', 'croissant'] : preload("res://assets/strawberry_croissant.webp"),
	
	['lemon bread dough', 'croissant'] : preload("res://assets/lemon_croissant.webp"),
	
	['vanilla strawberry dough', 'croissant'] : preload("res://assets/strawberry_croissant.webp"),
	
	['sweet lemon dough', 'croissant'] : preload("res://assets/lemon_croissant.webp"),
	
	['bitter strawberry bread dough', 'croissant']: preload("res://assets/strawberry_croissant.webp"),
	
	['strange bread dough', 'croissant'] : preload("res://assets/lemon_croissant.webp"),
	
	
	['plain cake dough', 'square'] : preload("res://assets/vanilla_square_cake.webp"),
	
	['vanilla cake dough', 'square'] : preload("res://assets/vanilla_square_cake.webp"),
	
	['chocolate cake dough', 'square'] : preload("res://assets/chocolate_square_cake.webp"),
	
	['strawberry cake dough', 'square'] : preload("res://assets/strawberry_square_cake.webp"),
	
	['lemon cake dough', 'square'] : preload("res://assets/lemon_square_cake.webp"),
	
	['strawberry vanilla cake dough', 'square'] : preload("res://assets/strawberry_vanilla_square_cake.webp"),

	['lemon vanilla cake dough', 'square'] : preload("res://assets/lemon_vanilla_square_cake.webp"),
	
	['fruity chocolate cake dough', 'square'] : preload("res://assets/strawberry_choco_square_cake.webp"),
	
	['strange cake dough', 'square'] : preload("res://assets/lemon_choco_square_cake.webp"),
	


	['plain cake dough', 'circle'] : preload("res://assets/vanilla_cake_circle.webp"),
	
	['vanilla cake dough', 'circle'] : preload("res://assets/vanilla_cake_circle.webp"),
	
	['chocolate cake dough', 'circle'] : preload("res://assets/choco_cake_circle.webp"),
	
	['strawberry cake dough', 'circle'] : preload("res://assets/strawberry_circle.webp"),
	
	['lemon cake dough', 'circle'] : preload("res://assets/lemon_cake_circle.webp"),
	
	['strawberry vanilla cake dough', 'circle'] : preload("res://assets/strawberry_vanilla_circle.webp"),

	['lemon vanilla cake dough', 'circle'] : preload("res://assets/lemon_vanilla_circle.webp"),
	
	['fruity chocolate cake dough', 'circle'] : preload("res://assets/strawberry_choco_circle.webp"),
	
	['strange cake dough', 'circle'] : preload("res://assets/lemon_choco_circle.webp"),
	
}

var ingredients = {
	'bread' : {
	},
	'cake' : {
		'sweetness' : 1,
	},
	'vanilla' : {
		'sweetness' : 2
	},
	'chocolate' : {
		'sweetness' : 1,
		'bitterness' : 2
	},
	'strawberry' : {
		'sweetness' : 3
	},
	'lemon' : {
		'sweetness' : 1,
		'bitterness' : 3
	}
}


var chosen_ingredients = [dough_type, flavour, flavour_2]
var type = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
