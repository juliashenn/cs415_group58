extends placed_item

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")

var is_occupied: bool = false
var sit_right: bool = false  # false for left chairs
var servedFood = false
var finishedEating = false
var seated_customer: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.type = Callable(self, "_on_check")
	$ProgressBar.visible = false
	$Plate.visible = false
	
	super()
	item_type = "chair3l"

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
	super(delta)
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
		seated_customer = null
		is_occupied = false
		#if coin.is_coin_collected == true:
		call_deferred("_check_waiting_line")
	elif not servedFood and hasFood:
		servedFood = true
		player.holdingObject = false
		$Plate.visible = true
		$Plate/Food.texture = load(foodobj.foodpath)
		$Plate/Food.visible = true
		foodobj.queue_free()

		$ProgressBar.visible = true
		$Timer.start()

		if seated_customer and seated_customer.has_node("FoodOrderSprite"):
			seated_customer.get_node("FoodOrderSprite").visible = false


func _check_waiting_line():
	var waiting_customers = get_tree().get_nodes_in_group("waiting_customers")
	waiting_customers.sort_custom(Callable(self, "_compare_queue_index"))
	for customer in waiting_customers:
		customer.check_if_seat_open()

func _compare_queue_index(a, b):
	return a.queue_index > b.queue_index

#func shift_waiting_line():
	#var customers = get_tree().get_nodes_in_group("waiting_customers")
	#customers.sort_custom(Callable(self, "_compare_queue_index"))  # sort oldest → newest
	#
	#for i in range(customers.size()):
		#customers[i].queue_index = i
		#customers[i].move_to_line_position(i)
		#


# seating customers and players
func seat_character(character: Node2D, sit_right: bool):
	
	character.position = $TextureRect.global_position
	character.position.x += 18
	character.position.y -= 8

	if character.has_method("update_sit_animation"):
		character.update_sit_animation(sit_right)
	is_occupied = true
	seated_customer = character
	#character.leave_waiting_line()  # Make sure the customer leaves the queue


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
