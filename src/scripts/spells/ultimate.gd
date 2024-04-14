extends SpellBase

func cast(player: CharacterBody2D, enemies: Array[Node]):
	for enemie in enemies:
		enemie.LIFE = 0.0

