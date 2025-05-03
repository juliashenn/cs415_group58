extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$EscMenu.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func openEsc():
	$EscMenu.visible = true

func _on_esc_button_pressed():
	$EscMenu.visible = true

func openFridge():
	$FridgeMenu.visible = true
	
func closeFridge():
	$FridgeMenu.visible = false
