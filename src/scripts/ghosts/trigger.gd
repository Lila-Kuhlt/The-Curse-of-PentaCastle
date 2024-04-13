class_name GhostTrigger

extends Object

var effect: GhostEffect

func _init(effect: GhostEffect) -> void:
	self.effect = effect

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		effect.free()
