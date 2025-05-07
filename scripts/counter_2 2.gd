extends StaticBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var interaction_area2: InteractionArea = $InteractionArea2
@onready var player = get_tree().get_first_node_in_group("player")


# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.type = Callable(self, "_on_check")
	if interaction_area2:
		interaction_area2.interact = Callable(self, "_on_interact2")
		interaction_area2.type = Callable(self, "_on_check")
	$Item.visible = false
	if $Item2:
		$Item2.visible = false
	
func _on_check():
	if not player.holdingObject:
		return false
	for child in player.get_children():
		if child is Food or child is Plate:
			return true
	return false

func _on_interact():
	if player.holdingObject:
		var objref
		for child in player.get_children():
			if child is Food or child is Plate:
				objref = child
				break
		var pos = $Item.global_position
		var world = get_parent()
		player.remove_child(objref)
		world.add_child(objref)
		objref.global_position = pos
		objref.z_index = 1
		player.holdingObject = false
		objref.scale = Vector2(1, 1)
		
func _on_interact2():
	if player.holdingObject:
		var objref
		for child in player.get_children():
			if child is Food or child is Plate:
				objref = child
				break
		var pos = $Item2.global_position
		var world = get_parent()
		player.remove_child(objref)
		world.add_child(objref)
		objref.global_position = pos
		objref.z_index = 1
		player.holdingObject = false
		objref.scale = Vector2(1, 1)
