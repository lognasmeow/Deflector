extends Node2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var spaceLabel: Label = $SpaceLabel

func _ready():
	spaceLabel.position.x = -168
	spaceLabel.position.y = -43.765

func _input(event):
	if event.is_action_pressed("space"):
		animationPlayer.play("play")
