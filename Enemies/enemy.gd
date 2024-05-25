extends Node2D

signal miss
signal attacking

@onready var telegraphTimer: Timer = $Telegraph

var isTelegraphing: bool = true

func _ready():
	telegraphTimer.start()

func telegraphAttack():
	telegraphTimer.start()
	isTelegraphing = true
	
func attack():
	emit_signal("attacking")
	

func _on_player_deflecting():
	if isTelegraphing:
		telegraphTimer.stop()
	else:
		print("missed")
		emit_signal("miss")


func _on_telegraph_timeout():
	isTelegraphing = false
	attack()
