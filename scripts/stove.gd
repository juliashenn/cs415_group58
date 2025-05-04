extends StaticBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")
@onready var food = $Food
@onready var circle = $Circle

var SPEED: float = 1
var cooking = false
var foodpath = ""
var cookingdict = {
	"res://assets/ingredients/egg.png": "res://assets/ingredients/friedegg.png",
	"res://assets/ingredients/strawberry.png": "res://assets/ingredients/jam_strawberry.png",
	"res://assets/ingredients/milk.png": "res://assets/ingredients/pudding.png",
	"res://assets/ingredients/meat.png": "res://assets/ingredients/steak.png",
	"res://assets/ingredients/frenchfries.png": "res://assets/ingredients/fries.png",
	"res://assets/ingredients/bacon_raw.png": "res://assets/ingredients/bacon.png",
	"res://assets/ingredients/flour.png": "res://assets/ingredients/bread.png",
	"res://assets/ingredients/fish.png": "res://assets/ingredients/fish_cooked.png",
	"res://assets/ingredients/carrot.png": "res://assets/ingredients/carrot_cake.png"
}

var canchop = [
	"res://assets/ingredients/friedegg.png", 
	"res://assets/ingredients/bread.png"
]

#carrot -> carrot cake, corn -> popcorn

func _ready():
	$ProgressBar.visible = false
	$Timer.wait_time /= SPEED
	$Pan.visible = false
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.type = Callable(self, "_on_check")
	food.visible = false
	circle.visible = false
	
func _on_check(): # cooking is they are holding food, it gets onto stove, and itll return to their hands cooked
#	print(player.holdingObject)
	if not player.holdingObject:
		return false
#	print(player.has_node("Food"))
	for child in player.get_children():
		if child is Food:
			return child.cookable
	return false

func _on_interact():
#	print("Interaction triggered")
#	$CollisionShape2D.disabled = true
	var hasFood = false
	var foodobj = null
	for child in player.get_children():
		if child is Food:
			hasFood = true
			foodobj = child
	if cooking:
		$Timer.paused = false
	elif hasFood:
		foodpath = foodobj.getFood()
		player.holdingObject = false
		player.remove_child(foodobj)
		foodobj.queue_free()

		$Food.texture = load(foodpath)

#		circle.visible = true
#		$Pan.visible = true
#		$Food.visible = true
#	elif not player.holdingObject:
#	else:
		$ProgressBar.visible = true
		$Timer.start()
		cooking = true
		$Pan.visible = true
		$Food.visible = true
		player.position = $TextureRect.global_position
		player.position.y += 8
		player.position.x += 20
		player.update_animation("idleBack")
	
func _process(delta):
	if $ProgressBar.visible and player.position.distance_to(position) < 50:
		$ProgressBar.value = ($Timer.wait_time - $Timer.time_left)/$Timer.wait_time*100
	elif $ProgressBar.visible:
		$Timer.paused = true
#		$ProgressBar.visible = false
#		$Pan.visible = false
#		cooking = false
	

func _on_timer_timeout():
	$ProgressBar.visible = false
	$Pan.visible = false
	$Food.visible = false
	if cooking:
	
		var foodref = load("res://food.tscn").instantiate()

		foodref.setFood(cookingdict[foodpath])
		foodref.scale = Vector2(0.5, 0.5)
		foodref.name = "Food"
		if cookingdict[foodpath] in canchop:
			foodref.choppable = true
		player.add_child(foodref)
		player.updateObjectPosition(3)
		player.holdingObject = true
		cooking = false

func levelUp():
	SPEED += 1
	$Timer.wait_time /= SPEED
