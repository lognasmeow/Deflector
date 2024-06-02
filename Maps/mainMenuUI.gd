extends Node2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var spaceLabel: Label = $SpaceLabel
@onready var selectAnOptionAudio: AudioStreamPlayer2D = $"../SelectAnOption"
@onready var spaceBarSprite: Sprite2D = $Sprite2D

func _ready():
	spaceBarSprite.frame = 0
	spaceLabel.position.x = -168
	spaceLabel.position.y = -43.765

func _input(event):
	if event.is_action_pressed("space"):
		selectAnOptionAudio.play()
		animationPlayer.play("play")
