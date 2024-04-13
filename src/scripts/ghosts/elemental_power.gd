class_name ElementalPower

extends Node

const ELEMENTAL_POWER_DURATION: float = 5
var _timer: Timer

func _init() -> void:
	_timer = Timer.new()
	_timer.one_shot = true
	_timer.wait_time = ELEMENTAL_POWER_DURATION
	_timer.timeout.connect(_reset_power)
	add_child(_timer)

var _is_active: bool :
	get:
		return _timer.time_left > 0

var _elemental_power: int = 0
var _triggered_ghosts: Array[ElementalPowerTrigger] = []
var _triggered_until: int = 0

func _compare_by_power_needed(lhr: ElementalPowerTrigger, rhs: ElementalPowerTrigger):
	return lhr.power_needed < rhs.power_needed

func register_triggered_ghost(new: ElementalPowerTrigger):
	var i: int
	if _triggered_ghosts.size() == 0:
		i = 0
	else:
		i = _triggered_ghosts.bsearch_custom(new, _compare_by_power_needed)
	_triggered_ghosts.insert(i, new)
	if i <= _triggered_until and _triggered_until != 0:
		_triggered_until += 1

func remove_triggered_ghost(old: ElementalPowerTrigger):
	var start_index = _triggered_ghosts.bsearch_custom(old, _compare_by_power_needed)
	assert(start_index >= 0)
	var index = _triggered_ghosts.find(old, start_index)
	assert(index >= 0)
	_triggered_ghosts.remove_at(index)
	if index <= _triggered_until and _triggered_until != 0:
		_triggered_until -= 1


func inc_elemental_power(val: int):
	_elemental_power += val
	print(_elemental_power)
	_trigger_ghosts()
	if not _is_active:
		_timer.start()

func _trigger_ghosts():
	while _triggered_until < _triggered_ghosts.size():
		var next_ghost = _triggered_ghosts[_triggered_until]
		if next_ghost.power_needed < _elemental_power:
			next_ghost.trigger()
			_triggered_until += 1
		else:
			break

func _reset_power():
	_elemental_power = 0
	_triggered_until = 0
