extends Node

signal tutorial
signal next_day

var tutorial_box_number : int = 0

#var game_end := false

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

var in_topping_minigame = false

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



# Array for all customers
var customers = ['Birthday girl', 'Cat', 'Witch', 'Old lady', 'Edgy guy', 'Pink cake girl',
 				'Lemon guy', 'Villager', 'Strange man', 'Water girl', 'Old Man', 'Witch2']

# Dictionary storing all information to do with customers
var customer_dictionaries = {
	customers[0] : {
		'customer_dialogue' : load("res://addons/dialogue_manager/dialogue_scripts/birthday_girl.dialogue"),
		'customer_sprite' : preload("res://scenes/customer.tscn"),
		'customer_order' : '- cake
							- cute and sweet',
		'perfect_order' :  {
			'sweetness' : 6,
			'bitterness' : 0,
			dough_type : 'cake',
			'shape': 'circle',
			'best topping': 'sprinkles',
			'ok topping': 'stardust'
			}
	},
	customers[1] : {
		'customer_dialogue' : load("res://addons/dialogue_manager/dialogue_scripts/cat.dialogue"),
		'customer_sprite' : preload("res://scenes/cat.tscn"),
		'customer_order' :  '- bread
							 - simple, no funny business!!',
		'perfect_order' :  {
			'sweetness' : 0,
			'bitterness' : 0,
			dough_type : 'bread',
			'shape': 'loaf',
			}
	},
	customers[2] : {
		'customer_dialogue' : load("res://addons/dialogue_manager/dialogue_scripts/witch.dialogue"),
		'customer_sprite' : preload("res://scenes/witch.tscn"),
		'customer_order' :  '- cake
							 - PURELY white (vanilla?)
							 - stardust',
		'perfect_order' :  {
			'sweetness' : 4,
			'bitterness': 0,
			dough_type: 'cake',
			'shape': 'square',
			'best topping': 'stardust',
			'ok topping': 'vanilla_icing'
			}
	},
	customers[3] : {
		'customer_dialogue' : load("res://addons/dialogue_manager/dialogue_scripts/old_lady.dialogue"),
		'customer_sprite' : preload("res://scenes/old_fairy.tscn"),
		'customer_order' :  '- something nostalgic... 
							 - a strawberry touch',
		'perfect_order' :  {
			'sweetness' : 3,
			'bitterness': 0,
			dough_type: 'bread',
			'shape': 'loaf',
			'best topping': 'strawberry',
			'ok topping': 'choco_chips'
			}
	},
	customers[4] : {
		'customer_dialogue' : load("res://addons/dialogue_manager/dialogue_scripts/edgy_guy.dialogue"),
		'customer_sprite' : preload("res://scenes/edgy_guy.tscn"),
		'customer_order' : '- bitter and dark, like their soul?
							- bread',
		'perfect_order' :  {
			'sweetness' : 1,
			'bitterness' : 2,
			dough_type: 'bread',
			'shape' : 'loaf'
			}
	},
	customers[5] : {
		'customer_dialogue' : load("res://addons/dialogue_manager/dialogue_scripts/pink_cake_girl.dialogue"),
		'customer_sprite' : preload("res://scenes/pink_cake_girl.tscn"),
		'customer_order' : '- cake
							- pink (strawberrys?)',
		'perfect_order' :  {
			'sweetness' : 5,
			'bitterness' : 0,
			dough_type: 'cake',
			'shape' : 'square',
			'best topping' : 'strawberry',
			'ok topping' : 'vanilla_icing'
			}
	},
	customers[6] : {
		'customer_dialogue' : load("res://addons/dialogue_manager/dialogue_scripts/lemon_guy.dialogue"),
		'customer_sprite' : preload("res://scenes/lemon_guy.tscn"),
		'customer_order' : '- LEMON >:)
							- cake
							- vanilla icing',
		'perfect_order' :  {
			'sweetness' : 3,
			'bitterness' : 3,
			dough_type: 'cake',
			'shape' : 'circle',
			'best topping' : 'vanilla_icing',
			'ok topping' : 'sprinkles'
			}
	},
	customers[7] : {
		'customer_dialogue' : load("res://addons/dialogue_manager/dialogue_scripts/villager.dialogue"),
		'customer_sprite' : preload("res://scenes/villager.tscn"),
		'customer_order' : '- lemon
							- croissant',
		'perfect_order' :  {
			'sweetness' : 1,
			'bitterness' : 3,
			dough_type: 'bread',
			'shape' : 'croissant'
			}
	},
	customers[8] : {
		'customer_dialogue' : load("res://addons/dialogue_manager/dialogue_scripts/strange_man.dialogue"),
		'customer_sprite' : preload("res://scenes/strange_man.tscn"),
		'customer_order' : '- something strange
							- what is an unusual flavour combination??',
		'perfect_order' :  {
			'sweetness' : 3,
			'bitterness' : 5,
			dough_type: 'cake',
			'shape' : 'square',
			'best topping' : 'strawberry',
			'ok topping' : 'sprinkles'
			}
	},
	customers[9] : {
		'customer_dialogue' : load("res://addons/dialogue_manager/dialogue_scripts/water_girl.dialogue"),
		'customer_sprite' : preload("res://scenes/water_girl.tscn"),
		'customer_order' : '- vanilla
							- croissant
							- strawberry top',
		'perfect_order' :  {
			'sweetness' : 2,
			'bitterness' : 0,
			dough_type : 'bread',
			'shape' : 'croissant',
			'best topping' : 'strawberry',
			'ok topping' : 'choco_icing'
			}
	},
	customers[10] : {
		'customer_dialogue' : load("res://addons/dialogue_manager/dialogue_scripts/old_man.dialogue"),
		'customer_sprite' : preload("res://scenes/old_man.tscn"),
		'customer_order' : '- magical ~
					 		- strawberry and chocolate
					 		- cake',
		'perfect_order' :  {
			'sweetness' : 5,
			'bitterness' : 2,
			dough_type : 'cake',
			'shape' : 'circle',
			'best topping' : 'stardust',
			'ok topping' : 'choco_icing'
			}
	},
	customers[11] : {
		'customer_dialogue' : load("res://addons/dialogue_manager/dialogue_scripts/witch_2.dialogue"),
		'customer_sprite' : preload("res://scenes/witch_sister.tscn"),
		'customer_order' : '- chocolate
					 		- cake
					 		- circle
					 		- stardust',
		'perfect_order' :  {
			'sweetness' : 3,
			'bitterness': 2,
			dough_type : 'cake',
			'shape' : 'circle',
			'best topping' : 'stardust',
			'ok topping' : 'choco_chips'
			}
	},
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
	
	'basic dough': preload("res://assets/dough_plain.webp"),
	
	'vanilla bread dough': preload("res://assets/dough_vanilla.webp"),
	
	'chocolate bread dough' : preload("res://assets/dough_choco.webp"),
	
	'strawberry bread dough' : preload("res://assets/dough_strawberry.webp"),
	
	'lemon bread dough' : preload("res://assets/dough_lemon.webp"),
	
	'vanilla strawberry dough' : preload("res://assets/dough_strawberry.webp"),
	
	'sweet lemon dough' : preload("res://assets/dough_lemon.webp"),
	
	'bitter strawberry bread dough': preload("res://assets/dough_strawberry.webp"),
	
	'strange bread dough': preload("res://assets/dough_lemon.webp"),
	
	
	'plain cake dough' : preload("res://assets/batter_vanilla.webp"),
	
	'vanilla cake dough' : preload("res://assets/batter_vanilla.webp"),
	
	'chocolate cake dough' : preload("res://assets/batter_choco.webp"),
	
	'strawberry cake dough' : preload("res://assets/batter_strawberry.webp"),
	
	'lemon cake dough' : preload("res://assets/batter_lemon.webp"),
	
	'strawberry vanilla cake dough' : preload("res://assets/batter_strawberry.webp"),

	'lemon vanilla cake dough' : preload("res://assets/batter_lemon.webp"),
	
	'fruity chocolate cake dough': preload("res://assets/batter_strawberry.webp"),
	
	'strange cake dough' : preload("res://assets/batter_lemon.webp"),
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
	
	['strawberry cake dough', 'circle'] : preload("res://assets/strawberry_cake_circle.webp"),
	
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
var order_item = []
