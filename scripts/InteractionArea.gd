extends Area2D

class_name InteractionArea

@export var action_name: String = "interact"

var interact: Callable = func():
	pass
	
var type: Callable = func():
	pass


var bodies_inside = []

func _on_body_entered(body):
	if body.is_in_group("player"):
		bodies_inside.append(body)
	InteractionManager.register_area(self)

func _on_body_exited(body):
	if body.is_in_group("player"):
		bodies_inside.erase(body)
	InteractionManager.unregister_area(self)

func has_player_inside():
	return bodies_inside.size() > 0
