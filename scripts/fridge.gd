extends StaticBody2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")

var SPEED: float = 1

@onready var openedImg = $Opened
@onready var closedImg = $Closed
@onready var ui = get_tree().get_first_node_in_group("ui")

var opened = false

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	openedImg.visible = false
	ui.closeFridge()

func _on_interact():
	player.position = openedImg.global_position
	player.position.x += 50
	player.position.y += 60
	player.update_animation("idleBack")
	if not opened:
		open()
	
func _process(delta):
	if player.position.distance_to(position) < 50:
		close()
	
func open():
	opened = true
	openedImg.visible = true
	closedImg.visible = false
	ui.openFridge()
	
func close():
	opened = false
	openedImg.visible = false
	closedImg.visible = true
	ui.closeFridge()
