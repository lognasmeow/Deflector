extends Node2D

@onready var player: Node2D = $"../Player"
@onready var map: Node2D = $".."
@onready var spawnTimer: Timer = $"../Spawn"
@onready var anyEnemyTelegraphingTimer: Timer = $"../AnyEnemyTelegraphing"

var enemy = preload("res://Enemies/enemy.tscn")
var enemy1Taken: bool = false
var enemy2Taken: bool = false
var enemy3Taken: bool = false
var enemy4Taken: bool = false
var enemy5Taken: bool = false
var enemy1X: int = 256
var enemy4X: int = 352
var enemy2X: int = 448
var enemy5X: int = 544
var enemy3X: int = 640
var isAnyEnemyTelegraphing: bool = false

func _process(delta):
	if map.enemiesKilled > 0:
		spawnTimer.wait_time = 5 / map.enemiesKilled
	else:
		spawnTimer.wait_time = 5

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
		enemy4Taken = false
		enemy5Taken = false
		for i in get_children():
			if i.position.x == enemy1X and i.isAlive:
				enemy1Taken = true
			elif i.position.x == enemy2X and i.isAlive:
				enemy2Taken = true
			elif i.position.x == enemy3X and i.isAlive:
				enemy3Taken = true
			elif i.position.x == enemy4X and i.isAlive:
				enemy4Taken = true
			elif i.position.x == enemy5X and i.isAlive:
				enemy5Taken = true
		if not enemy1Taken:
			spawnEnemy(enemy1X)
		elif not enemy2Taken:
			spawnEnemy(enemy2X)
		elif not enemy3Taken:
			spawnEnemy(enemy3X)
		elif not enemy4Taken:
			spawnEnemy(enemy4X)
		elif not enemy5Taken:
			spawnEnemy(enemy5X)
	else:
		spawnEnemy(enemy1X)


func _on_any_enemy_telegraphing_timeout():
	isAnyEnemyTelegraphing = false
