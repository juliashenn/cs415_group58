extends Node2D

@onready var sprite = $Sprite2D

@onready var interaction_area = $InteractionArea

# Amount of coins this gives when picked up
@export var coin_value: int = 20
@export var coin_id: String


func _ready():
	# Hook up the interact function to your InteractionArea
	if GameState.collected_coins.has(coin_id):
		queue_free()
		return
	interaction_area.interact = Callable(self, "_on_pickup")

func _on_pickup():
	# Find the UI node and add coins
	$AudioStreamPlayer.play()

	var ui = get_tree().get_root().get_node("Restaurant/CanvasLayer/UI")
	ui.addCoins(coin_value)

	# Mark as collected
	if not GameState.collected_coins.has(coin_id):
		GameState.collected_coins.append(coin_id)

	# Save immediately (optional: or just wait for save button)
	var state = GameState.build_game_state()
	GameState.save(state)

	queue_free()
