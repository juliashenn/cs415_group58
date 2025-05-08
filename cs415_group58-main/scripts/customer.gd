extends CharacterBody2D

@onready var agent = $NavigationAgent2D
@onready var sprite = $Sprite

@export var seat_container_path: NodePath
@export var waiting_line_positions: Array[Vector2] = [] # List of positions where customers wait if no chairs are open
@export var first_line_position: Vector2 = Vector2(100, 100)
@export var exit_position: Vector2 = Vector2(98,43)
@export var spacing: float = 32.0
@export var max_waiting_customers: int = 5

# Food ordering
@onready var food_order_sprite = $FoodOrderSprite
var order_name := ""
var menu = [
	"res://assets/ingredients/applepie.png", "res://assets/ingredients/burger.png",
	"res://assets/ingredients/cake.png", "res://assets/ingredients/chocolate_bread.png",
	"res://assets/ingredients/cookie.png", "res://assets/ingredients/donut.png",
	"res://assets/ingredients/egg_salad.png", "res://assets/ingredients/fish_cooked.png",
	"res://assets/ingredients/fries.png", "res://assets/ingredients/friedegg.png",
	"res://assets/ingredients/garlicbread.png", "res://assets/ingredients/popcorn.png",
	"res://assets/ingredients/sandwich.png", "res://assets/ingredients/steak.png",
	"res://assets/ingredients/strawberrycake.png", "res://assets/ingredients/sushi.png"
]

# State variables
var target_position: Vector2  # Where the customer is going
var assigned_seat: Node2D = null  # The chair assigned to this customer
var in_queue: bool = false  # True if waiting in line
var queue_index: int = -1  # Their position in the waiting line

const SPEED = 100.0

func _ready():
	# Food ordering
	order_name = menu[randi() % menu.size()]
	food_order_sprite.texture = load(order_name)
	food_order_sprite.visible = true

	# Generate the waiting line positions (e.g., stacked vertically)
	for i in range(max_waiting_customers):
		waiting_line_positions.append(first_line_position + Vector2(0, i * spacing))
	# Start in idle animation and look for a seat
	sprite.play("idleFront")
	try_to_find_seat()

func _process(delta):
	if in_queue:
		return  # If in line, don't move

	# If destination reached and seat assigned, sit down
	if agent.is_navigation_finished() and assigned_seat != null:
		assigned_seat.call("seat_character", self, assigned_seat.sit_right)
		return

	# Move toward the next point on the path
	var next_position = agent.get_next_path_position()
	var direction = (next_position - global_position).normalized()
	velocity = direction * SPEED  # Adjust movement speed as needed
	move_and_slide()

	play_run_animation(direction)

# Try to find the closest unoccupied seat
func try_to_find_seat():
	var container = get_node(seat_container_path)
	var closest_seat: Node2D = null
	var min_dist = INF
#	print("Seat container path is: ", seat_container_path)
#	print("Checking available seats in: ", seat_container_path)


	#for table in container.get_children():
		#for chair in table.get_children():
			#if chair.has_method("get") and chair.get("is_occupied") == false:
##				print("Table: ", table.name, " | Chair: ", chair.name, " | Occupied: ", chair.is_occupied)
				#var dist = global_position.distance_to(chair.global_position)
				#if dist < min_dist:
					#min_dist = dist
					#closest_seat = chair
	
	for chair in container.get_children():
		if chair.has_method("get") and chair.get("is_occupied") == false:
#				print("Table: ", table.name, " | Chair: ", chair.name, " | Occupied: ", chair.is_occupied)
			var dist = global_position.distance_to(chair.global_position)
			if dist < min_dist:
				min_dist = dist
				closest_seat = chair
					
	if closest_seat:
#		print("closest_Seat")
		assigned_seat = closest_seat
		assigned_seat.is_occupied = true
		target_position = assigned_seat.global_position
		agent.target_position = target_position
	else:
#		print("No seats available → waiting in line")
		join_waiting_line()

# Put this customer into the waiting line
func join_waiting_line():
	in_queue = true
	queue_index = get_tree().get_nodes_in_group("waiting_customers").size()
	add_to_group("waiting_customers")

	if queue_index < waiting_line_positions.size():
		global_position = waiting_line_positions[queue_index]
	else:
		queue_index = -1  # Overflow

# Try to grab a seat if one frees up
func check_if_seat_open():
	if not in_queue:
		return

	var container = get_node(seat_container_path)
	for chair in container.get_children():
		if chair.has_method("get") and chair.get("is_occupied") == false:
				leave_waiting_line()
				assigned_seat = chair
				chair.is_occupied = true
				target_position = chair.global_position
				agent.target_position = target_position
				in_queue = false
				#call_deferred("shift_waiting_line")
				return

# Remove this customer from the line
func leave_waiting_line():
	remove_from_group("waiting_customers")
	queue_index = -1
	

# Customer leaving a seat
func leave_restaurant():
	agent.target_position = exit_position
	await agent.navigation_finished
	queue_free()


# Animate based on direction of movement
func play_run_animation(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		sprite.play("runRight" if dir.x > 0 else "runLeft")
	else:
		sprite.play("runFront" if dir.y > 0 else "runBack")
		
func update_sit_animation(direction: bool):
	if direction:
		sprite.play("sitRight")
	else:
		sprite.play("sitLeft")
