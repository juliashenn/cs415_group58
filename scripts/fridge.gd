extends placed_item

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")

var SPEED: float = 1

@onready var openedImg = $Opened
@onready var closedImg = $Closed
@onready var menu = $CanvasLayer/FridgeMenu

var opened = false

func _ready():
	item_type = "fridge"
	super()
	
	interaction_area.interact = Callable(self, "_on_interact")
	openedImg.visible = false
	menu.visible = false

func _on_interact():
	#player.position = openedImg.global_position
	#player.position.x += 50
	#player.position.y += 60
	player.update_animation("idleBack")
	#if not opened:
	open()
	
func _process(delta):
	super(delta)
	#print("Distance to player:", player.position.distance_to(position))
	#print("PLEASE JUST CLOSE")
	#if player.position.distance_to(position) < 50 and opened == false:
	#	close()
	
func open():
	opened = true
	openedImg.visible = false
	closedImg.visible = true
	menu.visible = true
	print(menu.visible)
	
func close():
	#print("WHY WILL YOU NOT CLOSE")
	opened = false
	openedImg.visible = false
	closedImg.visible = true
	menu.visible = false
