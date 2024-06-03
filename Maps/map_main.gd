extends Node2D

signal tenEnemiesKilled

@onready var killsLabel: Label = $UI/Kills/KillsLabel
@onready var deathAnimationPlayer: AnimationPlayer = $UI/Death/DeathAnimationPlayer
@onready var deathTimer: Timer = $UI/Death/DeathTimer
@onready var directAttackAudio: AudioStreamPlayer2D = $Sound/DirectAttack
@onready var miniHitAudio: AudioStreamPlayer2D = $Sound/MiniHit
@onready var unknownAttackStyleAudio: AudioStreamPlayer2D = $Sound/UnknownAttackStyle
@onready var digitalRearrangeAudio: AudioStreamPlayer2D = $Sound/DigitalRearrange
@onready var multiPowerUpgradeAudio: AudioStreamPlayer2D = $Sound/MultiPowerUpgrade


var timeStart = 0
var currentTime = 0
var enemiesKilled: float = 0
var enemiesKilledSinceLastUltimate: float = 0
var enemiesKilledAlreadyReached: bool = false
var pressSpaceToRestart: bool = false
var playerDeadShown: bool = false

func _ready():
	deathAnimationPlayer.play("RESET")
	timeStart = int(Time.get_unix_time_from_system())

func _process(_delta):
	currentTime = int(Time.get_unix_time_from_system()) - timeStart
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if pressSpaceToRestart:
		if event.is_action_pressed("space"):
			get_tree().reload_current_scene()

func _on_enemy_dead():
	directAttackAudio.play()
	miniHitAudio.play()
	enemiesKilled += 1
	enemiesKilledSinceLastUltimate += 1
	killsLabel.text = str(enemiesKilled)
	if enemiesKilledSinceLastUltimate >= 10 and not enemiesKilledAlreadyReached:
		emit_signal("tenEnemiesKilled")
		print("ten enemies Killed")
		enemiesKilledAlreadyReached = true


func _on_player_dead():
	if not playerDeadShown:
		multiPowerUpgradeAudio.play()
		deathAnimationPlayer.play("showDeathUI")
		deathTimer.start()
		playerDeadShown = true


func _on_player_using_ultimate():
	unknownAttackStyleAudio.play()
	digitalRearrangeAudio.play()
	enemiesKilledSinceLastUltimate = 0
	enemiesKilledAlreadyReached = false
	


func _on_death_timer_timeout():
	pressSpaceToRestart = true
