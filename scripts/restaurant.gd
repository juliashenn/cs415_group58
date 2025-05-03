extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# 3, 430, 138, 95


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().paused = not get_tree().paused
		$CanvasLayer/UI.openEsc()
		# maybe make it so that all gameplay pauses, including all timers and customer patience
