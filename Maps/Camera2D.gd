extends Camera2D

@onready var shakeTimer: Timer = $Shake

var shakeAmount: float = 0

func _process(delta):
	offset = Vector2(randf_range(-1, 1) * shakeAmount , randf_range(-1, 1) * shakeAmount)
	
func shake(time: float, amount: float):
	shakeTimer.wait_time = time
	shakeAmount = amount
	set_process(true)
	shakeTimer.start()
	

func _on_enemy_dead():
	shake(0.1, 3)
	

func _on_shake_timeout():
	set_process(false)
	get_tree().create_tween().interpolate_value(self, "offset", 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
