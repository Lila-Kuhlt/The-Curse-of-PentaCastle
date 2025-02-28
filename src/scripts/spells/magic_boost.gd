extends SpellBase

const DAMAGE_MULTIPLIER := 1.5

func cast(player: Player, _enemies: Array[Node]):
	player.damage_multiplier *= DAMAGE_MULTIPLIER

func uncast(player: Player, _enemies: Array[Node]):
	player.damage_multiplier /= DAMAGE_MULTIPLIER
