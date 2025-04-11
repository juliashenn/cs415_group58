extends StaticBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")
@onready var food = $Circle/Food
@onready var circle = $Circle

var SPEED: float = 1
var cooking = false
var foodpath = ""
var cookingdict = {
	"res://assets/ingredients/egg.png": "res://assets/Ghostpixxells_pixelfood/38_friedegg.png"
}

func _ready():
	$ProgressBar.visible = false
	$Timer.wait_time /= SPEED
	$Pan.visible = false
	interaction_area.interact = Callable(self, "_on_interact")
#	interaction_area.type = Callable(self, "_on_check")
	food.visible = false
	circle.visible = false
	
#func _on_check():
#	return player.has_node("Food") and player.holdingObject

func _on_interact():
#	$CollisionShape2D.disabled = true
#	if cooking:
#		$Timer.paused = false
#	elif player.holdingObject:
#		var fp = player.giveObject()
#		food.texture = load(fp)
#		foodpath = fp
#		food.visible = true
#		circle.visible = true
	if not player.holdingObject:
		$ProgressBar.visible = true
		$Timer.start()
		cooking = true
		$Pan.visible = true
		player.position = $TextureRect.global_position
		player.position.y += 8
		player.position.x += 20
		player.update_animation("idleBack")
	
func _process(delta):
	if $ProgressBar.visible and player.position.distance_to(position) < 50:
		$ProgressBar.value = ($Timer.wait_time - $Timer.time_left)/$Timer.wait_time*100
	else:
#		$Timer.paused = true
		$ProgressBar.visible = false
		$Pan.visible = false
		cooking = false
	

func _on_timer_timeout():
	$ProgressBar.visible = false
	$Pan.visible = false
	cooking = false
	
#	var foodref = load("res://food.tscn").instantiate()
#
#	foodref.setFood(cookingdict[foodpath])
#	foodref.scale = Vector2(0.5, 0.5)
#
#	player.add_child(foodref)
#	player.updateObjectPosition(3)
#	player.holdingObject = true

