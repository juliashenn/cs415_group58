extends Node2D
class_name Food

var food: String = "" 


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

	elif player.holdingObject and player.has_node("Plate"):
		var plate = player.get_node("Plate")
		plate.setFood(food)
		queue_free()
		
func _on_check():
	if player.holdingObject and player.has_node("Plate"):
		return true
	if player.holdingObject and player.has_node("Food") and player.position.distance_to(get_tree().get_first_node_in_group("stove").global_position) < 100:
		return true
	return false
