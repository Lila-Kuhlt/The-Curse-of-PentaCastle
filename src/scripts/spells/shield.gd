extends SpellBase

func cast(player: Player, _enemies: Array[Node]):
	player.enable_shield(0.5)

func uncast(player: Player, _enemies: Array[Node]):
	player.disable_shield()

