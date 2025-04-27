extends StaticBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")

var is_occupied: bool = false
var sit_right: bool = true  # false for left chairs
var servedFood = false
var finishedEating = false
var plateref = null

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.type = Callable(self, "_on_check")
	$ProgressBar.visible = false

func _on_check(): # cooking is they are holding food, it gets onto board, and itll return to their hands chopped
#	print(player.holdingObject)
	if servedFood and finishedEating:
		return true
	if not player.holdingObject:
		return false
#	print(player.has_node("Food"))
	for child in player.get_children():
		if child is Plate:
			return child.hasFood
	return false

func _on_interact():
	var hasFood = false
	var foodobj = null
	for child in player.get_children():
		if child is Plate and child.hasFood:
			hasFood = true
			foodobj = child
	if servedFood and finishedEating:
		finishedEating = false
		servedFood = false
		plateref.queue_free()
	elif not servedFood and hasFood:
		plateref = foodobj
		servedFood = true
		var pos = $Plate.global_position
		
		player.holdingObject = false
		player.remove_child(foodobj)
		add_child(foodobj)
		foodobj.global_position = pos
		foodobj.z_index = 1
		foodobj.scale = Vector2(1, 1)
		
		$ProgressBar.visible = true
		$Timer.start()

#	seat_character(player, sit_right)
	
# seating customers and players
func seat_character(character: Node2D, sit_right: bool):
	character.position = $TextureRect.global_position
	character.position.x += 18
	character.position.y -= 8

	if character.has_method("update_sit_animation"):
		character.update_sit_animation(sit_right)

	is_occupied = true # false for left chair
	
	#character.leave_waiting_line()  # Make sure the customer leaves the queue


func _on_timer_timeout():
	$Timer.stop()
	$ProgressBar.visible = false
	finishedEating = true
	plateref.clearFood()
	

