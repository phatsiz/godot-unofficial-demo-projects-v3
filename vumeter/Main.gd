# VU meter, based on https://github.com/Plopsiskopsis/visualiser

extends Node2D

onready var stream = $AudioStreamPlayer
onready var vuPanel = $VUPanel

var bus
var left = 0.0
var right = 0.0

func _ready():
	bus = AudioServer.get_bus_index("Master")
	stream.play()

func _process(delta):
	left = AudioServer.get_bus_peak_volume_left_db(bus, 0)
	right = AudioServer.get_bus_peak_volume_right_db(bus, 0)
	vuPanel.left = clamp(left, -100, 0)
	vuPanel.right = clamp(right, -100, 0)
	vuPanel.update()
