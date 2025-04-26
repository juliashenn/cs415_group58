extends StaticBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")

var is_occupied: bool = false
var sit_right: bool = true  # false for left chairs

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")

#func _on_interact():
##	$CollisionShape2D.disabled = true
	#player.position = $TextureRect.global_position
	#player.position.x += 18
	#player.position.y -= 8
	#print("Player sitting at left chair: ", player.position)
#
	#player.update_sit_animation(false)
	#
func _on_interact():
	seat_character(player, sit_right)
	
# seating customers and players
func seat_character(character: Node2D, sit_right: bool):
	character.position = $TextureRect.global_position
	character.position.x += 18
	character.position.y -= 8

	if character.has_method("update_sit_animation"):
		character.update_sit_animation(sit_right)

	is_occupied = true # false for left chair
	
	#character.leave_waiting_line()  # Make sure the customer leaves the queue
