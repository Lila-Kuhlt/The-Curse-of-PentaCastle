extends SpellBase

func cast(_player: CharacterBody2D, enemies: Array[Node]):
	for enemy in enemies:
		enemy.MOVEMENT_SPEED *= 0.5

func uncast(_player: CharacterBody2D, enemies: Array[Node]):
	for enemy in enemies:
		enemy.MOVEMENT_SPEED *= 2
