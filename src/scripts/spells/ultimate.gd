extends SpellBase

func cast(player: Player, enemies: Array[Node]):
	for enemy in enemies:
		enemy.life = 0.0
	player.take_damage(30)

