extends SpellBase

func cast(_player: CharacterBody2D, enemies: Array[Node]):
	for enemy in enemies:
		enemy.LIFE = 0.0

