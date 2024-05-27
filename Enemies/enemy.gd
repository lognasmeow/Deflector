extends Node2D

signal miss
signal attacking
signal dead

@onready var telegraphTimer: Timer = $Telegraph
@onready var restTimer: Timer = $Rest
@onready var map: Node2D = $".."

var isTelegraphing: bool = true
var startingSpawnTime: float = 5

func _ready():
	if map.currentTime > 0:
		print(startingSpawnTime / map.currentTime)
	else:
		print(startingSpawnTime / 1)
	rest()
	
func _process(delta):
	if map.currentTime > 0:
		print(startingSpawnTime / map.currentTime)
	
func rest():
	restTimer.start()
	print("enemy resting")

func telegraphAttack():
	telegraphTimer.start()
	isTelegraphing = true
	print("enemy telegraphing attack")
	
func attack():
	emit_signal("attacking")
	rest()
	

func _on_player_deflecting():
	if isTelegraphing:
		telegraphTimer.stop()
		emit_signal("dead")
	else:
		print("player missed")
		emit_signal("miss")


func _on_telegraph_timeout():
	isTelegraphing = false
	attack()


func _on_rest_timeout():
	telegraphAttack()
