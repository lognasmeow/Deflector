extends Node2D

signal deflecting
signal dead

@onready var deflectCooldownTimer: Timer = $DeflectCooldown

var deflectAvailable: bool = true
var health: int = 3

func _input(event):
	if event.is_action_pressed("space"):
		handleDeflect()

func handleDeflect():
	if deflectAvailable:
		print("yup")
		emit_signal("deflecting")
		
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
	takeDamage(1)
