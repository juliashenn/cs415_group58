extends Node2D
class_name Plate

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var coll: CollisionShape2D = $InteractionArea/CollisionShape2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var food = $Food

var foodpath = ""
var hasFood = false
# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.type = Callable(self, "_on_check")
	food.visible = false

func _on_interact():
#	print("plate interaction")
	if player.holdingObject and player.has_node("Food") and not hasFood:
		var f = player.get_node("Food")
		setFood(f.food)
		player.holdingObject = false
		position = f.position
		f.queue_free()
		
	if not player.holdingObject:
		var world = get_parent()
		var pos = position
		world.remove_child(self)
		player.add_child(self)
		scale = Vector2(0.5, 0.5)
		player.holdingObject = true
		player.updateObjectPosition(0)

func getFood():
	if hasFood:
		return foodpath

func setFood(img):
	hasFood = true
	food.visible = true
	food.texture = load(img)
	foodpath = img
	
func clearFood():
	hasFood = false
	food.visible = false
	

func _on_check():
#	return player.holdingObject and player.has_node("Food")
	if not player.holdingObject:
		return false

	for child in player.get_children():
		if child is Food:
			return true
	return false
