extends Node2D


var customer_scenes = [
	preload("res://customer_amelia.tscn"),
	preload("res://customer_adam.tscn"),
	preload("res://customer_alex.tscn")
]

@export var spawn_positions: Array[Vector2] = [Vector2(100, 100)]
@export var seat_container_path: NodePath

func _ready():
	randomize()
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)

func _on_spawn_timer_timeout():
	# Before spawning, check how many customers are already waiting
	var waiting_customers = get_tree().get_nodes_in_group("waiting_customers")
	
	if waiting_customers.size() >= 5:
#		print("Waiting line full! Not spawning new customer.")
		return  # Don't spawn if 5 or more customers are waiting

	spawn_random_customer()

func spawn_random_customer():
	# loads and instantiates a random customer scene
	var scene = customer_scenes[randi() % customer_scenes.size()]
	var customer = scene.instantiate()

	#print("Seat container path is: ", seat_container_path)
	#print("Customer instance type: ", customer)
	#print("Customer has seat_container_path property: ", "seat_container_path" in customer)
	customer.seat_container_path = seat_container_path
	customer.first_line_position = Vector2(100, 100)
	
	customer.position = spawn_positions[randi() % spawn_positions.size()]
	get_parent().add_child(customer)
