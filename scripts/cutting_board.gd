extends placed_item

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")

var SPEED: float = 1
var cutting = false
var foodpath = ""

var cuttingdict = {
	"res://assets/ingredients/meat.png": "res://assets/ingredients/bacon_raw.png",
	"res://assets/ingredients/cabbage.png" : "res://assets/ingredients/salad.png",
	"res://assets/ingredients/fish.png": "res://assets/ingredients/sushi.png",
	"res://assets/ingredients/friedegg.png": "res://assets/ingredients/egg_salad.png",
	"res://assets/ingredients/bread.png": "res://assets/ingredients/bread_sliced.png",
	"res://assets/ingredients/potato.png": "res://assets/ingredients/frenchfries.png"
}

var cancook = [
	"res://assets/ingredients/bacon_raw.png",
	"res://assets/ingredients/frenchfries.png"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$ProgressBar.visible = false
	$Timer.wait_time /= SPEED
	$Knife.visible = false
	$Food.visible = false
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.type = Callable(self, "_on_check")
	
	item_type = "cutting"
	super()
	
func _on_check(): # cooking is they are holding food, it gets onto board, and itll return to their hands chopped
#	print(player.holdingObject)
	if not player.holdingObject:
		return false
#	print(player.has_node("Food"))
	for child in player.get_children():
		if child is Food:
			return child.choppable
	return false

func _on_interact():
	var hasFood = false
	var foodobj = null
	for child in player.get_children():
		if child is Food:
			hasFood = true
			foodobj = child
	if cutting:
		$Timer.paused = false
	elif hasFood:
		cutting = true
		
		foodpath = foodobj.getFood()
		player.holdingObject = false
		player.remove_child(foodobj)
		foodobj.queue_free()

		$Food.texture = load(foodpath)
		
		$ProgressBar.visible = true
		$Timer.start()
		$Knife.visible = true
		$Food.visible = true
		#player.position = $TextureRect.global_position
		#player.position.y += 8
		#player.position.x += 20
		player.update_animation("idleBack")
	
func _process(delta):
	if $ProgressBar.visible and player.position.distance_to(position) < 50:
		$ProgressBar.value = ($Timer.wait_time - $Timer.time_left)/$Timer.wait_time*100
	elif $ProgressBar.visible:
		$Timer.paused = true
#	else:
#		$Timer.stop()
#		$ProgressBar.visible = false
#		$Knife.visible = false
	super(delta)

func _on_timer_timeout():
	$Timer.stop()
	$ProgressBar.visible = false
	$Knife.visible = false
	$Food.visible = false
	if cutting:
	
		var foodref = load("res://food.tscn").instantiate()

		foodref.setFood(cuttingdict[foodpath])
		foodref.scale = Vector2(0.5, 0.5)
		foodref.name = "Food"
		if cuttingdict[foodpath] in cancook:
			foodref.cookable = true
		player.add_child(foodref)
		player.updateObjectPosition(3)
		player.holdingObject = true
		cutting = false
