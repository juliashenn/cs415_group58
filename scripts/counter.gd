extends StaticBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")
# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.type = Callable(self, "_on_check")
	$Item.visible = false
	
func _on_check():
	if not player.holdingObject:
		return false
	for child in player.get_children():
		if child is Food or child is Plate:
			return true
	return false

func _on_interact():
	if not player.holdingObject:
		var objref
		for child in player.get_children():
			if child is Food or child is Plate:
				objref = child
				break
		var pos = $Item.global_position
#		player.remove_child(obj_ref)
#		world.add_child(obj_ref)
#		obj_ref.global_position = pos
#		obj_ref.z_index = 0
#		holdingObject = false
#		obj_ref.scale = Vector2(1, 1)
