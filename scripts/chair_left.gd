extends placed_item

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")

var is_occupied: bool = false
var sit_right: bool = false  # false for left chairs
var servedFood = false
var finishedEating = false

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.type = Callable(self, "_on_check")
	$ProgressBar.visible = false
	$Plate.visible = false

#func _on_interact():
##	$CollisionShape2D.disabled = true
	#player.position = $TextureRect.global_position
	#player.position.x += 18
	#player.position.y -= 8
	#print("Player sitting at left chair: ", player.position)
#
	#player.update_sit_animation(false)
	#
#func _on_interact():
	#seat_character(player, sit_right)
	
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
func _process(delta):
	if $ProgressBar.visible:
		$ProgressBar.value = ($Timer.wait_time - $Timer.time_left)/$Timer.wait_time*100
		
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
		$Plate.visible = false
	elif not servedFood and hasFood:
		servedFood = true
		player.holdingObject = false
		$Plate.visible = true
		$Plate/Food.texture = load(foodobj.foodpath)
		$Plate/Food.visible = true
		foodobj.queue_free()

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
	
	#character.leave_waiting_line()
	

func _on_timer_timeout():
	$Timer.stop()
	$ProgressBar.visible = false
	finishedEating = true
	$Plate/Food.visible = false

	# Customer paying
	var coin = preload("res://Coin.tscn").instantiate()
	coin.global_position = $Plate.global_position + Vector2(10, 8)
	get_tree().current_scene.add_child(coin)

	# Tell customer to leave
	if seated_customer:
		seated_customer.leave_restaurant()
		seated_customer.assigned_seat = null
		seated_customer.in_queue = false
		seated_customer.queue_index = -1
