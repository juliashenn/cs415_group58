extends Node2D

#@onready var player = get_tree().get_first_node_in_group("player")
#@onready var label = $Label

#const base_text = "[E] to"

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
#		label.text = base_text + active_areas[0].action_name
#		label.global_position = active_areas[0].global_position
#		label.global_position.y -= 36
#		label.global_position.x -= label.size.x/2
#		label.visible = true
#	else:
#		label.visible = false
		

func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.position.distance_to(area1.global_position)
	var area2_to_player = player.position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player
	

func _input(event):
	if event.is_action_pressed("interact") && can_interact && not player.holdingObject:
		if active_areas.size() > 0 && player.position.distance_to(active_areas[0].global_position) < 100:
#			can_interact = false
			await active_areas[0].interact.call()
#			can_interact = true
	elif event.is_action_pressed("interact") and player.holdingObject and can_interact:
#		print(active_areas.size())
		if active_areas.size() > 1 && player.position.distance_to(active_areas[1].global_position) < 100:
#			print(player.has_node("Food"))
#			print(player.holdingObject)
#			print(active_areas[1].type.call())
#			print(player.position.distance_to(get_tree().get_first_node_in_group("stove").global_position))
			if active_areas[1].type.call():
				await active_areas[1].interact.call()
			else:
				player.dropObject()
		elif active_areas.size() > 0 && player.position.distance_to(active_areas[0].global_position) < 100:
			if active_areas[0].type.call():
				await active_areas[0].interact.call()
			else:
				player.dropObject()
