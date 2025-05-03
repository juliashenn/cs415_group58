extends Control

@onready var chair = $Chairs
@onready var table = $Tables
@onready var misc = $Misc

@onready var ui = get_tree().get_first_node_in_group("ui")

# Called when the node enters the scene tree for the first time.
func _ready():
	for button in get_tree().get_nodes_in_group("furnitureButton"):
		button.pressed.connect(_on_furniture_button_pressed.bind(button))

func _on_furniture_button_pressed(button):
	ui.removeCoins(100)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_chair_button_pressed():
	chair.visible = true
	table.visible = false
	misc.visible = false 


func _on_table_button_pressed():
	chair.visible = false
	table.visible = true
	misc.visible = false 


func _on_misc_button_pressed():
	chair.visible = false
	table.visible = false
	misc.visible = true 


func _on_texture_button_pressed():
	chair.visible = true
	table.visible = false
	misc.visible = false 
	visible = false
	get_tree().paused = false
