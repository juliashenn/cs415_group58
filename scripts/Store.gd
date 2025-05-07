extends Control

signal buy_furniture(item_name)

@onready var chair = $Chairs
@onready var table = $Tables
@onready var misc = $Misc
@onready var level = $Level
@onready var popup = $PopupPanel

@onready var ui = get_tree().get_first_node_in_group("ui")
@onready var cuttingBoard = get_tree().get_first_node_in_group("cuttingBoard")
@onready var stove = get_tree().get_first_node_in_group("stove")

# Called when the node enters the scene tree for the first time.
func _ready():
	for button in get_tree().get_nodes_in_group("furnitureButton"):
		button.pressed.connect(_on_furniture_button_pressed.bind(button))
		
	for button in get_tree().get_nodes_in_group("levelCutting"):
		button.pressed.connect(_on_level_cutting_button_pressed.bind(button))
		
	for button in get_tree().get_nodes_in_group("levelStove"):
		button.pressed.connect(_on_level_stove_button_pressed.bind(button))

func _on_furniture_button_pressed(button):
	pop()
	if button == $Chairs/GridContainer/VSplitContainer/Button:
		emit_signal("buy_furniture", "chair1")
	if button == $Chairs/GridContainer/VSplitContainer2/Button:
		emit_signal("buy_furniture", "chair2")
	if button == $Chairs/GridContainer/VSplitContainer3/Button:
		emit_signal("buy_furniture", "chair3")
		
	if button == $Tables/GridContainer/VSplitContainer/Button:
		emit_signal("buy_furniture", "table1")
	if button == $Tables/GridContainer/VSplitContainer2/Button:
		emit_signal("buy_furniture", "table2")
	if button == $Tables/GridContainer/VSplitContainer3/Button:
		emit_signal("buy_furniture", "table3")
	
	if button == $Misc/GridContainer/VSplitContainer23/Button:
		emit_signal("buy_furniture", "stove")
	if button == $Misc/GridContainer/VSplitContainer24/Button:
		emit_signal("buy_furniture", "fridge")
	if button == $Misc/GridContainer/VSplitContainer25/Button:
		emit_signal("buy_furniture", "cutting")
	
	_on_texture_button_pressed()
	
func _on_level_cutting_button_pressed(button):
	pop()
	Global.money -= (1000*cuttingBoard.SPEED)
	cuttingBoard.levelUp()
	$Level/Level/GridContainer/VSplitContainer2/HBoxContainer/Label.text = str(1000*cuttingBoard.SPEED)
	
func _on_level_stove_button_pressed(button):
	pop()
	Global.money -= (1000*stove.SPEED)
	stove.levelUp()
	$Level/Level/GridContainer/VSplitContainer/HBoxContainer/Label.text = str(1000*stove.SPEED)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func pop():
	popup.popup_centered()
	await get_tree().create_timer(1.0).timeout 
	popup.hide() 


func _on_chair_button_pressed():
	chair.visible = true
	table.visible = false
	misc.visible = false 
	level.visible = false


func _on_table_button_pressed():
	chair.visible = false
	table.visible = true
	misc.visible = false 
	level.visible = false


func _on_misc_button_pressed():
	chair.visible = false
	table.visible = false
	misc.visible = true 
	level.visible = false


func _on_texture_button_pressed():
	chair.visible = true
	table.visible = false
	misc.visible = false 
	level.visible = false
	visible = false
	get_tree().paused = false


func _on_level_button_pressed():
	chair.visible = false
	table.visible = false
	misc.visible = false 
	level.visible = true
