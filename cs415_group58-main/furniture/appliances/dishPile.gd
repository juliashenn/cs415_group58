extends placed_item

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")
# Called when the node enters the scene tree for the first time.
func _ready():
	item_type = "dishpile"
	super()
	
	interaction_area.interact = Callable(self, "_on_interact")
	
func _process(delta):
	super(delta)

func _on_interact():
	var plateref = load("res://plate.tscn").instantiate()
	plateref.scale = Vector2(0.5, 0.5)
	player.add_child(plateref)
	player.updateObjectPosition(3)
	player.holdingObject = true
