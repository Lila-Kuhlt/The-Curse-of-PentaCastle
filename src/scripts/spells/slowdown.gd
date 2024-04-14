extends SpellBase

func cast(_player: Player, enemies: Array[Node]):
	for enemy in enemies:
		enemy.MOVEMENT_SPEED *= 0.5

func uncast(_player: Player, enemies: Array[Node]):
	for enemy in enemies:
		enemy.MOVEMENT_SPEED *= 2
