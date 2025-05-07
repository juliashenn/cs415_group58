extends Node2D

var shop_open := false
var edit_open := false
var placing_object: Sprite2D = null
@onready var fridge_scene = preload("res://fridge.tscn")
@onready var stove_scene = preload("res://stove.tscn")
@onready var cutting_scene = preload("res://cutting_board.tscn")
@onready var table_scene = preload("res://table_chairs.tscn")
@onready var shop_node = $CanvasLayer/UI/Store
@onready var edit_node = $Edit

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.tilemap = $tilegrid
	Global.currently_placing_item = null
	
	shop_node.connect("buy_furniture", func(item_name):
		var scene_path = Global.furniture[item_name][0]
		var scene = load(scene_path)
		place_object(scene)
	)
	print(Global.build_inventory)
	print(Global.currently_placing_item)
	# 3, 430, 138, 95


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("escape"):
		get_tree().paused = not get_tree().paused
		$CanvasLayer/UI.openEsc()
		# maybe make it so that all gameplay pauses, including all timers and customer patience

func _input(event):
	if event.is_action_pressed("Shop Menu"):
		shop_open = !shop_open
	
	if event.is_action_pressed("Debug"):
		Global.money += 100
		
	if event.is_action_pressed("UI Cancel"):
		if placing_object != null:
			cancel_placement()
	
	if event.is_action_pressed("UI Edit"):
		edit_open = !edit_open
		Global.edit_mode = !Global.edit_mode
		print(Global.edit_mode)


func place_object(object_scene):
	shop_open = false
	var object_instance = object_scene.instantiate()
	Global.money -= object_instance.price
	add_child(object_instance)
	placing_object = object_instance
	object_instance.placing = true

	var mouse_tile = Global.tilemap.local_to_map(get_global_mouse_position())
	var local_position = Global.tilemap.map_to_local(mouse_tile)
	var world_position = Global.tilemap.to_global(local_position)

	object_instance.global_position = world_position

func cancel_placement():
	if placing_object:
		Global.money += placing_object.price
		placing_object.queue_free()
		placing_object = null

func finish_placement():
	placing_object = null
