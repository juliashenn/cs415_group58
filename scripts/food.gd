extends Node2D
class_name Food

var food: String = "" #string of the filepath of the food texture

#logic will be if the food its interacting with is in the array from this dict then
#the on check should return true for interacting and then one of the foods gets deleted
#and the other sets the image to the new guy, will need to have another dict of pairs of food that
#have key of the two foods and value of the new one.

var combodict = {
	"res://assets/ingredients/bread.png": 
		{
			"res://assets/ingredients/garlic.png": "res://assets/ingredients/garlicbread.png",
			"res://assets/ingredients/chocolate.png": "res://assets/ingredients/chocolate_bread.png",
			"res://assets/ingredients/bacon.png": "res://assets/ingredients/sandwich.png",
			"res://assets/ingredients/steak.png": "res://assets/ingredients/burger.png"
		},
	"res://assets/ingredients/bagel.png" :
		{
			"res://assets/ingredients/chocolate.png": "res://assets/ingredients/donut.png"
		},
	"res://assets/ingredients/flour.png" : 
		{
			"res://assets/ingredients/chocolate.png": "res://assets/ingredients/cookie.png",
			"res://assets/ingredients/strawberry.png": "res://assets/ingredients/strawberrycake.png",
			"res://assets/ingredients/carrot.png": "res://assets/ingredients/carrot_cake.png",
			"res://assets/ingredients/milk.png": "res://assets/ingredients/cake.png",
			"res://assets/ingredients/egg.png": "res://assets/ingredients/bread.png",
			"res://assets/ingredients/apple.png": "res://assets/ingredients/applepie.png"
		},
	"res://assets/ingredients/garlic.png" :
		{
			"res://assets/ingredients/bread.png": "res://assets/ingredients/garlicbread.png"
		},
	"res://assets/ingredients/chocolate.png" :
		{
			"res://assets/ingredients/bread.png": "res://assets/ingredients/chocolate_bread.png",
			"res://assets/ingredients/bagel.png": "res://assets/ingredients/donut.png",
			"res://assets/ingredients/flour.png": "res://assets/ingredients/cookie.png"
		},
	"res://assets/ingredients/bacon.png" :
		{
			"res://assets/ingredients/bread.png": "res://assets/ingredients/sandwich.png"
		},
	"res://assets/ingredients/strawberry.png" :
		{
			"res://assets/ingredients/flour.png" : "res://assets/ingredients/strawberrycake.png"
		},
	"res://assets/ingredients/carrot.png" :
		{
			"res://assets/ingredients/flour.png" : "res://assets/ingredients/carrot_cake.png"
		},
	"res://assets/ingredients/milk.png" :
		{
			"res://assets/ingredients/flour.png" : "res://assets/ingredients/cake.png"
		},
	"res://assets/ingredients/egg.png" :
		{
			"res://assets/ingredients/flour.png" : "res://assets/ingredients/bread.png"
		},
	"res://assets/ingredients/apple.png" :
		{
			"res://assets/ingredients/flour.png" : "res://assets/ingredients/applepie.png"
		},
	"res://assets/ingredients/steak.png" :
		{
			"res://assets/ingredients/bread.png" : "res://assets/ingredients/burger.png"
		}
}

@onready var interaction_area: InteractionArea = $InteractionArea
#@onready var coll: CollisionShape2D = $InteractionArea/CollisionShape2D
@onready var player = get_tree().get_first_node_in_group("player")

var SPEED: float = 1
var cookable = false
var choppable = false

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.type = Callable(self, "_on_check")
	food = $Sprite2D.texture.resource_path


func getFood():
	return food
	
func setFood(img):
	food = img
	$Sprite2D.texture = load(img)

func _on_interact():

	if not player.holdingObject:
#		print("food interaction")
		var world = get_parent()
		name = "Food"
		world.remove_child(self)
		player.add_child(self)
		scale = Vector2(0.5, 0.5)
		player.holdingObject = true
		player.updateObjectPosition(0)

	else :
		for child in player.get_children():
			if child is Plate:
				var plate = player.get_node("Plate")
				plate.setFood(food)
				queue_free()
				break
			if child is Food:
				if child.food in combodict.keys() and food in combodict[child.food].keys():
					child.setFood(combodict[child.food][food])
					queue_free()
					break
		
func _on_check():
	for child in player.get_children():
		if child is Plate:
			return true
		if child is Food:
			return child.food in combodict.keys() and food in combodict[child.food].keys()
	return false
