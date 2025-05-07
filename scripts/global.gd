extends Node2D

var tilemap
var edit_mode := false
var shop_mode := false

var money := 5000
var currently_placing_item : Node = null

#tscn, price, qty owned
var furniture = {
	"fridge": ["res://fridge.tscn"],
	"stove": ["res://stove.tscn"],
	"cutting": ["res://cutting_board.tscn"],
	
	"chair1": ["res://furniture/chair1.tscn"],
	"chair2": ["res://furniture/chair2.tscn"],
	"chair3": ["res://furniture/chair3.tscn"],
	
	"table1": ["res://furniture/table1.tscn"],
	"table2": ["res://furniture/table2.tscn"],
	"table3": ["res://furniture/table3.tscn"]
}

var build_inventory = {
	"fridge": 5,
	"stove": 5,
	"table": 5,
	"chair": 0,
	"cutting": 5
}
