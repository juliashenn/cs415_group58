class_name placed_item
extends Sprite2D

@onready var area = $Area2D
@onready var body_shape = $StaticBody2D/CollisionShape2D

var placing := false
var item_type = "object1"  # Type used to track inventory count
var price = 100

func _ready():
	body_shape.disabled = true
	area.input_event.connect(_on_area_input_event)
	
	if placing:
		Global.currently_placing_item = self

func _process(delta):
	if placing:
		var mouse_tile = Global.tilemap.local_to_map(get_global_mouse_position())
		var local_position = Global.tilemap.map_to_local(mouse_tile)
		var world_position = Global.tilemap.to_global(local_position)
		global_position = world_position

func _on_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT and Global.edit_mode:
			Global.money += price
			queue_free()
			print(Global.furniture)
			return

		# --- LEFT CLICK (placing or picking up) ---
		if event.button_index == MOUSE_BUTTON_LEFT:

			# CASE 1: Currently placing the object
			if placing:
				var blocked = false
				for body in area.get_overlapping_bodies():
					if body.name in ["chairLeft", "chairRight"]:
						continue  # Ignore these objects
					blocked = true
					break

				if not blocked:
					print("Placed successfully.")
					placing = false
					#set_process(false)
					
					if "chair" in item_type:
						print("is it working")
						var restaurant_node = find_parent("Restaurant")
						print(restaurant_node)
						var tables_node = restaurant_node.get_node("tables")
						print(tables_node)
						if tables_node:
							print("debug")
							get_parent().remove_child(self)
							tables_node.add_child(self)
							# Optional: reset position relative to new parent if needed
						else:
							print("Warning: 'tables' node not found in the scene tree.")
					
					body_shape.disabled = false
					if get_parent().has_method("finish_placement"):
						get_parent().finish_placement()
					if Global.currently_placing_item == self:
						Global.currently_placing_item = null
				else:
					print("Blocked: cannot place here.")

			# CASE 2: Not placing but edit mode is active (pick up for moving)
			elif Global.edit_mode:
				if Global.currently_placing_item == null:
					print("Edit mode: picked up object for moving.")
					placing = true
					Global.currently_placing_item = self
					print(Global.currently_placing_item)
					#set_process(true)
					body_shape.disabled = true
