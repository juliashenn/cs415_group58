extends Node

var save_data = {}
var collected_coins := []


func save(game_state: Dictionary):
	save_data = game_state
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()

func load():
	if FileAccess.file_exists("user://savegame.json"):
		var file = FileAccess.open("user://savegame.json", FileAccess.READ)
		var data = file.get_as_text()
		save_data = JSON.parse_string(data)
		file.close()
		
		if save_data.has("collected_coins"):
			collected_coins = save_data["collected_coins"]
			
		return save_data
	return {}
# In GameState.gd
func build_game_state():
	var state = {}
	var ui = get_tree().get_first_node_in_group("ui")
	state["coins"] = ui.coins

	var cuttingBoard = get_tree().get_first_node_in_group("cuttingBoard")
	var stove = get_tree().get_first_node_in_group("stove")
	state["cutting_speed"] = cuttingBoard.SPEED
	state["stove_speed"] = stove.SPEED
	state["collected_coins"] = collected_coins

	var placed = []
	for node in get_tree().get_nodes_in_group("placed_furniture"):
		placed.append({
			"scene": node.scene_file_path,
			"position": node.global_position
		})
	state["furniture"] = placed

	return state
