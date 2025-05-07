extends Area2D

class_name InteractionArea

@export var action_name: String = "interact"

var interact: Callable = func():
	pass
	
var type: Callable = func():
	pass


var bodies_inside = []

func _on_body_entered(body):
	print("enter")
	if body.is_in_group("player"):
		bodies_inside.append(body)
	InteractionManager.register_area(self)
	#print(InteractionManager.active_areas[0])
	#print(InteractionManager.active_areas[1])
	#print(InteractionManager.active_areas[2])

func _on_body_exited(body):
	print("exit")
	if body.is_in_group("player"):
		bodies_inside.erase(body)
	InteractionManager.unregister_area(self)
#	print(InteractionManager.active_areas[0])
	#print(InteractionManager.active_areas[1])
	#print(InteractionManager.active_areas[2])

func has_player_inside():
	return bodies_inside.size() > 0
