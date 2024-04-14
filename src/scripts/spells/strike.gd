extends SpellBase

const Strike = preload("res://scenes/projectiles/strike.tscn")

func cast(player: Player, _enemies: Array[Node]):
	spawn_projectile(player, Strike.instantiate())
