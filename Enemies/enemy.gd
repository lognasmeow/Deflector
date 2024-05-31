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
var randomSpawnSeconds: int = 1

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
	telegraphTimer.start()
	isTelegraphing = true
	animationPlayer.play("telegraph")
	print("enemy telegraphing attack")
	
func attack():
	animationPlayer.play("shoot")
	emit_signal("attacking")
	rest()
	
func die():
	restTimer.stop()
	telegraphTimer.stop()
	isAlive = false
	animationPlayer.play("die")
	emit_signal("dead")
	print("enemy dead")
	deadTimer.start()
	
func respawn():
	isAlive = true
	isTelegraphing = false
	jumpAnimationPlayed = false
	position.y = -200
	spawnTimer.start()

func _on_player_deflecting():
	if isTelegraphing:
		die()
	else:
		if not player.ultimateAvailable:
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
	if map.currentTime > 0:
		restTimer.wait_time = startingSpawnTime / map.currentTime + 2
		deadTimer.wait_time = startingSpawnTime / map.currentTime + 2
	else:
		restTimer.wait_time = startingSpawnTime / 1
		deadTimer.wait_time = startingSpawnTime / 1
	rest()


func _on_dead_timeout():
	respawn()
