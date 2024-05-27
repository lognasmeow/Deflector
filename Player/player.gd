extends Node2D

signal deflecting
signal dead
signal usingUltimate
signal ultimateIsAvailable
signal healing
signal takingDamage

@onready var deflectCooldownTimer: Timer = $DeflectCooldown
@onready var ultimateAvailableTimer: Timer = $UltimateAvailable
@onready var ultimateAvailableLastChanceTimer: Timer = $UltimateAvailableLastChance
@onready var ultimateCheckerTimer: Timer = $UltimateChecker

var deflectAvailable: bool = true
var health: int = 3
var ultimateAvailable: bool = false
var spacePressed: bool = false
var isInvincible: bool = false
var ultimateCheckerTimerStarted: bool = false
var ultimateReadyToUse: bool = false
var ultimateReadyTime: float = 0

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

func handleUltimateAvailable():
	ultimateAvailable = true
	ultimateAvailableTimer.start()
	emit_signal("ultimateIsAvailable")
	print("ultimate available")
	
func handleUltimateAvailableLastChance():
	ultimateAvailableLastChanceTimer.start()
	print("last chance to use ultimate!")
	
func handleDidNotUseUltimate():
	ultimateAvailable = false
	print("didn't use ultimate")
	
		
func showUltimateVisuals():
	print("showing ultimate visuals")
		
func useUltimate():
	print("using ultimate")
	emit_signal("usingUltimate")
	heal(1)
	ultimateCheckerTimerStarted = false
	ultimateReadyToUse = false
	ultimateAvailable = false

func heal(healAmount: int):
	health += healAmount
	emit_signal("healing")
	print("healing")
		
func takeDamage(damageAmount: int):
	health -= damageAmount
	if health <= 0:
		print("dead")
		emit_signal("dead")
	else:
		emit_signal("takingDamage")


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
	ultimateAvailableTimer.stop()
	ultimateAvailableLastChanceTimer.stop()
	ultimateReadyToUse = true
	showUltimateVisuals()


func _on_map_main_ten_enemies_killed():
	handleUltimateAvailable()


func _on_ultimate_available_timeout():
	handleUltimateAvailableLastChance()


func _on_ultimate_available_last_chance_timeout():
	handleDidNotUseUltimate()
