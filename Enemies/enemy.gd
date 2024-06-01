extends Node2D

signal miss
signal attacking
signal dead

@onready var telegraphTimer: Timer = $Telegraph
@onready var restTimer: Timer = $Rest
@onready var spawnTimer: Timer = $Spawn
@onready var deadTimer: Timer = $Dead
@onready var map: Node2D = $"../.."
@onready var player: Node2D = $"../../Player"
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

var isTelegraphing: bool = false
var startingSpawnTime: float = 5
var isAlive: bool = true
var jumpAnimationPlayed: bool = false
var defaultWaitTime: float = 4

func _ready():
	spawnTimer.wait_time = startingSpawnTime / 3.5
	spawnTimer.start()
	
func _process(delta):
	if position.y < 0:
		position.y += 4.4
		if not animationPlayer.is_playing() or animationPlayer.current_animation != "fall":
			animationPlayer.play("fall")
	else:
		if not jumpAnimationPlayed:
			animationPlayer.play("jump")
			jumpAnimationPlayed = true
		
	if not animationPlayer.is_playing() and jumpAnimationPlayed and isAlive:
		animationPlayer.play("idle")
	
func rest():
	restTimer.start()
	print("enemy resting")

func telegraphAttack():
	if isAlive:
		telegraphTimer.start()
		isTelegraphing = true
		get_parent().isAnyEnemyTelegraphing = true
		get_parent().anyEnemyTelegraphingTimer.start()
		animationPlayer.play("telegraph")
		print("enemy telegraphing attack")
	
func attack():
	if isAlive:
		animationPlayer.play("shoot")
		emit_signal("attacking")
		rest()
	
func die():
	if isAlive:
		restTimer.stop()
		telegraphTimer.stop()
		isAlive = false
		animationPlayer.play("die")
		emit_signal("dead")
		print("enemy dead")
		deadTimer.start()

func _on_player_deflecting():
	if isAlive:
		if isTelegraphing:
			die()
		else:
			if not player.ultimateAvailable and not get_parent().isAnyEnemyTelegraphing:
				print("player missed")
				emit_signal("miss")


func _on_telegraph_timeout():
	isTelegraphing = false
	attack()


func _on_rest_timeout():
	telegraphAttack()


func _on_player_using_ultimate():
	die()


func _on_spawn_timeout():
	if map.enemiesKilled > 0:
		restTimer.wait_time = defaultWaitTime / map.enemiesKilled + randf_range(0.1, 5)
	else:
		restTimer.wait_time = defaultWaitTime
	deadTimer.wait_time = defaultWaitTime
	rest()


func _on_dead_timeout():
	queue_free()
