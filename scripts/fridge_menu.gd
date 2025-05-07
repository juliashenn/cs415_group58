extends Control

@onready var player = get_tree().get_first_node_in_group("player")
#@onready var fridge = get_tree().get_first_node_in_group("fridge")


const FoodScene = preload("res://food.tscn")

var cookchop = {
	"res://assets/ingredients/meat.png": [true, true],
	"res://assets/ingredients/flour.png": [false, false],
	"res://assets/ingredients/egg.png": [true, false],
	"res://assets/ingredients/corn.png": [true, false],
	"res://assets/ingredients/carrot.png": [false, false],
	"res://assets/ingredients/cabbage.png": [false, true],
	"res://assets/ingredients/chocolate.png": [false, false],
	"res://assets/ingredients/fish.png": [true, true],
	"res://assets/ingredients/milk.png": [true, false],
	"res://assets/ingredients/potato.png": [false, true],
	"res://assets/ingredients/strawberry.png": [true, false],
	"res://assets/ingredients/apple.png": [false, false],
	"res://assets/ingredients/garlic.png": [false, false],
	"res://assets/ingredients/bagel.png": [false, false],
	"res://assets/ingredients/bread.png": [false, false]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	for button in $PanelContainer/GridContainer.get_children():
		button.pressed.connect(_on_food_button_pressed.bind(button))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_texture_button_pressed():
	visible = false
	#fridge.close()
	print("CLOSE")
#	get_parent().get_parent().close()

func _on_food_button_pressed(button):
	var foodtext = button.texture_normal
	var foodref = load("res://food.tscn").instantiate()
	if foodtext is AtlasTexture:
		foodtext = foodtext.atlas.resource_path
	else:
		foodtext = foodtext.resource_path
	foodref.setFood(foodtext)
	foodref.scale = Vector2(0.5, 0.5)
	foodref.name = "Food"
	foodref.cookable = cookchop[foodtext][0]
	foodref.choppable = cookchop[foodtext][1]
	player.add_child(foodref)
	player.updateObjectPosition(3)
	player.holdingObject = true
	
	visible = false
	#fridge.close()
	
