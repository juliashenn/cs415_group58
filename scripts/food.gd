extends Node2D


var food: String = "" 


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")

var SPEED: float = 1


func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.type = Callable(self, "_on_check")
#	var r = randi_range(0, 6)
#	food = foodoptions[r]
#	setFood(food)


func getFood():
	return food
	
func setFood(img):
	food = img
	$Sprite2D.texture = load(img)

func _on_interact():
	if not player.holdingObject:
		var world = get_parent()
		world.remove_child(self)
		player.add_child(self)
		scale = Vector2(0.5, 0.5)
		player.holdingObject = true
		player.updateObjectPosition(0)
	elif player.holdingObject and player.has_node("Plate"):
		var plate = player.get_node("Plate")
		plate.setFood(food)
		queue_free()
		
func _on_check():
	return player.holdingObject and player.has_node("Plate")
