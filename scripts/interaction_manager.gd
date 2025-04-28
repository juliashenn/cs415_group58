extends Node2D

#@onready var player = get_tree().get_first_node_in_group("player")


var player

func _ready():
	player = get_tree().get_first_node_in_group("player")

var active_areas = []
var can_interact = true

func register_area(area: InteractionArea):
	active_areas.push_back(area)
	
	
func unregister_area(area: InteractionArea):
	active_areas.erase(area)

func _process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	else: 
		if active_areas.size() > 0 && can_interact:
			active_areas.sort_custom(_sort_by_distance_to_player)
		

func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.position.distance_to(area1.global_position)
	var area2_to_player = player.position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player
	

func _input(event):
	if event.is_action_pressed("interact") && can_interact && not player.holdingObject:
		if active_areas.size() > 0 && active_areas[0].has_player_inside():
#			can_interact = false
			await active_areas[0].interact.call()
#			can_interact = true
	elif event.is_action_pressed("interact") and player.holdingObject and can_interact:
#		print(active_areas.size())
		if active_areas.size() > 1 && active_areas[1].has_player_inside():
#			print(player.has_node("Food"))
#			print(player.holdingObject)
#			print(active_areas[1].type.call())
#			print(player.position.distance_to(get_tree().get_first_node_in_group("stove").global_position))
			if active_areas[1].type.call():
				await active_areas[1].interact.call()
			else:
				player.dropObject()
		elif active_areas.size() > 0 && active_areas[0].has_player_inside():
			print(active_areas[0].type.call())
			if active_areas[0].type.call():
				await active_areas[0].interact.call()
			else:
				player.dropObject()
