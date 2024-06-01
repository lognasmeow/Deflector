extends Node2D

signal tenEnemiesKilled

var timeStart = 0
var currentTime = 0
var enemiesKilled: float = 0

func _ready():
	timeStart = int(Time.get_unix_time_from_system())

func _process(delta):
	currentTime = int(Time.get_unix_time_from_system()) - timeStart
	if int(enemiesKilled) % 10 == 0 and enemiesKilled > 0:
		emit_signal("tenEnemiesKilled")
		print("ten enemies Killed")


func _on_enemy_dead():
	enemiesKilled += 1


func _on_player_ultimate_is_available():
	pass # show on UI


func _on_player_taking_damage():
	pass # show on UI


func _on_player_dead():
	pass # show on UI
