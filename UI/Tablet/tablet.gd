extends Node2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready():
	visible = false

func _on_player_ultimate_is_available():
	visible = true
	animationPlayer.play("openTablet")


func _on_player_using_ultimate():
	animationPlayer.play("closeTablet")
