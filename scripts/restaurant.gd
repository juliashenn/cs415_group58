extends Node2D

var placing_object: Sprite2D = null
@onready var shop_node = $CanvasLayer/UI/Store

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.connect("finished", Callable(self, "_on_audio_finished"))
	
	Global.tilemap = $tilegrid
	Global.currently_placing_item = null
	
	shop_node.connect("buy_furniture", func(item_name):
		var scene_path = Global.furniture[item_name][0]
		var scene = load(scene_path)
		place_object(scene)
	)
	print(Global.currently_placing_item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("escape"):
		get_tree().paused = not get_tree().paused
		$CanvasLayer/UI.openEsc()
		# maybe make it so that all gameplay pauses, including all timers and customer patience

func _input(event):
	if event.is_action_pressed("UI Cancel"):
		if placing_object != null:
			cancel_placement()
	
	if event.is_action_pressed("UI Edit"):
		Global.edit_mode = !Global.edit_mode
		print(Global.edit_mode)
		
func place_object(object_scene):
	var ui = get_tree().get_root().get_node("Restaurant/CanvasLayer/UI")
	var object_instance = object_scene.instantiate() 
	if ui.coins >= object_instance.price:
		ui.removeCoins(object_instance.price)
		#Global.money -= object_instance.price
		add_child(object_instance)
		placing_object = object_instance
		object_instance.placing = true

		var mouse_tile = Global.tilemap.local_to_map(get_global_mouse_position())
		var local_position = Global.tilemap.map_to_local(mouse_tile)
		var world_position = Global.tilemap.to_global(local_position)

		object_instance.global_position = world_position
	else:
		object_instance.queue_free()

func cancel_placement():
	if placing_object:
		var ui = get_tree().get_root().get_node("Restaurant/CanvasLayer/UI") 
		ui.addCoins(placing_object.price)
		#Global.money += placing_object.price
		placing_object.queue_free()
		placing_object = null

func finish_placement():
	placing_object = null
