extends CanvasLayer

signal place_fridge
signal place_stove
signal place_cutting
signal place_table
signal place_chair

func _ready():
	$PlaceFridge.pressed.connect(place_fridge_pressed)
	$PlaceStove.pressed.connect(place_stove_pressed)
	$PlaceCutting.pressed.connect(place_cutting_pressed)
	$PlaceTable.pressed.connect(place_table_pressed)
	$PlaceChair.pressed.connect(place_chair_pressed)
	
func place_fridge_pressed():
	if Global.build_inventory["fridge"] > 0 and Global.currently_placing_item == null:
		Global.build_inventory["fridge"] -=1
		emit_signal("place_fridge")

func place_stove_pressed():
	if Global.build_inventory["stove"] > 0 and Global.currently_placing_item == null:
		Global.build_inventory["stove"] -=1
		emit_signal("place_stove")

func place_cutting_pressed():
	if Global.build_inventory["cutting"] > 0 and Global.currently_placing_item == null:
		Global.build_inventory["cutting"] -=1
		emit_signal("place_cutting")

func place_table_pressed():
	if Global.build_inventory["table"] > 0 and Global.currently_placing_item == null:
		Global.build_inventory["table"] -=1
		emit_signal("place_table")

func place_chair_pressed():
	if Global.build_inventory["chair"] > 0 and Global.currently_placing_item == null:
		Global.build_inventory["chair"] -=1
		emit_signal("place_chair")
