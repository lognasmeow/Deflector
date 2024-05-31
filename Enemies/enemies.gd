extends Node2D

@onready var player: Node2D = $"../Player"
@onready var map: Node2D = $".."
@onready var spawnTimer: Timer = $"../Spawn"

var enemy = preload("res://Enemies/enemy.tscn")
var enemy1Taken: bool = false
var enemy2Taken: bool = false
var enemy3Taken: bool = false
var enemy1X: int = 256
var enemy2X: int = 448
var enemy3X: int = 640

func connectSignals(instance):
	instance.attacking.connect(player._on_enemy_attacking)
	instance.miss.connect(player._on_enemy_miss)
	instance.dead.connect(map._on_enemy_dead)
	player.deflecting.connect(instance._on_player_deflecting)
	player.usingUltimate.connect(instance._on_player_using_ultimate)

func spawnEnemy(positionX: int):
	var instance = enemy.instantiate()
	instance.position.x = positionX
	instance.position.y = -400
	connectSignals(instance)
	add_child(instance)

func _on_spawn_timeout():
	if get_child_count() > 0:
		enemy1Taken = false
		enemy2Taken = false
		enemy3Taken = false
		for i in get_children():
			if i.position.x == 256:
				enemy1Taken = true
			elif i.position.x == 448:
				enemy2Taken = true
			elif i.position.x == 640:
				enemy3Taken = true
		if not enemy1Taken:
			spawnEnemy(256)
		elif not enemy2Taken:
			spawnEnemy(448)
		elif not enemy3Taken:
			spawnEnemy(640)
	else:
		spawnEnemy(256)
