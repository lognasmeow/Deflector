extends Node2D

var timeStart = 0
var currentTime = 0

func _ready():
	timeStart = int(Time.get_unix_time_from_system())

func _process(delta):
	currentTime = int(Time.get_unix_time_from_system()) - timeStart
