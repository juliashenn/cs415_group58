extends placed_item
var price = 10


func _ready():
	item_type = "table"
	super()

func _process(delta):
	super(delta)
