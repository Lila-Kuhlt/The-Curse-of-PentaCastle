class_name cooldown_effect

extends GhostEffect

var cooldown: int

var last_triggered: int = -9223372036854775808

func _init(cooldown: int) -> void:
	self.cooldown = cooldown

func execute_with_cooldown():
	pass

func execute() -> void:
	var current_time = Time.get_ticks_msec()
	if current_time < last_triggered + cooldown:
		return
	last_triggered = current_time
	execute_with_cooldown()
