extends Node2D

@onready var pageTransitionTimer: Timer = $PageTransition
@onready var label: Label = $Node2D/Label
@onready var enemy1: Sprite2D = $Enemies/Sprite2D
@onready var enemy2: Sprite2D = $Enemies/Sprite2D2
@onready var enemy3: Sprite2D = $Enemies/Sprite2D3
@onready var textureRect: TextureRect = $Node2D/TextureRect
var ultimateShown: bool = false
var creditsShown: bool = false
var mainMap = preload("res://Maps/map_main.tscn")

func _ready():
	label.position.y = 96
	textureRect.visible = true
	label.text = "PRESS SPACE TO\nDEFLECT SHOTS\nBACK AT ENEMIES"
	enemy1.frame = 23
	enemy2.frame = 24
	enemy3.frame = 31
	enemy1.visible = true
	enemy2.visible = true
	enemy3.visible = true

func _on_page_transition_timeout():
	if not ultimateShown:
		label.text = "HOLD SPACE TO\nUSE ULTIMATE\nWHEN IT'S READY"
		enemy1.frame = 31
		enemy2.frame = 31
		enemy3.frame = 31
		ultimateShown = true
		pageTransitionTimer.start()
	elif not creditsShown:
		label.position.y = 40
		textureRect.visible = false
		label.text = "CREDITS\n\nGAME BY LOGNASMEOW\n\n*** Sprites ***\n- TheWiseHedgehog\n- Jesse Eisenbart\n\n*** Backgrounds ***\n- ansimuz\n\n*** Overlays ***\n- 1up Indie\n\n*** UI ***\n- Finnmercury\n\n*** Audio ***\n-GameSupplyGuy\n- Shapeforms"
		label.set("theme_override_font_sizes/font_size", 15)
		enemy1.visible = false
		enemy2.visible = false
		enemy3.visible = false
		creditsShown = true
		pageTransitionTimer.start()
	else:
		get_tree().change_scene_to_packed(mainMap)
