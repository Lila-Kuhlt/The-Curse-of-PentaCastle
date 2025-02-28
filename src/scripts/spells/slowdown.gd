extends SpellBase

var _slowed_enemies: Array[Enemy] = []

func cast(_player: Player, enemies: Array[Node]):
	_slowed_enemies = enemies.duplicate()
	for enemy in _slowed_enemies:
		enemy.MOVEMENT_SPEED *= 0.5

func uncast(_player: Player, _enemies: Array[Node]):
	for enemy in _slowed_enemies:
		if enemy != null:
			enemy.MOVEMENT_SPEED *= 2
