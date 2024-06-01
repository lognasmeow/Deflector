extends Node2D

signal tenEnemiesKilled

@onready var killsLabel: Label = $UI/Kills/KillsLabel

var timeStart = 0
var currentTime = 0
var enemiesKilled: float = 0
var enemiesKilledSinceLastUltimate: float = 0
var enemiesKilledAlreadyReached: bool = false

func _ready():
	timeStart = int(Time.get_unix_time_from_system())
	emit_signal("tenEnemiesKilled")

func _process(_delta):
	currentTime = int(Time.get_unix_time_from_system()) - timeStart


func _on_enemy_dead():
	enemiesKilled += 1
	enemiesKilledSinceLastUltimate += 1
	killsLabel.text = str(enemiesKilled)
	if enemiesKilledSinceLastUltimate >= 15 and not enemiesKilledAlreadyReached:
		emit_signal("tenEnemiesKilled")
		print("ten enemies Killed")
		enemiesKilledAlreadyReached = true


func _on_player_dead():
	pass # show on UI


func _on_player_using_ultimate():
	enemiesKilledSinceLastUltimate = 0
	enemiesKilledAlreadyReached = false
	
