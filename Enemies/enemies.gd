extends Node2D

@onready var player: Node2D = $"../Player"
@onready var map: Node2D = $".."

var enemy = preload("res://Enemies/enemy.tscn")

func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		print("yeah")
		var instance = enemy.instantiate()
		instance.position.x = 300
		connectSignals(instance)
		add_child(instance)

func connectSignals(instance):
	instance.attacking.connect(player._on_enemy_attacking)
	instance.miss.connect(player._on_enemy_miss)
	instance.dead.connect(map._on_enemy_dead)
	player.deflecting.connect(instance._on_player_deflecting)
	player.usingUltimate.connect(instance._on_player_using_ultimate)
