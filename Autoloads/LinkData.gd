extends Node

var inventory = {
	"sword" : false,
	"sword_2" : false,
	"sheild" : false
}

var link = {
	"heart_max" : 3,
	"heart" : 3,
	"rupies_max" : 100,
	"rupies" : 0
}

var is_reading = false

func _ready():
	randomize()
