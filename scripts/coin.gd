extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea

# Amount of coins this gives when picked up
@export var coin_value: int = 20

func _ready():
	print("ran")
	# Hook up the interact function to your InteractionArea
	interaction_area.interact = Callable(self, "_on_pickup")

func _on_pickup():
	print("called")
	# Find the UI node and add coins
	var ui = get_tree().get_root().get_node("Restaurant/CanvasLayer/UI")  # Adjust path if needed
	ui.addCoins(coin_value)
	queue_free()  # Remove coin from scene after pickup
