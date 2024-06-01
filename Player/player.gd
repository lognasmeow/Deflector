extends Node2D

signal deflecting
signal dead
signal usingUltimate
signal ultimateIsAvailable
signal takingDamage

@onready var deflectCooldownTimer: Timer = $DeflectCooldown
@onready var ultimateAvailableTimer: Timer = $UltimateAvailable
@onready var ultimateAvailableLastChanceTimer: Timer = $UltimateAvailableLastChance
@onready var ultimateCheckerTimer: Timer = $UltimateChecker
@onready var bobUpTimer: Timer = $BobUp
@onready var bobDownTimer: Timer = $BobDown
@onready var textureAnimationPlayer: AnimationPlayer = $"../Camera2D/TextureRect/Texture"


var deflectAvailable: bool = true
var health: int = 1
var ultimateAvailable: bool = true
var spacePressed: bool = false
var isInvincible: bool = false
var ultimateCheckerTimerStarted: bool = false
var ultimateReadyToUse: bool = false
var ultimateReadyTime: float = 0
var currentDeflectionAnimationPosition: int = 2
var bobUp: bool = true

func _ready():
	setSwordPosition(randf_range(280, 350), randf_range(350, 394), 41.1, 2)

func _process(_delta):
	if bobUp:
		position.y += 0.3
	else:
		position.y -= 0.3
		
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
		animateDeflection()
		emit_signal("deflecting")

func animateDeflection():
	match currentDeflectionAnimationPosition:
		1:
			setRandomCurrentDeflectionAnimationPosition(2, 3)
		2:
			setRandomCurrentDeflectionAnimationPosition(1, 3)
		3:
			setRandomCurrentDeflectionAnimationPosition(1, 2)
	
	match currentDeflectionAnimationPosition:
		1:
			setSwordPosition(randf_range(185, 245), randf_range(350, 394), -20.6, 1)
		2:
			setSwordPosition(randf_range(280, 350), randf_range(350, 394), 41.1, 2)
		3:
			setSwordPosition(randf_range(461, 500), randf_range(350, 394), 68.5, 3)

func setRandomCurrentDeflectionAnimationPosition(position1, position2):
	if randi_range(0, 1) == 0:
		currentDeflectionAnimationPosition = position1
	else:
		currentDeflectionAnimationPosition = position2

func setSwordPosition(positionX: float, positionY: float, rotationDegrees: float, animationPosition: int, tweenSpeed: float = 0.02):
	get_tree().create_tween().tween_property(self, "position:x", positionX, tweenSpeed)
	get_tree().create_tween().tween_property(self, "position:y", positionY, tweenSpeed)
	get_tree().create_tween().tween_property(self, "rotation", deg_to_rad(rotationDegrees), tweenSpeed)
	currentDeflectionAnimationPosition = animationPosition

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
	setSwordPosition(400, 380, 102.8, 2, 0.7)
	textureAnimationPlayer.play("showTexture")
		
func useUltimate():
	print("using ultimate")
	emit_signal("usingUltimate")
	setSwordPosition(150, 380, 102.8, 2, 0.02)
	textureAnimationPlayer.play("RESET")
	ultimateCheckerTimerStarted = false
	ultimateReadyToUse = false
	ultimateAvailable = false
		
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


func _on_bob_up_timeout():
	bobDownTimer.start()
	bobUp = false


func _on_bob_down_timeout():
	bobUpTimer.start()
	bobUp = true
