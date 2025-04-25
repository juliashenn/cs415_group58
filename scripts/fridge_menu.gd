extends Control


@onready var player = get_tree().get_first_node_in_group("player")
@onready var fridge = get_tree().get_first_node_in_group("fridge")

const FoodScene = preload("res://food.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for button in get_tree().get_nodes_in_group("foodButton"):
		button.pressed.connect(_on_food_button_pressed.bind(button))
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	visible = false
	fridge.close()
#	get_parent().get_parent().close()


func _on_food_button_pressed(button):
	var foodtext = button.texture_normal
	var foodref = load("res://food.tscn").instantiate()
	
	foodref.setFood(foodtext.resource_path)
	foodref.scale = Vector2(0.5, 0.5)
	foodref.name = "Food"
	player.add_child(foodref)
	player.updateObjectPosition(3)
	player.holdingObject = true
	
	visible = false
	fridge.close()
	
