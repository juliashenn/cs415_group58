extends Control

#@onready var coins = int($Coin/CoinCount.text)
@onready var font = $Coin/CoinCount.get_theme_font("font")
@onready var coinLable = $Coin/CoinCount

# Called when the node enters the scene tree for the first time.
func _ready():
	updateCoins()
	process_mode = Node.PROCESS_MODE_ALWAYS
	$EscMenu.visible = false
	$FridgeMenu.visible = false
	update_font_size_to_fit()

func update_font_size_to_fit():
	var max_width = coinLable.size.x
	var text = coinLable.text
	var font_size = 64  # start big, reduce as needed

	while font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > max_width and font_size > 8:
		font_size -= 1
	
	add_theme_font_size_override("font_size", font_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateCoins()

func openEsc():
	$EscMenu.visible = true

func _on_esc_button_pressed():
	$EscMenu.visible = true

func openFridge():
	$FridgeMenu.visible = true
	
func closeFridge():
	$FridgeMenu.visible = false


func _on_shop_pressed():
	get_tree().paused = not get_tree().paused
	$Store.visible = true

func updateCoins():
	$Coin/CoinCount.text = str(Global.money)
	update_font_size_to_fit()
