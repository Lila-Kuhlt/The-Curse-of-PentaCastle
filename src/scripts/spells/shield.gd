extends SpellBase

func cast(player: Player, _enemies: Array[Node]):
	player.shield_multiplier = 0.5

func uncast(player: Player, _enemies: Array[Node]):
	player.shield_multiplier = 1.0

