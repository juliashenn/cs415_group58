extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	$Selection.visible = true
	$Recipe.visible = false
	$Instructions.visible = false
	$Settings.visible = false
	visible = false
	get_tree().paused = false


func _on_recipe_button_pressed():
	$Selection.visible = false
	$Recipe.visible = true


func _on_instruct_button_pressed():
	$Selection.visible = false
	$Instructions.visible = true

func _on_settings_button_pressed():
	$Selection.visible = false
	$Settings.visible = true

func _on_save_button_pressed():
	#save function
	get_tree().change_scene_to_file("res://selection.tscn")
