extends SpellBase

var multiplier_diff

func cast(_player: Player, enemies: Array[Node]):
	for enemy in enemies:
		multiplier_diff = enemy.damage_multiplier
		enemy.damage_multiplier *= 1.5
		multiplier_diff = enemy.damage_multiplier - multiplier_diff

func uncast(_player: Player, enemies: Array[Node]):
	for enemy in enemies:
		enemy.damage_multiplier -= multiplier_diff

