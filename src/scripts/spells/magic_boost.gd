extends SpellBase

func cast(_player: Player, enemies: Array[Node]):
	for enemy in enemies:
		enemy.damage_multiplier *= 1.5

func uncast(_player: Player, enemies: Array[Node]):
	for enemy in enemies:
		enemy.damage_multiplier /= 1.5

