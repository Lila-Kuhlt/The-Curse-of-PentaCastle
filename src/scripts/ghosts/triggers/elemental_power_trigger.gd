class_name ElementalPowerTrigger

extends GhostTrigger

var _power_needed: int
@export var power_needed: int :
	get:
		return _power_needed

var _registry: ElementalPower

func _init(power_needed: int, registry: ElementalPower, effect: GhostEffect) -> void:
	super(effect)
	_power_needed = power_needed
	_registry = registry
	registry.register_triggered_ghost(self)

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		_registry.remove_triggered_ghost(self)

func trigger():
	effect.execute()
