extends SpellBase

func cast(player: CharacterBody2D, enemies: Array[Node]):
	for enemie in enemies:
		enemie.MOVEMENT_SPEED *= 0.5

func uncast(player: CharacterBody2D, enemies: Array[Node]):
	for enemie in enemies:
		enemie.MOVEMENT_SPEED *= 2
