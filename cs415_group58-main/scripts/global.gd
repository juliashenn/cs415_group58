extends Node2D

var tilemap
var edit_mode := false
var shop_mode := false

#var money := 5000
var currently_placing_item : Node = null

#tscn, price, qty owned
var furniture = {
	"fridge": ["res://furniture/appliances/fridge.tscn"],
	"stove": ["res://furniture/appliances/stove.tscn"],
	"cutting": ["res://furniture/appliances/cutting_board.tscn"],
	"counter1": ["res://furniture/appliances/counter.tscn"],
	"counter2": ["res://furniture/appliances/counter_2.tscn"],
	"dishpile": ["res://furniture/appliances/dish_pile.tscn"],
	
	"chair1r": ["res://furniture/chairs/chair1r.tscn"],
	"chair1l": ["res://furniture/chairs/chair1l.tscn"],
	"chair2r": ["res://furniture/chairs/chair2r.tscn"],
	"chair2l": ["res://furniture/chairs/chair2l.tscn"],
	"chair3r": ["res://furniture/chairs/chair3r.tscn"],
	"chair3l": ["res://furniture/chairs/chair3l.tscn"],
	
	"table1": ["res://furniture/tables/table1.tscn"],
	"table2": ["res://furniture/tables/table2.tscn"],
	"table3": ["res://furniture/tables/table3.tscn"]
}
