extends Node2D

@onready var navigateToInstructionsTimer: Timer = $NavigateToInstructions
var instructionMap = preload("res://Maps/map_instructions.tscn")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	if event.is_action_pressed("space"):
		navigateToInstructionsTimer.start()


func _on_navigate_to_instructions_timeout():
	get_tree().change_scene_to_packed(instructionMap)
