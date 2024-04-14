extends SpellBase

func cast(_player: Player, enemies: Array[Node]):
	for enemy in enemies:
		enemy.life = 0.0

