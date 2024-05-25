extends Node2D

signal deflecting
signal dead
signal usingUltimate

@onready var deflectCooldownTimer: Timer = $DeflectCooldown
@onready var ultimateCheckerTimer: Timer = $UltimateChecker

var deflectAvailable: bool = true
var health: int = 3
var ultimateAvailable: bool = true
var spacePressed: bool = false
var isInvincible: bool = false
var ultimateCheckerTimerStarted: bool = false
var ultimateReadyToUse: bool = false

func _process(delta):
	if ultimateAvailable:
		if deflectAvailable and spacePressed:
			isInvincible = true
			if not ultimateCheckerTimerStarted:
				ultimateCheckerTimer.start()
				ultimateCheckerTimerStarted = true
		else:
			isInvincible = false
			ultimateCheckerTimer.stop()
			ultimateCheckerTimerStarted = false
			
	if ultimateReadyToUse:
		if spacePressed == false:
			useUltimate()

func _input(event):
	if event.is_action_pressed("space"):
		spacePressed = true
		handleDeflect()
		
	if event.is_action_released("space"):
		spacePressed = false

func handleDeflect():
	if deflectAvailable:
		print("deflecting")
		emit_signal("deflecting")
		
func showUltimateVisuals():
	print("showing ultimate visuals")
		
func useUltimate():
	print("using ultimate")
	emit_signal("usingUltimate")
	ultimateCheckerTimerStarted = false
	ultimateReadyToUse = false
	ultimateAvailable = false

		
func takeDamage(damageAmount: int):
	health -= damageAmount
	if health <= 0:
		print("dead")
		emit_signal("dead")


func _on_deflect_cooldown_timeout():
	deflectAvailable = true


func _on_enemy_miss():
	deflectCooldownTimer.start()
	deflectAvailable = false


func _on_enemy_attacking():
	print("player takes damage!")
	if not isInvincible:
		takeDamage(1)


func _on_ultimate_checker_timeout():
	print("ultimate time")
	ultimateReadyToUse = true
	showUltimateVisuals()
