extends Control

var coins: int = 0  # Start from zero; will be updated from save

@onready var font = $Coin/CoinCount.get_theme_font("font")
@onready var coinLabel = $Coin/CoinCount

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$EscMenu.visible = false
	$FridgeMenu.visible = false

	# Wait one frame to ensure everything is ready
	await get_tree().process_frame
	load_saved_data()

func load_saved_data():
	var saved_state = GameState.load()
	if saved_state.has("coins"):
		coins = saved_state["coins"]
	else:
		coins = 0  # fallback

	update_coin_display()

func update_font_size_to_fit():
	var max_width = coinLabel.size.x
	var text = coinLabel.text
	var font_size = 64  # start big, reduce as needed

	while font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > max_width and font_size > 8:
		font_size -= 1
	
	add_theme_font_size_override("font_size", font_size)

func update_coin_display():
	coinLabel.text = str(coins)
	update_font_size_to_fit()

func addCoins(amount):
	coins += amount
	update_coin_display()

func removeCoins(amount):
	coins = max(0, coins - amount)
	update_coin_display()

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
