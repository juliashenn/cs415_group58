extends StaticBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")

var is_occupied: bool = false
var sit_right: bool = false  # false for left chairs
var servedFood = false

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.type = Callable(self, "_on_check")

func _on_check(): # cooking is they are holding food, it gets onto board, and itll return to their hands chopped
#	print(player.holdingObject)
	if not player.holdingObject:
		return false
#	print(player.has_node("Food"))
	for child in player.get_children():
		if child is Plate:
			return child.hasFood
	return false

func _on_interact():
	pass
#	seat_character(player, sit_right)
	
# seating customers and players
func seat_character(character: Node2D, sit_right: bool):
	character.position = $TextureRect.global_position
	character.position.x += 18
	character.position.y -= 8

	if character.has_method("update_sit_animation"):
		character.update_sit_animation(sit_right)

	is_occupied = true # false for left chair
	
	#character.leave_waiting_line()
