extends StaticBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
#	$CollisionShape2D.disabled = true
	player.position = $TextureRect.global_position
	player.position.x += 18
	player.position.y -= 8
	player.update_sit_animation(true)
