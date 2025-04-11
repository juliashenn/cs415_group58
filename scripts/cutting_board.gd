extends StaticBody2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")

var SPEED: float = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	$ProgressBar.visible = false
	$Timer.wait_time /= SPEED
	$Knife.visible = false
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	$ProgressBar.visible = true
	$Timer.start()
	$Knife.visible = true
	player.position = $TextureRect.global_position
	player.position.y += 8
	player.position.x += 20
	player.update_animation("idleBack")
	
func _process(delta):
	if $ProgressBar.visible and player.position.distance_to(position) < 50:
		$ProgressBar.value = ($Timer.wait_time - $Timer.time_left)/$Timer.wait_time*100
	else:
		$Timer.stop()
		$ProgressBar.visible = false
		$Knife.visible = false
	

func _on_timer_timeout():
	$ProgressBar.visible = false
	$Knife.visible = false
